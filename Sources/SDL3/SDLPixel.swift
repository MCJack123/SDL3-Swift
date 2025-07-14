import SDL3_Native

public struct SDLPixelFormat {
    public static let unknown = SDLPixelFormat(from: SDL_PIXELFORMAT_UNKNOWN)
    public static let index1LSB = SDLPixelFormat(from: SDL_PIXELFORMAT_INDEX1LSB)
    public static let index1MSB = SDLPixelFormat(from: SDL_PIXELFORMAT_INDEX1MSB)
    public static let index4LSB = SDLPixelFormat(from: SDL_PIXELFORMAT_INDEX4LSB)
    public static let index4MSB = SDLPixelFormat(from: SDL_PIXELFORMAT_INDEX4MSB)
    public static let index8 = SDLPixelFormat(from: SDL_PIXELFORMAT_INDEX8)
    public static let rgb332 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGB332)
    public static let xrgb4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_XRGB4444)
    public static let xbgr4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_XBGR4444)
    public static let xrgb1555 = SDLPixelFormat(from: SDL_PIXELFORMAT_XRGB1555)
    public static let xbgr1555 = SDLPixelFormat(from: SDL_PIXELFORMAT_XBGR1555)
    public static let argb4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_ARGB4444)
    public static let rgba4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBA4444)
    public static let abgr4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_ABGR4444)
    public static let bgra4444 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRA4444)
    public static let argb1555 = SDLPixelFormat(from: SDL_PIXELFORMAT_ARGB1555)
    public static let rgba5551 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBA5551)
    public static let abgr1555 = SDLPixelFormat(from: SDL_PIXELFORMAT_ABGR1555)
    public static let bgra5551 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRA5551)
    public static let rgb565 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGB565)
    public static let bgr565 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGR565)
    public static let rgb24 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGB24)
    public static let bgr24 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGR24)
    public static let xrgb8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_XRGB8888)
    public static let rgbx8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBX8888)
    public static let xbgr8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_XBGR8888)
    public static let bgrx8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRX8888)
    public static let argb8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_ARGB8888)
    public static let rgba8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBA8888)
    public static let abgr8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_ABGR8888)
    public static let bgra8888 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRA8888)
    public static let argb2101010 = SDLPixelFormat(from: SDL_PIXELFORMAT_ARGB2101010)
    public static let rgba32 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBA32)
    public static let argb32 = SDLPixelFormat(from: SDL_PIXELFORMAT_ARGB32)
    public static let bgra32 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRA32)
    public static let abgr32 = SDLPixelFormat(from: SDL_PIXELFORMAT_ABGR32)
    public static let rgbx32 = SDLPixelFormat(from: SDL_PIXELFORMAT_RGBX32)
    public static let xrgb32 = SDLPixelFormat(from: SDL_PIXELFORMAT_XRGB32)
    public static let bgrx32 = SDLPixelFormat(from: SDL_PIXELFORMAT_BGRX32)
    public static let xbgr32 = SDLPixelFormat(from: SDL_PIXELFORMAT_XBGR32)
    public static let yv12 = SDLPixelFormat(from: SDL_PIXELFORMAT_YV12)
    public static let iyuv = SDLPixelFormat(from: SDL_PIXELFORMAT_IYUV)
    public static let yuy2 = SDLPixelFormat(from: SDL_PIXELFORMAT_YUY2)
    public static let uyvy = SDLPixelFormat(from: SDL_PIXELFORMAT_UYVY)
    public static let yvyu = SDLPixelFormat(from: SDL_PIXELFORMAT_YVYU)
    public static let nv12 = SDLPixelFormat(from: SDL_PIXELFORMAT_NV12)
    public static let nv21 = SDLPixelFormat(from: SDL_PIXELFORMAT_NV21)
    public static let externalOES = SDLPixelFormat(from: SDL_PIXELFORMAT_EXTERNAL_OES)

    internal let fmt: SDL_PixelFormat
    internal var details: UnsafePointer<SDL_PixelFormatDetails>? {
        return nullCheck(SDL_GetPixelFormatDetails(fmt))
    }

    internal init(from fmt: SDL_PixelFormat) {
        self.fmt = fmt
    }

    public init(from fourcc: String) throws {
        if fourcc.count != 4 {
            throw SDLError(message: "FourCC must be 4 characters long")
        }
        let chars = fourcc.map {$0.asciiValue!}
        self.fmt = SDL_PixelFormat(rawValue: 
            UInt32(chars[0]) << 0 |
            UInt32(chars[1]) << 8 |
            UInt32(chars[2]) << 16 |
            UInt32(chars[3]) << 24
        )
    }

    public init(with type: SDLIndexedPixelType, order: SDLBitmapPixelOrder, bits: Int, bytes: Int) {
        let t = ((type.rawValue) << 24)
        let o = ((order.rawValue) << 20)
        let b = UInt32((bits) << 8)
        let B = UInt32((bytes) << 0)
        self.fmt = SDL_PixelFormat(rawValue: (1 << 28) | t | o | b | B)
    }

    public init(with type: SDLPackedPixelType, order: SDLPackedPixelOrder, layout: SDLPackedPixelLayout, bits: Int, bytes: Int) {
        let t = ((type.rawValue) << 24)
        let o = ((order.rawValue) << 20)
        let l = ((layout.rawValue) << 16)
        let b = UInt32((bits) << 8)
        let B = UInt32((bytes) << 0)
        self.fmt = SDL_PixelFormat(rawValue: (1 << 28) | t | o | l | b | B)
    }

    public init(with type: SDLArrayPixelType, order: SDLArrayPixelOrder, bits: Int, bytes: Int) {
        let t = ((type.rawValue) << 24)
        let o = ((order.rawValue) << 20)
        let b = UInt32((bits) << 8)
        let B = UInt32((bytes) << 0)
        self.fmt = SDL_PixelFormat(rawValue: (1 << 28) | t | o | b | B)
    }

    public init(bitsPerPixel bpp: Int32, red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32) {
        self.fmt = SDL_GetPixelFormatForMasks(bpp, red, green, blue, alpha);
    }

    public var bitsPerPixel: UInt8 {return details!.pointee.bits_per_pixel}
    public var bytesPerPixel: UInt8  {return details!.pointee.bytes_per_pixel}
    public var Rmask: UInt32 {return details!.pointee.Rmask}
    public var Gmask: UInt32 {return details!.pointee.Gmask}
    public var Bmask: UInt32 {return details!.pointee.Bmask}
    public var Amask: UInt32 {return details!.pointee.Amask}
    public var Rbits: UInt8 {return details!.pointee.Rbits}
    public var Gbits: UInt8 {return details!.pointee.Gbits}
    public var Bbits: UInt8 {return details!.pointee.Bbits}
    public var Abits: UInt8 {return details!.pointee.Abits}
    public var Rshift: UInt8 {return details!.pointee.Rshift}
    public var Gshift: UInt8 {return details!.pointee.Gshift}
    public var Bshift: UInt8 {return details!.pointee.Bshift}
    public var Ashift: UInt8 {return details!.pointee.Ashift}

    public var name: String {
        return String(cString: SDL_GetPixelFormatName(fmt));
    }
}

public enum SDLIndexedPixelType: UInt32 {
    case i1 = 1
    case i2 = 12
    case i4 = 2
    case i8 = 3
}

public enum SDLPackedPixelType: UInt32 {
    case p8 = 4
    case p16 = 5
    case p32 = 6
}

public enum SDLArrayPixelType: UInt32 {
    case u8 = 7
    case u16 = 8
    case u32 = 9
    case f16 = 10
    case f32 = 11
}

public enum SDLBitmapPixelOrder: UInt32 {
    case none
    case o4321
    case o1234
}

public enum SDLPackedPixelOrder: UInt32 {
    case none
    case xrgb
    case rgbx
    case argb
    case rgba
    case xbgr
    case bgrx
    case abgr
    case bgra
}

public enum SDLArrayPixelOrder: UInt32 {
    case none
    case rgb
    case rgba
    case argb
    case bgr
    case bgra
    case abgr
}

public enum SDLPackedPixelLayout: UInt32 {
    case none
    case l332
    case l4444
    case l1555
    case l5551
    case l565
    case l8888
    case l2101010
    case l1010102
}

public class SDLPalette {
    internal let ptr: UnsafeMutablePointer<SDL_Palette>
    private let owned: Bool

    internal init(from ptr: UnsafeMutablePointer<SDL_Palette>) {
        self.ptr = ptr
        self.owned = false
    }

    internal init(owning ptr: UnsafeMutablePointer<SDL_Palette>) {
        self.ptr = ptr
        self.owned = true
    }

    public init(count: Int32) throws {
        if let ptr = nullCheck(SDL_CreatePalette(count)) {
            self.ptr = ptr
            owned = true
        } else {
            throw SDLError()
        }
    }

    deinit {
        if owned {
            SDL_DestroyPalette(ptr)
        }
    }

    public subscript(index: Int) -> SDLColor! {
        get {
            if index < 0 || index >= ptr.pointee.ncolors {
                return nil
            }
            return SDLColor(from: ptr.pointee.colors[index])
        } set (value) {
            ptr.pointee.colors[index] = value.sdlColor
        }
    }

    public func setColors(from array: [SDLColor], start: Int32) throws {
        let colors = UnsafeMutablePointer<SDL_Color>.allocate(capacity: array.count)
        defer {colors.deallocate()}
        for i in 0..<array.count {
            colors[i] = array[i].sdlColor
        }
        SDL_SetPaletteColors(ptr, colors, start, Int32(array.count))
    }
}

/// 
/// A structure that represents a color as RGBA components.
/// 
/// The bits of this structure can be directly reinterpreted as an
/// integer-packed color which uses the SDL_PIXELFORMAT_RGBA32 format
/// (SDL_PIXELFORMAT_ABGR8888 on little-endian systems and
/// SDL_PIXELFORMAT_RGBA8888 on big-endian systems).
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
public struct SDLColor {
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var alpha: UInt8 = 255

    internal init(from color: SDL_Color) {
        red = color.r
        green = color.g
        blue = color.b
        alpha = color.a
    }

    public init() {}

    public init(rgb: UInt32) {
        red = UInt8((rgb >> 16) & 0xFF)
        green = UInt8((rgb >> 8) & 0xFF)
        blue = UInt8(rgb & 0xFF)
        alpha = 0xFF
    }

    public init(red r: UInt8, green g: UInt8, blue b: UInt8, alpha a: UInt8 = 255) {
        red = r
        green = g
        blue = b
        alpha = a
    }

    public init(from pixel: UInt32, as format: SDLPixelFormat, with palette: SDLPalette? = nil) {
        SDL_GetRGBA(pixel, format.details!, palette?.ptr, &red, &green, &blue, &alpha)
    }

    internal var sdlColor: SDL_Color {
        return SDL_Color(r: red, g: green, b: blue, a: alpha)
    }

    public var rgba32: UInt32 {
        return (UInt32(alpha) << 0) | (UInt32(blue) << 8) | (UInt32(green) << 16) | (UInt32(red) << 24)
    }

    public var abgr32: UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(blue) << 16) | (UInt32(green) << 8) | (UInt32(red) << 0)
    }

    public var argb32: UInt32 {
        return (UInt32(alpha) << 24) | (UInt32(blue) << 0) | (UInt32(green) << 8) | (UInt32(red) << 16)
    }

    public var bgra32: UInt32 {
        return (UInt32(alpha) << 0) | (UInt32(blue) << 24) | (UInt32(green) << 16) | (UInt32(red) << 8)
    }

    public var rgb24: UInt32 {
        return (UInt32(blue) << 0) | (UInt32(green) << 8) | (UInt32(red) << 16)
    }

    public var bgr24: UInt32 {
        return (UInt32(blue) << 16) | (UInt32(green) << 8) | (UInt32(red) << 0)
    }

    public func rgb(as format: SDLPixelFormat, with palette: SDLPalette? = nil) -> UInt32 {
        SDL_MapRGB(format.details!, palette?.ptr, red, green, blue)
    }

    public func rgba(as format: SDLPixelFormat, with palette: SDLPalette? = nil) -> UInt32 {
        SDL_MapRGBA(format.details!, palette?.ptr, red, green, blue, alpha)
    }
}

/// 
/// The bits of this structure can be directly reinterpreted as a float-packed
/// color which uses the SDL_PIXELFORMAT_RGBA128_FLOAT format
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
public struct SDLFColor {
    var red: Float = 0.0
    var green: Float = 0.0
    var blue: Float = 0.0
    var alpha: Float = 1.0

    internal init(from color: SDL_FColor) {
        red = color.r
        green = color.g
        blue = color.b
        alpha = color.a
    }

    public init() {}

    public init(rgb: UInt32) {
        red = Float((rgb >> 16) & 0xFF) / 255.0
        green = Float((rgb >> 8) & 0xFF) / 255.0
        blue = Float(rgb & 0xFF) / 255.0
        alpha = 1.0
    }

    public init(red r: Float, green g: Float, blue b: Float, alpha a: Float = 1.0) {
        red = r
        green = g
        blue = b
        alpha = a
    }

    public init(from pixel: UInt32, as format: SDLPixelFormat, with palette: SDLPalette? = nil) {
        SDL_GetRGBA(pixel, format.details!, palette?.ptr, &red, &green, &blue, &alpha)
    }

    internal var sdlColor: SDL_FColor {
        return SDL_FColor(r: red, g: green, b: blue, a: alpha)
    }

    public var rgba32: UInt32 {
        return (UInt32(alpha * 255) << 0) | (UInt32(blue * 255) << 8) | (UInt32(green * 255) << 16) | (UInt32(red * 255) << 24)
    }

    public var abgr32: UInt32 {
        return (UInt32(alpha * 255) << 24) | (UInt32(blue * 255) << 16) | (UInt32(green * 255) << 8) | (UInt32(red * 255) << 0)
    }

    public var argb32: UInt32 {
        return (UInt32(alpha * 255) << 24) | (UInt32(blue * 255) << 0) | (UInt32(green * 255) << 8) | (UInt32(red * 255) << 16)
    }

    public var bgra32: UInt32 {
        return (UInt32(alpha * 255) << 0) | (UInt32(blue * 255) << 24) | (UInt32(green * 255) << 16) | (UInt32(red * 255) << 8)
    }

    public var rgb24: UInt32 {
        return (UInt32(blue * 255) << 0) | (UInt32(green * 255) << 8) | (UInt32(red * 255) << 16)
    }

    public var bgr24: UInt32 {
        return (UInt32(blue * 255) << 16) | (UInt32(green * 255) << 8) | (UInt32(red * 255) << 0)
    }

    public func rgb(as format: SDLPixelFormat, with palette: SDLPalette? = nil) -> UInt32 {
        SDL_MapRGB(format.details!, palette?.ptr, UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255))
    }

    public func rgba(as format: SDLPixelFormat, with palette: SDLPalette? = nil) -> UInt32 {
        SDL_MapRGBA(format.details!, palette?.ptr, UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255), UInt8(alpha * 255))
    }
}

/// 
/// Copy a block of pixels of one format to another format.
/// 
/// - Parameter width: the width of the block to copy, in pixels.
/// - Parameter height: the height of the block to copy, in pixels.
/// - Parameter src_format: an SDL_PixelFormat value of the `src` pixels format.
/// - Parameter src: a pointer to the source pixels.
/// - Parameter src_pitch: the pitch of the source pixels, in bytes.
/// - Parameter dst_format: an SDL_PixelFormat value of the `dst` pixels format.
/// - Parameter dst: a pointer to be filled in with new pixel data.
/// - Parameter dst_pitch: the pitch of the destination pixels, in bytes.
/// - Throws: ``SDLError`` if the function fails.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
/// - See also: SDL_ConvertPixelsAndColorspace
/// 
public func SDLConvertPixels(
    width: Int32, height: Int32,
    srcFormat: SDLPixelFormat, src: UnsafeRawPointer, srcPitch: Int32,
    dstFormat: SDLPixelFormat, dst: UnsafeMutableRawPointer, dstPitch: Int32
) throws {
    if !SDL_ConvertPixels(width, height, srcFormat.fmt, src, srcPitch, dstFormat.fmt, dst, dstPitch) {
        throw SDLError()
    }
}

// TODO: SDLConvertPixelsAndColorspace

/// 
/// Premultiply the alpha on a block of pixels.
/// 
/// This is safe to use with src == dst, but not for other overlapping areas.
/// 
/// - Parameter width: the width of the block to convert, in pixels.
/// - Parameter height: the height of the block to convert, in pixels.
/// - Parameter src_format: an SDL_PixelFormat value of the `src` pixels format.
/// - Parameter src: a pointer to the source pixels.
/// - Parameter src_pitch: the pitch of the source pixels, in bytes.
/// - Parameter dst_format: an SDL_PixelFormat value of the `dst` pixels format.
/// - Parameter dst: a pointer to be filled in with premultiplied pixel data.
/// - Parameter dst_pitch: the pitch of the destination pixels, in bytes.
/// - Parameter linear: true to convert from sRGB to linear space for the alpha
///               multiplication, false to do multiplication in sRGB space.
/// - Throws: ``SDLError`` if the function fails.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
public func SDLPremultiplyAlpha(
    width: Int32, height: Int32,
    srcFormat: SDLPixelFormat, src: UnsafeRawPointer, srcPitch: Int32,
    dstFormat: SDLPixelFormat, dst: UnsafeMutableRawPointer, dstPitch: Int32,
    linear: Bool
) throws {
    if !SDL_PremultiplyAlpha(width, height, srcFormat.fmt, src, srcPitch, dstFormat.fmt, dst, dstPitch, linear) {
        throw SDLError()
    }
}
