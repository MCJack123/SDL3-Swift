import SDL3_Native

public protocol SDLEventDelegate {
    func filter(event: SDLEventType) -> Bool
    func watch(event: SDLEventType) -> Bool
}

public extension SDLEventDelegate {
    func filter(event: SDLEventType) -> Bool {return true}
    func watch(event: SDLEventType) -> Bool {return true}
}

public protocol SDLEventType {
    static var type: SDL_EventType {get}
    var timestamp: UInt64 {get set}
    var sdlEvent: SDL_Event {get}
    init(from: SDL_Event)
}

public extension SDLEventType {
    static var enabled: Bool {
        get {
            return SDL_EventEnabled(self.type.rawValue)
        } set (value) {
            SDL_SetEventEnabled(self.type.rawValue, value)
        }
    }

    func push() throws {
        try SDLEvent.push(event: self)
    }
}

public protocol SDLWindowedEvent: SDLEventType {
    var window: SDLWindow? {get set}
    init()
}

fileprivate var SDLEvent_delegate: SDLEventDelegate? = nil
public enum SDLEvent {
    public static var delegate: SDLEventDelegate? {
        get {
            return SDLEvent_delegate
        } set (value) {
            if SDLEvent_delegate == nil && value != nil {
                SDL_SetEventFilter(eventFilter, nil)
                SDL_AddEventWatch(eventWatch, nil)
            } else if SDLEvent_delegate != nil && value == nil {
                SDL_SetEventFilter(nil, nil)
                SDL_DelEventWatch(eventWatch, nil)
            }
            SDLEvent_delegate = value
        }
    }

    internal static var eventMap: [UInt32: SDLEventType.Type] = [
        SDL_EVENT_QUIT.rawValue: SDLQuitEvent.self,
        SDL_EVENT_DISPLAY_ORIENTATION.rawValue: SDLDisplayOrientationEvent.self,
        SDL_EVENT_DISPLAY_ADDED.rawValue: SDLDisplayAddedEvent.self,
        SDL_EVENT_DISPLAY_REMOVED.rawValue: SDLDisplayRemovedEvent.self,
        SDL_EVENT_DISPLAY_MOVED.rawValue: SDLDisplayMovedEvent.self,
        SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED.rawValue: SDLDisplayContentScaleChangedEvent.self,
        SDL_EVENT_WINDOW_SHOWN.rawValue: SDLWindowShownEvent.self,
        SDL_EVENT_WINDOW_HIDDEN.rawValue: SDLWindowHiddenEvent.self,
        SDL_EVENT_WINDOW_EXPOSED.rawValue: SDLWindowExposedEvent.self,
        SDL_EVENT_WINDOW_MOVED.rawValue: SDLWindowMovedEvent.self,
        SDL_EVENT_WINDOW_RESIZED.rawValue: SDLWindowResizedEvent.self,
        SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED.rawValue: SDLWindowPixelSizeChangedEvent.self,
        SDL_EVENT_WINDOW_MINIMIZED.rawValue: SDLWindowMinimizedEvent.self,
        SDL_EVENT_WINDOW_MAXIMIZED.rawValue: SDLWindowMaximizedEvent.self,
        SDL_EVENT_WINDOW_RESTORED.rawValue: SDLWindowRestoredEvent.self,
        SDL_EVENT_WINDOW_MOUSE_ENTER.rawValue: SDLWindowMouseEnterEvent.self,
        SDL_EVENT_WINDOW_MOUSE_LEAVE.rawValue: SDLWindowMouseLeaveEvent.self,
        SDL_EVENT_WINDOW_FOCUS_GAINED.rawValue: SDLWindowFocusGainedEvent.self,
        SDL_EVENT_WINDOW_FOCUS_LOST.rawValue: SDLWindowFocusLostEvent.self,
        SDL_EVENT_WINDOW_CLOSE_REQUESTED.rawValue: SDLWindowCloseRequestedEvent.self,
        SDL_EVENT_WINDOW_HIT_TEST.rawValue: SDLWindowHitTestEvent.self,
        SDL_EVENT_WINDOW_ICCPROF_CHANGED.rawValue: SDLWindowIccprofChangedEvent.self,
        SDL_EVENT_WINDOW_DISPLAY_CHANGED.rawValue: SDLWindowDisplayChangedEvent.self,
        SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED.rawValue: SDLWindowDisplayScaleChangedEvent.self,
        SDL_EVENT_WINDOW_OCCLUDED.rawValue: SDLWindowOccludedEvent.self,
        SDL_EVENT_WINDOW_DESTROYED.rawValue: SDLWindowDestroyedEvent.self,
        SDL_EVENT_KEY_DOWN.rawValue: SDLKeyDownEvent.self,
        SDL_EVENT_KEY_UP.rawValue: SDLKeyUpEvent.self,
        SDL_EVENT_TEXT_EDITING.rawValue: SDLTextEditingEvent.self,
        SDL_EVENT_TEXT_INPUT.rawValue: SDLTextInputEvent.self,
        SDL_EVENT_KEYMAP_CHANGED.rawValue: SDLKeymapChangedEvent.self,
        SDL_EVENT_MOUSE_MOTION.rawValue: SDLMouseMotionEvent.self,
        SDL_EVENT_MOUSE_BUTTON_DOWN.rawValue: SDLMouseButtonDownEvent.self,
        SDL_EVENT_MOUSE_BUTTON_UP.rawValue: SDLMouseButtonUpEvent.self,
        SDL_EVENT_MOUSE_WHEEL.rawValue: SDLMouseWheelEvent.self,
    ]

    internal static func make(event: SDL_Event) -> SDLEventType {
        if let T = eventMap[event.type] {
            return T.init(from: event)
        }
        return SDLUnknownEvent()
    }

    public static func has<T: SDLEventType>(class clazz: T.Type) -> Bool {
        return SDL_HasEvent(clazz.type.rawValue)
    }

    @MainActor public static func pump() {
        SDL_PumpEvents()
    }

    @MainActor public static func poll() -> SDLEventType? {
        var event = SDL_Event()
        let ok = withUnsafeMutablePointer(to: &event) {_event in
            SDL_PollEvent(_event)
        }
        if ok {
            return make(event: event)
        } else {
            return nil
        }
    }

    @MainActor public static func wait() throws -> SDLEventType {
        var event = SDL_Event()
        let ok = withUnsafeMutablePointer(to: &event) {_event in
            SDL_WaitEvent(_event)
        }
        if ok {
            return make(event: event)
        } else {
            throw SDLError()
        }
    }

    @MainActor public static func wait(for timeout: Int32) throws -> SDLEventType? {
        var event = SDL_Event()
        let ok = withUnsafeMutablePointer(to: &event) {_event in
            SDL_WaitEventTimeout(_event, timeout)
        }
        if ok {
            return make(event: event)
        } else {
            throw SDLError()
        }
    }

    public static func flush<T: SDLEventType>(type: T.Type) {
        SDL_FlushEvent(type.type.rawValue)
    }

    public static func push(event: SDLEventType) throws {
        var ev = event.sdlEvent
        let res = withUnsafeMutablePointer(to: &ev) {_ev in
            SDL_PushEvent(_ev)
        }
        if res {
            return
        } else {
            throw SDLError()
        }
    }

    public static func stub<T: SDLEventType>(for event: T) -> SDL_Event {
        var ev = SDL_Event()
        ev.common.type = T.type.rawValue
        ev.common.timestamp = event.timestamp
        return ev
    }
}

public struct SDLUnknownEvent: SDLEventType {
    public static var type: SDL_EventType {return SDL_EVENT_FIRST}
    public var timestamp: UInt64 = 0
    public var sdlEvent: SDL_Event {
        return SDLEvent.stub(for: self)
    }
    public init() {}
    public init(from: SDL_Event) {}
}

public struct SDLQuitEvent: SDLEventType {
    public static var type: SDL_EventType {return SDL_EVENT_QUIT}
    public var timestamp: UInt64 = 0
    public var sdlEvent: SDL_Event {
        return SDLEvent.stub(for: self)
    }
    public init() {}
    public init(from: SDL_Event) {}
}

public protocol SDLDisplayEvent: SDLEventType {
    var display: SDLDisplay {get set}
    var data1: Int32 {get set}
    init(on display: SDLDisplay)
}

public extension SDLDisplayEvent {
    var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.display.displayID = display.id
        event.display.data1 = data1
        return event
    }

    init(from event: SDL_Event) {
        self.init(on: SDLDisplay(for: event.display.displayID))
        self.timestamp = event.display.timestamp
        self.data1 = event.display.data1
    }
}

public struct SDLDisplayOrientationEvent: SDLDisplayEvent {
    public static var type: SDL_EventType = SDL_EVENT_DISPLAY_ORIENTATION
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayAddedEvent: SDLDisplayEvent {
    public static var type: SDL_EventType = SDL_EVENT_DISPLAY_ADDED
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public var timestamp: UInt64 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayRemovedEvent: SDLDisplayEvent {
    public static var type: SDL_EventType = SDL_EVENT_DISPLAY_REMOVED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayMovedEvent: SDLDisplayEvent {
    public static var type: SDL_EventType = SDL_EVENT_DISPLAY_MOVED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayContentScaleChangedEvent: SDLDisplayEvent {
    public static var type: SDL_EventType = SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public protocol SDLWindowEvent: SDLWindowedEvent {
    var data1: Int32 {get set}
    var data2: Int32 {get set}
    init(for window: SDLWindow)
}

public extension SDLWindowEvent {
    var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.window.windowID = window!.id
        event.window.data1 = data1
        event.window.data2 = data2
        return event
    }

    init(for window: SDLWindow) {
        self.init()
        self.window = window
    }
    init(from event: SDL_Event) {
        self.init(for: SDLWindow.from(id: event.window.windowID)!)
        self.timestamp = event.window.timestamp
        self.data1 = event.window.data1
        self.data2 = event.window.data2
    }
}

public struct SDLWindowShownEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_SHOWN
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowHiddenEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_HIDDEN
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowExposedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_EXPOSED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMovedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_MOVED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowResizedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_RESIZED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowPixelSizeChangedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMinimizedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_MINIMIZED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMaximizedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_MAXIMIZED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowRestoredEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_RESTORED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMouseEnterEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_MOUSE_ENTER
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMouseLeaveEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_MOUSE_LEAVE
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowFocusGainedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_FOCUS_GAINED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowFocusLostEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_FOCUS_LOST
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowCloseRequestedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_CLOSE_REQUESTED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowHitTestEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_HIT_TEST
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowIccprofChangedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_ICCPROF_CHANGED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDisplayChangedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_DISPLAY_CHANGED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDisplayScaleChangedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowOccludedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_OCCLUDED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDestroyedEvent: SDLWindowEvent {
    public static var type: SDL_EventType = SDL_EVENT_WINDOW_DESTROYED
    public var timestamp: UInt64 = 0
    public var window: SDLWindow?
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public protocol SDLKeyboardEvent: SDLWindowedEvent {
    var pressed: Bool {get set}
    var `repeat`: Bool {get set}
    var scancode: SDLScancode {get set}
    var symbol: SDLKeycode {get set}
    var modifiers: SDLKeyModifiers {get set}
}

public extension SDLKeyboardEvent {
    var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.key.windowID = window?.id ?? 0
        event.key.state = UInt8(pressed ? SDL_PRESSED : SDL_RELEASED)
        event.key.repeat = self.repeat ? 1 : 0
        event.key.keysym.scancode = SDL_Scancode(rawValue: scancode.rawValue)
        event.key.keysym.sym = symbol.rawValue
        event.key.keysym.mod = modifiers.rawValue
        return event
    }

    init(from event: SDL_Event) {
        self.init()
        self.timestamp = event.key.timestamp
        self.window = SDLWindow.from(id: event.key.windowID)
        self.pressed = event.key.state == SDL_PRESSED
        self.repeat = event.key.repeat != 0
        self.scancode = SDLScancode(rawValue: event.key.keysym.scancode.rawValue)!
        self.symbol = SDLKeycode(rawValue: event.key.keysym.sym)!
        self.modifiers = SDLKeyModifiers(rawValue: event.key.keysym.mod)
    }
}

public struct SDLKeyDownEvent: SDLKeyboardEvent {
    public var window: SDLWindow? = nil
    public var pressed: Bool = false
    public var `repeat`: Bool = false
    public var scancode: SDLScancode = .unknown
    public var symbol: SDLKeycode = .unknown
    public var modifiers: SDLKeyModifiers = .none
    public var timestamp: UInt64 = 0
    public static var type: SDL_EventType = SDL_EVENT_KEY_DOWN
    public init() {}
}

public struct SDLKeyUpEvent: SDLKeyboardEvent {
    public var window: SDLWindow? = nil
    public var pressed: Bool = false
    public var `repeat`: Bool = false
    public var scancode: SDLScancode = .unknown
    public var symbol: SDLKeycode = .unknown
    public var modifiers: SDLKeyModifiers = .none
    public var timestamp: UInt64 = 0
    public static var type: SDL_EventType = SDL_EVENT_KEY_UP
    public init() {}
}

public struct SDLTextEditingEvent: SDLWindowedEvent {
    public static var type: SDL_EventType = SDL_EVENT_TEXT_EDITING
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var text: String = ""
    public var cursorPosition: Int32 = 0
    public var selectionLength: Int32 = 0

    public var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.edit.windowID = window?.id ?? 0
        let str = SDL_malloc(text.count + 1)!
        text.withCString {_text in
            str.copyMemory(from: UnsafeRawPointer(_text), byteCount: text.count)
        }
        event.edit.text = str.bindMemory(to: CChar.self, capacity: text.count + 1)
        event.edit.start = cursorPosition
        event.edit.length = selectionLength
        return event
    }

    public init() {}
    public init(from event: SDL_Event) {
        timestamp = event.edit.timestamp
        window = SDLWindow.from(id: event.edit.windowID)
        text = String(cString: event.edit.text)
        cursorPosition = event.edit.start
        selectionLength = event.edit.length
    }
}

public struct SDLTextInputEvent: SDLWindowedEvent {
    public static var type: SDL_EventType = SDL_EVENT_TEXT_INPUT
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var text: String = ""

    public var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.text.windowID = window?.id ?? 0
        let str = SDL_malloc(text.count + 1)!
        text.withCString {_text in
            str.copyMemory(from: UnsafeRawPointer(_text), byteCount: text.count)
        }
        event.text.text = str.bindMemory(to: CChar.self, capacity: text.count + 1)
        return event
    }

    public init() {}
    public init(from event: SDL_Event) {
        timestamp = event.edit.timestamp
        window = SDLWindow.from(id: event.text.windowID)
        text = String(cString: event.text.text)
    }
}

public struct SDLKeymapChangedEvent: SDLEventType {
    public static var type: SDL_EventType = SDL_EVENT_KEYMAP_CHANGED
    public var timestamp: UInt64 = 0
    public var sdlEvent: SDL_Event {
        return SDLEvent.stub(for: self)
    }
    public init() {}
    public init(from: SDL_Event) {}
}

public protocol SDLMouseButtonEvent: SDLWindowedEvent {
    var mouseID: UInt32 {get set}
    var button: UInt8 {get set}
    var pressed: Bool {get set}
    var clickCount: UInt8 {get set}
    var x: Float {get set}
    var y: Float {get set}
}

public extension SDLMouseButtonEvent {
    var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.button.windowID = window?.id ?? 0
        ev.button.which = mouseID
        ev.button.button = button
        ev.button.state = UInt8(pressed ? SDL_PRESSED : SDL_RELEASED)
        ev.button.clicks = clickCount
        ev.button.x = x
        ev.button.y = y
        return ev
    }

    init(from event: SDL_Event) {
        self.init()
        timestamp = event.button.timestamp
        window = SDLWindow.from(id: event.button.windowID)
        mouseID = event.button.which
        button = event.button.button
        pressed = event.button.state == SDL_PRESSED
        clickCount = event.button.clicks
        x = event.button.x
        y = event.button.y
    }
}

public struct SDLMouseButtonDownEvent: SDLMouseButtonEvent {
    public static var type: SDL_EventType = SDL_EVENT_MOUSE_BUTTON_DOWN
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var mouseID: UInt32 = 0
    public var button: UInt8 = 0
    public var pressed: Bool = false
    public var clickCount: UInt8 = 0
    public var x: Float = 0
    public var y: Float = 0
    public init() {}
}

public struct SDLMouseButtonUpEvent: SDLMouseButtonEvent {
    public static var type: SDL_EventType = SDL_EVENT_MOUSE_BUTTON_UP
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var mouseID: UInt32 = 0
    public var button: UInt8 = 0
    public var pressed: Bool = false
    public var clickCount: UInt8 = 0
    public var x: Float = 0
    public var y: Float = 0
    public init() {}
}

public struct SDLMouseMotionEvent: SDLWindowedEvent {
    public static var type: SDL_EventType = SDL_EVENT_MOUSE_MOTION
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var mouseID: UInt32 = 0
    public var pressed: Bool = false
    public var x: Float = 0
    public var y: Float = 0
    public var relativeX: Float = 0
    public var relativeY: Float = 0
    public var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.motion.windowID = window?.id ?? 0
        ev.motion.which = mouseID
        ev.motion.state = UInt32(pressed ? SDL_PRESSED : SDL_RELEASED)
        ev.motion.x = x
        ev.motion.y = y
        ev.motion.xrel = relativeX
        ev.motion.yrel = relativeY
        return ev
    }

    public init() {}
    public init(from event: SDL_Event) {
        self.init()
        timestamp = event.motion.timestamp
        window = SDLWindow.from(id: event.motion.windowID)
        mouseID = event.motion.which
        pressed = event.motion.state == SDL_PRESSED
        x = event.motion.x
        y = event.motion.y
        relativeX = event.motion.xrel
        relativeY = event.motion.yrel
    }
}

public struct SDLMouseWheelEvent: SDLWindowedEvent {
    public static var type: SDL_EventType = SDL_EVENT_MOUSE_WHEEL
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var mouseID: UInt32 = 0
    public var flipped: Bool = false
    public var x: Float = 0
    public var y: Float = 0
    public var mouseX: Float = 0
    public var mouseY: Float = 0
    public var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.wheel.windowID = window?.id ?? 0
        ev.wheel.which = mouseID
        ev.wheel.direction = (flipped ? SDL_MOUSEWHEEL_FLIPPED : SDL_MOUSEWHEEL_NORMAL).rawValue
        ev.wheel.x = x
        ev.wheel.y = y
        ev.wheel.mouseX = mouseX
        ev.wheel.mouseY = mouseY
        return ev
    }

    public init() {}
    public init(from event: SDL_Event) {
        self.init()
        timestamp = event.wheel.timestamp
        window = SDLWindow.from(id: event.wheel.windowID)
        mouseID = event.wheel.which
        flipped = event.wheel.direction == SDL_MOUSEWHEEL_FLIPPED.rawValue
        x = event.wheel.x
        y = event.wheel.y
        mouseX = event.wheel.mouseX
        mouseY = event.wheel.mouseY
    }
}

public protocol SDLUserEvent: SDLWindowedEvent {
    static var _type: UInt32! {get set}
    var code: Int32 {get set}
    var data1: UnsafeMutableRawPointer? {get set}
    var data2: UnsafeMutableRawPointer? {get set}
}

public extension SDLUserEvent {
    var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.user.code = code
        ev.user.data1 = data1
        ev.user.data2 = data2
        return ev
    }

    static var type: SDL_EventType {
        return SDL_EventType(rawValue: _type)
    }

    init(from event: SDL_Event) {
        self.init()
        timestamp = event.user.timestamp
        window = SDLWindow.from(id: event.user.windowID)
        code = event.user.code
        data1 = event.user.data1
        data2 = event.user.data2
    }
}

open class SDLUserEventBase {
    public var timestamp: UInt64 = 0
    public var window: SDLWindow? = nil
    public var code: Int32 = 0
    public var data1: UnsafeMutableRawPointer? = nil
    public var data2: UnsafeMutableRawPointer? = nil

    public required init() {
        if let T = type(of: self) as? SDLUserEvent.Type {
            if T._type == nil {
                T._type = SDL_RegisterEvents(1)
                SDLEvent.eventMap[T._type] = T
            }
        } else {
            assert(false, "User event type \(type(of: self)) must conform to SDLUserEvent")
        }
    }
}

fileprivate func eventFilter(_ userdata: UnsafeMutableRawPointer!, _ event: UnsafeMutablePointer<SDL_Event>!) -> Int32 {
    if let delegate = SDLEvent_delegate {
        return delegate.filter(event: SDLEvent.make(event: event.pointee)) ? 1 : 0
    }
    return 1
}

fileprivate func eventWatch(_ userdata: UnsafeMutableRawPointer!, _ event: UnsafeMutablePointer<SDL_Event>!) -> Int32 {
    if let delegate = SDLEvent_delegate {
        return delegate.watch(event: SDLEvent.make(event: event.pointee)) ? 1 : 0
    }
    return 1
}
