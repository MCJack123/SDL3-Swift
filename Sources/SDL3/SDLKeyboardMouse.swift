import SDL3_Native

public struct SDLMouseButtons: OptionSet {
    public let rawValue: UInt32
    public init(rawValue val: UInt32) {rawValue = val}
    public static let left = SDLMouseButtons(rawValue: 1)
    public static let right = SDLMouseButtons(rawValue: 2)
    public static let middle = SDLMouseButtons(rawValue: 4)
    public static let button4 = SDLMouseButtons(rawValue: 8)
    public static let button5 = SDLMouseButtons(rawValue: 16)
}

public class SDLCursor {
    @EnumWrapper(SDL_SystemCursor.self)
    public enum SystemCursor: UInt32 {
        case arrow = 0
        case Ibeam = 1
        case wait = 2
        case crosshair = 3
        case waitArrow = 4
        case sizeNWSE = 5
        case sizeNESW = 6
        case sizeWE = 7
        case sizeNS = 8
        case sizeAll = 9
        case no = 10
        case hand = 11
    }

    public static var cursor: SDLCursor {
        get {
            return SDLCursor(from: SDL_GetCursor(), owned: false)
        } set (value) {
            SDL_SetCursor(value.pointer)
        }
    }

    public static var `default`: SDLCursor {
        return SDLCursor(from: SDL_GetDefaultCursor(), owned: false)
    }

    public static var visble: Bool {
        get {
            return SDL_CursorVisible()
        } set (value) {
            if value {
                SDL_ShowCursor()
            } else {
                SDL_HideCursor()
            }
        }
    }

    internal let pointer: OpaquePointer
    private let owned: Bool

    internal init(from val: OpaquePointer, owned: Bool) {
        self.pointer = val
        self.owned = owned
    }

    public init(bitmap: [UInt8], mask: [UInt8], width: Int32, height: Int32, offsetX: Int32, offsetY: Int32) throws {
        var pointer: OpaquePointer!
        var owned: Bool = false
        try bitmap.withContiguousStorageIfAvailable {_bitmap in
            try mask.withContiguousStorageIfAvailable {_mask in
                if let ptr = SDL_CreateCursor(_bitmap.baseAddress, _mask.baseAddress, width, height, offsetX, offsetY) {
                    pointer = ptr
                    owned = true
                } else {
                    throw SDLError()
                }
            }
        }
        self.pointer = pointer
        self.owned = owned
    }

    public init(using surface: SDLSurface, offsetX: Int32, offsetY: Int32) throws {
        if let ptr = SDL_CreateColorCursor(surface.surf, offsetX, offsetY) {
            pointer = ptr
            owned = true
        } else {
            throw SDLError()
        }
    }

    public init(systemCursor id: SystemCursor) throws {
        if let ptr = SDL_CreateSystemCursor(id.sdlValue) {
            pointer = ptr
            owned = true
        } else {
            throw SDLError()
        }
    }

    deinit {
        if owned {
            SDL_DestroyCursor(pointer)
        }
    }
}

/// Namespace for keyboard-related variables and functions
public enum SDLKeyboard {
    /// 
    /// Return whether a keyboard is currently connected.
    /// 
    /// \returns true if a keyboard is connected, false otherwise.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyboards
    /// 
    @MainActor
    public var hasKeyboard: Bool {
        return SDL_HasKeyboard()
    }

    /// 
    /// Get a list of currently connected keyboards.
    /// 
    /// Note that this will include any device or virtual driver that includes
    /// keyboard functionality, including some mice, KVM switches, motherboard
    /// power buttons, etc. You should wait for input from a device before you
    /// consider it actively in use.
    /// 
    /// \param count a pointer filled in with the number of keyboards returned, may
    ///              be NULL.
    /// \returns a 0 terminated array of keyboards instance IDs or NULL on failure;
    ///          call SDL_GetError() for more information. This should be freed
    ///          with SDL_free() when it is no longer needed.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyboardNameForID
    /// \sa SDL_HasKeyboard
    /// 
    @MainActor
    public var keyboards: [UInt32] {
        get throws {
            var count: Int32 = 0
            if let ptr = SDL_GetKeyboards(&count) {
                return [UInt32](unsafeUninitializedCapacity: Int(count)) {_buffer, _count in
                    _buffer.baseAddress!.initialize(from: ptr, count: Int(count))
                    _count = Int(count)
                    SDL_free(ptr)
                }
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Get the name of a keyboard.
    /// 
    /// This function returns "" if the keyboard doesn't have a name.
    /// 
    /// \param instance_id the keyboard instance ID.
    /// \returns the name of the selected keyboard or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyboards
    /// 
    @MainActor
    public func name(for id: UInt32) throws -> String {
        if let ptr = SDL_GetKeyboardNameForID(id) {
            return String(cString: ptr)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Get a snapshot of the current state of the keyboard.
    /// 
    /// This function gives you the current state after all events have been
    /// processed, so if a key or button has been pressed and released before you
    /// process events, then the pressed state will never show up in the
    /// SDL_GetKeyboardState() calls.
    /// 
    /// Note: This function doesn't take into account whether shift has been
    /// pressed or not.
    /// 
    /// \returns a set of pressed keys.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_PumpEvents
    /// \sa SDL_ResetKeyboard
    /// 
    public var state: Set<SDLScancode> {
        var numkeys: Int32 = 0
        let ptr = SDL_GetKeyboardState(&numkeys)!
        let buf = UnsafeBufferPointer<Bool>(start: ptr, count: Int(numkeys))
        var retval = Set<SDLScancode>()
        for (i, v) in buf.enumerated() {
            if v {
                retval.insert(SDLScancode(rawValue: UInt32(i))!)
            }
        }
        return retval
    }

    /// 
    /// Clear the state of the keyboard.
    /// 
    /// This function will generate key up events for all pressed keys.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyboardState
    /// 
    @MainActor
    public func reset() {
        SDL_ResetKeyboard()
    }

    /// 
    /// Get the current key modifier state for the keyboard.
    /// 
    /// \returns an OR'd combination of the modifier keys for the keyboard. See
    ///          SDL_Keymod for details.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyboardState
    /// \sa SDL_SetModState
    /// 
    public var modState: SDLKeyModifiers {
        get {
            return SDLKeyModifiers(rawValue: SDL_GetModState())
        } set (value) {
            SDL_SetModState(value.rawValue)
        }
    }

    // 
    // Check whether the platform has screen keyboard support.
    // 
    // \returns true if the platform has some screen keyboard support or false if
    //          not.
    // 
    // \since This function is available since SDL 3.2.0.
    // 
    // \sa SDL_StartTextInput
    // \sa SDL_ScreenKeyboardShown
    // 
    @MainActor
    public var hasScreenKeyboardSupport: Bool {
        return SDL_HasScreenKeyboardSupport()
    }
}
