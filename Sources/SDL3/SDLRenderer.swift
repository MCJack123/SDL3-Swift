import SDL3_Native

/// 
/// Vertex structure.
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
public struct SDLVertex {
    /// Vertex position, in SDL_Renderer coordinates
    public var position: SDLFPoint = SDLFPoint()
    /// Vertex color
    public var color: SDLFColor = SDLFColor()
    /// Normalized texture coordinates, if needed
    public var textureCoordinates: SDLFPoint = SDLFPoint()
    internal var sdlVertex: SDL_Vertex {
        return SDL_Vertex(position: position.sdlPoint, color: color.sdlColor, tex_coord: textureCoordinates.sdlPoint)
    }
    public init() {}
    internal init(from vertex: SDL_Vertex) {
        position = SDLFPoint(from: vertex.position)
        color = SDLFColor(from: vertex.color)
        textureCoordinates = SDLFPoint(from: vertex.tex_coord)
    }
}

/// 
/// An efficient driver-specific representation of pixel data
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
/// - See also: SDL_CreateTexture
/// - See also: SDL_CreateTextureFromSurface
/// - See also: SDL_CreateTextureWithProperties
/// - See also: SDL_DestroyTexture
/// 
@MainActor
public class SDLTexture: Sendable {
    /// 
    /// The access pattern allowed for a texture.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_TextureAccess.self)
    public enum Access: UInt32 {
        /// Changes rarely, not lockable
        case `static` = 0
        /// Changes frequently, lockable
        case streaming = 1
        /// Texture can be used as a render target
        case target = 2
    }

    nonisolated(unsafe) internal let texture: UnsafeMutablePointer<SDL_Texture>
    private let owned: Bool
    public unowned let renderer: SDLRenderer

    internal init(rawValue: UnsafeMutablePointer<SDL_Texture>, owned: Bool, renderer: SDLRenderer) {
        texture = rawValue
        self.owned = owned
        self.renderer = renderer
    }

    deinit {
        if owned {
            SDL_DestroyTexture(texture)
        }
    }

    /// 
    /// Get the size of a texture, as floating point values.
    /// 
    /// - Parameter texture: the texture to query.
    /// - Parameter w: a pointer filled in with the width of the texture in pixels. This
    ///          argument can be nil if you don't need this information.
    /// - Parameter h: a pointer filled in with the height of the texture in pixels. This
    ///          argument can be nil if you don't need this information.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var size: SDLFSize {
        get throws {
            var w: Float = 0.0, h: Float = 0.0
            if !SDL_GetTextureSize(texture, &w, &h) {
                throw SDLError()
            }
            return SDLFSize(width: w, height: h)
        }
    }

    /// 
    /// Get the additional color value multiplied into render copy operations.
    /// 
    /// - Returns: the color value
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaMod
    /// - See also: SDL_GetTextureColorModFloat
    /// - See also: SDL_SetTextureColorMod
    /// 
    @MainActor
    public var colorMod: SDLColor {
        get throws {
            var r: UInt8 = 0, g: UInt8 = 0, b: UInt8 = 0
            if !SDL_GetTextureColorMod(texture, &r, &g, &b) {
                throw SDLError()
            }
            return SDLColor(red: r, green: g, blue: b)
        }
    }

    /// 
    /// Set an additional color value multiplied into render copy operations.
    /// 
    /// When this texture is rendered, during the copy operation each source color
    /// channel is modulated by the appropriate color value according to the
    /// following formula:
    /// 
    /// `srcC = srcC * (color / 255)`
    /// 
    /// Color modulation is not always supported by the renderer; it will return
    /// false if color modulation is not supported.
    /// 
    /// - Parameter color: the color value multiplied into copy operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureColorMod
    /// - See also: SDL_SetTextureAlphaMod
    /// - See also: SDL_SetTextureColorModFloat
    /// 
    @MainActor
    public func set(colorMod value: SDLColor) throws {
        if !SDL_SetTextureColorMod(texture, value.red, value.green, value.blue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the additional color value multiplied into render copy operations.
    /// 
    /// - Returns: the color value
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaMod
    /// - See also: SDL_GetTextureColorModFloat
    /// - See also: SDL_SetTextureColorMod
    /// 
    @MainActor
    public var colorModFloat: SDLFColor {
        get throws {
            var r: Float = 0, g: Float = 0, b: Float = 0
            if !SDL_GetTextureColorModFloat(texture, &r, &g, &b) {
                throw SDLError()
            }
            return SDLFColor(red: r, green: g, blue: b)
        }
    }

    /// 
    /// Set an additional color value multiplied into render copy operations.
    /// 
    /// When this texture is rendered, during the copy operation each source color
    /// channel is modulated by the appropriate color value according to the
    /// following formula:
    /// 
    /// `srcC = srcC * color`
    /// 
    /// Color modulation is not always supported by the renderer; it will return
    /// false if color modulation is not supported.
    /// 
    /// - Parameter color: the color value multiplied into copy operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureColorMod
    /// - See also: SDL_SetTextureAlphaMod
    /// - See also: SDL_SetTextureColorModFloat
    /// 
    @MainActor
    public func set(colorModFloat value: SDLFColor) throws {
        if !SDL_SetTextureColorModFloat(texture, value.red, value.green, value.blue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the additional alpha value multiplied into render copy operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaModFloat
    /// - See also: SDL_GetTextureColorMod
    /// - See also: SDL_SetTextureAlphaMod
    /// 
    @MainActor
    public var alphaMod: UInt8 {
        get throws {
            var a: UInt8 = 0
            if !SDL_GetTextureAlphaMod(texture, &a) {
                throw SDLError()
            }
            return a
        }
    }

    /// 
    /// Set an additional alpha value multiplied into render copy operations.
    /// 
    /// When this texture is rendered, during the copy operation the source alpha
    /// value is modulated by this alpha value according to the following formula:
    /// 
    /// `srcA = srcA * (alpha / 255)`
    /// 
    /// Alpha modulation is not always supported by the renderer; it will return
    /// false if alpha modulation is not supported.
    /// 
    /// - Parameter alpha: the source alpha value multiplied into copy operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaMod
    /// - See also: SDL_SetTextureAlphaModFloat
    /// - See also: SDL_SetTextureColorMod
    /// 
    @MainActor
    public func set(alphaMod value: UInt8) throws {
        if !SDL_SetTextureAlphaMod(texture, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the additional alpha value multiplied into render copy operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaModFloat
    /// - See also: SDL_GetTextureColorMod
    /// - See also: SDL_SetTextureAlphaMod
    /// 
    @MainActor
    public var alphaModFloat: Float {
        get throws {
            var a: Float = 0
            if !SDL_GetTextureAlphaModFloat(texture, &a) {
                throw SDLError()
            }
            return a
        }
    }

    /// 
    /// Set an additional alpha value multiplied into render copy operations.
    /// 
    /// When this texture is rendered, during the copy operation the source alpha
    /// value is modulated by this alpha value according to the following formula:
    /// 
    /// `srcA = srcA * alpha`
    /// 
    /// Alpha modulation is not always supported by the renderer; it will return
    /// false if alpha modulation is not supported.
    /// 
    /// - Parameter alpha: the source alpha value multiplied into copy operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureAlphaMod
    /// - See also: SDL_SetTextureAlphaModFloat
    /// - See also: SDL_SetTextureColorMod
    /// 
    @MainActor
    public func set(alphaModFloat value: Float) throws {
        if !SDL_SetTextureAlphaModFloat(texture, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the blend mode used for texture copy operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetTextureBlendMode
    /// 
    @MainActor
    public var blendMode: SDLSurface.BlendMode {
        get throws {
            var mode = SDL_BLENDMODE_NONE
            if !SDL_GetTextureBlendMode(texture, &mode) {
                throw SDLError()
            }
            return SDLSurface.BlendMode(rawValue: mode)
        }
    }

    /// 
    /// Set the blend mode for a texture, used by SDL_RenderTexture().
    /// 
    /// If the blend mode is not supported, the closest supported mode is chosen
    /// and this function returns false.
    /// 
    /// - Parameter blendMode: the SDL_BlendMode to use for texture blending.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureBlendMode
    /// 
    @MainActor
    public func set(blendMode value: SDLSurface.BlendMode) throws {
        if !SDL_SetTextureBlendMode(texture, value.rawValue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the scale mode used for texture scale operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetTextureScaleMode
    /// 
    @MainActor
    public var scaleMode: SDLSurface.ScaleMode {
        get throws {
            var mode = SDL_SCALEMODE_NEAREST
            if !SDL_GetTextureScaleMode(texture, &mode) {
                throw SDLError()
            }
            return .sdl(mode)
        }
    }

    /// 
    /// Set the scale mode used for texture scale operations.
    /// 
    /// The default texture scale mode is SDL_SCALEMODE_LINEAR.
    /// 
    /// If the scale mode is not supported, the closest supported mode is chosen.
    /// 
    /// - Parameter scaleMode: the SDL_ScaleMode to use for texture scaling.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextureScaleMode
    /// 
    @MainActor
    public func set(scaleMode value: SDLSurface.ScaleMode) throws {
        if !SDL_SetTextureScaleMode(texture, value.sdlValue) {
            throw SDLError()
        }
    }

    // TODO: SDL_GetTextureProperties

    /// 
    /// Update the given texture rectangle with new pixel data.
    /// 
    /// The pixel data must be in the pixel format of the texture, which can be
    /// queried using the SDL_PROP_TEXTURE_FORMAT_NUMBER property.
    /// 
    /// This is a fairly slow function, intended for use with static textures that
    /// do not change often.
    /// 
    /// If the texture is intended to be updated often, it is preferred to create
    /// the texture as streaming and use the locking functions referenced below.
    /// While this function will work with streaming textures, for optimization
    /// reasons you may not get the pixels back if you lock the texture afterward.
    /// 
    /// - Parameter rect: an SDL_Rect structure representing the area to update, or nil
    ///             to update the entire texture.
    /// - Parameter pixels: the raw pixel data in the format of the texture.
    /// - Parameter pitch: the number of bytes in a row of pixel data, including padding
    ///              between lines.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTexture
    /// - See also: SDL_UnlockTexture
    /// - See also: SDL_UpdateNVTexture
    /// - See also: SDL_UpdateYUVTexture
    /// 
    @MainActor
    public func update(pixels: UnsafeRawBufferPointer, pitch: Int32, in rect: SDLRect?) throws {
        if var rect = rect?.sdlRect {
            if !SDL_UpdateTexture(texture, &rect, pixels.baseAddress, pitch) {
                throw SDLError()
            }
        } else {
            if !SDL_UpdateTexture(texture, nil, pixels.baseAddress, pitch) {
                throw SDLError()
            }
        }
    }

    // TODO: SDL_UpdateYUVTexture

    /// 
    /// Lock a portion of the texture for **write-only** pixel access.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: an SDL_Rect structure representing the area to lock for access
    /// - Parameter body: a function to call with the locked pixels
    /// - Returns: true on success or false if the texture is not valid or was not
    ///          created with `SDL_TEXTUREACCESS_STREAMING`
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTextureToSurface
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedData<R>(in rect: SDLRect, _ body: (UnsafeMutableRawBufferPointer, Int32) throws -> R) throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        var rect = rect.sdlRect
        if !SDL_LockTexture(texture, &rect, &pixels, &pitch) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(rect.h * pitch)), pitch)
    }

    /// 
    /// Lock the entire texture for **write-only** pixel access.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter body: a function to call with the locked pixels
    /// - Returns: true on success or false if the texture is not valid or was not
    ///          created with `SDL_TEXTUREACCESS_STREAMING`
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTextureToSurface
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedData<R>(_ body: (UnsafeMutableRawBufferPointer, Int32) throws -> R) throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        let size = try self.size
        if !SDL_LockTexture(texture, nil, &pixels, &pitch) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(Int32(size.height) * pitch)), pitch)
    }

    /// 
    /// Lock a portion of the texture for **write-only** pixel access, and expose
    /// it as a SDL surface.
    /// 
    /// Besides providing an SDL_Surface instead of raw pixel data, this function
    /// operates like SDL_LockTexture.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: the rectangle to lock for access. If the rect is
    ///             nil, the entire texture will be locked.
    /// - Parameter body: a callback receiving an SDL surface of size **rect**. Don't assume
    ///                any specific pixel content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTexture
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedSurface<R>(in rect: SDLRect, _ body: (SDLSurface) throws -> R) throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        var rect = rect.sdlRect
        if !SDL_LockTextureToSurface(texture, &rect, &surface) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(SDLSurface(from: surface!.sendable, owned: false))
    }

    /// 
    /// Lock the entire texture for **write-only** pixel access, and expose
    /// it as a SDL surface.
    /// 
    /// Besides providing an SDL_Surface instead of raw pixel data, this function
    /// operates like SDL_LockTexture.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: the rectangle to lock for access. If the rect is
    ///             nil, the entire texture will be locked.
    /// - Parameter body: a callback receiving an SDL surface of size **rect**. Don't assume
    ///                any specific pixel content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTexture
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedSurface<R>(_ body: (SDLSurface) throws -> R) throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        if !SDL_LockTextureToSurface(texture, nil, &surface) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try body(SDLSurface(from: surface!.sendable, owned: false))
    }

    /// 
    /// Lock a portion of the texture for **write-only** pixel access.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: an SDL_Rect structure representing the area to lock for access
    /// - Parameter body: a function to call with the locked pixels
    /// - Returns: true on success or false if the texture is not valid or was not
    ///          created with `SDL_TEXTUREACCESS_STREAMING`
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTextureToSurface
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedData<R: Sendable>(in rect: SDLRect, _ body: (SendableMutableRawBufferPointer, Int32) async throws -> R) async throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        var rect = rect.sdlRect
        if !SDL_LockTexture(texture, &rect, &pixels, &pitch) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try await body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(rect.h * pitch)).sendable, pitch)
    }

    /// 
    /// Lock the entire texture for **write-only** pixel access.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter body: a function to call with the locked pixels
    /// - Returns: true on success or false if the texture is not valid or was not
    ///          created with `SDL_TEXTUREACCESS_STREAMING`
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTextureToSurface
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedData<R: Sendable>(_ body: (SendableMutableRawBufferPointer, Int32) async throws -> R) async throws -> R {
        var pixels = UnsafeMutableRawPointer(bitPattern: 0)
        var pitch: Int32 = 0
        let size = try self.size
        if !SDL_LockTexture(texture, nil, &pixels, &pitch) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try await body(UnsafeMutableRawBufferPointer(start: pixels, count: Int(Int32(size.height) * pitch)).sendable, pitch)
    }

    /// 
    /// Lock a portion of the texture for **write-only** pixel access, and expose
    /// it as a SDL surface.
    /// 
    /// Besides providing an SDL_Surface instead of raw pixel data, this function
    /// operates like SDL_LockTexture.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: the rectangle to lock for access. If the rect is
    ///             nil, the entire texture will be locked.
    /// - Parameter body: a callback receiving an SDL surface of size **rect**. Don't assume
    ///                any specific pixel content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTexture
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedSurface<R: Sendable>(in rect: SDLRect, _ body: (SDLSurface) async throws -> R) async throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        var rect = rect.sdlRect
        if !SDL_LockTextureToSurface(texture, &rect, &surface) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try await body(SDLSurface(from: surface!.sendable, owned: false))
    }

    /// 
    /// Lock the entire texture for **write-only** pixel access, and expose
    /// it as a SDL surface.
    /// 
    /// Besides providing an SDL_Surface instead of raw pixel data, this function
    /// operates like SDL_LockTexture.
    /// 
    /// As an optimization, the pixels made available for editing don't necessarily
    /// contain the old texture data. This is a write-only operation, and if you
    /// need to keep a copy of the texture data you should do that at the
    /// application level.
    /// 
    /// - Parameter rect: the rectangle to lock for access. If the rect is
    ///             nil, the entire texture will be locked.
    /// - Parameter body: a callback receiving an SDL surface of size **rect**. Don't assume
    ///                any specific pixel content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_LockTexture
    /// - See also: SDL_UnlockTexture
    /// 
    @MainActor
    public func withLockedSurface<R: Sendable>(_ body: (SDLSurface) async throws -> R) async throws -> R {
        var surface: UnsafeMutablePointer<SDL_Surface>?
        if !SDL_LockTextureToSurface(texture, nil, &surface) {
            throw SDLError()
        }
        defer {SDL_UnlockTexture(texture)}
        return try await body(SDLSurface(from: surface!.sendable, owned: false))
    }
}

/// 
/// A structure representing rendering state
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
@MainActor
public class SDLRenderer: Sendable {
    public struct FlipMode: OptionSet, Sendable {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        public static let none = FlipMode([])
        public static let horizontal = FlipMode(rawValue: 1)
        public static let vertical = FlipMode(rawValue: 2)
        internal static func sdl(_ value: SDL_FlipMode) -> FlipMode {
            return FlipMode(rawValue: value.rawValue)
        }
        internal var sdlValue: SDL_FlipMode {
            return SDL_FlipMode(rawValue: rawValue)
        }
    }

    /// 
    /// How the logical size is mapped to the output.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_RendererLogicalPresentation.self)
    public enum LogicalPresentation: UInt32 {
        /// There is no logical size in effect
        case disabled = 0
        /// The rendered content is stretched to the output resolution
        case stretch = 1
        /// The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars
        case letterbox = 2
        /// The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds
        case overscan = 3
        /// The rendered content is scaled up by integer multiples to fit the output resolution
        case integerScale = 4
    }

    /// 
    /// Get the number of 2D rendering drivers available for the current display.
    /// 
    /// A render driver is a set of code that handles rendering and texture
    /// management on a particular display. Normally there is only one, but some
    /// drivers may have several available with different capabilities.
    /// 
    /// There may be none if SDL was compiled without render support.
    /// 
    /// - Returns: the number of built in render drivers.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateRenderer
    /// - See also: SDL_GetRenderDriver
    /// 
    public static var driverCount: Int32 {
        return SDL_GetNumRenderDrivers()
    }

    /// 
    /// Use this function to get the name of a built in 2D rendering driver.
    /// 
    /// The list of rendering drivers is given in the order that they are normally
    /// initialized by default; the drivers that seem more reasonable to choose
    /// first (as far as the SDL developers believe) are earlier in the list.
    /// 
    /// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
    /// "direct3d12" or "metal". These never have Unicode characters, and are not
    /// meant to be proper names.
    /// 
    /// - Parameter index: the index of the rendering driver; the value ranges from 0 to
    ///              SDL_GetNumRenderDrivers() - 1.
    /// - Returns: the name of the rendering driver at the requested index, or nil
    ///          if an invalid index was specified.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetNumRenderDrivers
    /// 
    public static func driver(for index: Int32) -> String? {
        if let s = SDL_GetRenderDriver(index) {
            return String(cString: s)
        } else {
            return nil
        }
    }

    nonisolated(unsafe) internal let renderer: OpaquePointer
    public unowned var window: SDLWindow?

    internal init(rawValue: OpaquePointer) {
        renderer = rawValue
    }

    deinit {
        SDL_DestroyRenderer(renderer)
    }

    /// 
    /// Get the name of a renderer.
    /// 
    /// - Parameter renderer: the rendering context.
    /// - Returns: the name of the selected renderer
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateRenderer
    /// - See also: SDL_CreateRendererWithProperties
    /// 
    public var name: String {
        get throws {
            if let s = SDL_GetRendererName(renderer) {
                return String(cString: s)
            } else {
                throw SDLError()
            }
        }
    }

    // TODO: SDL_GetRendererProperties

    /// 
    /// Get the output size in pixels of a rendering context.
    /// 
    /// This returns the true output size in pixels, ignoring any render targets or
    /// logical size and presentation.
    /// 
    /// For the output size of the current rendering target, with logical size
    /// adjustments, use SDL_GetCurrentRenderOutputSize() instead.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetCurrentRenderOutputSize
    /// 
    @MainActor
    public var outputSize: SDLSize {
        get throws {
            var w: Int32 = 0, h: Int32 = 0
            if !SDL_GetRenderOutputSize(renderer, &w, &h) {
                throw SDLError()
            }
            return SDLSize(width: w, height: h)
        }
    }

    /// 
    /// Get the current output size in pixels of a rendering context.
    /// 
    /// If a rendering target is active, this will return the size of the rendering
    /// target in pixels, otherwise return the value of SDL_GetRenderOutputSize().
    /// 
    /// Rendering target or not, the output will be adjusted by the current logical
    /// presentation state, dictated by SDL_SetRenderLogicalPresentation().
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderOutputSize
    /// 
    @MainActor
    public var currentOutputSize: SDLSize {
        get throws {
            var w: Int32 = 0, h: Int32 = 0
            if !SDL_GetCurrentRenderOutputSize(renderer, &w, &h) {
                throw SDLError()
            }
            return SDLSize(width: w, height: h)
        }
    }

    /// 
    /// Get the current render target.
    /// 
    /// The default render target is the window for which the renderer was created,
    /// and is reported a nil here.
    /// 
    /// - Returns: the current render target or nil for the default render target.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderTarget
    /// 
    @MainActor
    public var renderTarget: SDLTexture? {
        get throws {
            if let t = SDL_GetRenderTarget(renderer) {
                return SDLTexture(rawValue: t, owned: false, renderer: self)
            } else {
                return nil
            }
        }
    }

    /// 
    /// Set a texture as the current rendering target.
    /// 
    /// The default render target is the window for which the renderer was created.
    /// To stop rendering to a texture and render to the window again, call this
    /// function with a nil `texture`.
    /// 
    /// Viewport, cliprect, scale, and logical presentation are unique to each
    /// render target. Get and set functions for these states apply to the current
    /// render target set by this function, and those states persist on each target
    /// when the current render target changes.
    /// 
    /// - Parameter texture: the targeted texture, which must be created with the
    ///                `SDL_TEXTUREACCESS_TARGET` flag, or nil to render to the
    ///                window instead of a texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderTarget
    /// 
    @MainActor
    public func set(renderTarget value: SDLTexture?) throws {
        if !SDL_SetRenderTarget(renderer, value?.texture) {
            throw SDLError()
        }
    }

    /// 
    /// Get device independent resolution and presentation mode for rendering.
    /// 
    /// This function gets the width and height of the logical rendering output, or
    /// the output size in pixels if a logical resolution is not enabled.
    /// 
    /// Each render target has its own logical presentation state. This function
    /// gets the state for the current render target.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderLogicalPresentation
    /// 
    @MainActor
    public var logicalPresentation: (LogicalPresentation, SDLSize) {
        get throws {
            var mode: SDL_RendererLogicalPresentation = SDL_LOGICAL_PRESENTATION_DISABLED
            var w: Int32 = 0, h: Int32 = 0
            if !SDL_GetRenderLogicalPresentation(renderer, &w, &h, &mode) {
                throw SDLError()
            }
            return (.sdl(mode), SDLSize(width: w, height: h))
        }
    }

    /// 
    /// Set a device-independent resolution and presentation mode for rendering.
    /// 
    /// This function sets the width and height of the logical rendering output.
    /// The renderer will act as if the current render target is always the
    /// requested dimensions, scaling to the actual resolution as necessary.
    /// 
    /// This can be useful for games that expect a fixed size, but would like to
    /// scale the output to whatever is available, regardless of how a user resizes
    /// a window, or if the display is high DPI.
    /// 
    /// Logical presentation can be used with both render target textures and the
    /// renderer's window; the state is unique to each render target, and this
    /// function sets the state for the current render target. It might be useful
    /// to draw to a texture that matches the window dimensions with logical
    /// presentation enabled, and then draw that texture across the entire window
    /// with logical presentation disabled. Be careful not to render both with
    /// logical presentation enabled, however, as this could produce
    /// double-letterboxing, etc.
    /// 
    /// You can disable logical coordinates by setting the mode to
    /// SDL_LOGICAL_PRESENTATION_DISABLED, and in that case you get the full pixel
    /// resolution of the render target; it is safe to toggle logical presentation
    /// during the rendering of a frame: perhaps most of the rendering is done to
    /// specific dimensions but to make fonts look sharp, the app turns off logical
    /// presentation while drawing text, for example.
    /// 
    /// For the renderer's window, letterboxing is drawn into the framebuffer if
    /// logical presentation is enabled during SDL_RenderPresent; be sure to
    /// reenable it before presenting if you were toggling it, otherwise the
    /// letterbox areas might have artifacts from previous frames (or artifacts
    /// from external overlays, etc). Letterboxing is never drawn into texture
    /// render targets; be sure to call SDL_RenderClear() before drawing into the
    /// texture so the letterboxing areas are cleared, if appropriate.
    /// 
    /// You can convert coordinates in an event into rendering coordinates using
    /// SDL_ConvertEventToRenderCoordinates().
    /// 
    /// - Parameter logicalPresentation: the presentation mode used.
    /// - Parameter size: the size of the logical resolution.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_ConvertEventToRenderCoordinates
    /// - See also: SDL_GetRenderLogicalPresentation
    /// - See also: SDL_GetRenderLogicalPresentationRect
    /// 
    @MainActor
    public func set(logicalPresentation mode: LogicalPresentation, size: SDLSize) throws {
        if !SDL_SetRenderLogicalPresentation(renderer, size.width, size.height, mode.sdlValue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the final presentation rectangle for rendering.
    /// 
    /// This function returns the calculated rectangle used for logical
    /// presentation, based on the presentation mode and output size. If logical
    /// presentation is disabled, it will fill the rectangle with the output size,
    /// in pixels.
    /// 
    /// Each render target has its own logical presentation state. This function
    /// gets the rectangle for the current render target.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderLogicalPresentation
    /// 
    @MainActor
    public var logicalPresentationRect: SDLFRect {
        get throws {
            var rect = SDL_FRect()
            if !SDL_GetRenderLogicalPresentationRect(renderer, &rect) {
                throw SDLError()
            }
            return SDLFRect(from: rect)
        }
    }

    /// 
    /// Get the drawing area for the current target.
    /// 
    /// Each render target has its own viewport. This function gets the viewport
    /// for the current render target.
    /// 
    /// - Returns: an SDL_Rect structure filled in with the current drawing area.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderViewportSet
    /// - See also: SDL_SetRenderViewport
    /// 
    @MainActor
    public var viewport: SDLRect? {
        get throws {
            if !SDL_RenderViewportSet(renderer) {
                return nil
            }
            var rect = SDL_Rect()
            if !SDL_GetRenderViewport(renderer, &rect) {
                throw SDLError()
            }
            return SDLRect(from: rect)
        }
    }

    /// 
    /// Set the drawing area for rendering on the current target.
    /// 
    /// Drawing will clip to this area (separately from any clipping done with
    /// SDL_SetRenderClipRect), and the top left of the area will become coordinate
    /// (0, 0) for future drawing commands.
    /// 
    /// The area's width and height must be >= 0.
    /// 
    /// Each render target has its own viewport. This function sets the viewport
    /// for the current render target.
    /// 
    /// - Parameter rect: the SDL_Rect structure representing the drawing area, or nil
    ///             to set the viewport to the entire target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderViewport
    /// - See also: SDL_RenderViewportSet
    /// 
    @MainActor
    public func set(viewport value: SDLRect?) throws {
        if var rect = value?.sdlRect {
            if !SDL_SetRenderViewport(renderer, &rect) {
                throw SDLError()
            }
        } else {
            if !SDL_SetRenderViewport(renderer, nil) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Return whether an explicit rectangle was set as the viewport.
    /// 
    /// This is useful if you're saving and restoring the viewport and want to know
    /// whether you should restore a specific rectangle or nil. Note that the
    /// viewport is always reset when changing rendering targets.
    /// 
    /// Each render target has its own viewport. This function checks the viewport
    /// for the current render target.
    /// 
    /// - Returns: true if the viewport was set to a specific rectangle, or false if
    ///          it was set to nil (the entire target).
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderViewport
    /// - See also: SDL_SetRenderViewport
    /// 
    @MainActor
    public var viewportSet: Bool {
        return SDL_RenderViewportSet(renderer)
    }

    /// 
    /// Get the safe area for rendering within the current viewport.
    /// 
    /// Some devices have portions of the screen which are partially obscured or
    /// not interactive, possibly due to on-screen controls, curved edges, camera
    /// notches, TV overscan, etc. This function provides the area of the current
    /// viewport which is safe to have interactible content. You should continue
    /// rendering into the rest of the render target, but it should not contain
    /// visually important or interactible content.
    /// 
    /// - Returns: a SDLRect filled in with the area that is safe for interactive
    ///             content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var safeArea: SDLRect {
        get throws {
            var rect = SDL_Rect()
            if !SDL_GetRenderSafeArea(renderer, &rect) {
                throw SDLError()
            }
            return SDLRect(from: rect)
        }
    }

    /// 
    /// Get the clip rectangle for the current target.
    /// 
    /// Each render target has its own clip rectangle. This function gets the
    /// cliprect for the current render target.
    /// 
    /// - Returns: an SDLRect structure filled in with the current clipping area
    ///             or nil if clipping is disabled.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderClipEnabled
    /// - See also: SDL_SetRenderClipRect
    /// 
    @MainActor
    public var clipRect: SDLRect? {
        get throws {
            var rect = SDL_Rect()
            if !SDL_GetRenderClipRect(renderer, &rect) {
                throw SDLError()
            }
            if rect.w == 0 && rect.h == 0 {
                return nil
            }
            return SDLRect(from: rect)
        }
    }

    /// 
    /// Set the clip rectangle for rendering on the specified target.
    /// 
    /// Each render target has its own clip rectangle. This function sets the
    /// cliprect for the current render target.
    /// 
    /// - Parameter rect: an SDL_Rect structure representing the clip area, relative to
    ///             the viewport, or nil to disable clipping.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderClipRect
    /// - See also: SDL_RenderClipEnabled
    /// 
    @MainActor
    public func set(clipRect value: SDLRect?) throws {
        if var rect = value?.sdlRect {
            if !SDL_SetRenderClipRect(renderer, &rect) {
                throw SDLError()
            }
        } else {
            if !SDL_SetRenderClipRect(renderer, nil) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get whether clipping is enabled on the given render target.
    /// 
    /// Each render target has its own clip rectangle. This function checks the
    /// cliprect for the current render target.
    /// 
    /// - Returns: true if clipping is enabled or false if not
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderClipRect
    /// - See also: SDL_SetRenderClipRect
    /// 
    @MainActor
    public var clipEnabled: Bool {
        return SDL_RenderClipEnabled(renderer)
    }

    /// 
    /// Get the drawing scale for the current target.
    /// 
    /// Each render target has its own scale. This function gets the scale for the
    /// current render target.
    /// 
    /// - Returns: the horizontal and vertical scaling factor.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderScale
    /// 
    @MainActor
    public var scale: SDLFSize {
        get throws {
            var x: Float = 0, y: Float = 0
            if !SDL_GetRenderScale(renderer, &x, &y) {
                throw SDLError()
            }
            return SDLFSize(width: x, height: y)
        }
    }

    /// 
    /// Set the drawing scale for rendering on the current target.
    /// 
    /// The drawing coordinates are scaled by the x/y scaling factors before they
    /// are used by the renderer. This allows resolution independent drawing with a
    /// single coordinate system.
    /// 
    /// If this results in scaling or subpixel drawing by the rendering backend, it
    /// will be handled using the appropriate quality hints. For best results use
    /// integer scaling factors.
    /// 
    /// Each render target has its own scale. This function sets the scale for the
    /// current render target.
    /// 
    /// - Parameter scaleX: the horizontal scaling factor.
    /// - Parameter scaleY: the vertical scaling factor.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderScale
    /// 
    @MainActor
    public func set(scale value: SDLFSize) throws {
        if !SDL_SetRenderScale(renderer, value.width, value.height) {
            throw SDLError()
        }
    }

    /// 
    /// Get the color used for drawing operations (Rect, Line and Clear).
    /// 
    /// - Returns: the color used to draw on the rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderDrawColorFloat
    /// - See also: SDL_SetRenderDrawColor
    /// 
    @MainActor
    public var drawColor: SDLColor {
        get throws {
            var r: UInt8 = 0, g: UInt8 = 0, b: UInt8 = 0, a: UInt8 = 0
            if !SDL_GetRenderDrawColor(renderer, &r, &g, &b, &a) {
                throw SDLError()
            }
            return SDLColor(red: r, green: g, blue: b, alpha: a)
        }
    }

    /// 
    /// Set the color used for drawing operations.
    /// 
    /// Set the color for drawing or filling rectangles, lines, and points, and for
    /// SDL_RenderClear().
    ///
    /// Use SDL_SetRenderDrawBlendMode to specify how the alpha channel is used.
    /// 
    /// - Parameter drawColor: the color used to draw on the rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderDrawColor
    /// - See also: SDL_SetRenderDrawColorFloat
    /// 
    @MainActor
    public func set(drawColor value: SDLColor) throws {
        if !SDL_SetRenderDrawColor(renderer, value.red, value.green, value.blue, value.alpha) {
            throw SDLError()
        }
    }

    /// 
    /// Get the color used for drawing operations (Rect, Line and Clear).
    /// 
    /// - Returns: the color used to draw on the rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderDrawColorFloat
    /// - See also: SDL_SetRenderDrawColor
    /// 
    @MainActor
    public var drawColorFloat: SDLFColor {
        get throws {
            var r: Float = 0, g: Float = 0, b: Float = 0, a: Float = 0
            if !SDL_GetRenderDrawColorFloat(renderer, &r, &g, &b, &a) {
                throw SDLError()
            }
            return SDLFColor(red: r, green: g, blue: b, alpha: a)
        }
    }

    /// 
    /// Set the color used for drawing operations.
    /// 
    /// Set the color for drawing or filling rectangles, lines, and points, and for
    /// SDL_RenderClear().
    ///
    /// Use SDL_SetRenderDrawBlendMode to specify how the alpha channel is used.
    /// 
    /// - Parameter drawColor: the color used to draw on the rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderDrawColor
    /// - See also: SDL_SetRenderDrawColorFloat
    /// 
    @MainActor
    public func set(drawColorFloat value: SDLFColor) throws {
        if !SDL_SetRenderDrawColorFloat(renderer, value.red, value.green, value.blue, value.alpha) {
            throw SDLError()
        }
    }

    /// 
    /// Get the color scale used for render operations.
    /// 
    /// - Returns: the current color scale value.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderColorScale
    /// 
    @MainActor
    public var colorScale: Float {
        get throws {
            var scale: Float = 0.0
            if !SDL_GetRenderColorScale(renderer, &scale) {
                throw SDLError()
            }
            return scale
        }
    }

    /// 
    /// Set the color scale used for render operations.
    /// 
    /// The color scale is an additional scale multiplied into the pixel color
    /// value while rendering. This can be used to adjust the brightness of colors
    /// during HDR rendering, or changing HDR video brightness when playing on an
    /// SDR display.
    /// 
    /// The color scale does not affect the alpha channel, only the color
    /// brightness.
    /// 
    /// - Parameter scale: the color scale value.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderColorScale
    /// 
    @MainActor
    public func set(colorScale value: Float) throws {
        if !SDL_SetRenderColorScale(renderer, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the blend mode used for drawing operations.
    /// 
    /// - Returns: the current SDL_BlendMode.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderDrawBlendMode
    /// 
    @MainActor
    public var blendMode: SDLSurface.BlendMode {
        get throws {
            var mode: UInt32 = 0
            if !SDL_GetRenderDrawBlendMode(renderer, &mode) {
                throw SDLError()
            }
            return SDLSurface.BlendMode(rawValue: mode)
        }
    }

    /// 
    /// Set the blend mode used for drawing operations (Fill and Line).
    /// 
    /// If the blend mode is not supported, the closest supported mode is chosen.
    /// 
    /// - Parameter blendMode: the SDL_BlendMode to use for blending.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderDrawBlendMode
    /// 
    @MainActor
    public func set(blendMode value: SDLSurface.BlendMode) throws {
        if !SDL_SetRenderDrawBlendMode(renderer, value.rawValue) {
            throw SDLError()
        }
    }

    /// 
    /// Get VSync of the given renderer.
    /// 
    /// - Returns: the current vertical refresh sync interval.
    ///              See SDL_SetRenderVSync() for the meaning of the value.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderVSync
    /// 
    @MainActor
    public var vsync: Int {
        get throws {
            var res: Int32 = 0
            if !SDL_GetRenderVSync(renderer, &res) {
                throw SDLError()
            }
            return Int(res)
        }
    }

    /// 
    /// Toggle VSync of the given renderer.
    /// 
    /// When a renderer is created, vsync defaults to SDL_RENDERER_VSYNC_DISABLED.
    /// 
    /// The `vsync` parameter can be 1 to synchronize present with every vertical
    /// refresh, 2 to synchronize present with every second vertical refresh, etc.,
    /// SDL_RENDERER_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync), or
    /// SDL_RENDERER_VSYNC_DISABLED to disable. Not every value is supported by
    /// every driver, so you should check the return value to see whether the
    /// requested setting is supported.
    /// 
    /// - Parameter vsync: the vertical refresh sync interval.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderVSync
    /// 
    @MainActor
    public func set(vsync value: Int) throws {
        if !SDL_SetRenderVSync(renderer, Int32(value)) {
            throw SDLError()
        }
    }

    /// 
    /// Create a texture for a rendering context.
    /// 
    /// The contents of a texture when first created are not defined.
    /// 
    /// - Parameter renderer: the rendering context.
    /// - Parameter format: one of the enumerated values in SDL_PixelFormat.
    /// - Parameter access: one of the enumerated values in SDL_TextureAccess.
    /// - Parameter w: the width of the texture in pixels.
    /// - Parameter h: the height of the texture in pixels.
    /// - Returns: the created texture
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateTextureFromSurface
    /// - See also: SDL_CreateTextureWithProperties
    /// - See also: SDL_DestroyTexture
    /// - See also: SDL_GetTextureSize
    /// - See also: SDL_UpdateTexture
    /// 
    @MainActor
    public func texture(with format: SDLPixelFormat, access: SDLTexture.Access, width: Int32, height: Int32) throws -> SDLTexture {
        if let t = SDL_CreateTexture(renderer, format.fmt, access.sdlValue, width, height) {
            return SDLTexture(rawValue: t, owned: true, renderer: self)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Create a texture from an existing surface.
    /// 
    /// The surface is not modified or freed by this function.
    /// 
    /// The SDL_TextureAccess hint for the created texture is
    /// `SDL_TEXTUREACCESS_STATIC`.
    /// 
    /// The pixel format of the created texture may be different from the pixel
    /// format of the surface, and can be queried using the
    /// SDL_PROP_TEXTURE_FORMAT_NUMBER property.
    /// 
    /// - Parameter renderer: the rendering context.
    /// - Parameter surface: the SDL_Surface structure containing pixel data used to fill
    ///                the texture.
    /// - Returns: the created texture
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateTexture
    /// - See also: SDL_CreateTextureWithProperties
    /// - See also: SDL_DestroyTexture
    /// 
    @MainActor
    public func texture(from surface: SDLSurface) throws -> SDLTexture {
        if let t = SDL_CreateTextureFromSurface(renderer, surface.surf.pointer) {
            return SDLTexture(rawValue: t, owned: true, renderer: self)
        } else {
            throw SDLError()
        }
    }

    // TODO: SDL_CreateTextureWithProperties

    /// 
    /// Get a point in render coordinates when given a point in window coordinates.
    /// 
    /// This takes into account several states:
    /// 
    /// - The window dimensions.
    /// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
    /// - The scale (SDL_SetRenderScale)
    /// - The viewport (SDL_SetRenderViewport)
    /// 
    /// - Parameter point: the coordinates in window coordinates.
    /// - Returns: a SDLFPoint filled with the coordinates in render coordinates.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderLogicalPresentation
    /// - See also: SDL_SetRenderScale
    /// 
    @MainActor
    public func coordinates(fromWindow point: SDLFPoint) throws -> SDLFPoint {
        var x: Float = 0.0, y: Float = 0.0
        if !SDL_RenderCoordinatesFromWindow(renderer, point.x, point.y, &x, &y) {
            throw SDLError()
        }
        return SDLFPoint(x: x, y: y)
    }

    /// 
    /// Get a point in window coordinates when given a point in render coordinates.
    /// 
    /// This takes into account several states:
    /// 
    /// - The window dimensions.
    /// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
    /// - The scale (SDL_SetRenderScale)
    /// - The viewport (SDL_SetRenderViewport)
    /// 
    /// - Parameter point: the coordinates in render coordinates.
    /// - Returns: a SDLFPoint filled with the coordinates in window coordinates.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderLogicalPresentation
    /// - See also: SDL_SetRenderScale
    /// - See also: SDL_SetRenderViewport
    /// 
    @MainActor
    public func coordinates(toWindow point: SDLFPoint) throws -> SDLFPoint {
        var x: Float = 0.0, y: Float = 0.0
        if !SDL_RenderCoordinatesToWindow(renderer, point.x, point.y, &x, &y) {
            throw SDLError()
        }
        return SDLFPoint(x: x, y: y)
    }

    /// 
    /// Convert the coordinates in an event to render coordinates.
    /// 
    /// This takes into account several states:
    /// 
    /// - The window dimensions.
    /// - The logical presentation settings (SDL_SetRenderLogicalPresentation)
    /// - The scale (SDL_SetRenderScale)
    /// - The viewport (SDL_SetRenderViewport)
    /// 
    /// Various event types are converted with this function: mouse, touch, pen,
    /// etc.
    /// 
    /// Touch coordinates are converted from normalized coordinates in the window
    /// to non-normalized rendering coordinates.
    /// 
    /// Relative mouse coordinates (xrel and yrel event fields) are _also_
    /// converted. Applications that do not want these fields converted should use
    /// SDL_RenderCoordinatesFromWindow() on the specific event fields instead of
    /// converting the entire event structure.
    /// 
    /// Once converted, coordinates may be outside the rendering area.
    /// 
    /// - Parameter event: the event to modify.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderCoordinatesFromWindow
    /// 
    @MainActor
    public func convertEventCoordinates<T: SDLEventType>(in event: T) throws -> T {
        var ev = event.sdlEvent
        if !SDL_ConvertEventToRenderCoordinates(renderer, &ev) {
            throw SDLError()
        }
        return T(from: ev)
    }

    /// 
    /// Clear the current rendering target with the drawing color.
    /// 
    /// This function clears the entire rendering target, ignoring the viewport and
    /// the clip rectangle. Note, that clearing will also set/fill all pixels of
    /// the rendering target to current renderer draw color, so make sure to invoke
    /// SDL_SetRenderDrawColor() when needed.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetRenderDrawColor
    /// 
    @MainActor
    public func clear() throws {
        if !SDL_RenderClear(renderer) {
            throw SDLError()
        }
    }

    /// 
    /// Draw a point on the current rendering target at subpixel precision.
    /// 
    /// - Parameter point: the coordinates of the point.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderPoints
    /// 
    @MainActor
    public func render(point: SDLFPoint) throws {
        if !SDL_RenderPoint(renderer, point.x, point.y) {
            throw SDLError()
        }
    }

    /// 
    /// Draw multiple points on the current rendering target at subpixel precision.
    /// 
    /// - Parameter points: the points to draw.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderPoint
    /// 
    @MainActor
    public func render(points: [SDLFPoint]) throws {
        let ok = points.map {$0.sdlPoint}.withContiguousStorageIfAvailable { _points in
            SDL_RenderPoints(self.renderer, _points.baseAddress, Int32(points.count))
        }!
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Draw a line on the current rendering target at subpixel precision.
    /// 
    /// - Parameter lineFrom: the coordinates of the start point.
    /// - Parameter to: the coordinates of the end point.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderLines
    /// 
    @MainActor
    public func render(lineFrom from: SDLFPoint, to: SDLFPoint) throws {
        if !SDL_RenderLine(renderer, from.x, from.y, to.x, to.y) {
            throw SDLError()
        }
    }

    /// 
    /// Draw a series of connected lines on the current rendering target at
    /// subpixel precision.
    /// 
    /// - Parameter points: the points along the lines.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderLine
    /// 
    @MainActor
    public func render(lines: [SDLFPoint]) throws {
        let ok = lines.map {$0.sdlPoint}.withContiguousStorageIfAvailable { _lines in
            SDL_RenderLines(self.renderer, _lines.baseAddress, Int32(lines.count))
        }!
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Draw a rectangle on the current rendering target at subpixel precision.
    /// 
    /// - Parameter rect: the destination rectangle, or nil to outline the
    ///             entire rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderRects
    /// 
    @MainActor
    public func render(rect: SDLFRect?) throws {
        if var r = rect?.sdlRect {
            if !SDL_RenderRect(renderer, &r) {
                throw SDLError()
            }
        } else {
            if !SDL_RenderRect(renderer, nil) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Draw some number of rectangles on the current rendering target at subpixel
    /// precision.
    /// 
    /// - Parameter rects: an array of destination rectangles.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderRect
    /// 
    @MainActor
    public func render(rects: [SDLFRect]) throws {
        let ok = rects.map {$0.sdlRect}.withContiguousStorageIfAvailable { _rects in
            SDL_RenderRects(self.renderer, _rects.baseAddress, Int32(rects.count))
        }!
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Fill a rectangle on the current rendering target with the drawing color at
    /// subpixel precision.
    /// 
    /// - Parameter rect: the destination rectangle, or nil for the entire
    ///             rendering target.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderFillRects
    /// 
    @MainActor
    public func render(fillRect rect: SDLFRect?) throws {
        if var r = rect?.sdlRect {
            if !SDL_RenderRect(renderer, &r) {
                throw SDLError()
            }
        } else {
            if !SDL_RenderRect(renderer, nil) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Fill some number of rectangles on the current rendering target with the
    /// drawing color at subpixel precision.
    /// 
    /// - Parameter rects: an array of destination rectangles.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderFillRect
    /// 
    @MainActor
    public func render(fillRects rects: [SDLFRect]) throws {
        let ok = rects.map {$0.sdlRect}.withContiguousStorageIfAvailable { _rects in
            SDL_RenderRects(self.renderer, _rects.baseAddress, Int32(rects.count))
        }!
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Copy a portion of the texture to the current rendering target at subpixel
    /// precision.
    /// 
    /// - Parameter texture: the source texture.
    /// - Parameter to: the destination rectangle, or nil for the
    ///                entire rendering target.
    /// - Parameter from: the source rectangle, or nil for the entire
    ///                texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderTextureRotated
    /// - See also: SDL_RenderTextureTiled
    /// 
    @MainActor
    public func render(texture: SDLTexture, to: SDLFRect?, from: SDLFRect? = nil) throws {
        if var src = from?.sdlRect {
            if var dst = to?.sdlRect {
                if !SDL_RenderTexture(renderer, texture.texture, &src, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTexture(renderer, texture.texture, &src, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dst = to?.sdlRect {
                if !SDL_RenderTexture(renderer, texture.texture, nil, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTexture(renderer, texture.texture, nil, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Copy a portion of the source texture to the current rendering target, with
    /// rotation and flipping, at subpixel precision.
    /// 
    /// - Parameter texture: the source texture.
    /// - Parameter to: the destination rectangle, or nil for the
    ///                entire rendering target.
    /// - Parameter angle: an angle in degrees that indicates the rotation that will be
    ///              applied to dstrect, rotating it in a clockwise direction.
    /// - Parameter center: a point indicating the point around which
    ///               dstrect will be rotated (if nil, rotation will be done
    ///               around dstrect.w/2, dstrect.h/2).
    /// - Parameter flip: an SDL_FlipMode value stating which flipping actions should be
    ///             performed on the texture.
    /// - Parameter from: the source rectangle, or nil for the entire
    ///                texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderTexture
    /// 
    @MainActor
    public func render(texture: SDLTexture, to: SDLFRect?, angle: Double, center: SDLFPoint, flip: FlipMode, from: SDLFRect? = nil) throws {
        var centerp = center.sdlPoint
        if var src = from?.sdlRect {
            if var dst = to?.sdlRect {
                if !SDL_RenderTextureRotated(renderer, texture.texture, &src, &dst, angle, &centerp, flip.sdlValue) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTextureRotated(renderer, texture.texture, &src, nil, angle, &centerp, flip.sdlValue) {
                    throw SDLError()
                }
            }
        } else {
            if var dst = to?.sdlRect {
                if !SDL_RenderTextureRotated(renderer, texture.texture, nil, &dst, angle, &centerp, flip.sdlValue) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTextureRotated(renderer, texture.texture, nil, nil, angle, &centerp, flip.sdlValue) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Copy a portion of the source texture to the current rendering target, with
    /// affine transform, at subpixel precision.
    /// 
    /// - Parameter texture: the source texture.
    /// - Parameter origin: a point indicating where the top-left corner of
    ///               srcrect should be mapped to, or nil for the rendering
    ///               target's origin.
    /// - Parameter right: a point indicating where the top-right corner of
    ///              srcrect should be mapped to, or nil for the rendering
    ///              target's top-right corner.
    /// - Parameter down: a point indicating where the bottom-left corner of
    ///             srcrect should be mapped to, or nil for the rendering target's
    ///             bottom-left corner.
    /// - Parameter from: the source rectangle, or nil for the entire
    ///                texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderTexture
    /// 
    @MainActor
    public func render(texture: SDLTexture, origin: SDLFPoint?, right: SDLFPoint?, down: SDLFPoint?, from: SDLFRect? = nil) throws {
        // disgusting!
        if var originp = origin?.sdlPoint {
            if var rightp = right?.sdlPoint {
                if var downp = down?.sdlPoint {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, &originp, &rightp, &downp) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, &originp, &rightp, &downp) {
                            throw SDLError()
                        }
                    }
                } else {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, &originp, &rightp, nil) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, &originp, &rightp, nil) {
                            throw SDLError()
                        }
                    }
                }
            } else {
                if var downp = down?.sdlPoint {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, &originp, nil, &downp) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, &originp, nil, &downp) {
                            throw SDLError()
                        }
                    }
                } else {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, &originp, nil, nil) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, &originp, nil, nil) {
                            throw SDLError()
                        }
                    }
                }
            }
        } else {
            if var rightp = right?.sdlPoint {
                if var downp = down?.sdlPoint {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, nil, &rightp, &downp) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, nil, &rightp, &downp) {
                            throw SDLError()
                        }
                    }
                } else {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, nil, &rightp, nil) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, nil, &rightp, nil) {
                            throw SDLError()
                        }
                    }
                }
            } else {
                if var downp = down?.sdlPoint {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, nil, nil, &downp) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, nil, nil, &downp) {
                            throw SDLError()
                        }
                    }
                } else {
                    if var src = from?.sdlRect {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, &src, nil, nil, nil) {
                            throw SDLError()
                        }
                    } else {
                        if !SDL_RenderTextureAffine(renderer, texture.texture, nil, nil, nil, nil) {
                            throw SDLError()
                        }
                    }
                }
            }
        }
    }

    /// 
    /// Tile a portion of the texture to the current rendering target at subpixel
    /// precision.
    /// 
    /// The pixels in `srcrect` will be repeated as many times as needed to
    /// completely fill `dstrect`.
    /// 
    /// - Parameter renderer: the renderer which should copy parts of a texture.
    /// - Parameter texture: the source texture.
    /// - Parameter to: the destination rectangle, or nil for the
    ///                entire rendering target.
    /// - Parameter scale: the scale used to transform srcrect into the destination
    ///              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
    ///              64x64 tiles.
    /// - Parameter from: the source rectangle, or nil for the entire
    ///                texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderTexture
    /// 
    @MainActor func render(textureTiled texture: SDLTexture, to: SDLFRect?, scale: Float, from: SDLFRect? = nil) throws {
        if var src = from?.sdlRect {
            if var dst = to?.sdlRect {
                if !SDL_RenderTextureTiled(renderer, texture.texture, &src, scale, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTextureTiled(renderer, texture.texture, &src, scale, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dst = to?.sdlRect {
                if !SDL_RenderTextureTiled(renderer, texture.texture, nil, scale, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTextureTiled(renderer, texture.texture, nil, scale, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Perform a scaled copy using the 9-grid algorithm to the current rendering
    /// target at subpixel precision.
    /// 
    /// The pixels in the texture are split into a 3x3 grid, using the different
    /// corner sizes for each corner, and the sides and center making up the
    /// remaining pixels. The corners are then scaled using `scale` and fit into
    /// the corners of the destination rectangle. The sides and center are then
    /// stretched into place to cover the remaining destination rectangle.
    /// 
    /// - Parameter texture: the source texture.
    /// - Parameter to: the destination rectangle, or nil for the
    ///                entire rendering target.
    /// - Parameter left_width: the width, in pixels, of the left corners in `srcrect`.
    /// - Parameter right_width: the width, in pixels, of the right corners in `srcrect`.
    /// - Parameter top_height: the height, in pixels, of the top corners in `srcrect`.
    /// - Parameter bottom_height: the height, in pixels, of the bottom corners in
    ///                      `srcrect`.
    /// - Parameter scale: the scale used to transform the corner of `srcrect` into the
    ///              corner of `dstrect`, or 0.0f for an unscaled copy.
    /// - Parameter from: the SDL_Rect structure representing the rectangle to be used
    ///                for the 9-grid, or nil to use the entire texture.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderTexture
    /// 
    @MainActor
    public func render(texture9Grid texture: SDLTexture, to: SDLFRect?, leftWidth: Float, rightWidth: Float, topHeight: Float, bottomHeight: Float, scale: Float, from: SDLFRect? = nil) throws {
        if var src = from?.sdlRect {
            if var dst = to?.sdlRect {
                if !SDL_RenderTexture9Grid(renderer, texture.texture, &src, leftWidth, rightWidth, topHeight, bottomHeight, scale, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTexture9Grid(renderer, texture.texture, &src, leftWidth, rightWidth, topHeight, bottomHeight, scale, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dst = to?.sdlRect {
                if !SDL_RenderTexture9Grid(renderer, texture.texture, nil, leftWidth, rightWidth, topHeight, bottomHeight, scale, &dst) {
                    throw SDLError()
                }
            } else {
                if !SDL_RenderTexture9Grid(renderer, texture.texture, nil, leftWidth, rightWidth, topHeight, bottomHeight, scale, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Render a list of triangles, optionally using a texture and indices into the
    /// vertex array Color and alpha modulation is done per vertex
    /// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
    /// 
    /// - Parameter vertices: vertices.
    /// - Parameter texture: (optional) The SDL texture to use.
    /// - Parameter indices: (optional) An array of integer indices into the 'vertices'
    ///                array, if nil all vertices will be rendered in sequential
    ///                order.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderGeometryRaw
    /// 
    @MainActor
    public func render(geometry vertices: [SDLVertex], texture: SDLTexture? = nil, indices: [Int]? = nil) throws {
        let ok: Bool
        if let indices = indices {
            ok = vertices.map {$0.sdlVertex}.withContiguousStorageIfAvailable { _vertices in
                indices.map {Int32($0)}.withContiguousStorageIfAvailable { _indices in
                    SDL_RenderGeometry(self.renderer, texture?.texture, _vertices.baseAddress, Int32(vertices.count), _indices.baseAddress, Int32(indices.count))
                }!
            }!
        } else {
            ok = vertices.map {$0.sdlVertex}.withContiguousStorageIfAvailable { _vertices in
                SDL_RenderGeometry(self.renderer, texture?.texture, _vertices.baseAddress, Int32(vertices.count), nil, 0)
            }!
        }
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Render a list of triangles, optionally using a texture and indices into the
    /// vertex arrays Color and alpha modulation is done per vertex
    /// (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
    /// 
    /// - Parameter xy: vertex positions.
    /// - Parameter color: vertex colors (as SDL_FColor).
    /// - Parameter uv: vertex normalized texture coordinates.
    /// - Parameter texture: (optional) The SDL texture to use.
    /// - Parameter indices: (optional) An array of indices into the 'vertices' arrays,
    ///                if nil all vertices will be rendered in sequential order.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderGeometry
    /// 
    @MainActor
    public func render(geometryRaw xy: [Float], colors: [SDLFColor], uv: [Float], texture: SDLTexture? = nil, indices: [Int32]? = nil) throws {
        if xy.count % 2 != 0 {
            throw SDLError(message: "Vertex array count must be even")
        }
        if colors.count != xy.count / 2 {
            throw SDLError(message: "Vertex color array count must be half the XY array count")
        }
        if uv.count != xy.count {
            throw SDLError(message: "Vertex UV array count must be equal to XY array count")
        }
        let colorsp = colors.map {$0.sdlColor}
        let ok: Bool
        if let indices = indices {
            ok = xy.withContiguousStorageIfAvailable { _xy in
                colorsp.withContiguousStorageIfAvailable {_colors in
                    uv.withContiguousStorageIfAvailable {_uv in
                        indices.withContiguousStorageIfAvailable { _indices in
                            SDL_RenderGeometryRaw(self.renderer, texture?.texture, _xy.baseAddress, 8, _colors.baseAddress, 16, _uv.baseAddress, 8, Int32(xy.count / 2), _indices.baseAddress, Int32(indices.count), 4)
                        }!
                    }!
                }!
            }!
        } else {
            ok = xy.withContiguousStorageIfAvailable { _xy in
                colorsp.withContiguousStorageIfAvailable {_colors in
                    uv.withContiguousStorageIfAvailable {_uv in
                        SDL_RenderGeometryRaw(self.renderer, texture?.texture, _xy.baseAddress, 8, _colors.baseAddress, 16, _uv.baseAddress, 8, Int32(xy.count / 2), nil, 0, 4)
                    }!
                }!
            }!
        }
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Draw debug text to an SDL_Renderer.
    /// 
    /// This function will render a string of text to an SDL_Renderer. Note that
    /// this is a convenience function for debugging, with severe limitations, and
    /// not intended to be used for production apps and games.
    /// 
    /// Among these limitations:
    /// 
    /// - It accepts UTF-8 strings, but will only renders ASCII characters.
    /// - It has a single, tiny size (8x8 pixels). One can use logical presentation
    ///   or scaling to adjust it, but it will be blurry.
    /// - It uses a simple, hardcoded bitmap font. It does not allow different font
    ///   selections and it does not support truetype, for proper scaling.
    /// - It does no word-wrapping and does not treat newline characters as a line
    ///   break. If the text goes out of the window, it's gone.
    /// 
    /// For serious text rendering, there are several good options, such as
    /// SDL_ttf, stb_truetype, or other external libraries.
    /// 
    /// On first use, this will create an internal texture for rendering glyphs.
    /// This texture will live until the renderer is destroyed.
    /// 
    /// The text is drawn in the color specified by SDL_SetRenderDrawColor().
    /// 
    /// - Parameter debugText: the string to render.
    /// - Parameter at: the coordinates where the top-left corner of the text will draw.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_RenderDebugTextFormat
    /// - See also: SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE
    /// 
    @MainActor
    public func render(debugText: String, at pos: SDLFPoint) throws {
        if !SDL_RenderDebugText(renderer, pos.x, pos.y, debugText) {
            throw SDLError()
        }
    }

    /// 
    /// Read pixels from the current rendering target.
    /// 
    /// The returned surface contains pixels inside the desired area clipped to the
    /// current viewport, and should be freed with SDL_DestroySurface().
    /// 
    /// Note that this returns the actual pixels on the screen, so if you are using
    /// logical presentation you should use SDL_GetRenderLogicalPresentationRect()
    /// to get the area containing your content.
    /// 
    /// **WARNING**: This is a very slow operation, and should not be used
    /// frequently. If you're using this on the main rendering target, it should be
    /// called after rendering and before SDL_RenderPresent().
    /// 
    /// - Parameter rect: an SDL_Rect structure representing the area to read, which will
    ///             be clipped to the current viewport, or nil for the entire
    ///             viewport.
    /// - Returns: a new SDL_Surface on success
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func readPixels(in rect: SDLRect) throws -> SDLSurface {
        var r = rect.sdlRect
        if let surf = SDL_RenderReadPixels(renderer, &r) {
            return SDLSurface(from: surf.sendable, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Update the screen with any rendering performed since the previous call.
    /// 
    /// SDL's rendering functions operate on a backbuffer; that is, calling a
    /// rendering function such as SDL_RenderLine() does not directly put a line on
    /// the screen, but rather updates the backbuffer. As such, you compose your
    /// entire scene and *present* the composed backbuffer to the screen as a
    /// complete picture.
    /// 
    /// Therefore, when using SDL's rendering API, one does all drawing intended
    /// for the frame, and then calls this function once per frame to present the
    /// final drawing to the user.
    /// 
    /// The backbuffer should be considered invalidated after each present; do not
    /// assume that previous contents will exist between frames. You are strongly
    /// encouraged to call SDL_RenderClear() to initialize the backbuffer before
    /// starting each new frame's drawing, even if you plan to overwrite every
    /// pixel.
    /// 
    /// Please note, that in case of rendering to a texture - there is **no need**
    /// to call `SDL_RenderPresent` after drawing needed objects to a texture, and
    /// should not be done; you are only required to change back the rendering
    /// target to default via `SDL_SetRenderTarget(renderer, nil)` afterwards, as
    /// textures by themselves do not have a concept of backbuffers. Calling
    /// SDL_RenderPresent while rendering to a texture will still update the screen
    /// with any current drawing that has been done _to the window itself_.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateRenderer
    /// - See also: SDL_RenderClear
    /// - See also: SDL_RenderFillRect
    /// - See also: SDL_RenderFillRects
    /// - See also: SDL_RenderLine
    /// - See also: SDL_RenderLines
    /// - See also: SDL_RenderPoint
    /// - See also: SDL_RenderPoints
    /// - See also: SDL_RenderRect
    /// - See also: SDL_RenderRects
    /// - See also: SDL_SetRenderDrawBlendMode
    /// - See also: SDL_SetRenderDrawColor
    /// 
    @MainActor
    public func present() throws {
        if !SDL_RenderPresent(renderer) {
            throw SDLError()
        }
    }

    /// 
    /// Force the rendering context to flush any pending commands and state.
    /// 
    /// You do not need to (and in fact, shouldn't) call this function unless you
    /// are planning to call into OpenGL/Direct3D/Metal/whatever directly, in
    /// addition to using an SDL_Renderer.
    /// 
    /// This is for a very-specific case: if you are using SDL's render API, and
    /// you plan to make OpenGL/D3D/whatever calls in addition to SDL render API
    /// calls. If this applies, you should call this function between calls to
    /// SDL's render API and the low-level API you're using in cooperation.
    /// 
    /// In all other cases, you can ignore this function.
    /// 
    /// This call makes SDL flush any pending rendering work it was queueing up to
    /// do later in a single batch, and marks any internal cached state as invalid,
    /// so it'll prepare all its state again later, from scratch.
    /// 
    /// This means you do not need to save state in your rendering code to protect
    /// the SDL renderer. However, there lots of arbitrary pieces of Direct3D and
    /// OpenGL state that can confuse things; you should use your best judgment and
    /// be prepared to make changes if specific state needs to be protected.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func flush() throws {
        if !SDL_FlushRenderer(renderer) {
            throw SDLError()
        }
    }
}

public extension Int {
    static let VSyncDisabled = 0
    static let VSyncAdaptive = -1
}

#if canImport(Metal)
import QuartzCore
import Metal

public extension SDLRenderer {
    /// 
    /// Get the CAMetalLayer associated with the given Metal renderer.
    /// 
    /// - Returns: a `CAMetalLayer` on success, or nil if the renderer isn't a
    ///          Metal renderer.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderMetalCommandEncoder
    /// 
    @MainActor
    var metalLayer: CAMetalLayer? {
        if let ptr = SDL_GetRenderMetalLayer(renderer) {
            return ptr.assumingMemoryBound(to: CAMetalLayer.self).pointee
        } else {
            return nil
        }
    }

    /// 
    /// Get the Metal command encoder for the current frame.
    /// 
    /// This function returns `void *`, so SDL doesn't have to include Metal's
    /// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
    /// 
    /// This will return nil if Metal refuses to give SDL a drawable to render to,
    /// which might happen if the window is hidden/minimized/offscreen. This
    /// doesn't apply to command encoders for render targets, just the window's
    /// backbuffer. Check your return values!
    /// 
    /// - Returns: an `id<MTLRenderCommandEncoder>` on success, or nil if the
    ///          renderer isn't a Metal renderer or there was an error.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetRenderMetalLayer
    /// 
    @MainActor
    var metalCommandEncoder: (any MTLRenderCommandEncoder)? {
        if let ptr = SDL_GetRenderMetalCommandEncoder(renderer) {
            return unsafeBitCast(ptr, to: (any MTLRenderCommandEncoder).self)
        } else {
            return nil
        }
    }
}
#endif
