import SDL3_Native

public class SDLPixelFormat {
    public typealias Enum = SDL_PixelFormatEnum
    public static let unknown = SDL_PIXELFORMAT_UNKNOWN
    public static let index1LSB = SDL_PIXELFORMAT_INDEX1LSB
    public static let index1MSB = SDL_PIXELFORMAT_INDEX1MSB
    public static let index4LSB = SDL_PIXELFORMAT_INDEX4LSB
    public static let index4MSB = SDL_PIXELFORMAT_INDEX4MSB
    public static let index8 = SDL_PIXELFORMAT_INDEX8
    public static let rgb332 = SDL_PIXELFORMAT_RGB332
    public static let xrgb4444 = SDL_PIXELFORMAT_XRGB4444
    public static let rgb444 = SDL_PIXELFORMAT_RGB444
    public static let xbgr4444 = SDL_PIXELFORMAT_XBGR4444
    public static let bgr444 = SDL_PIXELFORMAT_BGR444
    public static let xrgb1555 = SDL_PIXELFORMAT_XRGB1555
    public static let rgb555 = SDL_PIXELFORMAT_RGB555
    public static let xbgr1555 = SDL_PIXELFORMAT_XBGR1555
    public static let bgr555 = SDL_PIXELFORMAT_BGR555
    public static let argb4444 = SDL_PIXELFORMAT_ARGB4444
    public static let rgba4444 = SDL_PIXELFORMAT_RGBA4444
    public static let abgr4444 = SDL_PIXELFORMAT_ABGR4444
    public static let bgra4444 = SDL_PIXELFORMAT_BGRA4444
    public static let argb1555 = SDL_PIXELFORMAT_ARGB1555
    public static let rgba5551 = SDL_PIXELFORMAT_RGBA5551
    public static let abgr1555 = SDL_PIXELFORMAT_ABGR1555
    public static let bgra5551 = SDL_PIXELFORMAT_BGRA5551
    public static let rgb565 = SDL_PIXELFORMAT_RGB565
    public static let bgr565 = SDL_PIXELFORMAT_BGR565
    public static let rgb24 = SDL_PIXELFORMAT_RGB24
    public static let bgr24 = SDL_PIXELFORMAT_BGR24
    public static let xrgb8888 = SDL_PIXELFORMAT_XRGB8888
    public static let rgbx8888 = SDL_PIXELFORMAT_RGBX8888
    public static let xbgr8888 = SDL_PIXELFORMAT_XBGR8888
    public static let bgrx8888 = SDL_PIXELFORMAT_BGRX8888
    public static let argb8888 = SDL_PIXELFORMAT_ARGB8888
    public static let rgba8888 = SDL_PIXELFORMAT_RGBA8888
    public static let abgr8888 = SDL_PIXELFORMAT_ABGR8888
    public static let bgra8888 = SDL_PIXELFORMAT_BGRA8888
    public static let argb2101010 = SDL_PIXELFORMAT_ARGB2101010
    public static let rgba32 = SDL_PIXELFORMAT_RGBA32
    public static let argb32 = SDL_PIXELFORMAT_ARGB32
    public static let bgra32 = SDL_PIXELFORMAT_BGRA32
    public static let abgr32 = SDL_PIXELFORMAT_ABGR32
    public static let rgbx32 = SDL_PIXELFORMAT_RGBX32
    public static let xrgb32 = SDL_PIXELFORMAT_XRGB32
    public static let bgrx32 = SDL_PIXELFORMAT_BGRX32
    public static let xbgr32 = SDL_PIXELFORMAT_XBGR32
    public static let yv12 = SDL_PIXELFORMAT_YV12
    public static let iyuv = SDL_PIXELFORMAT_IYUV
    public static let yuy2 = SDL_PIXELFORMAT_YUY2
    public static let uyvy = SDL_PIXELFORMAT_UYVY
    public static let yvyu = SDL_PIXELFORMAT_YVYU
    public static let nv12 = SDL_PIXELFORMAT_NV12
    public static let nv21 = SDL_PIXELFORMAT_NV21
    public static let externalOES = SDL_PIXELFORMAT_EXTERNAL_OES

    public static func name(for format: UInt32) -> String {
        return String(cString: SDL_GetPixelFormatName(format));
    }

    public static func pixelFormatEnumForMasks(bitsPerPixel bpp: Int32, red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32) -> UInt32 {
        return SDL_GetPixelFormatEnumForMasks(bpp, red, green, blue, alpha);
    }
    
    public static func masks(for format: UInt32) -> (Int32, UInt32, UInt32, UInt32, UInt32)? {
        var bpp: Int32 = 0
        var t: (UInt32, UInt32, UInt32, UInt32) = (0, 0, 0, 0)
        var ok: Bool = false
        withUnsafeMutablePointer(to: &bpp) {_bpp in
            t = fourPointers {_red, _green, _blue, _alpha in
                ok = SDL_GetMasksForPixelFormatEnum(format, _bpp, _red, _green, _blue, _alpha) == SDL_TRUE
            }
        }
        if ok {
            return (bpp, t.0, t.1, t.2, t.3)
        } else {
            return nil
        }
    }

    internal let ptr: UnsafeMutablePointer<SDL_PixelFormat>
    private let owned: Bool

    internal init(from ptr: UnsafeMutablePointer<SDL_PixelFormat>) {
        self.ptr = ptr
        self.owned = false
    }

    public init(for format: UInt32) throws {
        if let ptr = nullCheck(SDL_CreatePixelFormat(format)) {
            self.ptr = ptr
            self.owned = true
        } else {
            throw SDLError()
        }
    }

    deinit {
        if owned {
            SDL_DestroyPixelFormat(ptr)
        }
    }

    public var format: SDLPixelFormat.Enum {return SDL_PixelFormatEnum(ptr.pointee.format)}
    public var bitsPerPixel: UInt8 {return ptr.pointee.BitsPerPixel}
    public var bytesPerPixel: UInt8  {return ptr.pointee.BytesPerPixel}
    public var Rmask: UInt32 {return ptr.pointee.Rmask}
    public var Gmask: UInt32 {return ptr.pointee.Gmask}
    public var Bmask: UInt32 {return ptr.pointee.Bmask}
    public var Amask: UInt32 {return ptr.pointee.Amask}
    public var Rloss: UInt8 {return ptr.pointee.Rloss}
    public var Gloss: UInt8 {return ptr.pointee.Gloss}
    public var Bloss: UInt8 {return ptr.pointee.Bloss}
    public var Aloss: UInt8 {return ptr.pointee.Aloss}
    public var Rshift: UInt8 {return ptr.pointee.Rshift}
    public var Gshift: UInt8 {return ptr.pointee.Gshift}
    public var Bshift: UInt8 {return ptr.pointee.Bshift}
    public var Ashift: UInt8 {return ptr.pointee.Ashift}

    public var palette: SDLPalette {
        get {
            return SDLPalette(from: ptr.pointee.palette)
        } set (value) {
            SDL_SetPixelFormatPalette(ptr, value.ptr)
        }
    }
}

public class SDLPalette {
    internal let ptr: UnsafeMutablePointer<SDL_Palette>
    private let owned: Bool

    internal init(from ptr: UnsafeMutablePointer<SDL_Palette>) {
        self.ptr = ptr
        self.owned = false
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

    public init(from pixel: UInt32, as format: SDLPixelFormat) {
        let t = fourPointers {_red, _green, _blue, _alpha in
            SDL_GetRGBA(pixel, format.ptr, _red, _green, _blue, _alpha)
        }
        red = t.0
        green = t.1
        blue = t.2
        alpha = t.3
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

    public func rgb(as format: SDLPixelFormat) -> UInt32 {
        SDL_MapRGB(format.ptr, red, green, blue)
    }

    public func rgba(as format: SDLPixelFormat) -> UInt32 {
        SDL_MapRGBA(format.ptr, red, green, blue, alpha)
    }
}