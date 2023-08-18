import SDL3_Native

public typealias SDLSysWMinfo = SDL_SysWMinfo

public struct SDLMessageBox {
    public enum BoxType: UInt32 {
        case `default` = 0
        case error = 0x10
        case warning = 0x20
        case information = 0x40
    }

    public enum ButtonOrder: UInt32 {
        case `default` = 0
        case leftToRight = 0x80
        case rightToLeft = 0x100
    }

    public enum DefaultButton: UInt32 {
        case none = 0
        case returnKey = 1
        case escapeKey = 2
    }

    public struct Button {
        public var defaultButton: DefaultButton
        public var buttonID: Int32
        public var text: String
    }

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
        internal init(for boxData: SDLMessageBox) {
            let arr = UnsafeMutablePointer<SDL_MessageBoxButtonData>.allocate(capacity: boxData.buttons.count)
            for i in 0..<boxData.buttons.count {
                let v = boxData.buttons[i]
                v.text.withCString {_text in
                    let str = UnsafeMutablePointer<CChar>.allocate(capacity: v.text.count + 1)
                    str.initialize(from: _text, count: v.text.count + 1)
                    arr[i] = SDL_MessageBoxButtonData(flags: v.defaultButton.rawValue, buttonid: v.buttonID, text: str)
                }
            }
            pointer = UnsafeMutablePointer<SDL_MessageBoxData>.allocate(capacity: 1)
            boxData.title.withCString {_title in
                boxData.message.withCString {_message in
                    let titleStr = UnsafeMutablePointer<CChar>.allocate(capacity: boxData.title.count + 1)
                    titleStr.initialize(from: _title, count: boxData.title.count + 1)
                    let messageStr = UnsafeMutablePointer<CChar>.allocate(capacity: boxData.message.count + 1)
                    messageStr.initialize(from: _message, count: boxData.message.count + 1)
                    pointer.pointee = SDL_MessageBoxData(flags: boxData.boxType.rawValue | boxData.buttonOrder.rawValue, window: boxData.window?.window, title: _title, message: _message, numbuttons: Int32(boxData.buttons.count), buttons: arr, colorScheme: nil)
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

    internal var sdlData: SDLData {
        return SDLData(for: self)
    }

    public func show() throws -> Int32 {
        let data = sdlData
        return try pointer {_button in
            if SDL_ShowMessageBox(data.pointer, _button) != 0 {
                throw SDLError()
            }
        }
    }
}

public protocol SDLWindowHitTestDelegate {
    func hitTest(in: SDLWindow, at: SDLPoint) -> SDLWindow.HitTestResult
}

public class SDLWindow: Equatable {
    public struct Flags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue v: UInt32) {rawValue = v}
        public static let fullScreen         = Flags(rawValue: 0x00000001)
        public static let openGL             = Flags(rawValue: 0x00000002)
        public static let occluded           = Flags(rawValue: 0x00000004)
        public static let hidden             = Flags(rawValue: 0x00000008)
        public static let borderless         = Flags(rawValue: 0x00000010)
        public static let resizable          = Flags(rawValue: 0x00000020)
        public static let minimized          = Flags(rawValue: 0x00000040)
        public static let maximized          = Flags(rawValue: 0x00000080)
        public static let mouseGrabbed       = Flags(rawValue: 0x00000100)
        public static let inputFocus         = Flags(rawValue: 0x00000200)
        public static let mouseFocus         = Flags(rawValue: 0x00000400)
        public static let foreign            = Flags(rawValue: 0x00000800)
        public static let highPixelDensity   = Flags(rawValue: 0x00002000)
        public static let mouseCapture       = Flags(rawValue: 0x00004000)
        public static let alwaysOnTop        = Flags(rawValue: 0x00008000)
        public static let utility            = Flags(rawValue: 0x00020000)
        public static let tooltip            = Flags(rawValue: 0x00040000)
        public static let popupMenu          = Flags(rawValue: 0x00080000)
        public static let keyboardGrabbed    = Flags(rawValue: 0x00100000)
        public static let vulkan             = Flags(rawValue: 0x10000000)
        public static let metal              = Flags(rawValue: 0x20000000)
        public static let transparent        = Flags(rawValue: 0x40000000)
    }

    public enum FlashOperation: UInt32 {
        case cancel = 0
        case briefly = 1
        case untilFocused = 2
    }

    public enum HitTestResult: UInt32 {
        case normal = 0
        case draggable = 1
        case resizeTopLeft = 2
        case resizeTop = 3
        case resizeTopRight = 4
        case resizeRight = 5
        case resizeBottomRight = 6
        case resizeBottom = 7
        case resizeBottomLeft = 8
        case resizeLeft = 9
    }

    public static var grabbed: SDLWindow? {
        if let _window = nullCheck(SDL_GetGrabbedWindow()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    public static var keyboardFocus: SDLWindow? {
        if let _window = nullCheck(SDL_GetKeyboardFocus()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    public static var mouseFocus: SDLWindow? {
        if let _window = nullCheck(SDL_GetMouseFocus()) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    public static func == (lhs: SDLWindow, rhs: SDLWindow) -> Bool {
        return lhs.window == rhs.window
    }

    public static func from(id: UInt32) -> SDLWindow? {
        if let _window = nullCheck(SDL_GetWindowFromID(id)) {
            return SDLWindow(rawValue: _window, owned: false)
        } else {
            return nil
        }
    }

    internal let window: OpaquePointer
    private let owned: Bool

    private init(rawValue: OpaquePointer, owned: Bool) {
        window = rawValue
        self.owned = owned
    }

    public init(named title: String, width: Int32, height: Int32, flags: Flags) throws {
        if let _window = nullCheck(SDL_CreateWindow(title, width, height, flags.rawValue)) {
            window = _window
            owned = true
        } else {
            throw SDLError()
        }
    }

    public init(withRendererNamed title: String, width: Int32, height: Int32, flags: Flags) throws {
        var ren: OpaquePointer?
        var win: OpaquePointer?
        let ok = withUnsafeMutablePointer(to: &win) {_window in
            withUnsafeMutablePointer(to: &ren) {_ren in
                SDL_CreateWindowAndRenderer(width, height, flags.rawValue, _window, _ren) == 0
            }
        }
        if ok {
            window = win!
            owned = true
            _renderer = SDLRenderer(rawValue: ren!)
        } else {
            throw SDLError()
        }
    }

    public init(named title: String, x: Int32, y: Int32, width: Int32, height: Int32, flags: Flags) throws {
        if let _window = nullCheck(SDL_CreateWindowWithPosition(title, x, y, width, height, flags.rawValue)) {
            window = _window
            owned = true
        } else {
            throw SDLError()
        }
    }

    public init(from data: UnsafeRawPointer) throws {
        if let _window = nullCheck(SDL_CreateWindowFrom(data)) {
            window = _window
            owned = true
        } else {
            throw SDLError()
        }
    }

    deinit {
        if owned {
            _renderer = nil
            SDL_DestroyWindow(window)
        }
    }

    public subscript(key: String) -> UnsafeMutableRawPointer {
        get {
            return SDL_GetWindowData(window, key)
        } set (value) {
            SDL_SetWindowData(window, key, value)
        }
    }

    private var _renderer: SDLRenderer? = nil
    public var renderer: SDLRenderer! {
        if let r = _renderer {
            return r
        }
        if let ren = SDL_CreateRenderer(window, nil, 0) {
            _renderer = SDLRenderer(rawValue: ren)
            _renderer!.window = self
            return _renderer!
        }
        return nil
    }

    public var alwaysOnTop: Bool {
        get {
            return flags.contains(.alwaysOnTop)
        } set (value) {
            SDL_SetWindowAlwaysOnTop(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var bordered: Bool {
        get {
            return !flags.contains(.borderless)
        } set (value) {
            SDL_SetWindowBordered(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var display: SDLDisplay {
        return SDLDisplay(for: SDL_GetDisplayForWindow(window))
    }

    public var displayScale: Float {
        return SDL_GetWindowDisplayScale(window)
    }

    public var flags: Flags {
        return Flags(rawValue: SDL_GetWindowFlags(window))
    }

    public var fullscreen: Bool {
        get {
            return flags.contains(.fullScreen)
        } set (value) {
            SDL_SetWindowFullscreen(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var fullscreenMode: SDLDisplay.Mode {
        get {
            return SDLDisplay.Mode(from: SDL_GetWindowFullscreenMode(window))
        } set (value) {
            SDL_SetWindowFullscreenMode(window, value.pointer)
        }
    }

    public var grab: Bool {
        get {
            return SDL_GetWindowGrab(window) == SDL_TRUE
        } set (value) {
            SDL_SetWindowGrab(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var keyboardGrab: Bool {
        get {
            return SDL_GetWindowKeyboardGrab(window) == SDL_TRUE
        } set (value) {
            SDL_SetWindowKeyboardGrab(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var mouseGrab: Bool {
        get {
            return SDL_GetWindowMouseGrab(window) == SDL_TRUE
        } set (value) {
            SDL_SetWindowMouseGrab(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var hasSurface: Bool {
        return SDL_HasWindowSurface(window) == SDL_TRUE
    }

    fileprivate var hitTestDelegate: SDLWindowHitTestDelegate?
    public var hitTest: SDLWindowHitTestDelegate? {
        get {
            return hitTestDelegate
        } set (value) {
            hitTestDelegate = value
            if value != nil {
                SDL_SetWindowHitTest(window, hitTestCallback, Unmanaged.passUnretained(self).toOpaque())
            } else {
                SDL_SetWindowHitTest(window, nil, nil)
            }
        }
    }

    public var id: UInt32 {
        return SDL_GetWindowID(window)
    }

    public var maximumSize: SDLSize {
        get {
            var w: Int32 = 0
            var h: Int32 = 0
            _ = withUnsafeMutablePointer(to: &w) {_w in
                withUnsafeMutablePointer(to: &h) {_h in
                    SDL_GetWindowMaximumSize(window, _w, _h)
                }
            }
            return SDLSize(width: w, height: h)
        } set (value) {
            SDL_SetWindowMaximumSize(window, value.width, value.height)
        }
    }

    public var minimumSize: SDLSize {
        get {
            var w: Int32 = 0
            var h: Int32 = 0
            _ = withUnsafeMutablePointer(to: &w) {_w in
                withUnsafeMutablePointer(to: &h) {_h in
                    SDL_GetWindowMinimumSize(window, _w, _h)
                }
            }
            return SDLSize(width: w, height: h)
        } set (value) {
            SDL_SetWindowMinimumSize(window, value.width, value.height)
        }
    }

    public var mouseRect: SDLRect {
        get {
            return SDLRect(from: SDL_GetWindowMouseRect(window).pointee)
        } set (value) {
            let rect = value.sdlRect
            _ = withUnsafePointer(to: rect) {_rect in
                SDL_SetWindowMouseRect(window, _rect)
            }
        }
    }

    public var opacity: Float {
        get {
            var res: Float = 0
            _ = withUnsafeMutablePointer(to: &res) {_res in
                SDL_GetWindowOpacity(window, _res)
            }
            return res
        } set (value) {
            SDL_SetWindowOpacity(window, value)
        }
    }

    public var pixelDensity: Float {
        return SDL_GetWindowPixelDensity(window)
    }

    public var pixelFormat: SDLPixelFormat.Enum {
        return SDLPixelFormat.Enum(rawValue: SDL_GetWindowPixelFormat(window))
    }

    public var position: SDLPoint {
        get {
            var x: Int32 = 0
            var y: Int32 = 0
            _ = withUnsafeMutablePointer(to: &x) {_x in
                withUnsafeMutablePointer(to: &y) {_y in
                    SDL_GetWindowPosition(window, _x, _y)
                }
            }
            return SDLPoint(x: x, y: y)
        } set (value) {
            SDL_SetWindowPosition(window, value.x, value.y)
        }
    }

    public var resizable: Bool {
        get {
            return flags.contains(.resizable)
        } set (value) {
            SDL_SetWindowResizable(window, value ? SDL_TRUE : SDL_FALSE)
        }
    }

    public var size: SDLSize {
        get {
            var x: Int32 = 0
            var y: Int32 = 0
            _ = withUnsafeMutablePointer(to: &x) {_x in
                withUnsafeMutablePointer(to: &y) {_y in
                    SDL_GetWindowPosition(window, _x, _y)
                }
            }
            return SDLSize(width: x, height: y)
        } set (value) {
            SDL_SetWindowPosition(window, value.width, value.height)
        }
    }

    public var title: String {
        get {
            return String(cString: SDL_GetWindowTitle(window))
        } set (value) {
            SDL_SetWindowTitle(window, value)
        }
    }

    public var sysWMinfo: SDLSysWMinfo {
        var info = SDLSysWMinfo()
        _ = withUnsafeMutablePointer(to: &info) {_info in
            SDL_GetWindowWMInfo(self.window, _info, UInt32(SDL_SYSWM_CURRENT_VERSION))
        }
        return info
    }

    public func flash(operation: FlashOperation) -> SDLError? {
        if SDL_FlashWindow(window, SDL_FlashOperation(rawValue: operation.rawValue)) != 0 {
            return SDLError()
        }
        return nil
    }

    public func bordersSize() throws -> (Int32, Int32, Int32, Int32) {
        var top: Int32 = 0
        var bottom: Int32 = 0
        var left: Int32 = 0
        var right: Int32 = 0
        let ok = withUnsafeMutablePointer(to: &top) {_top in
            withUnsafeMutablePointer(to: &bottom) {_bottom in
                withUnsafeMutablePointer(to: &left) {_left in
                    withUnsafeMutablePointer(to: &right) {_right in
                        return SDL_GetWindowBordersSize(window, _top, _bottom, _left, _right) == 0
                    }
                }
            }
        }
        if ok {
            return (top, bottom, left, right)
        } else {
            throw SDLError()
        }
    }

    public func surface() -> SDLSurface? {
        if let surface = nullCheck(SDL_GetWindowSurface(window)) {
            return SDLSurface(from: surface, owned: false)
        } else {
            return nil
        }
    }

    public func destroySurface() {
        SDL_DestroyWindowSurface(window)
    }

    public func showSimpleMessageBox(with type: SDLMessageBox.BoxType, title: String, message: String) throws {
        if SDL_ShowSimpleMessageBox(type.rawValue, title, message, window) != 0 {
            throw SDLError()
        }
    }

    public static func showSimpleMessageBox(with type: SDLMessageBox.BoxType, title: String, message: String) throws {
        if SDL_ShowSimpleMessageBox(type.rawValue, title, message, nil) != 0 {
            throw SDLError()
        }
    }

    public func hide() throws {
        if SDL_HideWindow(window) != 0 {
            throw SDLError()
        }
    }

    public func maximize() throws {
        if SDL_MaximizeWindow(window) != 0 {
            throw SDLError()
        }
    }
    
    public func minimize() throws {
        if SDL_MinimizeWindow(window) != 0 {
            throw SDLError()
        }
    }

    public func raise() throws {
        if SDL_RaiseWindow(window) != 0 {
            throw SDLError()
        }
    }

    public func restore() throws {
        if SDL_RestoreWindow(window) != 0 {
            throw SDLError()
        }
    }

    public func set(icon: SDLSurface) throws {
        if SDL_SetWindowIcon(window, icon.surf) != 0 {
            throw SDLError()
        }
    }

    public func setInputFocus() throws {
        if SDL_SetWindowInputFocus(window) != 0 {
            throw SDLError()
        }
    }

    public func setModal(for parent: SDLWindow) throws {
        if SDL_SetWindowModalFor(window, parent.window) != 0 {
            throw SDLError()
        }
    }

    public func show() throws {
        if SDL_ShowWindow(window) != 0 {
            throw SDLError()
        }
    }

    public func updateSurface() throws {
        if SDL_UpdateWindowSurface(window) != 0 {
            throw SDLError()
        }
    }

    public func updateSurface(in rects: [SDLRect]) throws {
        let arr = UnsafeMutablePointer<SDL_Rect>.allocate(capacity: rects.count)
        defer {arr.deallocate()}
        for i in 0..<rects.count {
            arr[i] = rects[i].sdlRect
        }
        if SDL_UpdateWindowSurfaceRects(window, arr, Int32(rects.count)) != 0 {
            throw SDLError()
        }
    }

    public func popup(offsetX: Int32, offsetY: Int32, width: Int32, height: Int32, flags: Flags) throws -> SDLWindow {
        if let _window = nullCheck(SDL_CreatePopupWindow(window, offsetX, offsetY, width, height, flags.rawValue)) {
            return SDLWindow(rawValue: _window, owned: true)
        } else {
            throw SDLError()
        }
    }

    public func showSystemMenu(x: Int32, y: Int32) throws {
        if SDL_ShowWindowSystemMenu(window, x, y) != 0 {
            throw SDLError()
        }
    }

    public func createRenderer(with driver: String, flags: SDLRenderer.Flags) throws -> SDLRenderer {
        if let r = _renderer {
            return r
        }
        if let ren = SDL_CreateRenderer(window, driver, flags.rawValue) {
            _renderer = SDLRenderer(rawValue: ren)
            _renderer!.window = self
            return _renderer!
        } else {
            throw SDLError()
        }
    }

    public func warpMouse(to point: SDLFPoint) {
        SDL_WarpMouseInWindow(window, point.x, point.y)
    }
}

fileprivate func hitTestCallback(_ window: OpaquePointer!, _ area: UnsafePointer<SDL_Point>!, _ data: UnsafeMutableRawPointer!) -> SDL_HitTestResult {
    let obj = Unmanaged<SDLWindow>.fromOpaque(data!).takeUnretainedValue()
    if let delegate = obj.hitTestDelegate {
        return SDL_HitTestResult(rawValue: delegate.hitTest(in: obj, at: SDLPoint(from: area.pointee)).rawValue)
    }
    return SDL_HITTEST_NORMAL
}
