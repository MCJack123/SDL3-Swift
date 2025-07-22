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
    @MainActor var window: SDLWindow? {get}
    var windowID: UInt32 {get set}
    init()
}

public extension SDLWindowedEvent {
    @MainActor
    var window: SDLWindow? {
        return SDLWindow.from(id: windowID)
    }
}

fileprivate class SDLEventDelegateBox {
    public let delegate: any SDLEventDelegate
    public init(_ delegate: any SDLEventDelegate) {self.delegate = delegate}
}

public enum SDLEvent {
    public static var delegate: SDLEventDelegate? {
        get {
            var filter: SDL_EventFilter? = nil, ud: UnsafeMutableRawPointer? = nil
            if SDL_GetEventFilter(&filter, &ud), let ud = ud {
                let delegate = Unmanaged<SDLEventDelegateBox>.fromOpaque(ud).takeUnretainedValue()
                return delegate.delegate
            } else {
                return nil
            }
        } set (value) {
            var filter: SDL_EventFilter? = nil, ud: UnsafeMutableRawPointer? = nil
            if SDL_GetEventFilter(&filter, &ud), let ud = ud {
                let delegate = Unmanaged<SDLEventDelegateBox>.fromOpaque(ud)
                SDL_SetEventFilter(nil, nil)
                SDL_RemoveEventWatch(eventWatch, ud)
                delegate.release()
            }
            if let value = value {
                let box = SDLEventDelegateBox(value)
                let ptr = Unmanaged.passRetained(box)
                SDL_SetEventFilter(eventFilter, ptr.toOpaque())
                SDL_AddEventWatch(eventWatch, ptr.toOpaque())
            }
        }
    }

    nonisolated(unsafe) internal static var eventMap: [UInt32: SDLEventType.Type] = [
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

    nonisolated(unsafe) internal static let eventMapLock = SDLMutex()

    internal static func make(event: SDL_Event) -> SDLEventType {
        return eventMapLock.lock {
            if let T = eventMap[event.type] {
                return T.init(from: event)
            }
            return SDLUnknownEvent()
        }
    }

    /// 
    /// Check for the existence of a certain event type in the event queue.
    /// 
    /// If you need to check for a range of event types, use SDL_HasEvents()
    /// instead.
    /// 
    /// \param type the type of event to be queried; see SDL_EventType for details.
    /// \returns true if events matching `type` are present, or false if events
    ///          matching `type` are not present.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_HasEvents
    /// 
    public static func has<T: SDLEventType>(class clazz: T.Type) -> Bool {
        return SDL_HasEvent(clazz.type.rawValue)
    }

    // 
    // Pump the event loop, gathering events from the input devices.
    // 
    // This function updates the event queue and internal input device state.
    // 
    // SDL_PumpEvents() gathers all the pending input information from devices and
    // places it in the event queue. Without calls to SDL_PumpEvents() no events
    // would ever be placed on the queue. Often the need for calls to
    // SDL_PumpEvents() is hidden from the user since SDL_PollEvent() and
    // SDL_WaitEvent() implicitly call SDL_PumpEvents(). However, if you are not
    // polling or waiting for events (e.g. you are filtering them), then you must
    // call SDL_PumpEvents() to force an event queue update.
    // 
    // \threadsafety This function should only be called on the main thread.
    // 
    // \since This function is available since SDL 3.2.0.
    // 
    // \sa SDL_PollEvent
    // \sa SDL_WaitEvent
    // 
    @MainActor
    public static func pump() {
        SDL_PumpEvents()
    }

    /// 
    /// Poll for currently pending events.
    /// 
    /// If `event` is not NULL, the next event is removed from the queue and stored
    /// in the SDL_Event structure pointed to by `event`. The 1 returned refers to
    /// this event, immediately stored in the SDL Event structure -- not an event
    /// to follow.
    /// 
    /// If `event` is NULL, it simply returns 1 if there is an event in the queue,
    /// but will not remove it from the queue.
    /// 
    /// As this function may implicitly call SDL_PumpEvents(), you can only call
    /// this function in the thread that set the video mode.
    /// 
    /// SDL_PollEvent() is the favored way of receiving system events since it can
    /// be done from the main loop and does not suspend the main loop while waiting
    /// on an event to be posted.
    /// 
    /// The common practice is to fully process the event queue once every frame,
    /// usually as a first step before updating the game's state:
    /// 
    /// ```c
    /// while (game_is_still_running) {
    ///     SDL_Event event;
    ///     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
    ///         // decide what to do with this event.
    ///     }
    /// 
    ///     // update game state, draw the current frame
    /// }
    /// ```
    /// 
    /// \param event the SDL_Event structure to be filled with the next event from
    ///              the queue, or NULL.
    /// \returns true if this got an event or false if there are none available.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_PushEvent
    /// \sa SDL_WaitEvent
    /// \sa SDL_WaitEventTimeout
    /// 
    @MainActor
    public static func poll() -> SDLEventType? {
        var event = SDL_Event()
        if SDL_PollEvent(&event) {
            return make(event: event)
        } else {
            return nil
        }
    }

    /// 
    /// Wait indefinitely for the next available event.
    /// 
    /// If `event` is not NULL, the next event is removed from the queue and stored
    /// in the SDL_Event structure pointed to by `event`.
    /// 
    /// As this function may implicitly call SDL_PumpEvents(), you can only call
    /// this function in the thread that initialized the video subsystem.
    /// 
    /// \param event the SDL_Event structure to be filled in with the next event
    ///              from the queue, or NULL.
    /// \returns true on success or false if there was an error while waiting for
    ///          events; call SDL_GetError() for more information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_PollEvent
    /// \sa SDL_PushEvent
    /// \sa SDL_WaitEventTimeout
    /// 
    @MainActor
    public static func wait() throws -> SDLEventType {
        var event = SDL_Event()
        if SDL_WaitEvent(&event) {
            return make(event: event)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Wait until the specified timeout (in milliseconds) for the next available
    /// event.
    /// 
    /// If `event` is not NULL, the next event is removed from the queue and stored
    /// in the SDL_Event structure pointed to by `event`.
    /// 
    /// As this function may implicitly call SDL_PumpEvents(), you can only call
    /// this function in the thread that initialized the video subsystem.
    /// 
    /// The timeout is not guaranteed, the actual wait time could be longer due to
    /// system scheduling.
    /// 
    /// \param event the SDL_Event structure to be filled in with the next event
    ///              from the queue, or NULL.
    /// \param timeoutMS the maximum number of milliseconds to wait for the next
    ///                  available event.
    /// \returns true if this got an event or false if the timeout elapsed without
    ///          any events available.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_PollEvent
    /// \sa SDL_PushEvent
    /// \sa SDL_WaitEvent
    /// 
    @MainActor
    public static func wait(for timeout: Int32) throws -> SDLEventType? {
        var event = SDL_Event()
        if SDL_WaitEventTimeout(&event, timeout) {
            return make(event: event)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Clear events of a specific type from the event queue.
    /// 
    /// This will unconditionally remove any events from the queue that match
    /// `type`. If you need to remove a range of event types, use SDL_FlushEvents()
    /// instead.
    /// 
    /// It's also normal to just ignore events you don't care about in your event
    /// loop without calling this function.
    /// 
    /// This function only affects currently queued events. If you want to make
    /// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
    /// on the main thread immediately before the flush call.
    /// 
    /// If you have user events with custom data that needs to be freed, you should
    /// use SDL_PeepEvents() to remove and clean up those events before calling
    /// this function.
    /// 
    /// \param type the type of event to be cleared; see SDL_EventType for details.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_FlushEvents
    /// 
    public static func flush<T: SDLEventType>(type: T.Type) {
        SDL_FlushEvent(type.type.rawValue)
    }

    /// 
    /// Add an event to the event queue.
    /// 
    /// The event queue can actually be used as a two way communication channel.
    /// Not only can events be read from the queue, but the user can also push
    /// their own events onto it. `event` is a pointer to the event structure you
    /// wish to push onto the queue. The event is copied into the queue, and the
    /// caller may dispose of the memory pointed to after SDL_PushEvent() returns.
    /// 
    /// Note: Pushing device input events onto the queue doesn't modify the state
    /// of the device within SDL.
    /// 
    /// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
    /// the event filter but events added with SDL_PeepEvents() do not.
    /// 
    /// For pushing application-specific events, please use SDL_RegisterEvents() to
    /// get an event type that does not conflict with other code that also wants
    /// its own custom event types.
    /// 
    /// \param event the SDL_Event to be added to the queue.
    /// \returns true on success, false if the event was filtered or on failure;
    ///          call SDL_GetError() for more information. A common reason for
    ///          error is the event queue being full.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_PeepEvents
    /// \sa SDL_PollEvent
    /// \sa SDL_RegisterEvents
    /// 
    public static func push(event: SDLEventType) throws {
        var ev = event.sdlEvent
        if !SDL_PushEvent(&ev) {
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

/// 
/// Fields shared by every event
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
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

/// 
/// Display state change event data (event.display.*)
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
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
    public static let type: SDL_EventType = SDL_EVENT_DISPLAY_ORIENTATION
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayAddedEvent: SDLDisplayEvent {
    public static let type: SDL_EventType = SDL_EVENT_DISPLAY_ADDED
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public var timestamp: UInt64 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayRemovedEvent: SDLDisplayEvent {
    public static let type: SDL_EventType = SDL_EVENT_DISPLAY_REMOVED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayMovedEvent: SDLDisplayEvent {
    public static let type: SDL_EventType = SDL_EVENT_DISPLAY_MOVED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

public struct SDLDisplayContentScaleChangedEvent: SDLDisplayEvent {
    public static let type: SDL_EventType = SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED
    public var timestamp: UInt64 = 0
    public var display: SDLDisplay
    public var data1: Int32 = 0
    public init(on display: SDLDisplay) {self.display = display}
}

/// 
/// Window state change event data (event.window.*)
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
public protocol SDLWindowEvent: SDLWindowedEvent {
    var data1: Int32 {get set}
    var data2: Int32 {get set}
    init(for windowID: UInt32)
}

public extension SDLWindowEvent {
    var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.window.windowID = windowID
        event.window.data1 = data1
        event.window.data2 = data2
        return event
    }

    init(for windowID: UInt32) {
        self.init()
        self.windowID = windowID
    }
    init(from event: SDL_Event) {
        self.init(for: event.window.windowID)
        self.timestamp = event.window.timestamp
        self.data1 = event.window.data1
        self.data2 = event.window.data2
    }
}

public struct SDLWindowShownEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_SHOWN
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowHiddenEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_HIDDEN
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowExposedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_EXPOSED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMovedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_MOVED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowResizedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_RESIZED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowPixelSizeChangedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMinimizedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_MINIMIZED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMaximizedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_MAXIMIZED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowRestoredEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_RESTORED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMouseEnterEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_MOUSE_ENTER
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowMouseLeaveEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_MOUSE_LEAVE
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowFocusGainedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_FOCUS_GAINED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowFocusLostEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_FOCUS_LOST
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowCloseRequestedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_CLOSE_REQUESTED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowHitTestEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_HIT_TEST
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowIccprofChangedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_ICCPROF_CHANGED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDisplayChangedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_DISPLAY_CHANGED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDisplayScaleChangedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowOccludedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_OCCLUDED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

public struct SDLWindowDestroyedEvent: SDLWindowEvent {
    public static let type: SDL_EventType = SDL_EVENT_WINDOW_DESTROYED
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var data1: Int32 = 0
    public var data2: Int32 = 0
    public init() {}
}

/// 
/// Keyboard button event structure (event.key.*)
/// 
/// The `key` is the base SDL_Keycode generated by pressing the `scancode`
/// using the current keyboard layout, applying any options specified in
/// SDL_HINT_KEYCODE_OPTIONS. You can get the SDL_Keycode corresponding to the
/// event scancode and modifiers directly from the keyboard layout, bypassing
/// SDL_HINT_KEYCODE_OPTIONS, by calling SDL_GetKeyFromScancode().
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
/// \sa SDL_GetKeyFromScancode
/// \sa SDL_HINT_KEYCODE_OPTIONS
/// 
public protocol SDLKeyboardEvent: SDLWindowedEvent {
    var which: UInt32 {get set}
    var pressed: Bool {get set}
    var `repeat`: Bool {get set}
    var scancode: SDLScancode {get set}
    var key: SDLKeycode {get set}
    var modifiers: SDLKeyModifiers {get set}
}

public extension SDLKeyboardEvent {
    var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.key.windowID = windowID
        event.key.which = which
        event.key.scancode = scancode.sdlValue
        event.key.key = key.rawValue
        event.key.mod = modifiers.rawValue
        event.key.down = pressed
        event.key.repeat = self.repeat
        return event
    }

    init(from event: SDL_Event) {
        self.init()
        self.timestamp = event.key.timestamp
        self.windowID = event.key.windowID
        self.which = event.key.which
        self.scancode = .sdl(event.key.scancode)
        self.key = SDLKeycode(rawValue: event.key.key)!
        self.modifiers = SDLKeyModifiers(rawValue: event.key.mod)
        self.pressed = event.key.down
        self.repeat = event.key.repeat
    }
}

public struct SDLKeyDownEvent: SDLKeyboardEvent {
    public var windowID: UInt32 = 0
    public var pressed: Bool = false
    public var `repeat`: Bool = false
    public var scancode: SDLScancode = .unknown
    public var key: SDLKeycode = .unknown
    public var modifiers: SDLKeyModifiers = .none
    public var timestamp: UInt64 = 0
    public var which: UInt32 = 0
    public static let type: SDL_EventType = SDL_EVENT_KEY_DOWN
    public init() {}
}

public struct SDLKeyUpEvent: SDLKeyboardEvent {
    public var windowID: UInt32 = 0
    public var pressed: Bool = false
    public var `repeat`: Bool = false
    public var scancode: SDLScancode = .unknown
    public var key: SDLKeycode = .unknown
    public var modifiers: SDLKeyModifiers = .none
    public var timestamp: UInt64 = 0
    public var which: UInt32 = 0
    public static let type: SDL_EventType = SDL_EVENT_KEY_UP
    public init() {}
}

public struct SDLTextEditingEvent: SDLWindowedEvent {
    public static let type: SDL_EventType = SDL_EVENT_TEXT_EDITING
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var text: String = ""
    public var cursorPosition: Int32 = 0
    public var selectionLength: Int32 = 0

    public var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.edit.windowID = windowID
        let str = SDL_malloc(text.count + 1)!
        text.withCString {_text in
            str.copyMemory(from: UnsafeRawPointer(_text), byteCount: text.count)
        }
        event.edit.text = UnsafePointer<CChar>(str.bindMemory(to: CChar.self, capacity: text.count + 1))
        event.edit.start = cursorPosition
        event.edit.length = selectionLength
        return event
    }

    public init() {}
    public init(from event: SDL_Event) {
        timestamp = event.edit.timestamp
        windowID = event.edit.windowID
        text = String(cString: event.edit.text)
        cursorPosition = event.edit.start
        selectionLength = event.edit.length
    }
}

public struct SDLTextInputEvent: SDLWindowedEvent {
    public static let type: SDL_EventType = SDL_EVENT_TEXT_INPUT
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var text: String = ""

    public var sdlEvent: SDL_Event {
        var event = SDLEvent.stub(for: self)
        event.text.windowID = windowID
        let str = SDL_malloc(text.count + 1)!
        text.withCString {_text in
            str.copyMemory(from: UnsafeRawPointer(_text), byteCount: text.count)
        }
        event.text.text = UnsafePointer<CChar>(str.bindMemory(to: CChar.self, capacity: text.count + 1))
        return event
    }

    public init() {}
    public init(from event: SDL_Event) {
        timestamp = event.edit.timestamp
        windowID = event.text.windowID
        text = String(cString: event.text.text)
    }
}

public struct SDLKeymapChangedEvent: SDLEventType {
    public static let type: SDL_EventType = SDL_EVENT_KEYMAP_CHANGED
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
        ev.button.windowID = windowID
        ev.button.which = mouseID
        ev.button.button = button
        ev.button.down = pressed
        ev.button.clicks = clickCount
        ev.button.x = x
        ev.button.y = y
        return ev
    }

    init(from event: SDL_Event) {
        self.init()
        timestamp = event.button.timestamp
        windowID = event.button.windowID
        mouseID = event.button.which
        button = event.button.button
        pressed = event.button.down
        clickCount = event.button.clicks
        x = event.button.x
        y = event.button.y
    }
}

public struct SDLMouseButtonDownEvent: SDLMouseButtonEvent {
    public static let type: SDL_EventType = SDL_EVENT_MOUSE_BUTTON_DOWN
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var mouseID: UInt32 = 0
    public var button: UInt8 = 0
    public var pressed: Bool = false
    public var clickCount: UInt8 = 0
    public var x: Float = 0
    public var y: Float = 0
    public init() {}
}

public struct SDLMouseButtonUpEvent: SDLMouseButtonEvent {
    public static let type: SDL_EventType = SDL_EVENT_MOUSE_BUTTON_UP
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var mouseID: UInt32 = 0
    public var button: UInt8 = 0
    public var pressed: Bool = false
    public var clickCount: UInt8 = 0
    public var x: Float = 0
    public var y: Float = 0
    public init() {}
}

public struct SDLMouseMotionEvent: SDLWindowedEvent {
    public static let type: SDL_EventType = SDL_EVENT_MOUSE_MOTION
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var mouseID: UInt32 = 0
    public var buttons: SDLMouse.ButtonFlags = []
    public var x: Float = 0
    public var y: Float = 0
    public var relativeX: Float = 0
    public var relativeY: Float = 0
    public var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.motion.windowID = windowID
        ev.motion.which = mouseID
        ev.motion.state = buttons.rawValue
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
        windowID = event.motion.windowID
        mouseID = event.motion.which
        buttons = SDLMouse.ButtonFlags(rawValue: event.motion.state)
        x = event.motion.x
        y = event.motion.y
        relativeX = event.motion.xrel
        relativeY = event.motion.yrel
    }
}

public struct SDLMouseWheelEvent: SDLWindowedEvent {
    public static let type: SDL_EventType = SDL_EVENT_MOUSE_WHEEL
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var mouseID: UInt32 = 0
    public var flipped: Bool = false
    public var x: Float = 0
    public var y: Float = 0
    public var mouseX: Float = 0
    public var mouseY: Float = 0
    public var sdlEvent: SDL_Event {
        var ev = SDLEvent.stub(for: self)
        ev.wheel.windowID = windowID
        ev.wheel.which = mouseID
        ev.wheel.direction = (flipped ? SDL_MOUSEWHEEL_FLIPPED : SDL_MOUSEWHEEL_NORMAL)
        ev.wheel.x = x
        ev.wheel.y = y
        ev.wheel.mouse_x = mouseX
        ev.wheel.mouse_y = mouseY
        return ev
    }

    public init() {}
    public init(from event: SDL_Event) {
        self.init()
        timestamp = event.wheel.timestamp
        windowID = event.wheel.windowID
        mouseID = event.wheel.which
        flipped = event.wheel.direction == SDL_MOUSEWHEEL_FLIPPED
        x = event.wheel.x
        y = event.wheel.y
        mouseX = event.wheel.mouse_x
        mouseY = event.wheel.mouse_y
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
        ev.user.windowID = windowID
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
        windowID = event.user.windowID
        code = event.user.code
        data1 = event.user.data1
        data2 = event.user.data2
    }
}

open class SDLUserEventBase {
    public var timestamp: UInt64 = 0
    public var windowID: UInt32 = 0
    public var code: Int32 = 0
    public var data1: UnsafeMutableRawPointer? = nil
    public var data2: UnsafeMutableRawPointer? = nil

    public required init() {
        if let T = type(of: self) as? SDLUserEvent.Type {
            if T._type == nil {
                T._type = SDL_RegisterEvents(1)
                SDLEvent.eventMapLock.lock {
                    SDLEvent.eventMap[T._type] = T
                }
            }
        } else {
            fatalError("User event type \(type(of: self)) must conform to SDLUserEvent")
        }
    }
}

fileprivate func eventFilter(_ userdata: UnsafeMutableRawPointer!, _ event: UnsafeMutablePointer<SDL_Event>!) -> Bool {
    let delegate = Unmanaged<SDLEventDelegateBox>.fromOpaque(userdata).takeUnretainedValue().delegate
    return delegate.filter(event: SDLEvent.make(event: event.pointee))
}

fileprivate func eventWatch(_ userdata: UnsafeMutableRawPointer!, _ event: UnsafeMutablePointer<SDL_Event>!) -> Bool {
    let delegate = Unmanaged<SDLEventDelegateBox>.fromOpaque(userdata).takeUnretainedValue().delegate
    return delegate.watch(event: SDLEvent.make(event: event.pointee))
}
