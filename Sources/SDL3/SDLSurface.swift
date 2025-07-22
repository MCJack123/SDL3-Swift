import SDL3_Native

/// 
/// A collection of pixels used in software blitting.
/// 
/// Pixels are arranged in memory in rows, with the top row first. Each row
/// occupies an amount of memory given by the pitch (sometimes known as the row
/// stride in non-SDL APIs).
/// 
/// Within each row, pixels are arranged from left to right until the width is
/// reached. Each pixel occupies a number of bits appropriate for its format,
/// with most formats representing each pixel as one or more whole bytes (in
/// some indexed formats, instead multiple pixels are packed into each byte),
/// and a byte order given by the format. After encoding all pixels, any
/// remaining bytes to reach the pitch are used as padding to reach a desired
/// alignment, and have undefined contents.
/// 
/// When a surface holds YUV format data, the planes are assumed to be
/// contiguous without padding between them, e.g. a 32x32 surface in NV12
/// format with a pitch of 32 would consist of 32x32 bytes of Y plane followed
/// by 32x16 bytes of UV plane.
/// 
/// When a surface holds MJPG format data, pixels points at the compressed JPEG
/// image and pitch is the length of that data.
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
/// - See: SDL_CreateSurface
/// - See: SDL_DestroySurface
/// 
public actor SDLSurface {
    /// 
    /// A set of blend modes used in drawing operations.
    /// 
    /// These predefined blend modes are supported everywhere.
    /// 
    /// Additional values may be obtained from BlendMode's constructor.
    /// 
    /// - Since: This datatype is available since SDL 3.2.0.
    /// 
    /// - See: SDL_ComposeCustomBlendMode
    ///
    public struct BlendMode: OptionSet, Sendable {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        /// no blending: dstRGBA = srcRGBA
        public static let none = BlendMode([])
        /// alpha blending: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)), dstA = srcA + (dstA * (1-srcA))
        public static let blend = BlendMode(rawValue: 0x00000001)
        /// pre-multiplied alpha blending: dstRGBA = srcRGBA + (dstRGBA * (1-srcA))
        public static let blendPremultiplied = BlendMode(rawValue: 0x00000010)
        /// additive blending: dstRGB = (srcRGB * srcA) + dstRGB, dstA = dstA
        public static let add = BlendMode(rawValue: 0x00000002)
        /// pre-multiplied additive blending: dstRGB = srcRGB + dstRGB, dstA = dstA
        public static let addPremultiplied = BlendMode(rawValue: 0x00000020)
        /// color modulate: dstRGB = srcRGB * dstRGB, dstA = dstA
        public static let modulate = BlendMode(rawValue: 0x00000004)
        /// color multiply: dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)), dstA = dstA
        public static let multiply = BlendMode(rawValue: 0x00000008)
        public static let invalid = BlendMode(rawValue: 0x7FFFFFFF)
        /// 
        /// Compose a custom blend mode for renderers.
        /// 
        /// The functions SDL_SetRenderDrawBlendMode and SDL_SetTextureBlendMode accept
        /// the SDL_BlendMode returned by this function if the renderer supports it.
        /// 
        /// A blend mode controls how the pixels from a drawing operation (source) get
        /// combined with the pixels from the render target (destination). First, the
        /// components of the source and destination pixels get multiplied with their
        /// blend factors. Then, the blend operation takes the two products and
        /// calculates the result that will get stored in the render target.
        /// 
        /// Expressed in pseudocode, it would look like this:
        /// 
        /// ```c
        /// dstRGB = colorOperation(srcRGB * srcColorFactor, dstRGB * dstColorFactor);
        /// dstA = alphaOperation(srcA * srcAlphaFactor, dstA * dstAlphaFactor);
        /// ```
        /// 
        /// Where the functions `colorOperation(src, dst)` and `alphaOperation(src,
        /// dst)` can return one of the following:
        /// 
        /// - `src + dst`
        /// - `src - dst`
        /// - `dst - src`
        /// - `min(src, dst)`
        /// - `max(src, dst)`
        /// 
        /// The red, green, and blue components are always multiplied with the first,
        /// second, and third components of the SDL_BlendFactor, respectively. The
        /// fourth component is not used.
        /// 
        /// The alpha component is always multiplied with the fourth component of the
        /// SDL_BlendFactor. The other components are not used in the alpha
        /// calculation.
        /// 
        /// Support for these blend modes varies for each renderer. To check if a
        /// specific SDL_BlendMode is supported, create a renderer and pass it to
        /// either SDL_SetRenderDrawBlendMode or SDL_SetTextureBlendMode. They will
        /// return with an error if the blend mode is not supported.
        /// 
        /// This list describes the support of custom blend modes for each renderer.
        /// All renderers support the four blend modes listed in the SDL_BlendMode
        /// enumeration.
        /// 
        /// - **direct3d**: Supports all operations with all factors. However, some
        ///   factors produce unexpected results with `SDL_BLENDOPERATION_MINIMUM` and
        ///   `SDL_BLENDOPERATION_MAXIMUM`.
        /// - **direct3d11**: Same as Direct3D 9.
        /// - **opengl**: Supports the `SDL_BLENDOPERATION_ADD` operation with all
        ///   factors. OpenGL versions 1.1, 1.2, and 1.3 do not work correctly here.
        /// - **opengles2**: Supports the `SDL_BLENDOPERATION_ADD`,
        ///   `SDL_BLENDOPERATION_SUBTRACT`, `SDL_BLENDOPERATION_REV_SUBTRACT`
        ///   operations with all factors.
        /// - **psp**: No custom blend mode support.
        /// - **software**: No custom blend mode support.
        /// 
        /// Some renderers do not provide an alpha component for the default render
        /// target. The `SDL_BLENDFACTOR_DST_ALPHA` and
        /// `SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA` factors do not have an effect in this
        /// case.
        /// 
        /// - Parameter srcColorFactor: the SDL_BlendFactor applied to the red, green, and
        ///                       blue components of the source pixels.
        /// - Parameter dstColorFactor: the SDL_BlendFactor applied to the red, green, and
        ///                       blue components of the destination pixels.
        /// - Parameter colorOperation: the SDL_BlendOperation used to combine the red,
        ///                       green, and blue components of the source and
        ///                       destination pixels.
        /// - Parameter srcAlphaFactor: the SDL_BlendFactor applied to the alpha component of
        ///                       the source pixels.
        /// - Parameter dstAlphaFactor: the SDL_BlendFactor applied to the alpha component of
        ///                       the destination pixels.
        /// - Parameter alphaOperation: the SDL_BlendOperation used to combine the alpha
        ///                       component of the source and destination pixels.
        /// - Returns: a BlendMode that represents the chosen factors and
        ///          operations.
        /// 
        /// - Since: This function is available since SDL 3.2.0.
        /// 
        /// - See: SDL_SetRenderDrawBlendMode
        /// - See: SDL_GetRenderDrawBlendMode
        /// - See: SDL_SetTextureBlendMode
        /// - See: SDL_GetTextureBlendMode
        /// 
        public init(
            srcColorFactor: BlendFactor,
            dstColorFactor: BlendFactor,
            colorOperation: BlendOperation,
            srcAlphaFactor: BlendFactor,
            dstAlphaFactor: BlendFactor,
            alphaOperation: BlendOperation
        ) {
            rawValue = SDL_ComposeCustomBlendMode(
                srcColorFactor.sdlValue,
                dstColorFactor.sdlValue,
                colorOperation.sdlValue,
                srcAlphaFactor.sdlValue,
                dstAlphaFactor.sdlValue,
                alphaOperation.sdlValue
            )
        }
    }

    /// 
    /// The blend operation used when combining source and destination pixel
    /// components.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_BlendOperation.self)
    public enum BlendOperation: UInt32 {
        /// dst + src: supported by all renderers
        case add = 1
        /// src - dst : supported by D3D, OpenGL, OpenGLES, and Vulkan
        case subtract = 2
        /// dst - src : supported by D3D, OpenGL, OpenGLES, and Vulkan
        case reverseSubtract = 3
        /// min(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
        case minimum = 4
        /// max(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
        case maximum = 5
    }

    /// 
    /// The normalized factor used to multiply pixel components.
    /// 
    /// The blend factors are multiplied with the pixels from a drawing operation
    /// (src) and the pixels from the render target (dst) before the blend
    /// operation. The comma-separated factors listed above are always applied in
    /// the component order red, green, blue, and alpha.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_BlendFactor.self)
    public enum BlendFactor: UInt32 {
        /// 0, 0, 0, 0
        case zero = 1
        /// 1, 1, 1, 1
        case one = 2
        /// srcR, srcG, srcB, srcA
        case sourceColor = 3
        /// 1-srcR, 1-srcG, 1-srcB, 1-srcA
        case oneMinusSourceColor = 4
        /// srcA, srcA, srcA, srcA
        case sourceAlpha = 5
        /// 1-srcA, 1-srcA, 1-srcA, 1-srcA
        case oneMinusSourceAlpha = 6
        /// dstR, dstG, dstB, dstA
        case destinationColor = 7
        /// 1-dstR, 1-dstG, 1-dstB, 1-dstA
        case oneMinusDestinationColor = 8
        /// dstA, dstA, dstA, dstA
        case destinationAlpha = 9
        /// 1-dstA, 1-dstA, 1-dstA, 1-dstA
        case oneMinusDestinationAlpha = 10
    }

    /// 
    /// The flip mode.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_FlipMode.self)
    public enum FlipMode: UInt32 {
        /// Do not flip
        case none
        /// flip horizontally
        case horizontal
        /// flip vertically
        case vertical
    }

    /// 
    /// The scaling mode.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_ScaleMode.self)
    public enum ScaleMode: UInt32 {
        /// nearest pixel sampling
        case nearest
        /// linear filtering
        case linear
    }

    internal let surf: SendableUnsafeMutablePointer<SDL_Surface>
    private let owned: Bool
    private let pixelData: SendableMutableRawPointer?
    public let width: Int32
    public let height: Int32
    public let pitch: Int32
    public let format: SDLPixelFormat
    public let pixels: UnsafeMutableRawPointer

    /// 
    /// Load a BMP image from a file.
    /// 
    /// The new surface should be freed with SDL_DestroySurface(). Not doing so
    /// will result in a memory leak.
    /// 
    /// - Parameter file: the BMP file to load.
    /// - Returns: a pointer to a new SDL_Surface structure or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_DestroySurface
    /// - See: SDL_LoadBMP_IO
    /// - See: SDL_SaveBMP
    /// 
    public static func loadBMP(at path: String) throws -> SDLSurface {
        if let ptr = nullCheck(SDL_LoadBMP(path)) {
            return SDLSurface(from: ptr, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Load a BMP image from a seekable SDL data stream.
    /// 
    /// The new surface should be freed with SDL_DestroySurface(). Not doing so
    /// will result in a memory leak.
    /// 
    /// - Parameter src: the data stream for the surface.
    /// - Parameter closeio: if true, calls SDL_CloseIO() on `src` before returning, even
    ///                in the case of an error.
    /// - Returns: a pointer to a new SDL_Surface structure or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_DestroySurface
    /// - See: SDL_LoadBMP
    /// - See: SDL_SaveBMP_IO
    /// 
    public static func loadBMP(from io: SDLIOStream) async throws -> SDLSurface {
        return SDLSurface(from: try await io.loadBMP().pointer, owned: true)
    }

    internal init(from: UnsafeMutablePointer<SDL_Surface>, owned _owned: Bool) {
        surf = from.sendable
        owned = _owned
        pixelData = nil
        width = surf.pointee.w
        height = surf.pointee.h
        pitch = surf.pointee.pitch
        format = SDLPixelFormat(from: surf.pointee.format)
        pixels = surf.pointee.pixels
    }

    internal init(from: SendableUnsafeMutablePointer<SDL_Surface>, owned _owned: Bool) {
        surf = from
        owned = _owned
        pixelData = nil
        width = surf.pointee.w
        height = surf.pointee.h
        pitch = surf.pointee.pitch
        format = SDLPixelFormat(from: surf.pointee.format)
        pixels = surf.pointee.pixels
    }

    /// 
    /// Allocate a new surface with a specific pixel format.
    /// 
    /// The pixels of the new surface are initialized to zero.
    /// 
    /// - Parameter width: the width of the surface.
    /// - Parameter height: the height of the surface.
    /// - Parameter format: the SDLPixelFormat for the new surface's pixel format.
    /// - Returns: the new SDL_Surface structure that is created or NULL on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateSurfaceFrom
    /// - See: SDL_DestroySurface
    /// 
    public init(width: Int32, height: Int32, format: SDLPixelFormat) throws {
        if let surface = nullCheck(SDL_CreateSurface(width, height, format.fmt)) {
            self.init(from: surface, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Allocate a new surface with a specific pixel format and existing pixel
    /// data.
    /// 
    /// No copy is made of the pixel data. Pixel data is not managed automatically;
    /// you must free the surface before you free the pixel data.
    /// 
    /// Pitch is the offset in bytes from one row of pixels to the next, e.g.
    /// `width*4` for `SDL_PIXELFORMAT_RGBA8888`.
    /// 
    /// You may pass NULL for pixels and 0 for pitch to create a surface that you
    /// will fill in with valid values later.
    /// 
    /// - Parameter width: the width of the surface.
    /// - Parameter height: the height of the surface.
    /// - Parameter format: the SDL_PixelFormat for the new surface's pixel format.
    /// - Parameter pixels: a pointer to existing pixel data.
    /// - Parameter pitch: the number of bytes between each row, including padding.
    /// - Returns: the new SDL_Surface structure that is created or NULL on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateSurface
    /// - See: SDL_DestroySurface
    /// 
    public init(width: Int32, height: Int32, format: SDLPixelFormat, from: [UInt32]) throws {
        let data = UnsafeMutablePointer<UInt32>.allocate(capacity: from.count)
        for i in 0..<from.count {
            data[i] = from[i]
        }
        if let surface = nullCheck(SDL_CreateSurfaceFrom(width, height, format.fmt, data, 4 * width)) {
            surf = surface.sendable
            owned = true
            pixelData = UnsafeMutableRawPointer(data).sendable
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

    /// 
    /// Allocate a new surface with a specific pixel format and existing pixel
    /// data.
    /// 
    /// No copy is made of the pixel data. Pixel data is not managed automatically;
    /// you must free the surface before you free the pixel data.
    /// 
    /// Pitch is the offset in bytes from one row of pixels to the next, e.g.
    /// `width*4` for `SDL_PIXELFORMAT_RGBA8888`.
    /// 
    /// You may pass NULL for pixels and 0 for pitch to create a surface that you
    /// will fill in with valid values later.
    /// 
    /// - Parameter width: the width of the surface.
    /// - Parameter height: the height of the surface.
    /// - Parameter format: the SDL_PixelFormat for the new surface's pixel format.
    /// - Parameter pixels: a pointer to existing pixel data.
    /// - Parameter pitch: the number of bytes between each row, including padding.
    /// - Returns: the new SDL_Surface structure that is created or NULL on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateSurface
    /// - See: SDL_DestroySurface
    /// 
    public init(width: Int32, height: Int32, format: SDLPixelFormat, from: [UInt8], pitch: Int32) throws {
        let data = UnsafeMutablePointer<UInt8>.allocate(capacity: from.count)
        for i in 0..<from.count {
            data[i] = from[i]
        }
        if let surface = nullCheck(SDL_CreateSurfaceFrom(width, height, format.fmt, data, pitch)) {
            surf = surface.sendable
            owned = true
            pixelData = UnsafeMutableRawPointer(data).sendable
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
            SDL_DestroySurface(surf.pointer)
            if let ptr = pixelData {
                ptr.pointer.deallocate()
            }
        }
    }

    // TODO: SDL_GetSurfaceProperties
    // TODO: SDL_[GS]etSurfaceColorspace

    /// 
    /// Returns whether the surface is RLE enabled.
    /// 
    /// - Returns: true if the surface is RLE enabled, false otherwise.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfaceRLE
    /// 
    public var rle: Bool {
        return SDL_SurfaceHasRLE(surf.pointer)
    }

    /// 
    /// Set the RLE acceleration hint for a surface.
    /// 
    /// If RLE is enabled, color key and alpha blending blits are much faster, but
    /// the surface must be locked before directly accessing the pixels.
    /// 
    /// - Parameter enabled: true to enable RLE acceleration, false to disable it.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurface
    /// - See: SDL_LockSurface
    /// - See: SDL_UnlockSurface
    /// 
    public func set(rle value: Bool) throws {
        if !SDL_SetSurfaceRLE(surf.pointer, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the color key (transparent pixel) for a surface.
    /// 
    /// The color key is a pixel of the format used by the surface, as generated by
    /// SDL_MapRGB().
    /// 
    /// If the surface doesn't have color key enabled this function returns nil.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfaceColorKey
    /// - See: SDL_SurfaceHasColorKey
    /// 
    public var colorKey: SDLColor? {
        get throws {
            if !SDL_SurfaceHasColorKey(surf.pointer) {
                return nil
            }
            var res: UInt32 = 0
            if SDL_GetSurfaceColorKey(surf.pointer, &res) {
                return SDLColor(from: res, as: format, with: palette)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Set the color key (transparent pixel) in a surface.
    /// 
    /// The color key defines a pixel value that will be treated as transparent in
    /// a blit. For example, one can use this to specify that cyan pixels should be
    /// considered transparent, and therefore not rendered.
    /// 
    /// It is a pixel of the format used by the surface, as generated by
    /// SDL_MapRGB().
    /// 
    /// - Parameter surface: the SDL_Surface structure to update.
    /// - Parameter enabled: true to enable color key, false to disable color key.
    /// - Parameter key: the transparent pixel.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceColorKey
    /// - See: SDL_SetSurfaceRLE
    /// - See: SDL_SurfaceHasColorKey
    /// 
    public func set(colorKey value: SDLColor?) throws {
        let ok: Bool
        if let value = value {
            ok = SDL_SetSurfaceColorKey(surf.pointer, true, value.rgb(as: format, with: palette))
        } else {
            ok = SDL_SetSurfaceColorKey(surf.pointer, false, 0)
        }
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Returns whether the surface has a color key.
    /// 
    /// - Returns: true if the surface has a color key, false otherwise.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfaceColorKey
    /// - See: SDL_GetSurfaceColorKey
    /// 
    public var hasColorKey: Bool {
        return SDL_SurfaceHasColorKey(surf.pointer)
    }

    /// 
    /// Get the additional color value multiplied into blit operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceAlphaMod
    /// - See: SDL_SetSurfaceColorMod
    /// 
    public var colorMod: SDLColor {
        get throws {
            var r: UInt8 = 0, g: UInt8 = 0, b: UInt8 = 0
            if !SDL_GetSurfaceColorMod(self.surf.pointer, &r, &g, &b) {
                throw SDLError()
            }
            return SDLColor(red: r, green: g, blue: b)
        }
    }

    /// 
    /// Set an additional color value multiplied into blit operations.
    /// 
    /// When this surface is blitted, during the blit operation each source color
    /// channel is modulated by the appropriate color value according to the
    /// following formula:
    /// 
    /// `srcC = srcC * (color / 255)`
    /// 
    /// - Parameter colorMod: the color value multiplied into blit operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceColorMod
    /// - See: SDL_SetSurfaceAlphaMod
    /// 
    public func set(colorMod value: SDLColor) throws {
        if !SDL_SetSurfaceColorMod(surf.pointer, value.red, value.green, value.blue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the additional alpha value used in blit operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceColorMod
    /// - See: SDL_SetSurfaceAlphaMod
    /// 
    public var alphaMod: UInt8 {
        get throws {
            var a: UInt8 = 0
            if !SDL_GetSurfaceAlphaMod(self.surf.pointer, &a) {
                throw SDLError()
            }
            return a
        }
    }

    /// 
    /// Set an additional alpha value used in blit operations.
    /// 
    /// When this surface is blitted, during the blit operation the source alpha
    /// value is modulated by this alpha value according to the following formula:
    /// 
    /// `srcA = srcA * (alpha / 255)`
    /// 
    /// - Parameter alphaMod: the alpha value multiplied into blit operations.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceAlphaMod
    /// - See: SDL_SetSurfaceColorMod
    /// 
    public func set(alphaMod value: UInt8) throws {
        if !SDL_SetSurfaceAlphaMod(surf.pointer, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the blend mode used for blit operations.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfaceBlendMode
    /// 
    public var blendMode: BlendMode {
        get throws {
            var res: SDL_BlendMode = SDL_BLENDMODE_NONE
            if !SDL_GetSurfaceBlendMode(self.surf.pointer, &res) {
                throw SDLError()
            }
            return BlendMode(rawValue: res)
        }
    }

    /// 
    /// Set the blend mode used for blit operations.
    /// 
    /// To copy a surface to another surface (or texture) without blending with the
    /// existing data, the blendmode of the SOURCE surface should be set to
    /// `SDL_BLENDMODE_NONE`.
    /// 
    /// - Parameter blendMode: the SDL_BlendMode to use for blit blending.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceBlendMode
    /// 
    public func set(blendMode value: BlendMode) throws {
        if !SDL_SetSurfaceBlendMode(surf.pointer, SDL_BlendMode(value.rawValue)) {
            throw SDLError()
        }
    }

    /// 
    /// Get the clipping rectangle for a surface.
    /// 
    /// When `surface` is the destination of a blit, only the area within the clip
    /// rectangle is drawn into.
    /// 
    /// - Parameter surface: the SDL_Surface structure representing the surface to be
    ///                clipped.
    /// - Parameter rect: an SDL_Rect structure filled in with the clipping rectangle for
    ///             the surface.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfaceClipRect
    /// 
    public var clipRect: SDLRect {
        get throws {
            var rect = SDL_Rect()
            if !SDL_GetSurfaceClipRect(surf.pointer, &rect) {
                throw SDLError()
            }
            return SDLRect(from: rect)
        }
    }

    /// 
    /// Set the clipping rectangle for a surface.
    /// 
    /// When `surface` is the destination of a blit, only the area within the clip
    /// rectangle is drawn into.
    /// 
    /// Note that blits are automatically clipped to the edges of the source and
    /// destination surfaces.
    /// 
    /// - Parameter surface: the SDL_Surface structure to be clipped.
    /// - Parameter rect: the SDL_Rect structure representing the clipping rectangle, or
    ///             NULL to disable clipping.
    /// - Returns: true if the rectangle intersects the surface, otherwise false and
    ///          blits will be completely clipped.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetSurfaceClipRect
    /// 
    public func set(clipRect value: SDLRect) throws {
        var rect = value.sdlRect
        if !SDL_SetSurfaceClipRect(surf.pointer, &rect) {
            throw SDLError()
        }
    }

    /// 
    /// Performs a fast blit from the source surface to the destination surface
    /// with clipping.
    /// 
    /// If either `srcrect` or `dstrect` are NULL, the entire surface (`src` or
    /// `dst`) is copied while ensuring clipping to `dst->clip_rect`.
    /// 
    /// The final blit rectangles are saved in `srcrect` and `dstrect` after all
    /// clipping is performed.
    /// 
    /// The blit function should not be called on a locked surface.
    /// 
    /// The blit semantics for surfaces with and without blending and colorkey are
    /// defined as follows:
    /// 
    /// ```
    ///    RGBA->RGB:
    ///      Source surface blend mode set to SDL_BLENDMODE_BLEND:
    ///       alpha-blend (using the source alpha-channel and per-surface alpha)
    ///       SDL_SRCCOLORKEY ignored.
    ///     Source surface blend mode set to SDL_BLENDMODE_NONE:
    ///       copy RGB.
    ///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
    ///       RGB values of the source color key, ignoring alpha in the
    ///       comparison.
    /// 
    ///   RGB->RGBA:
    ///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
    ///       alpha-blend (using the source per-surface alpha)
    ///     Source surface blend mode set to SDL_BLENDMODE_NONE:
    ///       copy RGB, set destination alpha to source per-surface alpha value.
    ///     both:
    ///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
    ///       source color key.
    /// 
    ///   RGBA->RGBA:
    ///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
    ///       alpha-blend (using the source alpha-channel and per-surface alpha)
    ///       SDL_SRCCOLORKEY ignored.
    ///     Source surface blend mode set to SDL_BLENDMODE_NONE:
    ///       copy all of RGBA to the destination.
    ///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
    ///       RGB values of the source color key, ignoring alpha in the
    ///       comparison.
    /// 
    ///   RGB->RGB:
    ///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
    ///       alpha-blend (using the source per-surface alpha)
    ///     Source surface blend mode set to SDL_BLENDMODE_NONE:
    ///       copy RGB.
    ///     both:
    ///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
    ///       source color key.
    /// ```
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be
    ///                copied, or NULL to copy the entire surface.
    /// - Parameter dstrect: the SDL_Rect structure representing the x and y position in
    ///                the destination surface, or NULL for (0,0). The width and
    ///                height are ignored, and are copied from `srcrect`. If you
    ///                want a specific width and height, you should use
    ///                SDL_BlitSurfaceScaled().
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurfaceScaled
    /// 
    public func blit(from src: SDLSurface, in srcRect: SDLRect?, to destPoint: SDLPoint?) throws {
        if var sr = srcRect?.sdlRect {
            if let destPoint = destPoint {
                var dr = SDL_Rect(x: destPoint.x, y: destPoint.y, w: 0, h: 0)
                if !SDL_BlitSurface(src.surf.pointer, &sr, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurface(src.surf.pointer, &sr, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        } else {
            if let destPoint = destPoint {
                var dr = SDL_Rect(x: destPoint.x, y: destPoint.y, w: 0, h: 0)
                if !SDL_BlitSurface(src.surf.pointer, nil, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurface(src.surf.pointer, nil, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Perform a scaled blit to a destination surface, which may be of a different
    /// format.
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be
    ///                copied, or NULL to copy the entire surface.
    /// - Parameter dstrect: the SDL_Rect structure representing the target rectangle in
    ///                the destination surface, or NULL to fill the entire
    ///                destination surface.
    /// - Parameter scaleMode: the SDL_ScaleMode to be used.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurface
    /// 
    public func blitScaled(from src: SDLSurface, in srcRect: SDLRect?, to destRect: SDLRect?, with mode: ScaleMode) throws {
        if var sr = srcRect?.sdlRect {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceScaled(src.surf.pointer, &sr, self.surf.pointer, &dr, mode.sdlValue) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceScaled(src.surf.pointer, &sr, self.surf.pointer, nil, mode.sdlValue) {
                    throw SDLError()
                }
            }
        } else {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceScaled(src.surf.pointer, nil, self.surf.pointer, &dr, mode.sdlValue) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceScaled(src.surf.pointer, nil, self.surf.pointer, nil, mode.sdlValue) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Perform a stretched pixel copy from one surface to another.
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be
    ///                copied, may not be NULL.
    /// - Parameter dstrect: the SDL_Rect structure representing the target rectangle in
    ///                the destination surface, may not be NULL.
    /// - Parameter scaleMode: the SDL_ScaleMode to be used.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.4.0.
    /// 
    /// - See: SDL_BlitSurfaceScaled
    /// 
    public func stretch(from src: SDLSurface, in srcRect: SDLRect, to destRect: SDLRect, with mode: ScaleMode) throws {
        var sr = srcRect.sdlRect, dr = destRect.sdlRect
        if !SDL_StretchSurface(src.surf.pointer, &sr, self.surf.pointer, &dr, mode.sdlValue) {
            throw SDLError()
        }
    }

    /// 
    /// Perform a tiled blit to a destination surface, which may be of a different
    /// format.
    /// 
    /// The pixels in `srcrect` will be repeated as many times as needed to
    /// completely fill `dstrect`.
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be
    ///                copied, or NULL to copy the entire surface.
    /// - Parameter dstrect: the SDL_Rect structure representing the target rectangle in
    ///                the destination surface, or NULL to fill the entire surface.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurface
    /// 
    public func blitTiled(from src: SDLSurface, in srcRect: SDLRect?, to destRect: SDLRect?) throws {
        if var sr = srcRect?.sdlRect {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceTiled(src.surf.pointer, &sr, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceTiled(src.surf.pointer, &sr, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceTiled(src.surf.pointer, nil, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceTiled(src.surf.pointer, nil, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Perform a scaled and tiled blit to a destination surface, which may be of a
    /// different format.
    /// 
    /// The pixels in `srcrect` will be scaled and repeated as many times as needed
    /// to completely fill `dstrect`.
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be
    ///                copied, or NULL to copy the entire surface.
    /// - Parameter scale: the scale used to transform srcrect into the destination
    ///              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
    ///              64x64 tiles.
    /// - Parameter scaleMode: scale algorithm to be used.
    /// - Parameter dstrect: the SDL_Rect structure representing the target rectangle in
    ///                the destination surface, or NULL to fill the entire surface.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurface
    /// 
    public func blitTiled(from src: SDLSurface, in srcRect: SDLRect?, to destRect: SDLRect?, with scale: Float, mode: ScaleMode) throws {
        if var sr = srcRect?.sdlRect {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceTiledWithScale(src.surf.pointer, &sr, scale, mode.sdlValue, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceTiledWithScale(src.surf.pointer, &sr, scale, mode.sdlValue, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurfaceTiledWithScale(src.surf.pointer, nil, scale, mode.sdlValue, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurfaceTiledWithScale(src.surf.pointer, nil, scale, mode.sdlValue, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Perform a scaled blit using the 9-grid algorithm to a destination surface,
    /// which may be of a different format.
    /// 
    /// The pixels in the source surface are split into a 3x3 grid, using the
    /// different corner sizes for each corner, and the sides and center making up
    /// the remaining pixels. The corners are then scaled using `scale` and fit
    /// into the corners of the destination rectangle. The sides and center are
    /// then stretched into place to cover the remaining destination rectangle.
    /// 
    /// - Parameter src: the SDL_Surface structure to be copied from.
    /// - Parameter srcrect: the SDL_Rect structure representing the rectangle to be used
    ///                for the 9-grid, or NULL to use the entire surface.
    /// - Parameter left_width: the width, in pixels, of the left corners in `srcrect`.
    /// - Parameter right_width: the width, in pixels, of the right corners in `srcrect`.
    /// - Parameter top_height: the height, in pixels, of the top corners in `srcrect`.
    /// - Parameter bottom_height: the height, in pixels, of the bottom corners in
    ///                      `srcrect`.
    /// - Parameter scale: the scale used to transform the corner of `srcrect` into the
    ///              corner of `dstrect`, or 0.0f for an unscaled blit.
    /// - Parameter scaleMode: scale algorithm to be used.
    /// - Parameter dstrect: the SDL_Rect structure representing the target rectangle in
    ///                the destination surface, or NULL to fill the entire surface.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: The same destination surface should not be used from two
    ///               threads at once. It is safe to use the same source surface
    ///               from multiple threads.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_BlitSurface
    /// 
    public func blit9Grid(from src: SDLSurface, in srcRect: SDLRect?, to destRect: SDLRect?, leftWidth: Int32, rightWidth: Int32, topHeight: Int32, bottomHeight: Int32, with scale: Float, mode: ScaleMode) throws {
        if var sr = srcRect?.sdlRect {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurface9Grid(src.surf.pointer, &sr, leftWidth, rightWidth, topHeight, bottomHeight, scale, mode.sdlValue, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurface9Grid(src.surf.pointer, &sr, leftWidth, rightWidth, topHeight, bottomHeight, scale, mode.sdlValue, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        } else {
            if var dr = destRect?.sdlRect {
                if !SDL_BlitSurface9Grid(src.surf.pointer, nil, leftWidth, rightWidth, topHeight, bottomHeight, scale, mode.sdlValue, self.surf.pointer, &dr) {
                    throw SDLError()
                }
            } else {
                if !SDL_BlitSurface9Grid(src.surf.pointer, nil, leftWidth, rightWidth, topHeight, bottomHeight, scale, mode.sdlValue, self.surf.pointer, nil) {
                    throw SDLError()
                }
            }
        }
    }

    /// 
    /// Clear a surface with a specific color, with floating point precision.
    /// 
    /// This function handles all surface formats, and ignores any clip rectangle.
    /// 
    /// If the surface is YUV, the color is assumed to be in the sRGB colorspace,
    /// otherwise the color is assumed to be in the colorspace of the suface.
    /// 
    /// - Parameter color: the color of the pixel to clear with
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func clear(with color: SDLColor) throws {
        if !SDL_ClearSurface(surf.pointer, Float(color.red) / 255.0, Float(color.green) / 255.0, Float(color.blue) / 255.0, Float(color.alpha) / 255.0) {
            throw SDLError()
        }
    }

    /// 
    /// Premultiply the alpha in a surface.
    /// 
    /// This is safe to use with src == dst, but not for other overlapping areas.
    /// 
    /// - Parameter linear: true to convert from sRGB to linear space for the alpha
    ///               multiplication, false to do multiplication in sRGB space.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func premultiplyAlpha(linear: Bool) throws {
        if !SDL_PremultiplySurfaceAlpha(surf.pointer, linear) {
            throw SDLError()
        }
    }

    /// 
    /// Copy an existing surface to a new surface of the specified format.
    /// 
    /// This function is used to optimize images for faster *repeat* blitting. This
    /// is accomplished by converting the original and storing the result as a new
    /// surface. The new, optimized surface can then be used as the source for
    /// future blits, making them faster.
    /// 
    /// If you are converting to an indexed surface and want to map colors to a
    /// palette, you can use SDL_ConvertSurfaceAndColorspace() instead.
    /// 
    /// If the original surface has alternate images, the new surface will have a
    /// reference to them as well.
    /// 
    /// - Parameter format: the new pixel format.
    /// - Returns: the new SDL_Surface structure that is created or NULL on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_ConvertSurfaceAndColorspace
    /// - See: SDL_DestroySurface
    /// 
    public func convert(to format: SDLPixelFormat) throws -> SDLSurface {
        if let s = nullCheck(SDL_ConvertSurface(surf.pointer, format.fmt)) {
            return SDLSurface(from: s.sendable, owned: true)
        } else {
            throw SDLError()
        }
    }

    // TODO: SDL_ConvertSurfaceAndColorspace

    /// 
    /// Creates a new surface identical to the existing surface.
    /// 
    /// If the original surface has alternate images, the new surface will have a
    /// reference to them as well.
    /// 
    /// - Returns: a copy of the surface or NULL on failure; call SDL_GetError() for
    ///          more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_DestroySurface
    /// 
    public func duplicate() throws -> SDLSurface {
        if let ptr = nullCheck(SDL_DuplicateSurface(surf.pointer)) {
            return SDLSurface(from: ptr.sendable, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Flip a surface vertically or horizontally.
    /// 
    /// - Parameter flip: the direction to flip.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func flip(in direction: FlipMode) throws {
        if !SDL_FlipSurface(surf.pointer, direction.sdlValue) {
            throw SDLError()
        }
    }

    /// 
    /// Creates a new surface identical to the existing surface, scaled to the
    /// desired size.
    /// 
    /// - Parameter width: the width of the new surface.
    /// - Parameter height: the height of the new surface.
    /// - Parameter scaleMode: the SDL_ScaleMode to be used.
    /// - Returns: a copy of the surface or NULL on failure; call SDL_GetError() for
    ///          more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_DestroySurface
    /// 
    public func scale(width: Int32, height: Int32, scaleMode: ScaleMode) throws -> SDLSurface {
        if let ptr = nullCheck(SDL_ScaleSurface(surf.pointer, width, height, scaleMode.sdlValue)) {
            return SDLSurface(from: ptr.sendable, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Create a palette and associate it with a surface.
    /// 
    /// This function creates a palette compatible with the provided surface. The
    /// palette is then returned for you to modify, and the surface will
    /// automatically use the new palette in future operations. You do not need to
    /// destroy the returned palette, it will be freed when the reference count
    /// reaches 0, usually when the surface is destroyed.
    /// 
    /// Bitmap surfaces (with format SDL_PIXELFORMAT_INDEX1LSB or
    /// SDL_PIXELFORMAT_INDEX1MSB) will have the palette initialized with 0 as
    /// white and 1 as black. Other surfaces will get a palette initialized with
    /// white in every entry.
    /// 
    /// If this function is called for a surface that already has a palette, a new
    /// palette will be created to replace it.
    /// 
    /// - Returns: a new SDL_Palette structure on success or NULL on failure (e.g. if
    ///          the surface didn't have an index format); call SDL_GetError() for
    ///          more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetPaletteColors
    /// 
    public func createPalette() throws -> SDLPalette {
        if let res = nullCheck(SDL_CreateSurfacePalette(surf.pointer)) {
            return SDLPalette(from: res)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Get the palette used by a surface.
    /// 
    /// - Returns: a pointer to the palette used by the surface, or NULL if there is
    ///          no palette used.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetSurfacePalette
    /// 
    public var palette: SDLPalette? {
        if let res = nullCheck(SDL_GetSurfacePalette(surf.pointer)) {
            return SDLPalette(from: res)
        } else {
            return nil
        }
    }

    /// 
    /// Set the palette used by a surface.
    /// 
    /// A single palette can be shared with many surfaces.
    /// 
    /// - Parameter palette: the SDL_Palette structure to use.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreatePalette
    /// - See: SDL_GetSurfacePalette
    /// 
    public func set(palette: SDLPalette) throws {
        if !SDL_SetSurfacePalette(surf.pointer, palette.ptr) {
            throw SDLError()
        }
    }

    /// 
    /// Set up a surface for directly accessing the pixels.
    /// 
    /// Inside calls to ``lock``, you can write to
    /// and read from `surface.pixels`, using the pixel format stored in
    /// `surface.format`.
    /// 
    /// Not all surfaces require locking. If `SDL_MUSTLOCK(surface)` evaluates to
    /// 0, then you can read and write to the surface at any time, and the pixel
    /// format of the surface will not change.
    /// 
    /// - Parameter body: The function to call with the locked surface.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MUSTLOCK
    /// - See: SDL_UnlockSurface
    /// 
    public func lock<Result>(_ body: (SDLSurface) throws -> Result) throws -> Result {
        if !SDL_LockSurface(surf.pointer) {
            throw SDLError()
        }
        defer {SDL_UnlockSurface(surf.pointer)}
        return try body(self)
    }

    /// 
    /// Save a surface to a seekable SDL data stream in BMP format.
    /// 
    /// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
    /// BMP directly. Other RGB formats with 8-bit or higher get converted to a
    /// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
    /// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
    /// not supported.
    /// 
    /// - Parameter dst: a data stream to save to.
    /// - Parameter closeio: if true, calls SDL_CloseIO() on `dst` before returning, even
    ///                in the case of an error.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_LoadBMP_IO
    /// - See: SDL_SaveBMP
    /// 
    public func saveBMP(into rw: SDLIOStream) async throws {
        try await rw.saveBMP(SDLIOStream.SurfacePointer(pointer: surf.pointer))
    }

    /// 
    /// Save a surface to a file.
    /// 
    /// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
    /// BMP directly. Other RGB formats with 8-bit or higher get converted to a
    /// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
    /// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
    /// not supported.
    /// 
    /// - Parameter file: a file to save to.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_LoadBMP
    /// - See: SDL_SaveBMP_IO
    /// 
    public func saveBMP(to path: String) throws {
        if !SDL_SaveBMP(surf.pointer, path) {
            throw SDLError()
        }
    }

    /// 
    /// Perform a fast fill of a rectangle with a specific color.
    /// 
    /// `color` should be a pixel of the format used by the surface, and can be
    /// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
    /// alpha component then the destination is simply filled with that alpha
    /// information, no blending takes place.
    /// 
    /// If there is a clip rectangle set on the destination (set via
    /// SDL_SetSurfaceClipRect()), then this function will fill based on the
    /// intersection of the clip rectangle and `rect`.
    /// 
    /// - Parameter rect: the SDL_Rect structure representing the rectangle to fill, or
    ///             NULL to fill the entire surface.
    /// - Parameter color: the color to fill with.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_FillSurfaceRects
    /// 
    public func fill(in rect: SDLRect?, with color: SDLColor) throws {
        if var sdlRect = rect?.sdlRect {
            if !SDL_FillSurfaceRect(self.surf.pointer, &sdlRect, color.rgba(as: self.format)) {
                throw SDLError()
            }
        } else {
            if !SDL_FillSurfaceRect(self.surf.pointer, nil, color.rgba(as: self.format)) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Perform a fast fill of a set of rectangles with a specific color.
    /// 
    /// `color` should be a pixel of the format used by the surface, and can be
    /// generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
    /// alpha component then the destination is simply filled with that alpha
    /// information, no blending takes place.
    /// 
    /// If there is a clip rectangle set on the destination (set via
    /// SDL_SetSurfaceClipRect()), then this function will fill based on the
    /// intersection of the clip rectangle and `rect`.
    /// 
    /// - Parameter rects: an array of SDL_Rects representing the rectangles to fill.
    /// - Parameter count: the number of rectangles in the array.
    /// - Parameter color: the color to fill with.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_FillSurfaceRect
    /// 
    public func fill(in rects: [SDLRect], with color: SDLColor) throws {
        let arr = UnsafeMutablePointer<SDL_Rect>.allocate(capacity: rects.count)
        defer {arr.deallocate()}
        for i in 0..<rects.count {
            arr[i] = rects[i].sdlRect
        }
        if !SDL_FillSurfaceRects(surf.pointer, arr, Int32(rects.count), color.rgba(as: format)) {
            throw SDLError()
        }
    }

    /// 
    /// Add an alternate version of a surface.
    /// 
    /// This function adds an alternate version of this surface, usually used for
    /// content with high DPI representations like cursors or icons. The size,
    /// format, and content do not need to match the original surface, and these
    /// alternate versions will not be updated when the original surface changes.
    /// 
    /// This function adds a reference to the alternate version, so you should call
    /// SDL_DestroySurface() on the image after this call.
    /// 
    /// - Parameter alternateImage: a pointer to an alternate SDL_Surface to associate with this
    ///              surface.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_RemoveSurfaceAlternateImages
    /// - See: SDL_GetSurfaceImages
    /// - See: SDL_SurfaceHasAlternateImages
    /// 
    public func add(alternateImage image: SDLSurface) throws {
        if !SDL_AddSurfaceAlternateImage(surf.pointer, image.surf.pointer) {
            throw SDLError()
        }
    }

    /// 
    /// Return whether a surface has alternate versions available.
    /// 
    /// - Parameter surface: the SDL_Surface structure to query.
    /// - Returns: true if alternate versions are available or false otherwise.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_AddSurfaceAlternateImage
    /// - See: SDL_RemoveSurfaceAlternateImages
    /// - See: SDL_GetSurfaceImages
    /// 
    public var hasAlternateImages: Bool {
        return SDL_SurfaceHasAlternateImages(surf.pointer)
    }

    /// 
    /// Get an array including all versions of a surface.
    /// 
    /// This returns all versions of a surface, with the surface being queried as
    /// the first element in the returned array.
    /// 
    /// Freeing the array of surfaces does not affect the surfaces in the array.
    /// They are still referenced by the surface being queried and will be cleaned
    /// up normally.
    /// 
    /// - Returns: a NULL terminated array of SDL_Surface pointers or NULL on
    ///          failure; call SDL_GetError() for more information. This should be
    ///          freed with SDL_free() when it is no longer needed.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_AddSurfaceAlternateImage
    /// - See: SDL_RemoveSurfaceAlternateImages
    /// - See: SDL_SurfaceHasAlternateImages
    /// 
    public var alternateImages: [SDLSurface] {
        get throws {
            var count: Int32 = 0
            if let arr = nullCheck(SDL_GetSurfaceImages(surf.pointer, &count)) {
                var res = [SDLSurface]()
                for i in 0..<Int(count) {
                    res.append(SDLSurface(from: arr[i]!.sendable, owned: false))
                }
                SDL_free(arr)
                return res
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Remove all alternate versions of a surface.
    /// 
    /// This function removes a reference from all the alternative versions,
    /// destroying them if this is the last reference to them.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_AddSurfaceAlternateImage
    /// - See: SDL_GetSurfaceImages
    /// - See: SDL_SurfaceHasAlternateImages
    /// 
    public func removeAlternateImages() {
        SDL_RemoveSurfaceAlternateImages(surf.pointer)
    }

    /// 
    /// Map an RGB triple to an opaque pixel value for a surface.
    /// 
    /// This function maps the RGB color value to the specified pixel format and
    /// returns the pixel value best approximating the given RGB color value for
    /// the given pixel format.
    /// 
    /// If the surface has a palette, the index of the closest matching color in
    /// the palette will be returned.
    /// 
    /// If the surface pixel format has an alpha component it will be returned as
    /// all 1 bits (fully opaque).
    /// 
    /// If the pixel format bpp (color depth) is less than 32-bpp then the unused
    /// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
    /// format the return value can be assigned to a Uint16, and similarly a Uint8
    /// for an 8-bpp format).
    /// 
    /// - Parameter color: the color to map.
    /// - Returns: a pixel value.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MapSurfaceRGBA
    /// 
    public func map(rgb: SDLColor) -> UInt32 {
        return SDL_MapSurfaceRGB(surf.pointer, rgb.red, rgb.green, rgb.blue)
    }

    /// 
    /// Map an RGBA quadruple to a pixel value for a surface.
    /// 
    /// This function maps the RGBA color value to the specified pixel format and
    /// returns the pixel value best approximating the given RGBA color value for
    /// the given pixel format.
    /// 
    /// If the surface pixel format has no alpha component the alpha value will be
    /// ignored (as it will be in formats with a palette).
    /// 
    /// If the surface has a palette, the index of the closest matching color in
    /// the palette will be returned.
    /// 
    /// If the pixel format bpp (color depth) is less than 32-bpp then the unused
    /// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
    /// format the return value can be assigned to a Uint16, and similarly a Uint8
    /// for an 8-bpp format).
    /// 
    /// - Parameter color: the color to map.
    /// - Returns: a pixel value.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MapSurfaceRGB
    /// 
    public func map(rgba: SDLColor) -> UInt32 {
        return SDL_MapSurfaceRGBA(surf.pointer, rgba.red, rgba.green, rgba.blue, rgba.alpha)
    }

    /// 
    /// Retrieves a single pixel from a surface.
    /// 
    /// This function prioritizes correctness over speed: it is suitable for unit
    /// tests, but is not intended for use in a game engine.
    /// 
    /// Like SDL_GetRGBA, this uses the entire 0..255 range when converting color
    /// components from pixel formats with less than 8 bits per RGB component.
    /// 
    /// - Parameter x: the horizontal coordinate, 0 <= x < width.
    /// - Parameter y: the vertical coordinate, 0 <= y < height.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func getPixel(atX x: Int32, y: Int32) throws -> SDLColor {
        var r: UInt8 = 0, g: UInt8 = 0, b: UInt8 = 0, a: UInt8 = 0
        if !SDL_ReadSurfacePixel(surf.pointer, x, y, &r, &g, &b, &a) {
            throw SDLError()
        }
        return SDLColor(red: r, green: g, blue: b, alpha: a)
    }

    /// 
    /// Writes a single pixel to a surface.
    /// 
    /// This function prioritizes correctness over speed: it is suitable for unit
    /// tests, but is not intended for use in a game engine.
    /// 
    /// Like SDL_MapRGBA, this uses the entire 0..255 range when converting color
    /// components from pixel formats with less than 8 bits per RGB component.
    /// 
    /// - Parameter x: the horizontal coordinate, 0 <= x < width.
    /// - Parameter y: the vertical coordinate, 0 <= y < height.
    /// - Parameter color: the color to write.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func setPixel(atX x: Int32, y: Int32, color: SDLColor) throws {
        if !SDL_WriteSurfacePixel(surf.pointer, x, y, color.red, color.green, color.blue, color.alpha) {
            throw SDLError()
        }
    }

    // TODO: SDL_ReadSurfacePixelFloat

    public private(set) var renderer: SDLRenderer? = nil
    
    /// 
    /// Create a 2D software rendering context for a surface.
    /// 
    /// Two other API which can be used to create SDL_Renderer:
    /// SDL_CreateRenderer() and SDL_CreateWindowAndRenderer(). These can _also_
    /// create a software renderer, but they are intended to be used with an
    /// SDL_Window as the final destination and not an SDL_Surface.
    /// 
    /// - Returns: a valid rendering context
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_DestroyRenderer
    /// 
    public func createRenderer() async throws -> SDLRenderer {
        if let r = renderer {
            return r
        }
        if let ren = await MainActor.run(body: {
            if let ptr = SDL_CreateSoftwareRenderer(surf.pointer) {
                return SDLRenderer(rawValue: ptr)
            } else {
                return nil
            }
        }) {
            renderer = ren
            return ren
        } else {
            throw SDLError()
        }
    }
}
