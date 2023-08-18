import SDL3_Native

public enum SDLSystemTheme: UInt32 {
    case unknown = 0
    case light = 1
    case dark = 2
}

public struct SDLDisplay {
    public enum Orientation: UInt32 {
        case unknown = 0
        case landscape = 1
        case landscapeFlipped = 2
        case portrait = 3
        case portraitFlipped = 4
    }

    public class Mode {
        internal let pointer: UnsafePointer<SDL_DisplayMode>
        public var displayID: UInt32 {return pointer.pointee.displayID}
        public var format: UInt32 {return pointer.pointee.format}
        public var width: Int32 {return pointer.pointee.w}
        public var height: Int32 {return pointer.pointee.h}
        public var pixelDensity: Float {return pointer.pointee.pixel_density}
        public var refreshRate: Float {return pointer.pointee.refresh_rate}
        internal init(from ptr: UnsafePointer<SDL_DisplayMode>) {pointer = ptr}
    }

    public static var displays: [SDLDisplay]? {
        get {
            var arr: UnsafeMutablePointer<SDL_DisplayID>?
            let count = pointer {_count in
                arr = SDL_GetDisplays(_count)
            }
            if let arr = arr {
                var res = [SDLDisplay]()
                for i in 0..<Int(count) {
                    res.append(SDLDisplay(for: arr[i]))
                }
                SDL_free(arr)
                return res
            } else {
                return nil
            }
        }
    }

    public static var primary: SDLDisplay? {
        get {
            let res = SDL_GetPrimaryDisplay()
            if res == 0 {
                return nil
            }
            return SDLDisplay(for: res)
        }
    }

    public static func display(at point: SDLPoint) -> SDLDisplay? {
        let pt = point.sdlPoint
        let res = withUnsafePointer(to: pt) {_pt in
            SDL_GetDisplayForPoint(_pt)
        }
        if res != 0 {
            return SDLDisplay(for: res)
        } else {
            return nil
        }
    }

    public static func display(for rect: SDLRect) -> SDLDisplay? {
        let pt = rect.sdlRect
        let res = withUnsafePointer(to: pt) {_pt in
            SDL_GetDisplayForRect(_pt)
        }
        if res != 0 {
            return SDLDisplay(for: res)
        } else {
            return nil
        }
    }

    public let id: UInt32

    internal init(for id: UInt32) {
        self.id = id
    }

    public var name: String! {
        if let s = SDL_GetDisplayName(id) {
            return String(cString: s)
        } else {
            return nil
        }
    }

    public var bounds: SDLRect! {
        var rect = SDL_Rect()
        let ok = withUnsafeMutablePointer(to: &rect) {_rect in
            SDL_GetDisplayBounds(id, _rect) == 0
        }
        if ok {
            return SDLRect(from: rect)
        } else {
            return nil
        }
    }

    public var usableBounds: SDLRect! {
        var rect = SDL_Rect()
        let ok = withUnsafeMutablePointer(to: &rect) {_rect in
            SDL_GetDisplayUsableBounds(id, _rect) == 0
        }
        if ok {
            return SDLRect(from: rect)
        } else {
            return nil
        }
    }

    public var naturalOrientation: Orientation {
        return Orientation(rawValue: SDL_GetNaturalDisplayOrientation(id).rawValue)!
    }

    public var orientation: Orientation {
        return Orientation(rawValue: SDL_GetCurrentDisplayOrientation(id).rawValue)!
    }

    public var contentScale: Float {
        return SDL_GetDisplayContentScale(id)
    }

    public var fullscreenModes: [Mode] {
        var arr: UnsafeMutablePointer<UnsafePointer<SDL_DisplayMode>?>!
        let count = pointer {_count in
            arr = SDL_GetFullscreenDisplayModes(id, _count)
        }
        var res = [Mode]()
        for i in 0..<Int(count) {
            res.append(Mode(from: arr[i]!))
        }
        SDL_free(arr)
        return res
    }

    public var desktopMode: Mode {
        return Mode(from: SDL_GetDesktopDisplayMode(id))
    }

    public var mode: Mode {
        return Mode(from: SDL_GetCurrentDisplayMode(id))
    }

    public func closestFullscreenMode(width: Int32, height: Int32, refreshRate: Float, includeHighDensityModes: Bool) -> Mode? {
        if let mode = SDL_GetClosestFullscreenDisplayMode(id, width, height, refreshRate, includeHighDensityModes ? SDL_TRUE : SDL_FALSE) {
            return Mode(from: mode)
        } else {
            return nil
        }
    }
}

public var SDLScreenSaverEnabled: Bool {
    get {
        return SDL_ScreenSaverEnabled() == SDL_TRUE
    } set (value) {
        if value {
            SDL_EnableScreenSaver()
        } else {
            SDL_DisableScreenSaver()
        }
    }
}

public func SDLGetNumVideoDrivers() throws -> Int32 {
    let res = SDL_GetNumVideoDrivers()
    if res < 0 {
        throw SDLError()
    }
    return res
}

public func SDLGetVideoDriver(for index: Int32) -> String? {
    if let s = SDL_GetVideoDriver(index) {
        return String(cString: s)
    } else {
        return nil
    }
}

public func SDLGetCurrentVideoDriver() -> String? {
    if let s = SDL_GetCurrentVideoDriver() {
        return String(cString: s)
    } else {
        return nil
    }
}

public func SDLGetSystemTheme() -> SDLSystemTheme {
    return SDLSystemTheme(rawValue: SDL_GetSystemTheme().rawValue)!
}
