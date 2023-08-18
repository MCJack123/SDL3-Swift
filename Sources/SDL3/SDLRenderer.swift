import SDL3_Native

public struct SDLVertex {
    public var position: SDLFPoint = SDLFPoint()
    public var color: SDLColor = SDLColor()
    public var textureCoordinates: SDLFPoint = SDLFPoint()
    internal var sdlVertex: SDL_Vertex {
        return SDL_Vertex(position: position.sdlPoint, color: color.sdlColor, tex_coord: textureCoordinates.sdlPoint)
    }
    public init() {}
    internal init(from vertex: SDL_Vertex) {
        position = SDLFPoint(from: vertex.position)
        color = SDLColor(from: vertex.color)
        textureCoordinates = SDLFPoint(from: vertex.tex_coord)
    }
}

public class SDLTexture {
    public enum ScaleMode: UInt32 {
        case nearest = 0
        case linear = 1
        case best = 2
    }

    public enum Access: Int32 {
        case `static` = 0
        case streaming = 1
        case target = 2
    }

    public struct Modulate: OptionSet {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        public static let none = Modulate([])
        public static let color = Modulate(rawValue: 1)
        public static let alpha = Modulate(rawValue: 2)
    }

    internal let texture: OpaquePointer
    private let owned: Bool

    internal init(rawValue: OpaquePointer, owned: Bool) {
        texture = rawValue
        self.owned = owned
    }

    deinit {
        if owned {
            SDL_DestroyTexture(texture)
        }
    }

    public var format: UInt32 {
        return pointer {_a in SDL_QueryTexture(texture, _a, nil, nil, nil)}
    }

    public var access: Access {
        return Access(rawValue: pointer {_a in SDL_QueryTexture(texture, nil, _a, nil, nil)})!
    }

    public var size: SDLSize {
        let t = twoPointers {_w, _h in SDL_QueryTexture(texture, nil, nil, _w, _h)}
        return SDLSize(width: t.0, height: t.1)
    }

    public var colorMod: SDLColor {
        get {
            let t = threePointers {_r, _g, _b in
                SDL_GetTextureColorMod(texture, _r, _g, _b)
            }
            return SDLColor(red: t.0, green: t.1, blue: t.2)
        } set (value) {
            SDL_SetTextureColorMod(texture, value.red, value.green, value.blue)
        }
    }

    public var alphaMod: UInt8 {
        get {
            return pointer {_a in SDL_GetTextureAlphaMod(texture, _a)}
        } set (value) {
            SDL_SetTextureAlphaMod(texture, value)
        }
    }

    public var blendMode: SDLSurface.BlendMode {
        get {
            var mode = SDL_BLENDMODE_NONE
            _ = withUnsafeMutablePointer(to: &mode) {_mode in
                SDL_GetTextureBlendMode(texture, _mode)
            }
            return SDLSurface.BlendMode(rawValue: mode.rawValue)
        } set (value) {
            SDL_SetTextureBlendMode(texture, SDL_BlendMode(rawValue: value.rawValue))
        }
    }

    public var scaleMode: ScaleMode {
        get {
            var mode = SDL_SCALEMODE_NEAREST
            _ = withUnsafeMutablePointer(to: &mode) {_mode in
                SDL_GetTextureScaleMode(texture, _mode)
            }
            return ScaleMode(rawValue: mode.rawValue)!
        } set (value) {
            SDL_SetTextureScaleMode(texture, SDL_ScaleMode(rawValue: value.rawValue))
        }
    }

    public func update(pixels: UnsafeRawBufferPointer, pitch: Int32, in rect: SDLRect?) throws {
        if let rect = rect?.sdlRect {
            let ok = withUnsafePointer(to: rect) {_rect in
                SDL_UpdateTexture(texture, _rect, pixels.baseAddress, pitch) == 0
            }
            if !ok {
                throw SDLError()
            }
        } else {
            if SDL_UpdateTexture(texture, nil, pixels.baseAddress, pitch) != 0 {
                throw SDLError()
            }
        }
    }

    public func withLockedData<R>(in rect: SDLRect, _ body: (UnsafeMutableRawBufferPointer, Int32) throws -> R) throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        let rect = rect.sdlRect
        let size = self.size
        let ok = withUnsafeMutablePointer(to: &pixels) {_pixels in
            withUnsafeMutablePointer(to: &pitch) {_pitch in
                withUnsafePointer(to: rect) {_rect in
                    return SDL_LockTexture(texture, _rect, _pixels, _pitch) == 0
                }
            }
        }
        if !ok {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(size.width * pitch)), pitch)
    }

    public func withLockedData<R>(_ body: (UnsafeMutableRawBufferPointer, Int32) throws -> R) throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        let size = self.size
        let ok = withUnsafeMutablePointer(to: &pixels) {_pixels in
            withUnsafeMutablePointer(to: &pitch) {_pitch in
                return SDL_LockTexture(texture, nil, _pixels, _pitch) == 0
            }
        }
        if !ok {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(size.width * pitch)), pitch)
    }

    public func withLockedSurface<R>(in rect: SDLRect, _ body: (SDLSurface) throws -> R) throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        let rect = rect.sdlRect
        let ok = withUnsafeMutablePointer(to: &surface) {_surface in
            withUnsafePointer(to: rect) {_rect in
                return SDL_LockTextureToSurface(texture, _rect, _surface) == 0
            }
        }
        if !ok {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(SDLSurface(from: surface!, owned: false))
    }

    public func withLockedSurface<R>(_ body: (SDLSurface) throws -> R) throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        let ok = withUnsafeMutablePointer(to: &surface) {_surface in
            return SDL_LockTextureToSurface(texture, nil, _surface) == 0
        }
        if !ok {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(SDLSurface(from: surface!, owned: false))
    }
}

public class SDLRenderer {
    public struct Flags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        public static let software = Flags(rawValue: 1)
        public static let accelerated = Flags(rawValue: 2)
        public static let presentVSync = Flags(rawValue: 4)
    }

    public struct Info {
        public let name: String
        public let flags: Flags
        public let textureFormats: [UInt32]
        public let maxTextureSize: SDLSize
        internal init(from info: SDL_RendererInfo) {
            name = String(cString: info.name)
            flags = Flags(rawValue: info.flags)
            var textureFormats: [UInt32]!
            withUnsafePointer(to: info.texture_formats) {_tex in
                let start = _tex.qpointer(to: \.0)!
                let count = MemoryLayout.size(ofValue: _tex.pointee) / MemoryLayout.size(ofValue: _tex.pointee.0)
                let buf = UnsafeBufferPointer(start: start, count: count)
                textureFormats = [UInt32](buf)
            }
            self.textureFormats = textureFormats
            maxTextureSize = SDLSize(width: info.max_texture_width, height: info.max_texture_height)
        }
    }

    public struct Flip: OptionSet {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        public static let none = Flip([])
        public static let horizontal = Flip(rawValue: 1)
        public static let vertical = Flip(rawValue: 2)
    }

    public enum LogicalPresentation: UInt32 {
        case disabled = 0
        case stretch = 1
        case letterbox = 2
        case overscan = 3
        case integerScale = 4
    }

    public static var driverCount: Int32 {
        return SDL_GetNumRenderDrivers()
    }

    public static func driver(for index: Int32) -> String? {
        if let s = SDL_GetRenderDriver(index) {
            return String(cString: s)
        } else {
            return nil
        }
    }

    internal let renderer: OpaquePointer
    public unowned var window: SDLWindow?

    internal init(rawValue: OpaquePointer) {
        renderer = rawValue
    }

    deinit {
        SDL_DestroyRenderer(renderer)
    }

    public var info: Info {
        var info = SDL_RendererInfo()
        _ = withUnsafeMutablePointer(to: &info) {_info in
            SDL_GetRendererInfo(renderer, _info)
        }
        return Info(from: info)
    }

    public var outputSize: SDLSize {
        let t = twoPointers {_w, _h in
            SDL_GetRenderOutputSize(renderer, _w, _h)
        }
        return SDLSize(width: t.0, height: t.1)
    }

    public var currentOutputSize: SDLSize {
        let t = twoPointers {_w, _h in
            SDL_GetCurrentRenderOutputSize(renderer, _w, _h)
        }
        return SDLSize(width: t.0, height: t.1)
    }

    public var renderTarget: SDLTexture? {
        get {
            if let t = SDL_GetRenderTarget(renderer) {
                return SDLTexture(rawValue: t, owned: false)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetRenderTarget(renderer, value?.texture)
        }
    }

    public var drawColor: SDLColor {
        get {
            let t = fourPointers {_r, _g, _b, _a in
                SDL_GetRenderDrawColor(renderer, _r, _g, _b, _a)
            }
            return SDLColor(red: t.0, green: t.1, blue: t.2, alpha: t.3)
        } set (value) {
            SDL_SetRenderDrawColor(renderer, value.red, value.green, value.blue, value.alpha)
        }
    }

    public func texture(with format: UInt32, access: SDLTexture.Access, width: Int32, height: Int32) throws -> SDLTexture {
        if let t = SDL_CreateTexture(renderer, format, access.rawValue, width, height) {
            return SDLTexture(rawValue: t, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func texture(from surface: SDLSurface) throws -> SDLTexture {
        if let t = SDL_CreateTextureFromSurface(renderer, surface.surf) {
            return SDLTexture(rawValue: t, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func clear() throws {
        if SDL_RenderClear(renderer) != 0 {
            throw SDLError()
        }
    }

    @MainActor public func present() throws {
        if SDL_RenderPresent(renderer) != 0 {
            throw SDLError()
        }
    }
}