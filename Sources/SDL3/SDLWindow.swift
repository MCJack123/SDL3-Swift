import SDL3_Native

public struct SDLMessageBox {
    /// 
    /// Message box flags.
    /// 
    /// If supported will display warning icon, etc.
    /// 
    /// - Since: This datatype is available since SDL 3.2.0.
    /// 
    public enum BoxType: UInt32, Sendable {
        case `default` = 0
        case error = 0x10
        case warning = 0x20
        case information = 0x40
    }

    /// 
    /// Message box button order.
    /// 
    /// If supported will set the order of buttons.
    /// 
    /// - Since: This datatype is available since SDL 3.2.0.
    /// 
    public enum ButtonOrder: UInt32, Sendable {
        case `default` = 0
        case leftToRight = 0x80
        case rightToLeft = 0x100
    }

    /// 
    /// SDL_MessageBoxButtonData flags.
    /// 
    /// - Since: This datatype is available since SDL 3.2.0.
    /// 
    public enum DefaultButton: UInt32, Sendable {
        case none = 0
        case returnKey = 1
        case escapeKey = 2
    }

    /// 
    /// Individual button data.
    /// 
    /// - Since: This struct is available since SDL 3.2.0.
    /// 
    public struct Button {
        public var defaultButton: DefaultButton
        public var buttonID: Int32
        public var text: String
    }

    /// 
    /// A set of colors to use for message box dialogs
    /// 
    /// - Since: This struct is available since SDL 3.2.0.
    /// 
    public struct ColorScheme {
        public var background: SDLColor
        public var text: SDLColor
        public var buttonBorder: SDLColor
        public var buttonBackground: SDLColor
        public var selectedButton: SDLColor
    }

    public var boxType: BoxType = .default
    public var buttonOrder: ButtonOrder = .default
    public var window: SDLWindow? = nil
    public var title: String = ""
    public var message: String = ""
    public var buttons: [Button] = [Button]()
    public var colorScheme: ColorScheme? = nil

    internal class SDLData {
        internal let pointer: UnsafeMutablePointer<SDL_MessageBoxData>
        @MainActor
        internal init(for boxData: SDLMessageBox) {
            let arr = UnsafeMutablePointer<SDL_MessageBoxButtonData>.allocate(capacity: boxData.buttons.count)
            for i in 0..<boxData.buttons.count {
                let v = boxData.buttons[i]
                let str = UnsafeMutablePointer<CChar>.allocate(capacity: v.text.count + 1)
                str.initialize(from: v.text, count: v.text.count + 1)
                arr[i] = SDL_MessageBoxButtonData(flags: v.defaultButton.rawValue, buttonID: v.buttonID, text: str)
            }
            pointer = UnsafeMutablePointer<SDL_MessageBoxData>.allocate(capacity: 1)
            let titleStr = UnsafeMutablePointer<CChar>.allocate(capacity: boxData.title.count + 1)
            titleStr.initialize(from: boxData.title, count: boxData.title.count + 1)
            let messageStr = UnsafeMutablePointer<CChar>.allocate(capacity: boxData.message.count + 1)
            messageStr.initialize(from: boxData.message, count: boxData.message.count + 1)
            pointer.pointee = SDL_MessageBoxData(flags: boxData.boxType.rawValue | boxData.buttonOrder.rawValue, window: boxData.window?.window, title: titleStr, message: messageStr, numbuttons: Int32(boxData.buttons.count), buttons: arr, colorScheme: nil)
            if let scheme = boxData.colorScheme {
                let p = UnsafeMutablePointer<SDL_MessageBoxColorScheme>.allocate(capacity: 1)
                p.pointee.colors = (
                    SDL_MessageBoxColor(r: scheme.background.red, g: scheme.background.green, b: scheme.background.blue),
                    SDL_MessageBoxColor(r: scheme.text.red, g: scheme.text.green, b: scheme.text.blue),
                    SDL_MessageBoxColor(r: scheme.buttonBorder.red, g: scheme.buttonBorder.green, b: scheme.buttonBorder.blue),
                    SDL_MessageBoxColor(r: scheme.buttonBackground.red, g: scheme.buttonBackground.green, b: scheme.buttonBackground.blue),
                    SDL_MessageBoxColor(r: scheme.selectedButton.red, g: scheme.selectedButton.green, b: scheme.selectedButton.blue)
                )
                self.pointer.pointee.colorScheme = UnsafePointer<SDL_MessageBoxColorScheme>(p)
            }
        }
        deinit {
            if let scheme = pointer.pointee.colorScheme {
                scheme.deallocate()
            }
            for i in 0..<Int(pointer.pointee.numbuttons) {
                pointer.pointee.buttons[i].text.deallocate()
            }
            pointer.pointee.title.deallocate()
            pointer.pointee.message.deallocate()
            pointer.pointee.buttons.deallocate()
            pointer.deallocate()
        }
    }

    @MainActor
    internal var sdlData: SDLData {
        return SDLData(for: self)
    }

    /// 
    /// Create a modal message box.
    /// 
    /// If your needs aren't complex, it might be easier to use
    /// SDL_ShowSimpleMessageBox.
    /// 
    /// This function should be called on the thread that created the parent
    /// window, or on the main thread if the messagebox has no parent. It will
    /// block execution of that thread until the user clicks a button or closes the
    /// messagebox.
    /// 
    /// This function may be called at any time, even before SDL_Init(). This makes
    /// it useful for reporting errors like a failure to create a renderer or
    /// OpenGL context.
    /// 
    /// On X11, SDL rolls its own dialog box with X11 primitives instead of a
    /// formal toolkit like GTK+ or Qt.
    /// 
    /// Note that if SDL_Init() would fail because there isn't any available video
    /// target, this function is likely to fail for the same reasons. If this is a
    /// concern, check the return value from this function and fall back to writing
    /// to stderr if you can.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_ShowSimpleMessageBox
    /// 
    @MainActor
    public func show() throws -> Int32 {
        let data = sdlData
        var button: Int32 = 0
        if !SDL_ShowMessageBox(data.pointer, &button) {
            throw SDLError()
        }
        return button
    }
}

/// A protocol for a delegate called for ``SDLWindow.hitTest``.
public protocol SDLWindowHitTestDelegate {
    /// 
    /// Callback used for hit-testing.
    /// 
    /// - Parameter win: the ``SDLWindow`` where hit-testing was set on.
    /// - Parameter area: an ``SDLPoint`` which should be hit-tested.
    /// - Returns: an ``SDLWindow.HitTestResult`` value.
    /// 
    /// - See: ``SDLWindow.hitTest``
    /// 
    func hitTest(in: SDLWindow, at: SDLPoint) -> SDLWindow.HitTestResult
}

fileprivate class SDLWindowHitTestDelegateBox {
    public let delegate: any SDLWindowHitTestDelegate
    public let window: SDLWindow
    init(delegate: any SDLWindowHitTestDelegate, window: SDLWindow) {
        self.delegate = delegate
        self.window = window
    }
}

/// 
/// The struct used as a handle to a window.
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
@MainActor
public final class SDLWindow: Sendable {
    /// 
    /// The flags on a window.
    /// 
    /// These cover a lot of true/false, or on/off, window state. Some of it is
    /// immutable after being set through SDL_CreateWindow(), some of it can be
    /// changed on existing windows by the app, and some of it might be altered by
    /// the user or system outside of the app's control.
    /// 
    /// - Since: This datatype is available since SDL 3.2.0.
    /// 
    /// - See: ``SDLWindow.flags``
    /// 
    public struct Flags: OptionSet, Sendable {
        public let rawValue: UInt64
        public init(rawValue v: UInt64) {rawValue = v}
        /// window is in fullscreen mode
        public static let fullScreen         = Flags(rawValue: 0x00000001)
        /// window usable with OpenGL context
        public static let openGL             = Flags(rawValue: 0x00000002)
        /// window is occluded
        public static let occluded           = Flags(rawValue: 0x00000004)
        /// window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible
        public static let hidden             = Flags(rawValue: 0x00000008)
        /// no window decoration
        public static let borderless         = Flags(rawValue: 0x00000010)
        /// window can be resized
        public static let resizable          = Flags(rawValue: 0x00000020)
        /// window is minimized
        public static let minimized          = Flags(rawValue: 0x00000040)
        /// window is maximized
        public static let maximized          = Flags(rawValue: 0x00000080)
        /// window has grabbed mouse input
        public static let mouseGrabbed       = Flags(rawValue: 0x00000100)
        /// window has input focus
        public static let inputFocus         = Flags(rawValue: 0x00000200)
        /// window has mouse focus
        public static let mouseFocus         = Flags(rawValue: 0x00000400)
        /// window not created by SDL
        public static let external           = Flags(rawValue: 0x00000800)
        /// window is modal
        public static let modal              = Flags(rawValue: 0x00001000)
        /// window uses high pixel density back buffer if possible
        public static let highPixelDensity   = Flags(rawValue: 0x00002000)
        /// window has mouse captured (unrelated to MOUSE_GRABBED)
        public static let mouseCapture       = Flags(rawValue: 0x00004000)
        /// window has relative mode enabled
        public static let mouseRelativeMode  = Flags(rawValue: 0x00008000)
        /// window should always be above others
        public static let alwaysOnTop        = Flags(rawValue: 0x00010000)
        /// window should be treated as a utility window, not showing in the task bar and window list
        public static let utility            = Flags(rawValue: 0x00020000)
        /// window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
        public static let tooltip            = Flags(rawValue: 0x00040000)
        /// window should be treated as a popup menu, requires a parent window
        public static let popupMenu          = Flags(rawValue: 0x00080000)
        /// window has grabbed keyboard input
        public static let keyboardGrabbed    = Flags(rawValue: 0x00100000)
        /// window usable for Vulkan surface
        public static let vulkan             = Flags(rawValue: 0x10000000)
        /// window usable for Metal view
        public static let metal              = Flags(rawValue: 0x20000000)
        /// window with transparent buffer
        public static let transparent        = Flags(rawValue: 0x40000000)
        /// window should not be focusable
        public static let notFocusable       = Flags(rawValue: 0x80000000)
    }

    /// 
    /// Window flash operation.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    ///
    @EnumWrapper(SDL_FlashOperation.self)
    public enum FlashOperation: UInt32 {
        case cancel = 0
        case briefly = 1
        case untilFocused = 2
    }

    /// 
    /// Possible return values from the SDL_HitTest callback.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    /// 
    /// - See: SDL_HitTest
    ///
    @EnumWrapper(SDL_HitTestResult.self)
    public enum HitTestResult: UInt32 {
        /// Region is normal. No special properties.
        case normal = 0
        /// Region can drag entire window.
        case draggable = 1
        /// Region is the resizable top-left corner border.
        case resizeTopLeft = 2
        /// Region is the resizable top border.
        case resizeTop = 3
        /// Region is the resizable top-right corner border.
        case resizeTopRight = 4
        /// Region is the resizable right border.
        case resizeRight = 5
        /// Region is the resizable bottom-right corner border.
        case resizeBottomRight = 6
        /// Region is the resizable bottom border.
        case resizeBottom = 7
        /// Region is the resizable bottom-left corner border.
        case resizeBottomLeft = 8
        /// Region is the resizable left border.
        case resizeLeft = 9
    }

    /// 
    /// Get the window that currently has an input grab enabled.
    /// 
    /// - Returns: the window if input is grabbed or nil otherwise.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowMouseGrab
    /// - See: SDL_SetWindowKeyboardGrab
    /// 
    @MainActor
    public static var grabbed: SDLWindow? {
        if let _window = nullCheck(SDL_GetGrabbedWindow()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    /// 
    /// Query the window which currently has keyboard focus.
    /// 
    /// - Returns: the window with keyboard focus.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var keyboardFocus: SDLWindow? {
        if let _window = nullCheck(SDL_GetKeyboardFocus()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    /// 
    /// Get the window which currently has mouse focus.
    /// 
    /// - Returns: the window with mouse focus.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var mouseFocus: SDLWindow? {
        if let _window = nullCheck(SDL_GetMouseFocus()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    /// 
    /// Get a list of valid windows.
    /// 
    /// - Parameter count: a pointer filled in with the number of windows returned, may
    ///              be nil.
    /// - Returns: a nil terminated array of SDL_Window pointers or nil on failure;
    ///          call SDL_GetError() for more information. This is a single
    ///          allocation that should be freed with SDL_free() when it is no
    ///          longer needed.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var windows: [SDLWindow] {
        get throws {
            var count: Int32 = 0
            let ptr = nullCheck(SDL_GetWindows(&count))
            if ptr == nil {
                throw SDLError()
            }
            var windows = [SDLWindow]()
            for i in 0..<Int(count) {
                windows.append(SDLWindow(rawValue: ptr![i]!, owned: false))
            }
            SDL_free(ptr)
            return windows
        }
    }

    /// 
    /// Get a window from a stored ID.
    /// 
    /// The numeric ID is what SDL_WindowEvent references, and is necessary to map
    /// these events to specific SDL_Window objects.
    /// 
    /// - Parameter id: the ID of the window.
    /// - Returns: the window associated with `id` or nil if it doesn't exist; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowID
    /// 
    @MainActor
    public static func from(id: UInt32) -> SDLWindow? {
        if let _window = nullCheck(SDL_GetWindowFromID(id)) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    nonisolated(unsafe) internal let window: OpaquePointer
    private let owned: Bool

    private init(rawValue: OpaquePointer, owned: Bool) {
        window = rawValue
        self.owned = owned
    }

    /// 
    /// Create a window with the specified dimensions and flags.
    /// 
    /// `flags` may be any of the following OR'd together:
    /// 
    /// - `SDL_WINDOW_FULLSCREEN`: fullscreen window at desktop resolution
    /// - `SDL_WINDOW_OPENGL`: window usable with an OpenGL context
    /// - `SDL_WINDOW_OCCLUDED`: window partially or completely obscured by another
    ///   window
    /// - `SDL_WINDOW_HIDDEN`: window is not visible
    /// - `SDL_WINDOW_BORDERLESS`: no window decoration
    /// - `SDL_WINDOW_RESIZABLE`: window can be resized
    /// - `SDL_WINDOW_MINIMIZED`: window is minimized
    /// - `SDL_WINDOW_MAXIMIZED`: window is maximized
    /// - `SDL_WINDOW_MOUSE_GRABBED`: window has grabbed mouse focus
    /// - `SDL_WINDOW_INPUT_FOCUS`: window has input focus
    /// - `SDL_WINDOW_MOUSE_FOCUS`: window has mouse focus
    /// - `SDL_WINDOW_EXTERNAL`: window not created by SDL
    /// - `SDL_WINDOW_MODAL`: window is modal
    /// - `SDL_WINDOW_HIGH_PIXEL_DENSITY`: window uses high pixel density back
    ///   buffer if possible
    /// - `SDL_WINDOW_MOUSE_CAPTURE`: window has mouse captured (unrelated to
    ///   MOUSE_GRABBED)
    /// - `SDL_WINDOW_ALWAYS_ON_TOP`: window should always be above others
    /// - `SDL_WINDOW_UTILITY`: window should be treated as a utility window, not
    ///   showing in the task bar and window list
    /// - `SDL_WINDOW_TOOLTIP`: window should be treated as a tooltip and does not
    ///   get mouse or keyboard focus, requires a parent window
    /// - `SDL_WINDOW_POPUP_MENU`: window should be treated as a popup menu,
    ///   requires a parent window
    /// - `SDL_WINDOW_KEYBOARD_GRABBED`: window has grabbed keyboard input
    /// - `SDL_WINDOW_VULKAN`: window usable with a Vulkan instance
    /// - `SDL_WINDOW_METAL`: window usable with a Metal instance
    /// - `SDL_WINDOW_TRANSPARENT`: window with transparent buffer
    /// - `SDL_WINDOW_NOT_FOCUSABLE`: window should not be focusable
    /// 
    /// The SDL_Window is implicitly shown if SDL_WINDOW_HIDDEN is not set.
    /// 
    /// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
    /// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
    /// 
    /// The window pixel size may differ from its window coordinate size if the
    /// window is on a high pixel density display. Use SDL_GetWindowSize() to query
    /// the client area's size in window coordinates, and
    /// SDL_GetWindowSizeInPixels() or SDL_GetRenderOutputSize() to query the
    /// drawable size in pixels. Note that the drawable size can vary after the
    /// window is created and should be queried again if you get an
    /// SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event.
    /// 
    /// If the window is created with any of the SDL_WINDOW_OPENGL or
    /// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
    /// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
    /// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
    /// 
    /// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
    /// SDL_CreateWindow() will fail, because SDL_Vulkan_LoadLibrary() will fail.
    /// 
    /// If SDL_WINDOW_METAL is specified on an OS that does not support Metal,
    /// SDL_CreateWindow() will fail.
    /// 
    /// If you intend to use this window with an SDL_Renderer, you should use
    /// SDL_CreateWindowAndRenderer() instead of this function, to avoid window
    /// flicker.
    /// 
    /// On non-Apple devices, SDL requires you to either not link to the Vulkan
    /// loader or link to a dynamic library version. This limitation may be removed
    /// in a future version of SDL.
    /// 
    /// - Parameter title: the title of the window, in UTF-8 encoding.
    /// - Parameter w: the width of the window.
    /// - Parameter h: the height of the window.
    /// - Parameter flags: 0, or one or more SDL_WindowFlags OR'd together.
    /// - Returns: the window that was created or nil on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateWindowAndRenderer
    /// - See: SDL_CreatePopupWindow
    /// - See: SDL_CreateWindowWithProperties
    /// - See: SDL_DestroyWindow
    /// 
    @MainActor
    public init(named title: String, width: Int32, height: Int32, flags: Flags) throws {
        if let _window = nullCheck(SDL_CreateWindow(title, width, height, flags.rawValue)) {
            window = _window
            owned = true
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Create a window and default renderer.
    /// 
    /// - Parameter title: the title of the window, in UTF-8 encoding.
    /// - Parameter width: the width of the window.
    /// - Parameter height: the height of the window.
    /// - Parameter flags: the flags used to create the window (see
    ///                     SDL_CreateWindow()).
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateRenderer
    /// - See also: SDL_CreateWindow
    /// 
    @MainActor
    public init(withRendererNamed title: String, width: Int32, height: Int32, flags: Flags) throws {
        var ren: OpaquePointer?
        var win: OpaquePointer?
        if SDL_CreateWindowAndRenderer(title, width, height, flags.rawValue, &win, &ren) {
            window = win!
            owned = true
            renderer = SDLRenderer(rawValue: ren!)
        } else {
            throw SDLError()
        }
    }

    // TODO: SDL_CreateWindowWithProperties

    deinit {
        if owned {
            SDL_DestroyWindow(window)
        }
    }

    public private(set) var renderer: SDLRenderer? = nil

    @MainActor
    public var alwaysOnTop: Bool {
        get {
            return flags.contains(.alwaysOnTop)
        }
    }

    /// 
    /// Set the window to always be above the others.
    /// 
    /// This will add or remove the window's `SDL_WINDOW_ALWAYS_ON_TOP` flag. This
    /// will bring the window to the front and keep the window above the rest.
    /// 
    /// - Parameter window: the window of which to change the always on top state.
    /// - Parameter on_top: true to set the window always on top, false to disable.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFlags
    /// 
    @MainActor
    public func set(alwaysOnTop value: Bool) throws {
        if !SDL_SetWindowAlwaysOnTop(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the size of a window's client area.
    /// 
    /// - Parameter window: the window to query the width and height from.
    /// - Parameter min_aspect: a pointer filled in with the minimum aspect ratio of the
    ///                   window, may be nil.
    /// - Parameter max_aspect: a pointer filled in with the maximum aspect ratio of the
    ///                   window, may be nil.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowAspectRatio
    /// 
    @MainActor
    public var aspectRatio: (Float, Float) {
        get throws {
            var min: Float = 0
            var max: Float = 0
            if !SDL_GetWindowAspectRatio(window, &min, &max) {
                throw SDLError()
            }
            return (min, max)
        }
    }

    /// 
    /// Request that the aspect ratio of a window's client area be set.
    /// 
    /// The aspect ratio is the ratio of width divided by height, e.g. 2560x1600
    /// would be 1.6. Larger aspect ratios are wider and smaller aspect ratios are
    /// narrower.
    /// 
    /// If, at the time of this request, the window in a fixed-size state, such as
    /// maximized or fullscreen, the request will be deferred until the window
    /// exits this state and becomes resizable again.
    /// 
    /// On some windowing systems, this request is asynchronous and the new window
    /// aspect ratio may not have have been applied immediately upon the return of
    /// this function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
    /// emitted with the new window dimensions. Note that the new dimensions may
    /// not match the exact aspect ratio requested, as some windowing systems can
    /// restrict the window size in certain scenarios (e.g. constraining the size
    /// of the content area to remain within the usable desktop bounds).
    /// Additionally, as this is just a request, it can be denied by the windowing
    /// system.
    /// 
    /// - Parameter window: the window to change.
    /// - Parameter min_aspect: the minimum aspect ratio of the window, or 0.0f for no
    ///                   limit.
    /// - Parameter max_aspect: the maximum aspect ratio of the window, or 0.0f for no
    ///                   limit.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowAspectRatio
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func set(aspectRatioMin min: Float, max: Float) throws {
        if !SDL_SetWindowAspectRatio(window, min, max) {
            throw SDLError()
        }
    }

    @MainActor
    public var bordered: Bool {
        get throws {
            return !flags.contains(.borderless)
        }
    }

    /// 
    /// Set the border state of a window.
    /// 
    /// This will add or remove the window's `SDL_WINDOW_BORDERLESS` flag and add
    /// or remove the border from the actual window. This is a no-op if the
    /// window's border already matches the requested state.
    /// 
    /// You can't change the border state of a fullscreen window.
    /// 
    /// - Parameter window: the window of which to change the border state.
    /// - Parameter bordered: false to remove border, true to add border.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFlags
    /// 
    @MainActor
    public func set(bordered value: Bool) throws {
        if !SDL_SetWindowBordered(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the display associated with a window.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the instance ID of the display containing the center of the window
    ///          on success or 0 on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetDisplayBounds
    /// - See: SDL_GetDisplays
    /// 
    @MainActor
    public var display: SDLDisplay {
        get throws {
            let id = SDL_GetDisplayForWindow(window)
            if id == 0 {
                throw SDLError()
            }
            return SDLDisplay(for: id)
        }
    }

    /// 
    /// Get the content display scale relative to a window's pixel size.
    /// 
    /// This is a combination of the window pixel density and the display content
    /// scale, and is the expected scale for displaying content in this window. For
    /// example, if a 3840x2160 window had a display scale of 2.0, the user expects
    /// the content to take twice as many pixels and be the same physical size as
    /// if it were being displayed in a 1920x1080 window with a display scale of
    /// 1.0.
    /// 
    /// Conceptually this value corresponds to the scale display setting, and is
    /// updated when that setting is changed, or the window moves to a display with
    /// a different scale setting.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the display scale, or 0.0f on failure; call SDL_GetError() for
    ///          more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var displayScale: Float {
        get throws {
            let res = SDL_GetWindowDisplayScale(window)
            if res == 0.0 {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Get the window flags.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: a mask of the SDL_WindowFlags associated with `window`.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateWindow
    /// - See: SDL_HideWindow
    /// - See: SDL_MaximizeWindow
    /// - See: SDL_MinimizeWindow
    /// - See: SDL_SetWindowFullscreen
    /// - See: SDL_SetWindowMouseGrab
    /// - See: SDL_ShowWindow
    /// 
    @MainActor
    public var flags: Flags {
        return Flags(rawValue: SDL_GetWindowFlags(window))
    }

    @MainActor
    public var focusable: Bool {
        return !flags.contains(.notFocusable)
    }

    /// 
    /// Set whether the window may have input focus.
    /// 
    /// - Parameter focusable: true to allow input focus, false to not allow input focus.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func set(focusable value: Bool) throws {
        if !SDL_SetWindowFocusable(window, value) {
            throw SDLError()
        }
    }

    @MainActor
    public var fullscreen: Bool {
        get {
            return flags.contains(.fullScreen)
        }
    }

    /// 
    /// Request that the window's fullscreen state be changed.
    /// 
    /// By default a window in fullscreen state uses borderless fullscreen desktop
    /// mode, but a specific exclusive display mode can be set using
    /// SDL_SetWindowFullscreenMode().
    /// 
    /// On some windowing systems this request is asynchronous and the new
    /// fullscreen state may not have have been applied immediately upon the return
    /// of this function. If an immediate change is required, call SDL_SyncWindow()
    /// to block until the changes have taken effect.
    /// 
    /// When the window state changes, an SDL_EVENT_WINDOW_ENTER_FULLSCREEN or
    /// SDL_EVENT_WINDOW_LEAVE_FULLSCREEN event will be emitted. Note that, as this
    /// is just a request, it can be denied by the windowing system.
    /// 
    /// - Parameter fullscreen: true for fullscreen mode, false for windowed mode.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFullscreenMode
    /// - See: SDL_SetWindowFullscreenMode
    /// - See: SDL_SyncWindow
    /// - See: SDL_WINDOW_FULLSCREEN
    /// 
    @MainActor
    public func set(fullscreen value: Bool) throws {
        if !SDL_SetWindowFullscreen(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Query the display mode to use when a window is visible at fullscreen.
    /// 
    /// - Returns: a pointer to the exclusive fullscreen mode to use or nil for
    ///          borderless fullscreen desktop mode.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowFullscreenMode
    /// - See: SDL_SetWindowFullscreen
    /// 
    @MainActor
    public var fullscreenMode: SDLDisplay.Mode? {
        get {
            if let res: UnsafePointer<SDL_DisplayMode> = nullCheck(SDL_GetWindowFullscreenMode(window)) {
                return SDLDisplay.Mode(from: res)
            } else {
                return nil
            }
        }
    }

    /// 
    /// Set the display mode to use when a window is visible and fullscreen.
    /// 
    /// This only affects the display mode used when the window is fullscreen. To
    /// change the window size when the window is not fullscreen, use
    /// SDL_SetWindowSize().
    /// 
    /// If the window is currently in the fullscreen state, this request is
    /// asynchronous on some windowing systems and the new mode dimensions may not
    /// be applied immediately upon the return of this function. If an immediate
    /// change is required, call SDL_SyncWindow() to block until the changes have
    /// taken effect.
    /// 
    /// When the new mode takes effect, an SDL_EVENT_WINDOW_RESIZED and/or an
    /// SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED event will be emitted with the new mode
    /// dimensions.
    /// 
    /// - Parameter mode: a pointer to the display mode to use, which can be nil for
    ///             borderless fullscreen desktop mode, or one of the fullscreen
    ///             modes returned by SDL_GetFullscreenDisplayModes() to set an
    ///             exclusive fullscreen mode.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFullscreenMode
    /// - See: SDL_SetWindowFullscreen
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func set(fullscreenMode value: SDLDisplay.Mode?) throws {
        if !SDL_SetWindowFullscreenMode(window, value?.pointer) {
            throw SDLError()
        }
    }

    // TODO: SDL_GetWindowICCProfile

    /// 
    /// Get a window's keyboard grab mode.
    /// 
    /// - Returns: true if keyboard is grabbed, and false otherwise.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowKeyboardGrab
    /// 
    @MainActor
    public var keyboardGrab: Bool {
        return SDL_GetWindowKeyboardGrab(window)
    }

    /// 
    /// Set a window's keyboard grab mode.
    /// 
    /// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
    /// the Meta/Super key. Note that not all system keyboard shortcuts can be
    /// captured by applications (one example is Ctrl+Alt+Del on Windows).
    /// 
    /// This is primarily intended for specialized applications such as VNC clients
    /// or VM frontends. Normal games should not use keyboard grab.
    /// 
    /// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
    /// window is full-screen to ensure the user is not trapped in your
    /// application. If you have a custom keyboard shortcut to exit fullscreen
    /// mode, you may suppress this behavior with
    /// `SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED`.
    /// 
    /// If the caller enables a grab while another window is currently grabbed, the
    /// other window loses its grab in favor of the caller's window.
    /// 
    /// - Parameter keyboardGrab: this is true to grab keyboard, and false to release.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowKeyboardGrab
    /// - See: SDL_SetWindowMouseGrab
    /// 
    @MainActor
    public func set(keyboardGrab value: Bool) throws {
        if !SDL_SetWindowKeyboardGrab(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get a window's mouse grab mode.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: true if mouse is grabbed, and false otherwise.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMouseRect
    /// - See: SDL_SetWindowMouseRect
    /// - See: SDL_SetWindowMouseGrab
    /// - See: SDL_SetWindowKeyboardGrab
    /// 
    @MainActor
    public var mouseGrab: Bool {
        return SDL_GetWindowMouseGrab(window)
    }

    /// 
    /// Set a window's mouse grab mode.
    /// 
    /// Mouse grab confines the mouse cursor to the window.
    /// 
    /// - Parameter window: the window for which the mouse grab mode should be set.
    /// - Parameter grabbed: this is true to grab mouse, and false to release.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMouseRect
    /// - See: SDL_SetWindowMouseRect
    /// - See: SDL_SetWindowMouseGrab
    /// - See: SDL_SetWindowKeyboardGrab
    /// 
    @MainActor
    public func set(mouseGrab value: Bool) throws {
        if !SDL_SetWindowMouseGrab(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Return whether the window has a surface associated with it.
    /// 
    /// - Returns: true if there is a surface associated with the window, or false
    ///          otherwise.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSurface
    /// 
    @MainActor
    public var hasSurface: Bool {
        return SDL_WindowHasSurface(window)
    }

    private var hitTestDelegate: SDLWindowHitTestDelegateBox?

    /// 
    /// Provide a callback that decides if a window region has special properties.
    /// 
    /// Normally windows are dragged and resized by decorations provided by the
    /// system window manager (a title bar, borders, etc), but for some apps, it
    /// makes sense to drag them from somewhere else inside the window itself; for
    /// example, one might have a borderless window that wants to be draggable from
    /// any part, or simulate its own title bar, etc.
    /// 
    /// This function lets the app provide a callback that designates pieces of a
    /// given window as special. This callback is run during event processing if we
    /// need to tell the OS to treat a region of the window specially; the use of
    /// this callback is known as "hit testing."
    /// 
    /// Mouse input may not be delivered to your application if it is within a
    /// special area; the OS will often apply that input to moving the window or
    /// resizing the window and not deliver it to the application.
    /// 
    /// Specifying nil for a callback disables hit-testing. Hit-testing is
    /// disabled by default.
    /// 
    /// Platforms that don't support this functionality will return false
    /// unconditionally, even if you're attempting to disable hit-testing.
    /// 
    /// Your callback may fire at any time, and its firing does not indicate any
    /// specific behavior (for example, on Windows, this certainly might fire when
    /// the OS is deciding whether to drag your window, but it fires for lots of
    /// other reasons, too, some unrelated to anything you probably care about _and
    /// when the mouse isn't actually at the location it is testing_). Since this
    /// can fire at any time, you should try to keep your callback efficient,
    /// devoid of allocations, etc.
    /// 
    /// - Parameter window: the window to set hit-testing on.
    /// - Parameter callback: the function to call when doing a hit-test.
    /// - Parameter callback_data: an app-defined void pointer passed to **callback**.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func set(hitTest value: SDLWindowHitTestDelegate?) throws {
        if !owned {
            throw SDLError(message: "This method can only be called on the owning instance.")
        }
        let ok: Bool
        if let value = value {
            let box = SDLWindowHitTestDelegateBox(delegate: value, window: self)
            ok = SDL_SetWindowHitTest(window, hitTestCallback, Unmanaged.passUnretained(box).toOpaque())
            hitTestDelegate = box
        } else {
            ok = SDL_SetWindowHitTest(window, nil, nil)
            hitTestDelegate = nil
        }
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Get the numeric ID of a window.
    /// 
    /// The numeric ID is what SDL_WindowEvent references, and is necessary to map
    /// these events to specific SDL_Window objects.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the ID of the window on success or 0 on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFromID
    /// 
    @MainActor
    public var id: UInt32 {
        get throws {
            let id = SDL_GetWindowID(window)
            if id == 0 {
                throw SDLError()
            }
            return id
        }
    }

    /// 
    /// Get the maximum size of a window's client area.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMinimumSize
    /// - See: SDL_SetWindowMaximumSize
    /// 
    @MainActor
    public var maximumSize: SDLSize {
        get throws {
            var w: Int32 = 0
            var h: Int32 = 0
            if !SDL_GetWindowMaximumSize(window, &w, &h) {
                throw SDLError()
            }
            return SDLSize(width: w, height: h)
        }
    }

    /// 
    /// Set the maximum size of a window's client area.
    /// 
    /// - Parameter maximumSize: the maximum size of the window - 0 for width or
    ///        height indicates no limit.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMaximumSize
    /// - See: SDL_SetWindowMinimumSize
    /// 
    @MainActor
    public func set(maximumSize value: SDLSize) throws {
        if !SDL_SetWindowMaximumSize(window, value.width, value.height) {
            throw SDLError()
        }
    }

    /// 
    /// Get the minimum size of a window's client area.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMaximumSize
    /// - See: SDL_SetWindowMinimumSize
    /// 
    @MainActor
    public var minimumSize: SDLSize {
        get throws {
            var w: Int32 = 0
            var h: Int32 = 0
            if !SDL_GetWindowMinimumSize(window, &w, &h) {
                throw SDLError()
            }
            return SDLSize(width: w, height: h)
        }
    }

    /// 
    /// Set the minimum size of a window's client area.
    /// 
    /// - Parameter minimumSize: the minimum size of the window - 0 for width or
    ///        height indicates no limit.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMinimumSize
    /// - See: SDL_SetWindowMaximumSize
    /// 
    @MainActor
    public func set(minimumSize value: SDLSize) throws {
        if !SDL_SetWindowMinimumSize(window, value.width, value.height) {
            throw SDLError()
        }
    }

    @MainActor
    public var modal: Bool {
        return flags.contains(.modal)
    }

    /// 
    /// Toggle the state of the window as modal.
    /// 
    /// To enable modal status on a window, the window must currently be the child
    /// window of a parent, or toggling modal status on will fail.
    /// 
    /// - Parameter modal: true to toggle modal status on, false to toggle it off.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowParent
    /// - See: SDL_WINDOW_MODAL
    /// 
    @MainActor
    public func set(modal value: Bool) throws {
        if !SDL_SetWindowModal(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the mouse confinement rectangle of a window.
    /// 
    /// - Returns: a pointer to the mouse confinement rectangle of a window, or nil
    ///          if there isn't one.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowMouseRect
    /// - See: SDL_GetWindowMouseGrab
    /// - See: SDL_SetWindowMouseGrab
    /// 
    @MainActor
    public var mouseRect: SDLRect? {
        if let rect: UnsafePointer<SDL_Rect> = nullCheck(SDL_GetWindowMouseRect(window)) {
            return SDLRect(from: rect.pointee)
        } else {
            return nil
        }
    }

    /// 
    /// Confines the cursor to the specified area of a window.
    /// 
    /// Note that this does NOT grab the cursor, it only defines the area a cursor
    /// is restricted to when the window has mouse focus.
    /// 
    /// - Parameter rect: a rectangle area in window-relative coordinates. If nil the
    ///             barrier for the specified window will be destroyed.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowMouseRect
    /// - See: SDL_GetWindowMouseGrab
    /// - See: SDL_SetWindowMouseGrab
    /// 
    @MainActor
    public func set(mouseRect value: SDLRect?) throws {
        if let value = value {
            var rect = value.sdlRect
            if !SDL_SetWindowMouseRect(window, &rect) {
                throw SDLError()
            }
        } else {
            if !SDL_SetWindowMouseRect(window, nil) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the opacity of a window.
    /// 
    /// If transparency isn't supported on this platform, opacity will be returned
    /// as 1.0f without error.
    /// 
    /// - Parameter window: the window to get the current opacity value from.
    /// - Returns: the opacity, (0.0f - transparent, 1.0f - opaque), or -1.0f on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowOpacity
    /// 
    @MainActor
    public var opacity: Float {
        get throws {
            let res = SDL_GetWindowOpacity(window)
            if res == -1.0 {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Set the opacity for a window.
    /// 
    /// The parameter `opacity` will be clamped internally between 0.0f
    /// (transparent) and 1.0f (opaque).
    /// 
    /// This function also returns false if setting the opacity isn't supported.
    /// 
    /// - Parameter opacity: the opacity value (0.0f - transparent, 1.0f - opaque).
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowOpacity
    /// 
    @MainActor
    public func set(opacity value: Float) throws {
        if !SDL_SetWindowOpacity(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get parent of a window.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the parent of the window on success or nil if the window has no
    ///          parent.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreatePopupWindow
    /// 
    @MainActor
    public var parent: SDLWindow? {
        if let parent = nullCheck(SDL_GetWindowParent(window)) {
            return SDLWindow(rawValue: parent, owned: false)
        } else {
            return nil
        }
    }

    /// 
    /// Set the window as a child of a parent window.
    /// 
    /// If the window is already the child of an existing window, it will be
    /// reparented to the new owner. Setting the parent window to nil unparents
    /// the window and removes child window status.
    /// 
    /// If a parent window is hidden or destroyed, the operation will be
    /// recursively applied to child windows. Child windows hidden with the parent
    /// that did not have their hidden status explicitly set will be restored when
    /// the parent is shown.
    /// 
    /// Attempting to set the parent of a window that is currently in the modal
    /// state will fail. Use SDL_SetWindowModal() to cancel the modal status before
    /// attempting to change the parent.
    /// 
    /// Popup windows cannot change parents and attempts to do so will fail.
    /// 
    /// Setting a parent window that is currently the sibling or descendent of the
    /// child window results in undefined behavior.
    /// 
    /// - Parameter parent: the new parent window for the child window.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowModal
    /// 
    @MainActor
    public func set(parent value: SDLWindow) throws {
        if !SDL_SetWindowParent(window, value.window) {
            throw SDLError()
        }
    }

    /// 
    /// Get the pixel density of a window.
    /// 
    /// This is a ratio of pixel size to window size. For example, if the window is
    /// 1920x1080 and it has a high density back buffer of 3840x2160 pixels, it
    /// would have a pixel density of 2.0.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the pixel density or 0.0f on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowDisplayScale
    /// 
    @MainActor
    public var pixelDensity: Float {
        get throws {
            let res = SDL_GetWindowPixelDensity(window)
            if res == 0.0 {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Get the pixel format associated with the window.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the pixel format of the window on success or
    ///          SDL_PIXELFORMAT_UNKNOWN on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var pixelFormat: SDLPixelFormat {
        get throws {
            let res = SDL_GetWindowPixelFormat(window)
            if res == SDL_PIXELFORMAT_UNKNOWN {
                throw SDLError()
            }
            return SDLPixelFormat(from: res)
        }
    }

    /// 
    /// Get the size of a window's client area, in pixels.
    /// 
    /// - Parameter window: the window from which the drawable size should be queried.
    /// - Parameter w: a pointer to variable for storing the width in pixels, may be
    ///          nil.
    /// - Parameter h: a pointer to variable for storing the height in pixels, may be
    ///          nil.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateWindow
    /// - See: SDL_GetWindowSize
    /// 
    @MainActor
    public var pixelSize: SDLSize {
        get throws {
            var w: Int32 = 0
            var h: Int32 = 0
            if !SDL_GetWindowSize(window, &w, &h) {
                throw SDLError()
            }
            return SDLSize(width: w, height: h)
        }
    }

    /// 
    /// Get the position of a window.
    /// 
    /// This is the current position of the window as last reported by the
    /// windowing system.
    /// 
    /// If you do not need the value for one of the positions a nil may be passed
    /// in the `x` or `y` parameter.
    /// 
    /// - Parameter window: the window to query.
    /// - Parameter x: a pointer filled in with the x position of the window, may be
    ///          nil.
    /// - Parameter y: a pointer filled in with the y position of the window, may be
    ///          nil.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowPosition
    /// 
    @MainActor
    public var position: SDLPoint {
        get throws {
            var x: Int32 = 0
            var y: Int32 = 0
            if !SDL_GetWindowPosition(window, &x, &y) {
                throw SDLError()
            }
            return SDLPoint(x: x, y: y)
        }
    }

    /// 
    /// Request that the window's position be set.
    /// 
    /// If the window is in an exclusive fullscreen or maximized state, this
    /// request has no effect.
    /// 
    /// This can be used to reposition fullscreen-desktop windows onto a different
    /// display, however, as exclusive fullscreen windows are locked to a specific
    /// display, they can only be repositioned programmatically via
    /// SDL_SetWindowFullscreenMode().
    /// 
    /// On some windowing systems this request is asynchronous and the new
    /// coordinates may not have have been applied immediately upon the return of
    /// this function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window position changes, an SDL_EVENT_WINDOW_MOVED event will be
    /// emitted with the window's new coordinates. Note that the new coordinates
    /// may not match the exact coordinates requested, as some windowing systems
    /// can restrict the position of the window in certain scenarios (e.g.
    /// constraining the position so the window is always within desktop bounds).
    /// Additionally, as this is just a request, it can be denied by the windowing
    /// system.
    /// 
    /// - Parameter window: the window to reposition.
    /// - Parameter x: the x coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
    ///          `SDL_WINDOWPOS_UNDEFINED`.
    /// - Parameter y: the y coordinate of the window, or `SDL_WINDOWPOS_CENTERED` or
    ///          `SDL_WINDOWPOS_UNDEFINED`.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowPosition
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func set(position value: SDLPoint) throws {
        if !SDL_SetWindowPosition(window, value.x, value.y) {
            throw SDLError()
        }
    }

    // TODO: SDL_GetWindowProperties

    /// 
    /// Query whether relative mouse mode is enabled for a window.
    /// 
    /// - Returns: true if relative mode is enabled for a window or false otherwise.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowRelativeMouseMode
    /// 
    @MainActor
    public var relativeMouseMode: Bool {
        return SDL_GetWindowRelativeMouseMode(window)
    }

    /// 
    /// Set relative mouse mode for a window.
    /// 
    /// While the window has focus and relative mouse mode is enabled, the cursor
    /// is hidden, the mouse position is constrained to the window, and SDL will
    /// report continuous relative mouse motion even if the mouse is at the edge of
    /// the window.
    /// 
    /// If you'd like to keep the mouse position fixed while in relative mode you
    /// can use SDL_SetWindowMouseRect(). If you'd like the cursor to be at a
    /// specific location when relative mode ends, you should use
    /// SDL_WarpMouseInWindow() before disabling relative mode.
    /// 
    /// This function will flush any pending mouse motion for this window.
    /// 
    /// - Parameter relativeMouseMode: true to enable relative mode, false to disable.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowRelativeMouseMode
    /// 
    @MainActor
    public func set(relativeMouseMode value: Bool) throws {
        if !SDL_SetWindowRelativeMouseMode(window, value) {
            throw SDLError()
        }
    }

    @MainActor
    public var resizable: Bool {
        get {
            return flags.contains(.resizable)
        }
    }

    /// 
    /// Set the user-resizable state of a window.
    /// 
    /// This will add or remove the window's `SDL_WINDOW_RESIZABLE` flag and
    /// allow/disallow user resizing of the window. This is a no-op if the window's
    /// resizable state already matches the requested state.
    /// 
    /// You can't change the resizable state of a fullscreen window.
    /// 
    /// - Parameter window: the window of which to change the resizable state.
    /// - Parameter resizable: true to allow resizing, false to disallow.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowFlags
    /// 
    @MainActor
    public func set(resizable value: Bool) throws {
        if !SDL_SetWindowResizable(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Get the safe area for this window.
    /// 
    /// Some devices have portions of the screen which are partially obscured or
    /// not interactive, possibly due to on-screen controls, curved edges, camera
    /// notches, TV overscan, etc. This function provides the area of the window
    /// which is safe to have interactable content. You should continue rendering
    /// into the rest of the window, but it should not contain visually important
    /// or interactible content.
    /// 
    /// - Parameter window: the window to query.
    /// - Parameter rect: a pointer filled in with the client area that is safe for
    ///             interactive content.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var safeArea: SDLRect {
        get throws {
            var res = SDL_Rect()
            let ok = SDL_GetWindowSafeArea(window, &res)
            if !ok {
                throw SDLError()
            }
            return SDLRect(from: res)
        }
    }

    /// 
    /// Check whether the screen keyboard is shown for given window.
    /// 
    /// - Returns: true if screen keyboard is shown or false if not.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_HasScreenKeyboardSupport
    /// 
    @MainActor
    public var screenKeyboardShown: Bool {
        return SDL_ScreenKeyboardShown(window)
    }

    /// 
    /// Set the shape of a transparent window.
    /// 
    /// This sets the alpha channel of a transparent window and any fully
    /// transparent areas are also transparent to mouse clicks. If you are using
    /// something besides the SDL render API, then you are responsible for drawing
    /// the alpha channel of the window to match the shape alpha channel to get
    /// consistent cross-platform results.
    /// 
    /// The shape is copied inside this function, so you can free it afterwards. If
    /// your shape surface changes, you should call SDL_SetWindowShape() again to
    /// update the window. This is an expensive operation, so should be done
    /// sparingly.
    /// 
    /// The window must have been created with the SDL_WINDOW_TRANSPARENT flag.
    /// 
    /// - Parameter shape: the surface representing the shape of the window, or nil to
    ///              remove any current shape.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func set(shape value: SDLSurface) throws {
        if !SDL_SetWindowShape(window, value.surf.pointer) {
            throw SDLError()
        }
    }

    /// 
    /// Get the size of a window's client area.
    /// 
    /// The window pixel size may differ from its window coordinate size if the
    /// window is on a high pixel density display. Use SDL_GetWindowSizeInPixels()
    /// or SDL_GetRenderOutputSize() to get the real client area size in pixels.
    /// 
    /// - Parameter window: the window to query the width and height from.
    /// - Parameter w: a pointer filled in with the width of the window, may be nil.
    /// - Parameter h: a pointer filled in with the height of the window, may be nil.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetRenderOutputSize
    /// - See: SDL_GetWindowSizeInPixels
    /// - See: SDL_SetWindowSize
    /// 
    @MainActor
    public var size: SDLSize {
        get throws {
            var x: Int32 = 0
            var y: Int32 = 0
            let ok = SDL_GetWindowPosition(window, &x, &y)
            if !ok {
                throw SDLError()
            }
            return SDLSize(width: x, height: y)
        }
    }

    /// 
    /// Request that the size of a window's client area be set.
    /// 
    /// If the window is in a fullscreen or maximized state, this request has no
    /// effect.
    /// 
    /// To change the exclusive fullscreen mode of a window, use
    /// SDL_SetWindowFullscreenMode().
    /// 
    /// On some windowing systems, this request is asynchronous and the new window
    /// size may not have have been applied immediately upon the return of this
    /// function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window size changes, an SDL_EVENT_WINDOW_RESIZED event will be
    /// emitted with the new window dimensions. Note that the new dimensions may
    /// not match the exact size requested, as some windowing systems can restrict
    /// the window size in certain scenarios (e.g. constraining the size of the
    /// content area to remain within the usable desktop bounds). Additionally, as
    /// this is just a request, it can be denied by the windowing system.
    /// 
    /// - Parameter window: the window to change.
    /// - Parameter w: the width of the window, must be > 0.
    /// - Parameter h: the height of the window, must be > 0.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSize
    /// - See: SDL_SetWindowFullscreenMode
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func set(size value: SDLSize) throws {
        if !SDL_SetWindowPosition(window, value.width, value.height) {
            throw SDLError()
        }
    }

    /// 
    /// Get the title of a window.
    /// 
    /// - Returns: the title of the window in UTF-8 format or "" if there is no
    ///          title.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public var title: String {
        return String(cString: SDL_GetWindowTitle(window))
    }

    /// 
    /// Set the title of a window.
    /// 
    /// This string is expected to be in UTF-8 encoding.
    /// 
    /// - Parameter window: the window to change.
    /// - Parameter title: the desired window title in UTF-8 format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowTitle
    /// 
    @MainActor
    public func set(title value: String) throws {
        if !SDL_SetWindowTitle(window, value) {
            throw SDLError()
        }
    }

    /// 
    /// Request a window to demand attention from the user.
    /// 
    /// - Parameter operation: the operation to perform.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func flash(operation: FlashOperation) throws {
        if !SDL_FlashWindow(window, operation.sdlValue) {
            throw SDLError()
        }
    }

    /// 
    /// Get the size of a window's borders (decorations) around the client area.
    /// 
    /// Note: If this function fails (returns false), the size values will be
    /// initialized to 0, 0, 0, 0 (if a non-nil pointer is provided), as if the
    /// window in question was borderless.
    /// 
    /// Note: This function may fail on systems where the window has not yet been
    /// decorated by the display server (for example, immediately after calling
    /// SDL_CreateWindow). It is recommended that you wait at least until the
    /// window has been presented and composited, so that the window system has a
    /// chance to decorate the window and provide the border dimensions to SDL.
    /// 
    /// This function also returns false if getting the information is not
    /// supported.
    /// 
    /// - Parameter window: the window to query the size values of the border
    ///               (decorations) from.
    /// - Parameter top: pointer to variable for storing the size of the top border; nil
    ///            is permitted.
    /// - Parameter left: pointer to variable for storing the size of the left border;
    ///             nil is permitted.
    /// - Parameter bottom: pointer to variable for storing the size of the bottom
    ///               border; nil is permitted.
    /// - Parameter right: pointer to variable for storing the size of the right border;
    ///              nil is permitted.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSize
    /// 
    @MainActor
    public var bordersSize: (Int32, Int32, Int32, Int32) {
        get throws {
            var top: Int32 = 0
            var bottom: Int32 = 0
            var left: Int32 = 0
            var right: Int32 = 0
            if SDL_GetWindowBordersSize(window, &top, &bottom, &left, &right) {
                return (top, bottom, left, right)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the SDL surface associated with the window.
    /// 
    /// A new surface will be created with the optimal format for the window, if
    /// necessary. This surface will be freed when the window is destroyed. Do not
    /// free this surface.
    /// 
    /// This surface will be invalidated if the window is resized. After resizing a
    /// window this function must be called again to return a valid surface.
    /// 
    /// You may not combine this with 3D or the rendering API on this window.
    /// 
    /// This function is affected by `SDL_HINT_FRAMEBUFFER_ACCELERATION`.
    /// 
    /// - Parameter window: the window to query.
    /// - Returns: the surface associated with the window, or nil on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_DestroyWindowSurface
    /// - See: SDL_WindowHasSurface
    /// - See: SDL_UpdateWindowSurface
    /// - See: SDL_UpdateWindowSurfaceRects
    /// 
    @MainActor
    public var surface: SDLSurface {
        get throws {
            if let surface = nullCheck(SDL_GetWindowSurface(window)) {
                return SDLSurface(from: surface.sendable, owned: false)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get VSync for the window surface.
    /// 
    /// - Parameter vsync: an int filled with the current vertical refresh sync interval.
    ///              See SDL_SetWindowSurfaceVSync() for the meaning of the value.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowSurfaceVSync
    /// 
    @MainActor
    public var vsync: Int32 {
        get throws {
            var res: Int32 = 0
            if !SDL_GetWindowSurfaceVSync(window, &res) {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Toggle VSync for the window surface.
    /// 
    /// When a window surface is created, vsync defaults to
    /// SDL_WINDOW_SURFACE_VSYNC_DISABLED.
    /// 
    /// The `vsync` parameter can be 1 to synchronize present with every vertical
    /// refresh, 2 to synchronize present with every second vertical refresh, etc.,
    /// SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync),
    /// or SDL_WINDOW_SURFACE_VSYNC_DISABLED to disable. Not every value is
    /// supported by every driver, so you should check the return value to see
    /// whether the requested setting is supported.
    /// 
    /// - Parameter vsync: the vertical refresh sync interval.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSurfaceVSync
    /// 
    @MainActor
    public func set(vsync value: Int32) throws {
        if !SDL_SetWindowSurfaceVSync(window, value) {
            throw SDLError()
        }
    }

    /// Constant for SDLWindow.vsync to disable Vsync
    public static let vsyncDisabled: Int32 = 0
    /// Constant for SDLWindow.vsync to enable adaptive Vsync
    public static let vsyncAdaptive: Int32 = -1

    /// 
    /// Destroy the surface associated with the window.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSurface
    /// - See: SDL_WindowHasSurface
    /// 
    @MainActor
    public func destroySurface() throws {
        if !SDL_DestroyWindowSurface(window) {
            throw SDLError()
        }
    }

    /// 
    /// Display a simple modal message box.
    /// 
    /// If your needs aren't complex, this function is preferred over
    /// ``SDLMessageBox``.
    /// 
    /// `flags` may be any of the following:
    /// 
    /// - `SDL_MESSAGEBOX_ERROR`: error dialog
    /// - `SDL_MESSAGEBOX_WARNING`: warning dialog
    /// - `SDL_MESSAGEBOX_INFORMATION`: informational dialog
    /// 
    /// This function should be called on the thread that created the parent
    /// window, or on the main thread if the messagebox has no parent. It will
    /// block execution of that thread until the user clicks a button or closes the
    /// messagebox.
    /// 
    /// This function may be called at any time, even before SDL_Init(). This makes
    /// it useful for reporting errors like a failure to create a renderer or
    /// OpenGL context.
    /// 
    /// On X11, SDL rolls its own dialog box with X11 primitives instead of a
    /// formal toolkit like GTK+ or Qt.
    /// 
    /// Note that if SDL_Init() would fail because there isn't any available video
    /// target, this function is likely to fail for the same reasons. If this is a
    /// concern, check the return value from this function and fall back to writing
    /// to stderr if you can.
    /// 
    /// - Parameter flags: an SDLMessageBox.BoxType value.
    /// - Parameter title: UTF-8 title text.
    /// - Parameter message: UTF-8 message text.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: ``SDLMessageBox``
    /// 
    @MainActor
    public func showSimpleMessageBox(with type: SDLMessageBox.BoxType, title: String, message: String) throws {
        if !SDL_ShowSimpleMessageBox(type.rawValue, title, message, window) {
            throw SDLError()
        }
    }

    /// 
    /// Display a simple modal message box.
    /// 
    /// If your needs aren't complex, this function is preferred over
    /// ``SDLMessageBox``.
    /// 
    /// `flags` may be any of the following:
    /// 
    /// - `SDL_MESSAGEBOX_ERROR`: error dialog
    /// - `SDL_MESSAGEBOX_WARNING`: warning dialog
    /// - `SDL_MESSAGEBOX_INFORMATION`: informational dialog
    /// 
    /// This function should be called on the thread that created the parent
    /// window, or on the main thread if the messagebox has no parent. It will
    /// block execution of that thread until the user clicks a button or closes the
    /// messagebox.
    /// 
    /// This function may be called at any time, even before SDL_Init(). This makes
    /// it useful for reporting errors like a failure to create a renderer or
    /// OpenGL context.
    /// 
    /// On X11, SDL rolls its own dialog box with X11 primitives instead of a
    /// formal toolkit like GTK+ or Qt.
    /// 
    /// Note that if SDL_Init() would fail because there isn't any available video
    /// target, this function is likely to fail for the same reasons. If this is a
    /// concern, check the return value from this function and fall back to writing
    /// to stderr if you can.
    /// 
    /// - Parameter flags: an SDLMessageBox.BoxType value.
    /// - Parameter title: UTF-8 title text.
    /// - Parameter message: UTF-8 message text.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: ``SDLMessageBox``
    /// 
    @MainActor
    public static func showSimpleMessageBox(with type: SDLMessageBox.BoxType, title: String, message: String) throws {
        if !SDL_ShowSimpleMessageBox(type.rawValue, title, message, nil) {
            throw SDLError()
        }
    }

    /// 
    /// Hide a window.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_ShowWindow
    /// - See: SDL_WINDOW_HIDDEN
    /// 
    @MainActor
    public func hide() throws {
        if !SDL_HideWindow(window) {
            throw SDLError()
        }
    }

    /// 
    /// Request that the window be made as large as possible.
    /// 
    /// Non-resizable windows can't be maximized. The window must have the
    /// SDL_WINDOW_RESIZABLE flag set, or this will have no effect.
    /// 
    /// On some windowing systems this request is asynchronous and the new window
    /// state may not have have been applied immediately upon the return of this
    /// function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window state changes, an SDL_EVENT_WINDOW_MAXIMIZED event will be
    /// emitted. Note that, as this is just a request, the windowing system can
    /// deny the state change.
    /// 
    /// When maximizing a window, whether the constraints set via
    /// SDL_SetWindowMaximumSize() are honored depends on the policy of the window
    /// manager. Win32 and macOS enforce the constraints when maximizing, while X11
    /// and Wayland window managers may vary.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MinimizeWindow
    /// - See: SDL_RestoreWindow
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func maximize() throws {
        if !SDL_MaximizeWindow(window) {
            throw SDLError()
        }
    }
    
    /// 
    /// Request that the window be minimized to an iconic representation.
    /// 
    /// If the window is in a fullscreen state, this request has no direct effect.
    /// It may alter the state the window is returned to when leaving fullscreen.
    /// 
    /// On some windowing systems this request is asynchronous and the new window
    /// state may not have been applied immediately upon the return of this
    /// function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window state changes, an SDL_EVENT_WINDOW_MINIMIZED event will be
    /// emitted. Note that, as this is just a request, the windowing system can
    /// deny the state change.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MaximizeWindow
    /// - See: SDL_RestoreWindow
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func minimize() throws {
        if !SDL_MinimizeWindow(window) {
            throw SDLError()
        }
    }

    /// 
    /// Request that a window be raised above other windows and gain the input
    /// focus.
    /// 
    /// The result of this request is subject to desktop window manager policy,
    /// particularly if raising the requested window would result in stealing focus
    /// from another application. If the window is successfully raised and gains
    /// input focus, an SDL_EVENT_WINDOW_FOCUS_GAINED event will be emitted, and
    /// the window will have the SDL_WINDOW_INPUT_FOCUS flag set.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func raise() throws {
        if !SDL_RaiseWindow(window) {
            throw SDLError()
        }
    }

    /// 
    /// Request that the size and position of a minimized or maximized window be
    /// restored.
    /// 
    /// If the window is in a fullscreen state, this request has no direct effect.
    /// It may alter the state the window is returned to when leaving fullscreen.
    /// 
    /// On some windowing systems this request is asynchronous and the new window
    /// state may not have have been applied immediately upon the return of this
    /// function. If an immediate change is required, call SDL_SyncWindow() to
    /// block until the changes have taken effect.
    /// 
    /// When the window state changes, an SDL_EVENT_WINDOW_RESTORED event will be
    /// emitted. Note that, as this is just a request, the windowing system can
    /// deny the state change.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_MaximizeWindow
    /// - See: SDL_MinimizeWindow
    /// - See: SDL_SyncWindow
    /// 
    @MainActor
    public func restore() throws {
        if !SDL_RestoreWindow(window) {
            throw SDLError()
        }
    }

    /// 
    /// Set the icon for a window.
    /// 
    /// If this function is passed a surface with alternate representations, the
    /// surface will be interpreted as the content to be used for 100% display
    /// scale, and the alternate representations will be used for high DPI
    /// situations. For example, if the original surface is 32x32, then on a 2x
    /// macOS display or 200% display scale on Windows, a 64x64 version of the
    /// image will be used, if available. If a matching version of the image isn't
    /// available, the closest larger size image will be downscaled to the
    /// appropriate size and be used instead, if available. Otherwise, the closest
    /// smaller image will be upscaled and be used instead.
    /// 
    /// - Parameter window: the window to change.
    /// - Parameter icon: an SDL_Surface structure containing the icon for the window.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func set(icon: SDLSurface) throws {
        if !SDL_SetWindowIcon(window, icon.surf.pointer) {
            throw SDLError()
        }
    }

    /// 
    /// Show a window.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_HideWindow
    /// - See: SDL_RaiseWindow
    /// 
    @MainActor
    public func show() throws {
        if !SDL_ShowWindow(window) {
            throw SDLError()
        }
    }

    /// 
    /// Block until any pending window state is finalized.
    /// 
    /// On asynchronous windowing systems, this acts as a synchronization barrier
    /// for pending window state. It will attempt to wait until any pending window
    /// state has been applied and is guaranteed to return within finite time. Note
    /// that for how long it can potentially block depends on the underlying window
    /// system, as window state changes may involve somewhat lengthy animations
    /// that must complete before the window is in its final requested state.
    /// 
    /// On windowing systems where changes are immediate, this does nothing.
    /// 
    /// - Returns: true on success or false if the operation timed out before the
    ///          window was in the requested state.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowSize
    /// - See: SDL_SetWindowPosition
    /// - See: SDL_SetWindowFullscreen
    /// - See: SDL_MinimizeWindow
    /// - See: SDL_MaximizeWindow
    /// - See: SDL_RestoreWindow
    /// - See: SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS
    /// 
    @MainActor
    public func sync() async -> Bool {
        return await withCheckedContinuation { continuation in
            continuation.resume(returning: SDL_SyncWindow(window))
        }
    }

    /// 
    /// Block until any pending window state is finalized.
    /// 
    /// On asynchronous windowing systems, this acts as a synchronization barrier
    /// for pending window state. It will attempt to wait until any pending window
    /// state has been applied and is guaranteed to return within finite time. Note
    /// that for how long it can potentially block depends on the underlying window
    /// system, as window state changes may involve somewhat lengthy animations
    /// that must complete before the window is in its final requested state.
    /// 
    /// On windowing systems where changes are immediate, this does nothing.
    /// 
    /// - Returns: true on success or false if the operation timed out before the
    ///          window was in the requested state.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SetWindowSize
    /// - See: SDL_SetWindowPosition
    /// - See: SDL_SetWindowFullscreen
    /// - See: SDL_MinimizeWindow
    /// - See: SDL_MaximizeWindow
    /// - See: SDL_RestoreWindow
    /// - See: SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS
    /// 
    @MainActor
    public func syncBlocking() -> Bool {
        return SDL_SyncWindow(window)
    }

    /// 
    /// Copy the window surface to the screen.
    /// 
    /// This is the function you use to reflect any changes to the surface on the
    /// screen.
    /// 
    /// This function is equivalent to the SDL 1.2 API SDL_Flip().
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSurface
    /// - See: SDL_UpdateWindowSurfaceRects
    /// 
    @MainActor
    public func updateSurface() throws {
        if !SDL_UpdateWindowSurface(window) {
            throw SDLError()
        }
    }

    /// 
    /// Copy areas of the window surface to the screen.
    /// 
    /// This is the function you use to reflect changes to portions of the surface
    /// on the screen.
    /// 
    /// This function is equivalent to the SDL 1.2 API SDL_UpdateRects().
    /// 
    /// Note that this function will update _at least_ the rectangles specified,
    /// but this is only intended as an optimization; in practice, this might
    /// update more of the screen (or all of the screen!), depending on what method
    /// SDL uses to send pixels to the system.
    /// 
    /// - Parameter rects: an array of SDLRect structures representing areas of the
    ///              surface to copy, in pixels.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_GetWindowSurface
    /// - See: SDL_UpdateWindowSurface
    /// 
    @MainActor
    public func updateSurface(in rects: [SDLRect]) throws {
        let arr = UnsafeMutablePointer<SDL_Rect>.allocate(capacity: rects.count)
        defer {arr.deallocate()}
        for i in 0..<rects.count {
            arr[i] = rects[i].sdlRect
        }
        if !SDL_UpdateWindowSurfaceRects(window, arr, Int32(rects.count)) {
            throw SDLError()
        }
    }

    /// 
    /// Create a child popup window of the specified parent window.
    /// 
    /// The flags parameter **must** contain at least one of the following:
    /// 
    /// - `SDL_WINDOW_TOOLTIP`: The popup window is a tooltip and will not pass any
    ///   input events.
    /// - `SDL_WINDOW_POPUP_MENU`: The popup window is a popup menu. The topmost
    ///   popup menu will implicitly gain the keyboard focus.
    /// 
    /// The following flags are not relevant to popup window creation and will be
    /// ignored:
    /// 
    /// - `SDL_WINDOW_MINIMIZED`
    /// - `SDL_WINDOW_MAXIMIZED`
    /// - `SDL_WINDOW_FULLSCREEN`
    /// - `SDL_WINDOW_BORDERLESS`
    /// 
    /// The following flags are incompatible with popup window creation and will
    /// cause it to fail:
    /// 
    /// - `SDL_WINDOW_UTILITY`
    /// - `SDL_WINDOW_MODAL`
    /// 
    /// The parent parameter **must** be non-null and a valid window. The parent of
    /// a popup window can be either a regular, toplevel window, or another popup
    /// window.
    /// 
    /// Popup windows cannot be minimized, maximized, made fullscreen, raised,
    /// flash, be made a modal window, be the parent of a toplevel window, or grab
    /// the mouse and/or keyboard. Attempts to do so will fail.
    /// 
    /// Popup windows implicitly do not have a border/decorations and do not appear
    /// on the taskbar/dock or in lists of windows such as alt-tab menus.
    /// 
    /// If a parent window is hidden or destroyed, any child popup windows will be
    /// recursively hidden or destroyed as well. Child popup windows not explicitly
    /// hidden will be restored when the parent is shown.
    /// 
    /// - Parameter offsetX: the x position of the popup window relative to the origin
    ///                 of the parent.
    /// - Parameter offsetY: the y position of the popup window relative to the origin
    ///                 of the parent window.
    /// - Parameter w: the width of the window.
    /// - Parameter h: the height of the window.
    /// - Parameter flags: SDL_WINDOW_TOOLTIP or SDL_WINDOW_POPUP_MENU, and zero or more
    ///              additional SDL_WindowFlags OR'd together.
    /// - Returns: the window that was created or nil on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CreateWindow
    /// - See: SDL_CreateWindowWithProperties
    /// - See: SDL_DestroyWindow
    /// - See: SDL_GetWindowParent
    /// 
    @MainActor
    public func popup(offsetX: Int32, offsetY: Int32, width: Int32, height: Int32, flags: Flags) throws -> SDLWindow {
        if let _window = nullCheck(SDL_CreatePopupWindow(window, offsetX, offsetY, width, height, flags.rawValue)) {
            return SDLWindow(rawValue: _window, owned: true)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Display the system-level window menu.
    /// 
    /// This default window menu is provided by the system and on some platforms
    /// provides functionality for setting or changing privileged state on the
    /// window, such as moving it between workspaces or displays, or toggling the
    /// always-on-top property.
    /// 
    /// On platforms or desktops where this is unsupported, this function does
    /// nothing.
    /// 
    /// - Parameter x: the x coordinate of the menu, relative to the origin (top-left) of
    ///          the client area.
    /// - Parameter y: the y coordinate of the menu, relative to the origin (top-left) of
    ///          the client area.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning:  This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public func showSystemMenu(x: Int32, y: Int32) throws {
        if !SDL_ShowWindowSystemMenu(window, x, y) {
            throw SDLError()
        }
    }

    /// 
    /// Create a 2D rendering context for a window.
    /// 
    /// If you want a specific renderer, you can specify its name here. A list of
    /// available renderers can be obtained by calling SDL_GetRenderDriver()
    /// multiple times, with indices from 0 to SDL_GetNumRenderDrivers()-1. If you
    /// don't need a specific renderer, specify NULL and SDL will attempt to choose
    /// the best option for you, based on what is available on the user's system.
    /// 
    /// If `name` is a comma-separated list, SDL will try each name, in the order
    /// listed, until one succeeds or all of them fail.
    /// 
    /// By default the rendering size matches the window size in pixels, but you
    /// can call SDL_SetRenderLogicalPresentation() to change the content size and
    /// scaling options.
    /// 
    /// - Parameter with: the name of the rendering driver to initialize, or NULL to let
    ///             SDL choose one.
    /// - Returns: a valid rendering context or NULL if there was an error; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_CreateRendererWithProperties
    /// - See also: SDL_CreateSoftwareRenderer
    /// - See also: SDL_DestroyRenderer
    /// - See also: SDL_GetNumRenderDrivers
    /// - See also: SDL_GetRenderDriver
    /// - See also: SDL_GetRendererName
    /// 
    @MainActor
    public func createRenderer(with driver: String) throws -> SDLRenderer {
        if let r = renderer {
            return r // TODO: should we error?
        }
        if let ren = SDL_CreateRenderer(window, driver) {
            renderer = SDLRenderer(rawValue: ren)
            renderer!.window = self
            return renderer!
        } else {
            throw SDLError()
        }
    }

    // TODO: SDL_CreateRendererWithProperties

    /// 
    /// Start accepting Unicode text input events in a window.
    /// 
    /// This function will enable text input (SDL_EVENT_TEXT_INPUT and
    /// SDL_EVENT_TEXT_EDITING events) in the specified window. Please use this
    /// function paired with SDL_StopTextInput().
    /// 
    /// Text input events are not received by default.
    /// 
    /// On some platforms using this function shows the screen keyboard and/or
    /// activates an IME, which can prevent some key press events from being passed
    /// through.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetTextInputArea
    /// - See also: SDL_StartTextInputWithProperties
    /// - See also: SDL_StopTextInput
    /// - See also: SDL_TextInputActive
    /// 
    @MainActor
    public func startTextInput() throws {
        if !SDL_StartTextInput(window) {
            throw SDLError()
        }
    }

    // TODO: SDL_StartTextInputWithProperties

    /// 
    /// Check whether or not Unicode text input events are enabled for a window.
    /// 
    /// - Returns: true if text input events are enabled else false.
    ///
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_StartTextInput
    /// 
    @MainActor
    public var textInputActive: Bool {
        return SDL_TextInputActive(window)
    }

    /// 
    /// Stop receiving any text input events in a window.
    /// 
    /// If SDL_StartTextInput() showed the screen keyboard, this function will hide
    /// it.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_StartTextInput
    /// 
    @MainActor
    public func stopTextInput() throws {
        if !SDL_StopTextInput(window) {
            throw SDLError()
        }
    }

    /// 
    /// Dismiss the composition window/IME without disabling the subsystem.
    /// 
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_StartTextInput
    /// - See also: SDL_StopTextInput
    /// 
    @MainActor
    public func clearComposition() throws {
        if !SDL_ClearComposition(window) {
            throw SDLError()
        }
    }

    /// 
    /// Get the area used to type Unicode text input.
    /// 
    /// This returns the values previously set by SDL_SetTextInputArea().
    /// 
    /// - Returns: an SDLRect filled in with the text input area,
    ///            and the offset of the current cursor location
    ///            relative to `rect.x`.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_SetTextInputArea
    /// 
    @MainActor
    public var textInputArea: (SDLRect, Int) {
        get throws {
            var rect = SDL_Rect()
            var cursor: Int32 = 0
            if !SDL_GetTextInputArea(window, &rect, &cursor) {
                throw SDLError()
            }
            return (SDLRect(from: rect), Int(cursor))
        }
    }

    /// 
    /// Set the area used to type Unicode text input.
    /// 
    /// Native input methods may place a window with word suggestions near the
    /// cursor, without covering the text being entered.
    /// 
    /// - Parameter rect: the SDL_Rect representing the text input area, in window
    ///             coordinates, or NULL to clear it.
    /// - Parameter cursor: the offset of the current cursor location relative to
    ///               `rect->x`, in window coordinates.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See also: SDL_GetTextInputArea
    /// - See also: SDL_StartTextInput
    /// 
    @MainActor
    public func set(textInputArea value: SDLRect?, cursor: Int) throws {
        if var rect = value?.sdlRect {
            if !SDL_SetTextInputArea(window, &rect, Int32(cursor)) {
                throw SDLError()
            }
        } else {
            if !SDL_SetTextInputArea(window, nil, Int32(cursor)) {
                throw SDLError()
            }
        }
    }

    /// 
    /// Move the mouse cursor to the given position within the window.
    /// 
    /// This function generates a mouse motion event if relative mode is not
    /// enabled. If relative mode is enabled, you can force mouse events for the
    /// warp by setting the SDL_HINT_MOUSE_RELATIVE_WARP_MOTION hint.
    /// 
    /// Note that this function will appear to succeed, but not actually move the
    /// mouse when used over Microsoft Remote Desktop.
    /// 
    /// - Parameter to: the coordinates within the window.
    /// 
    /// - Warning: This function should only be called on the main thread.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_WarpMouseGlobal
    /// 
    @MainActor
    public func warpMouse(to point: SDLFPoint) {
        SDL_WarpMouseInWindow(window, point.x, point.y)
    }
}

fileprivate func hitTestCallback(_ window: OpaquePointer!, _ area: UnsafePointer<SDL_Point>!, _ data: UnsafeMutableRawPointer!) -> SDL_HitTestResult {
    let obj = Unmanaged<SDLWindowHitTestDelegateBox>.fromOpaque(data!).takeUnretainedValue()
    return obj.delegate.hitTest(in: obj.window, at: SDLPoint(from: area.pointee)).sdlValue
}

#if canImport(Metal)

import Metal
import QuartzCore

public class SDLMetalView {
    private let pointer: UnsafeMutableRawPointer!
    private let window: SDLWindow // retain the window to keep it from being destroyed while this is alive
    internal init(from ptr: UnsafeMutableRawPointer!, for win: SDLWindow) {
        self.pointer = ptr
        self.window = win
    }
    deinit {
        SDL_Metal_DestroyView(pointer)
    }
    /// 
    /// Get the backing CAMetalLayer for the given view.
    /// 
    /// - Returns: the layer.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    public var layer: CAMetalLayer {
        return SDL_Metal_GetLayer(pointer)!.assumingMemoryBound(to: CAMetalLayer.self).pointee
    }
}

public extension SDLWindow {
    /// 
    /// Create a CAMetalLayer-backed NSView/UIView and attach it to the specified
    /// window.
    /// 
    /// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
    /// its own. It is up to user code to do that.
    /// 
    /// The returned handle can be casted directly to a NSView or UIView. To access
    /// the backing CAMetalLayer, call SDL_Metal_GetLayer().
    /// 
    /// \returns handle NSView or UIView.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_Metal_DestroyView
    /// \sa SDL_Metal_GetLayer
    /// 
    @MainActor
    func createMetalView() -> SDLMetalView {
        return SDLMetalView(from: SDL_Metal_CreateView(window), for: self)
    }
}

#if canImport(AppKit)

import AppKit

public extension SDLMetalView {
    /// Returns the underlying view object for the SDLMetalView.
    var view: NSView {
        return Unmanaged<NSView>.fromOpaque(pointer).takeUnretainedValue()
    }
}

#elseif canImport(UIKit)

import UIKit

public extension SDLMetalView {
    /// Returns the underlying view object for the SDLMetalView.
    var view: UIView {
        return Unmanaged<UIView>.fromOpaque(pointer).takeUnretainedValue()
    }
}

#endif

#endif
