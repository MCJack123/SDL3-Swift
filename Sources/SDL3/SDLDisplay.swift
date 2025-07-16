import SDL3_Native

/// 
/// System theme.
/// 
/// - Since: This enum is available since SDL 3.2.0.
///
@EnumWrapper(SDL_SystemTheme.self)
public enum SDLSystemTheme: UInt32 {
    /// Unknown system theme
    case unknown = 0
    /// Light colored system theme
    case light = 1
    /// Dark colored system theme
    case dark = 2

    /// 
    /// Get the current system theme.
    /// 
    /// - Returns: the current system theme, light, dark, or unknown.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var current: SDLSystemTheme {
        return .sdl(SDL_GetSystemTheme())
    }
}

public struct SDLDisplay {
    /// 
    /// Display orientation values; the way a display is rotated.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_DisplayOrientation.self)
    public enum Orientation: UInt32 {
        case unknown = 0
        case landscape = 1
        case landscapeFlipped = 2
        case portrait = 3
        case portraitFlipped = 4
    }

    /// 
    /// The structure that defines a display mode.
    /// 
    /// - Since: This struct is available since SDL 3.2.0.
    /// 
    /// - See: ``SDLDisplay.fullscreenModes``
    /// - See: ``SDLDisplay.desktopMode``
    /// - See: ``SDLDisplay.mode``
    /// - See: ``SDLWindow.fullscreenMode``
    /// - See: ``SDLWindow.fullscreenMode``
    /// 
    public class Mode {
        internal let pointer: UnsafePointer<SDL_DisplayMode>
        private let owned: Bool
        /// the display this mode is associated with
        public var displayID: UInt32 {return pointer.pointee.displayID}
        /// pixel format
        public var format: SDLPixelFormat {return SDLPixelFormat(from: pointer.pointee.format)}
        /// width
        public var width: Int32 {return pointer.pointee.w}
        /// height
        public var height: Int32 {return pointer.pointee.h}
        /// scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
        public var pixelDensity: Float {return pointer.pointee.pixel_density}
        /// refresh rate (or 0.0f for unspecified)
        public var refreshRate: Float {return pointer.pointee.refresh_rate}
        /// precise refresh rate numerator (or 0 for unspecified)
        public var refreshRateNumerator: Int32 {return pointer.pointee.refresh_rate_numerator}
        /// precise refresh rate denominator
        public var refreshRateDenominator: Int32 {return pointer.pointee.refresh_rate_denominator}
        internal init(from ptr: UnsafePointer<SDL_DisplayMode>) {pointer = ptr; owned = false}
        internal init(copying mode: SDL_DisplayMode) {
            let ptr = UnsafeMutablePointer<SDL_DisplayMode>.allocate(capacity: 1)
            ptr.initialize(to: mode)
            pointer = UnsafePointer<SDL_DisplayMode>(ptr)
            owned = true
        }
        deinit {if owned {pointer.deallocate()}}
    }

    /// 
    /// Get a list of currently connected displays.
    /// 
    /// - Parameter count: a pointer filled in with the number of displays returned, may
    ///              be NULL.
    /// - Returns: a 0 terminated array of display instance IDs or NULL on failure;
    ///          call SDL_GetError() for more information. This should be freed
    ///          with SDL_free() when it is no longer needed.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var displays: [SDLDisplay] {
        get throws {
            var count: Int32 = 0
            if let arr = nullCheck(SDL_GetDisplays(&count)) {
                var res = [SDLDisplay]()
                for i in 0..<Int(count) {
                    res.append(SDLDisplay(for: arr[i]))
                }
                SDL_free(arr)
                return res
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Return the primary display.
    /// 
    /// - Returns: the instance ID of the primary display on success or 0 on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public static var primary: SDLDisplay {
        get throws {
            let res = SDL_GetPrimaryDisplay()
            if res == 0 {
                throw SDLError()
            }
            return SDLDisplay(for: res)
        }
    }

    /// 
    /// Get the display containing a point.
    /// 
    /// - Parameter point: the point to query.
    /// - Returns: the instance ID of the display containing the point or 0 on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplayBounds
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public static func display(at point: SDLPoint) throws -> SDLDisplay {
        var pt = point.sdlPoint
        let res = SDL_GetDisplayForPoint(&pt)
        if res != 0 {
            return SDLDisplay(for: res)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Get the display primarily containing a rect.
    /// 
    /// - Parameter rect: the rect to query.
    /// - Returns: the instance ID of the display entirely containing the rect or
    ///          closest to the center of the rect on success or 0 on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplayBounds
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public static func display(for rect: SDLRect) throws -> SDLDisplay {
        var pt = rect.sdlRect
        let res = SDL_GetDisplayForRect(&pt)
        if res != 0 {
            return SDLDisplay(for: res)
        } else {
            throw SDLError()
        }
    }

    /// The internal ID of the display.
    public let id: UInt32

    internal init(for id: UInt32) {
        self.id = id
    }

    // TODO: SDL_GetDisplayProperties

    /// 
    /// Get the name of a display in UTF-8 encoding.
    /// 
    /// - Returns: the name of a display
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var name: String {
        get throws {
            if let s: UnsafePointer<CChar> = nullCheck(SDL_GetDisplayName(id)) {
                return String(cString: s)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the desktop area represented by a display.
    /// 
    /// The primary display is often located at (0,0), but may be placed at a
    /// different location depending on monitor layout.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplayUsableBounds
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var bounds: SDLRect {
        get throws {
            var rect = SDL_Rect()
            if SDL_GetDisplayBounds(id, &rect) {
                return SDLRect(from: rect)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the usable desktop area represented by a display, in screen
    /// coordinates.
    /// 
    /// This is the same area as SDL_GetDisplayBounds() reports, but with portions
    /// reserved by the system removed. For example, on Apple's macOS, this
    /// subtracts the area occupied by the menu bar and dock.
    /// 
    /// Setting a window to be fullscreen generally bypasses these unusable areas,
    /// so these are good guidelines for the maximum space available to a
    /// non-fullscreen window.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplayBounds
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var usableBounds: SDLRect {
        get throws {
            var rect = SDL_Rect()
            if SDL_GetDisplayUsableBounds(id, &rect) {
                return SDLRect(from: rect)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the orientation of a display when it is unrotated.
    /// 
    /// - Returns: the SDL_DisplayOrientation enum value of the display, or
    ///          ``Orientation.unknown`` if it isn't available.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var naturalOrientation: Orientation {
        return .sdl(SDL_GetNaturalDisplayOrientation(id))
    }

    /// 
    /// Get the orientation of a display.
    /// 
    /// - Returns: the SDL_DisplayOrientation enum value of the display, or
    ///          ``Orientation.unknown`` if it isn't available.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var orientation: Orientation {
        return .sdl(SDL_GetCurrentDisplayOrientation(id))
    }

    /// 
    /// Get the content scale of a display.
    /// 
    /// The content scale is the expected scale for content based on the DPI
    /// settings of the display. For example, a 4K display might have a 2.0 (200%)
    /// display scale, which means that the user expects UI elements to be twice as
    /// big on this display, to aid in readability.
    /// 
    /// After window creation, SDL_GetWindowDisplayScale() should be used to query
    /// the content scale factor for individual windows instead of querying the
    /// display for a window and calling this function, as the per-window content
    /// scale factor may differ from the base value of the display it is on,
    /// particularly on high-DPI and/or multi-monitor desktop configurations.
    /// 
    /// - Returns: the content scale of the display, or 0.0f on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowDisplayScale
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var contentScale: Float {
        get throws {
            let res = SDL_GetDisplayContentScale(id)
            if res == 0.0 {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Get a list of fullscreen display modes available on a display.
    /// 
    /// The display modes are sorted in this priority:
    /// 
    /// - w -> largest to smallest
    /// - h -> largest to smallest
    /// - bits per pixel -> more colors to fewer colors
    /// - packed pixel layout -> largest to smallest
    /// - refresh rate -> highest to lowest
    /// - pixel density -> lowest to highest
    /// 
    /// - Returns: an array of display mode pointers
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var fullscreenModes: [Mode] {
        get throws {
            var count: Int32 = 0
            guard let arr: UnsafeMutablePointer<UnsafeMutablePointer<SDL_DisplayMode>?> = nullCheck(SDL_GetFullscreenDisplayModes(id, &count)) else {
                throw SDLError()
            }
            var res = [Mode]()
            for i in 0..<Int(count) {
                res.append(Mode(from: arr[i]!))
            }
            SDL_free(arr)
            return res
        }
    }

    /// 
    /// Get information about the desktop's display mode.
    /// 
    /// There's a difference between this function and SDL_GetCurrentDisplayMode()
    /// when SDL runs fullscreen and has changed the resolution. In that case this
    /// function will return the previous native display mode, and not the current
    /// display mode.
    /// 
    /// - Returns: the desktop display mode
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetCurrentDisplayMode
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var desktopMode: Mode {
        get throws {
            guard let res: UnsafePointer<SDL_DisplayMode> = nullCheck(SDL_GetDesktopDisplayMode(id)) else {
                throw SDLError()
            }
            return Mode(from: res)
        }
    }

    /// 
    /// Get information about the current display mode.
    /// 
    /// There's a difference between this function and SDL_GetDesktopDisplayMode()
    /// when SDL runs fullscreen and has changed the resolution. In that case this
    /// function will return the current display mode, and not the previous native
    /// display mode.
    /// 
    /// - Returns: the desktop display mode
    /// - Throws: ``SDLError`` if the function fails
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDesktopDisplayMode
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var mode: Mode {
        get throws {
            guard let res: UnsafePointer<SDL_DisplayMode> = nullCheck(SDL_GetCurrentDisplayMode(id)) else {
                throw SDLError()
            }
            return Mode(from: res)
        }
    }

    /// 
    /// Get the closest match to the requested display mode.
    /// 
    /// The available display modes are scanned and `closest` is filled in with the
    /// closest mode matching the requested mode and returned. The mode format and
    /// refresh rate default to the desktop mode if they are set to 0. The modes
    /// are scanned with size being first priority, format being second priority,
    /// and finally checking the refresh rate. If all the available modes are too
    /// small, then false is returned.
    /// 
    /// - Parameter w: the width in pixels of the desired display mode.
    /// - Parameter h: the height in pixels of the desired display mode.
    /// - Parameter refreshRate: the refresh rate of the desired display mode, or 0.0f
    ///                     for the desktop refresh rate.
    /// - Parameter includeHighDensityModes: boolean to include high density modes in
    ///                                   the search.
    /// - Returns: the closest display mode equal to or larger than the desired mode.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplays
    /// - See: SDL_GetFullscreenDisplayModes
    /// 
    @MainActor
    public func closestFullscreenMode(width: Int32, height: Int32, refreshRate: Float, includeHighDensityModes: Bool) -> Mode? {
        var mode = SDL_DisplayMode()
        if SDL_GetClosestFullscreenDisplayMode(id, width, height, refreshRate, includeHighDensityModes, &mode) {
            return Mode(copying: mode)
        } else {
            return nil
        }
    }
}

/// 
/// Check whether the screensaver is currently enabled.
/// 
/// The screensaver is disabled by default.
/// 
/// The default can also be changed using `SDL_HINT_VIDEO_ALLOW_SCREENSAVER`.
/// 
/// - Returns: true if the screensaver is enabled, false if it is disabled.
/// 
/// - Warning: This function should only be called on the main thread.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
/// - See: SDL_DisableScreenSaver
/// - See: SDL_EnableScreenSaver
/// 
@MainActor
public var SDLScreenSaverEnabled: Bool {
    get {
        return SDL_ScreenSaverEnabled()
    } set (value) {
        if value {
            _ = SDL_EnableScreenSaver()
        } else {
            _ = SDL_DisableScreenSaver()
        }
    }
}

/// 
/// Get the number of video drivers compiled into SDL.
/// 
/// - Returns: the number of built in video drivers.
/// 
/// - Warning: This function should only be called on the main thread.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
/// - See: SDL_GetVideoDriver
/// 
@MainActor
public var SDLNumVideoDrivers: Int32 {
    get throws {
        let res = SDL_GetNumVideoDrivers()
        if res < 0 {
            throw SDLError()
        }
        return res
    }
}

/// 
/// Get the name of a built in video driver.
/// 
/// The video drivers are presented in the order in which they are normally
/// checked during initialization.
/// 
/// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
/// "x11" or "windows". These never have Unicode characters, and are not meant
/// to be proper names.
/// 
/// - Parameter index: the index of a video driver.
/// - Returns: the name of the video driver with the given **index**.
/// 
/// - Warning: This function should only be called on the main thread.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
/// - See: SDL_GetNumVideoDrivers
/// 
@MainActor
public func SDLVideoDriver(for index: Int32) -> String? {
    if let s = SDL_GetVideoDriver(index) {
        return String(cString: s)
    } else {
        return nil
    }
}

/// 
/// Get the name of the currently initialized video driver.
/// 
/// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
/// "x11" or "windows". These never have Unicode characters, and are not meant
/// to be proper names.
/// 
/// - Returns: the name of the current video driver or NULL if no driver has been
///          initialized.
/// 
/// - Warning: This function should only be called on the main thread.
/// 
/// - Since: This function is available since SDL 3.2.0.
/// 
/// - See: SDL_GetNumVideoDrivers
/// - See: SDL_GetVideoDriver
/// 
@MainActor
public var SDLCurrentVideoDriver: String? {
    if let s = SDL_GetCurrentVideoDriver() {
        return String(cString: s)
    } else {
        return nil
    }
}
