import SDL3_Native

public class SDLSurface {
    public struct BlendMode: OptionSet {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        static let none = BlendMode([])
        static let blend = BlendMode(rawValue: 0x00000001)
        static let add = BlendMode(rawValue: 0x00000002)
        static let modulate = BlendMode(rawValue: 0x00000004)
        static let multiply = BlendMode(rawValue: 0x00000008)
        static let invalid = BlendMode(rawValue: 0x7FFFFFFF)
    }

    public enum BlendOperation: UInt32 {
        case add = 1
        case subtract = 2
        case reverseSubtract = 3
        case minimum = 4
        case maximum = 5
    }

    public enum BlendFactor: UInt32 {
        case zero = 1
        case one = 2
        case sourceColor = 3
        case oneMinusSourceColor = 4
        case sourceAlpha = 5
        case oneMinusSourceAlpha = 6
        case destinationColor = 7
        case oneMinusDestinationColor = 8
        case destinationAlpha = 9
        case oneMinusDestinationAlpha = 10
    }

    internal let surf: UnsafeMutablePointer<SDL_Surface>
    private let owned: Bool
    private let pixelData: UnsafeMutableRawPointer?
    public let width: Int32
    public let height: Int32
    public let pitch: Int32
    public let format: SDLPixelFormat
    public let pixels: UnsafeMutableRawPointer
    private var locked: Bool = false

    public static func loadBMP(at path: String) throws -> SDLSurface {
        if let ptr = nullCheck(SDL_LoadBMP(path)) {
            return SDLSurface(from: ptr, owned: true)
        } else {
            throw SDLError()
        }
    }

    public static func loadBMP(from rw: SDLRWops, shouldClose close: Bool) throws -> SDLSurface {
        if let ptr = nullCheck(SDL_LoadBMP_RW(rw.sdlRWops, close ? SDL_TRUE : SDL_FALSE)) {
            return SDLSurface(from: ptr, owned: true)
        } else {
            throw SDLError()
        }
    }

    internal init(from: UnsafeMutablePointer<SDL_Surface>, owned _owned: Bool) {
        surf = from
        owned = _owned
        pixelData = nil
        width = surf.pointee.w
        height = surf.pointee.h
        pitch = surf.pointee.pitch
        format = SDLPixelFormat(from: surf.pointee.format)
        pixels = surf.pointee.pixels
    }

    public convenience init(width: Int32, height: Int32, format: SDLPixelFormat.Enum) throws {
        if let surface = nullCheck(SDL_CreateSurface(width, height, format.rawValue)) {
            self.init(from: surface, owned: true)
        } else {
            throw SDLError()
        }
    }

    public init(from: [UInt32], width: Int32, height: Int32, format: SDLPixelFormat.Enum) throws {
        let data = UnsafeMutablePointer<UInt32>.allocate(capacity: from.count)
        for i in 0..<from.count {
            data[i] = from[i]
        }
        if let surface = nullCheck(SDL_CreateSurfaceFrom(data, width, height, 4, format.rawValue)) {
            surf = surface
            owned = true
            pixelData = UnsafeMutableRawPointer(data)
            self.width = surf.pointee.w
            self.height = surf.pointee.h
            pitch = surf.pointee.pitch
            self.format = SDLPixelFormat(from: surf.pointee.format)
            pixels = surf.pointee.pixels
        } else {
            data.deallocate()
            throw SDLError()
        }
    }

    public init(from: [UInt8], width: Int32, height: Int32, pitch: Int32, format: SDLPixelFormat.Enum) throws {
        let data = UnsafeMutablePointer<UInt8>.allocate(capacity: from.count)
        for i in 0..<from.count {
            data[i] = from[i]
        }
        if let surface = nullCheck(SDL_CreateSurfaceFrom(data, width, height, pitch, format.rawValue)) {
            surf = surface
            owned = true
            pixelData = UnsafeMutableRawPointer(data)
            self.width = surf.pointee.w
            self.height = surf.pointee.h
            self.pitch = surf.pointee.pitch
            self.format = SDLPixelFormat(from: surf.pointee.format)
            pixels = surf.pointee.pixels
        } else {
            data.deallocate()
            throw SDLError()
        }
    }

    deinit {
        if owned {
            SDL_DestroySurface(surf)
            if let ptr = pixelData {
                ptr.deallocate()
            }
        }
    }

    public var rle: Bool {
        get {
            return SDL_SurfaceHasRLE(surf) == SDL_TRUE
        } set (value) {
            SDL_SetSurfaceRLE(surf, value ? 1 : 0)
        }
    }

    public var colorKey: SDLColor? {
        get {
            var res: UInt32 = 0
            if withUnsafeMutablePointer(to: &res, {_res in
                SDL_GetSurfaceColorKey(surf, _res) == 0
            }) {
                return SDLColor(from: res, as: format)
            } else {
                return nil
            }
        } set (value) {
            if let value = value {
                SDL_SetSurfaceColorKey(surf, 1, value.rgb(as: format))
            } else {
                SDL_SetSurfaceColorKey(surf, 0, 0)
            }
        }
    }

    public var hasColorKey: Bool {
        return SDL_SurfaceHasColorKey(surf) == SDL_TRUE
    }

    public var colorMod: SDLColor {
        get {
            let t = threePointers {_r, _g, _b in
                SDL_GetSurfaceColorMod(self.surf, _r, _g, _b)
            }
            return SDLColor(red: t.0, green: t.1, blue: t.2)
        } set (value) {
            SDL_SetSurfaceColorMod(surf, value.red, value.green, value.blue)
        }
    }

    public var alphaMod: UInt8 {
        get {
            return pointer {_a in
                SDL_GetSurfaceAlphaMod(self.surf, _a)
            }
        } set (value) {
            SDL_SetSurfaceAlphaMod(surf, value)
        }
    }

    public var blendMode: BlendMode {
        get {
            var res: SDL_BlendMode = SDL_BLENDMODE_NONE
            _ = withUnsafeMutablePointer(to: &res) {_res in
                SDL_GetSurfaceBlendMode(self.surf, _res)
            }
            return BlendMode(rawValue: res.rawValue)
        } set (value) {
            SDL_SetSurfaceBlendMode(surf, SDL_BlendMode(rawValue: value.rawValue))
        }
    }

    public var clipRect: SDLRect {
        get {
            return SDLRect(from: surf.pointee.clip_rect)
        } set (value) {
            let rect = value.sdlRect
            _ = withUnsafePointer(to: rect) {_rect in
                SDL_SetSurfaceClipRect(surf, _rect)
            }
        }
    }

    public func blit(from src: SDLSurface, in srcRect: SDLRect, to destRect: SDLRect) throws -> SDLRect {
        if locked {
            throw SDLError(message: "Surface is locked")
        }
        let sr = srcRect.sdlRect
        var dr = destRect.sdlRect
        let ok = withUnsafePointer(to: sr) {_sr in
            withUnsafeMutablePointer(to: &dr) {_dr in
                SDL_BlitSurface(src.surf, _sr, self.surf, _dr) == 0
            }
        }
        if ok {
            return SDLRect(from: dr)
        } else {
            throw SDLError()
        }
    }

    public func blitScaled(from src: SDLSurface, in srcRect: SDLRect?, to destRect: SDLRect?) throws -> SDLRect {
        if locked {
            throw SDLError(message: "Surface is locked")
        }
        var dr: SDL_Rect!
        let fn = {(_sr: UnsafePointer<SDL_Rect>) in
            let fn2 = {_dr in
                SDL_BlitSurface(src.surf, _sr, self.surf, _dr) == 0
            }
            if let destRect = destRect {
                dr = destRect.sdlRect
                return withUnsafeMutablePointer(to: &dr, fn2)
            } else {
                return fn2(UnsafeMutablePointer<SDL_Rect>(bitPattern: 0))
            }
        }
        var ok: Bool
        if let srcRect = srcRect {
            let sr = srcRect.sdlRect
            ok = withUnsafePointer(to: sr, fn)
        } else {
            ok = fn(SDL_Rect.NULL)
        }
        if ok && dr != nil {
            return SDLRect(from: dr)
        } else {
            throw SDLError()
        }
    }

    public func convert(to format: SDLPixelFormat) throws -> SDLSurface {
        if let s = nullCheck(SDL_ConvertSurface(surf, format.ptr)) {
            return SDLSurface(from: s, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func convert(to format: SDLPixelFormat.Enum) throws -> SDLSurface {
        if let s = nullCheck(SDL_ConvertSurfaceFormat(surf, format.rawValue)) {
            return SDLSurface(from: s, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func duplicate() throws -> SDLSurface {
        if let ptr = nullCheck(SDL_DuplicateSurface(surf)) {
            return SDLSurface(from: ptr, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func set(palette: SDLPalette) throws {
        if SDL_SetSurfacePalette(surf, palette.ptr) != 0 {
            throw SDLError()
        }
    }

    public func lock<Result>(_ body: () throws -> Result) throws -> Result {
        if locked {
            throw SDLError(message: "Surface is locked")
        }
        if SDL_LockSurface(surf) != 0 {
            throw SDLError()
        }
        let res: Result
        do {
            res = try body()
        } catch {
            SDL_UnlockSurface(surf)
            throw error
        }
        SDL_UnlockSurface(surf)
        return res
    }

    public func saveBMP(into rw: SDLRWops, shouldClose: Bool = false) throws {
        if SDL_SaveBMP_RW(surf, rw.sdlRWops, shouldClose ? SDL_TRUE : SDL_FALSE) != 0 {
            throw SDLError()
        }
    }

    public func saveBMP(to path: String) throws {
        if SDL_SaveBMP(surf, path) != 0 {
            throw SDLError()
        }
    }

    public func fill(in rect: SDLRect, with color: SDLColor) throws {
        let sdlRect = rect.sdlRect
        if !withUnsafePointer(to: sdlRect, {_sdlRect in
            SDL_FillSurfaceRect(self.surf, _sdlRect, color.rgba(as: self.format)) == 0
        }) {
            throw SDLError()
        }
    }

    public func fill(in rects: [SDLRect], with color: SDLColor) throws {
        let arr = UnsafeMutablePointer<SDL_Rect>.allocate(capacity: rects.count)
        defer {arr.deallocate()}
        for i in 0..<rects.count {
            arr[i] = rects[i].sdlRect
        }
        if SDL_FillSurfaceRects(surf, arr, Int32(rects.count), color.rgba(as: format)) != 0 {
            throw SDLError()
        }
    }

    private var _renderer: SDLRenderer? = nil
    public var renderer: SDLRenderer! {
        if let r = _renderer {
            return r
        }
        if let ren = SDL_CreateSoftwareRenderer(surf) {
            _renderer = SDLRenderer(rawValue: ren)
            return _renderer!
        }
        return nil
    }
}

public func SDLComposeCustomBlendMode(sourceColorFactor: SDLSurface.BlendFactor,
                                      destColorFactor: SDLSurface.BlendFactor,
                                      colorOperation: SDLSurface.BlendOperation,
                                      sourceAlphaFactor: SDLSurface.BlendFactor,
                                      destAlphaFactor: SDLSurface.BlendFactor,
                                      alphaOperation: SDLSurface.BlendOperation)
                                      -> SDLSurface.BlendMode {
    return SDLSurface.BlendMode(rawValue: SDL_ComposeCustomBlendMode(
        SDL_BlendFactor(rawValue: sourceColorFactor.rawValue),
        SDL_BlendFactor(rawValue: destColorFactor.rawValue),
        SDL_BlendOperation(rawValue: colorOperation.rawValue),
        SDL_BlendFactor(rawValue: sourceAlphaFactor.rawValue),
        SDL_BlendFactor(rawValue: destAlphaFactor.rawValue),
        SDL_BlendOperation(rawValue: alphaOperation.rawValue)
    ).rawValue)
}

public enum SDLYUVConversionModeEnum: UInt32 {
    case jpeg = 0
    case bt601 = 1
    case bt709 = 2
    case automatic = 3
}

public var SDLYUVConversionMode: SDLYUVConversionModeEnum {
    get {
        return SDLYUVConversionModeEnum(rawValue: SDL_GetYUVConversionMode().rawValue)!
    } set (value) {
        SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE(rawValue: value.rawValue))
    }
}

public func SDLYUVConversionMode(for resolution: SDLSize) -> SDLYUVConversionModeEnum {
    return SDLYUVConversionModeEnum(rawValue: SDL_GetYUVConversionModeForResolution(resolution.width, resolution.height).rawValue)!
}
