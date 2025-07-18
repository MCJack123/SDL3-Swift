import SDL3_Native

/// 
/// The structure used to identify an SDL cursor.
/// 
/// This is opaque data.
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
public class SDLCursor {
    /// 
    /// Cursor types for SDL_CreateSystemCursor().
    /// 
    /// \since This enum is available since SDL 3.2.0.
    /// 
    @EnumWrapper(SDL_SystemCursor.self)
    public enum SystemCursor: UInt32 {
        /// Default cursor. Usually an arrow.
        case `default`
        /// Text selection. Usually an I-beam.
        case text
        /// Wait. Usually an hourglass or watch or spinning ball.
        case wait
        /// Crosshair.
        case crosshair
        /// Program is busy but still interactive. Usually it's WAIT with an arrow.
        case progress
        /// Double arrow pointing northwest and southeast.
        case resizeNWSE
        /// Double arrow pointing northeast and southwest.
        case resizeNESW
        /// Double arrow pointing west and east.
        case resizeWE
        /// Double arrow pointing north and south.
        case resizeNS
        /// Four pointed arrow pointing north, south, east, and west.
        case move
        /// Not permitted. Usually a slashed circle or crossbones.
        case notAllowed
        /// Pointer that indicates a link. Usually a pointing hand.
        case pointer
        /// Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE.
        case resizeNW
        /// Window resize top. May be NS_RESIZE.
        case resizeN
        /// Window resize top-right. May be NESW_RESIZE.
        case resizeNE
        /// Window resize right. May be EW_RESIZE.
        case resizeE
        /// Window resize bottom-right. May be NWSE_RESIZE.
        case resizeSE
        /// Window resize bottom. May be NS_RESIZE.
        case resizeS
        /// Window resize bottom-left. May be NESW_RESIZE.
        case resizeSW
        /// Window resize left. May be EW_RESIZE.
        case resizeW
    }

    /// 
    /// Get the active cursor.
    /// 
    /// This function returns a pointer to the current cursor which is owned by the
    /// library. It is not necessary to free the cursor with SDL_DestroyCursor().
    /// 
    /// \returns the active cursor or NULL if there is no mouse.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_SetCursor
    /// 
    @MainActor
    public static var current: SDLCursor? {
        if let ptr = SDL_GetCursor() {
            return SDLCursor(from: ptr, owned: false)
        } else {
            return nil
        }
    }

    /// 
    /// Set the active cursor.
    /// 
    /// This function sets the currently active cursor to the specified one. If the
    /// cursor is currently visible, the change will be immediately represented on
    /// the display. SDL_SetCursor(NULL) can be used to force cursor redraw, if
    /// this is desired for any reason.
    /// 
    /// \param cursor a cursor to make active.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetCursor
    /// 
    @MainActor
    public static func set(cursor value: SDLCursor) throws {
        if !SDL_SetCursor(value.pointer) {
            throw SDLError()
        }
    }

    /// 
    /// Get the default cursor.
    /// 
    /// You do not have to call SDL_DestroyCursor() on the return value, but it is
    /// safe to do so.
    /// 
    /// \returns the default cursor on success or NULL on failuree; call
    ///          SDL_GetError() for more information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    @MainActor
    public static var `default`: SDLCursor {
        get throws {
            if let ptr = SDL_GetDefaultCursor() {
                return SDLCursor(from: ptr, owned: false)
            } else {
                throw SDLError()
            }
        }
    }

    /// 
    /// Return whether the cursor is currently being shown.
    /// 
    /// \returns `true` if the cursor is being shown, or `false` if the cursor is
    ///          hidden.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_HideCursor
    /// \sa SDL_ShowCursor
    /// 
    @MainActor
    public static var visble: Bool {
        get {
            return SDL_CursorVisible()
        } set (value) {
            
        }
    }

    /// 
    /// Show or hide the cursor.
    /// 
    /// \param visible whether the cursor should be visible.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CursorVisible
    /// \sa SDL_HideCursor
    /// 
    @MainActor
    public static func set(visible value: Bool) throws {
        if value {
            if !SDL_ShowCursor() {
                throw SDLError()
            }
        } else {
            if !SDL_HideCursor() {
                throw SDLError()
            }
        }
    }

    internal let pointer: OpaquePointer
    private let owned: Bool

    internal init(from val: OpaquePointer, owned: Bool) {
        self.pointer = val
        self.owned = owned
    }

    /// 
    /// Create a cursor using the specified bitmap data and mask (in MSB format).
    /// 
    /// `mask` has to be in MSB (Most Significant Bit) format.
    /// 
    /// The cursor width (`w`) must be a multiple of 8 bits.
    /// 
    /// The cursor is created in black and white according to the following:
    /// 
    /// - data=0, mask=1: white
    /// - data=1, mask=1: black
    /// - data=0, mask=0: transparent
    /// - data=1, mask=0: inverted color if possible, black if not.
    /// 
    /// Cursors created with this function must be freed with SDL_DestroyCursor().
    /// 
    /// If you want to have a color cursor, or create your cursor from an
    /// SDL_Surface, you should use SDL_CreateColorCursor(). Alternately, you can
    /// hide the cursor and draw your own as part of your game's rendering, but it
    /// will be bound to the framerate.
    /// 
    /// Also, SDL_CreateSystemCursor() is available, which provides several
    /// readily-available system cursors to pick from.
    /// 
    /// \param data the color value for each pixel of the cursor.
    /// \param mask the mask value for each pixel of the cursor.
    /// \param w the width of the cursor.
    /// \param h the height of the cursor.
    /// \param offsetX the x-axis offset from the left of the cursor image to the
    ///              mouse x position, in the range of 0 to `w` - 1.
    /// \param offsetY the y-axis offset from the top of the cursor image to the
    ///              mouse y position, in the range of 0 to `h` - 1.
    /// \returns a new cursor with the specified parameters on success or NULL on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CreateColorCursor
    /// \sa SDL_CreateSystemCursor
    /// \sa SDL_DestroyCursor
    /// \sa SDL_SetCursor
    /// 
    @MainActor
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

    /// 
    /// Create a color cursor.
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
    /// \param surface an SDL_Surface structure representing the cursor image.
    /// \param hot_x the x position of the cursor hot spot.
    /// \param hot_y the y position of the cursor hot spot.
    /// \returns the new cursor on success or NULL on failure; call SDL_GetError()
    ///          for more information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CreateCursor
    /// \sa SDL_CreateSystemCursor
    /// \sa SDL_DestroyCursor
    /// \sa SDL_SetCursor
    /// 
    @MainActor
    public init(using surface: SDLSurface, offsetX: Int32, offsetY: Int32) throws {
        if let ptr = SDL_CreateColorCursor(surface.surf, offsetX, offsetY) {
            pointer = ptr
            owned = true
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Create a system cursor.
    /// 
    /// \param id an SDL_SystemCursor enum value.
    /// \returns a cursor on success or NULL on failure; call SDL_GetError() for
    ///          more information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_DestroyCursor
    /// 
    @MainActor
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

/// Namespace for mouse-related variables and functions
public enum SDLMouse {
    /// 
    /// Scroll direction types for the Scroll event
    /// 
    /// \since This enum is available since SDL 3.2.0.
    /// 
    @EnumWrapper(SDL_MouseWheelDirection.self)
    public enum WheelDirection: UInt32 {
        /// The scroll direction is normal
        case normal
        /// The scroll direction is flipped / natural
        case flipped
    }

    /// 
    /// A bitmask of pressed mouse buttons, as reported by SDL_GetMouseState, etc.
    /// 
    /// - Button 1: Left mouse button
    /// - Button 2: Middle mouse button
    /// - Button 3: Right mouse button
    /// - Button 4: Side mouse button 1
    /// - Button 5: Side mouse button 2
    /// 
    /// \since This datatype is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetMouseState
    /// \sa SDL_GetGlobalMouseState
    /// \sa SDL_GetRelativeMouseState
    /// 
    public struct ButtonFlags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue val: UInt32) {rawValue = val}
        public static let left = ButtonFlags(rawValue: 1)
        public static let middle = ButtonFlags(rawValue: 2)
        public static let right = ButtonFlags(rawValue: 4)
        public static let x1 = ButtonFlags(rawValue: 8)
        public static let x2 = ButtonFlags(rawValue: 16)
    }

    /// Structure holding mouse state.
    public struct State {
        public let x: Float
        public let y: Float
        public let flags: ButtonFlags
    }

    /// 
    /// Return whether a mouse is currently connected.
    /// 
    /// \returns true if a mouse is connected, false otherwise.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetMice
    /// 
    @MainActor
    public static var hasMouse: Bool {
        return SDL_HasMouse()
    }

    /// 
    /// Get a list of currently connected mice.
    /// 
    /// Note that this will include any device or virtual driver that includes
    /// mouse functionality, including some game controllers, KVM switches, etc.
    /// You should wait for input from a device before you consider it actively in
    /// use.
    /// 
    /// \returns an array of mouse instance IDs, or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetMouseNameForID
    /// \sa SDL_HasMouse
    /// 
    @MainActor
    public static var mice: [UInt32] {
        get throws {
            var count: Int32 = 0
            if let ptr = SDL_GetMice(&count) {
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
    /// Get the name of a mouse.
    /// 
    /// This function returns "" if the mouse doesn't have a name.
    /// 
    /// \param instance_id the mouse instance ID.
    /// \returns the name of the selected mouse, or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetMice
    /// 
    @MainActor
    public static func name(for id: UInt32) throws -> String {
        if let name = SDL_GetMouseNameForID(id) {
            return String(cString: name)
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Query SDL's cache for the synchronous mouse button state and the
    /// window-relative SDL-cursor position.
    /// 
    /// This function returns the cached synchronous state as SDL understands it
    /// from the last pump of the event queue.
    /// 
    /// To query the platform for immediate asynchronous state, use
    /// SDL_GetGlobalMouseState.
    /// 
    /// Passing non-NULL pointers to `x` or `y` will write the destination with
    /// respective x or y coordinates relative to the focused window.
    /// 
    /// In Relative Mode, the SDL-cursor's position usually contradicts the
    /// platform-cursor's position as manually calculated from
    /// SDL_GetGlobalMouseState() and SDL_GetWindowPosition.
    /// 
    /// \param x a pointer to receive the SDL-cursor's x-position from the focused
    ///          window's top left corner, can be NULL if unused.
    /// \param y a pointer to receive the SDL-cursor's y-position from the focused
    ///          window's top left corner, can be NULL if unused.
    /// \returns a 32-bit bitmask of the button state that can be bitwise-compared
    ///          against the SDL_BUTTON_MASK(X) macro.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetGlobalMouseState
    /// \sa SDL_GetRelativeMouseState
    /// 
    @MainActor
    public static var state: State {
        var x: Float = 0.0, y: Float = 0.0
        let flags = SDL_GetMouseState(&x, &y)
        return State(x: x, y: y, flags: ButtonFlags(rawValue: flags))
    }

    /// 
    /// Query the platform for the asynchronous mouse button state and the
    /// desktop-relative platform-cursor position.
    /// 
    /// This function immediately queries the platform for the most recent
    /// asynchronous state, more costly than retrieving SDL's cached state in
    /// SDL_GetMouseState().
    /// 
    /// Passing non-NULL pointers to `x` or `y` will write the destination with
    /// respective x or y coordinates relative to the desktop.
    /// 
    /// In Relative Mode, the platform-cursor's position usually contradicts the
    /// SDL-cursor's position as manually calculated from SDL_GetMouseState() and
    /// SDL_GetWindowPosition.
    /// 
    /// This function can be useful if you need to track the mouse outside of a
    /// specific window and SDL_CaptureMouse() doesn't fit your needs. For example,
    /// it could be useful if you need to track the mouse while dragging a window,
    /// where coordinates relative to a window might not be in sync at all times.
    /// 
    /// \param x a pointer to receive the platform-cursor's x-position from the
    ///          desktop's top left corner, can be NULL if unused.
    /// \param y a pointer to receive the platform-cursor's y-position from the
    ///          desktop's top left corner, can be NULL if unused.
    /// \returns a 32-bit bitmask of the button state that can be bitwise-compared
    ///          against the SDL_BUTTON_MASK(X) macro.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CaptureMouse
    /// \sa SDL_GetMouseState
    /// \sa SDL_GetGlobalMouseState
    /// 
    @MainActor
    public static var globalState: State {
        var x: Float = 0.0, y: Float = 0.0
        let flags = SDL_GetGlobalMouseState(&x, &y)
        return State(x: x, y: y, flags: ButtonFlags(rawValue: flags))
    }

    /// 
    /// Query SDL's cache for the synchronous mouse button state and accumulated
    /// mouse delta since last call.
    /// 
    /// This function returns the cached synchronous state as SDL understands it
    /// from the last pump of the event queue.
    /// 
    /// To query the platform for immediate asynchronous state, use
    /// SDL_GetGlobalMouseState.
    /// 
    /// Passing non-NULL pointers to `x` or `y` will write the destination with
    /// respective x or y deltas accumulated since the last call to this function
    /// (or since event initialization).
    /// 
    /// This function is useful for reducing overhead by processing relative mouse
    /// inputs in one go per-frame instead of individually per-event, at the
    /// expense of losing the order between events within the frame (e.g. quickly
    /// pressing and releasing a button within the same frame).
    /// 
    /// \param x a pointer to receive the x mouse delta accumulated since last
    ///          call, can be NULL if unused.
    /// \param y a pointer to receive the y mouse delta accumulated since last
    ///          call, can be NULL if unused.
    /// \returns a 32-bit bitmask of the button state that can be bitwise-compared
    ///          against the SDL_BUTTON_MASK(X) macro.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetMouseState
    /// \sa SDL_GetGlobalMouseState
    /// 
    @MainActor
    public static var relativeState: State {
        var x: Float = 0.0, y: Float = 0.0
        let flags = SDL_GetRelativeMouseState(&x, &y)
        return State(x: x, y: y, flags: ButtonFlags(rawValue: flags))
    }

    /// 
    /// Move the mouse to the given position in global screen space.
    /// 
    /// This function generates a mouse motion event.
    /// 
    /// A failure of this function usually means that it is unsupported by a
    /// platform.
    /// 
    /// Note that this function will appear to succeed, but not actually move the
    /// mouse when used over Microsoft Remote Desktop.
    /// 
    /// \param to the coordinates.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_WarpMouseInWindow
    /// 
    @MainActor
    public static func warpGlobal(to point: SDLFPoint) throws {
        if !SDL_WarpMouseGlobal(point.x, point.y) {
            throw SDLError()
        }
    }

    /// 
    /// Capture the mouse and to track input outside an SDL window.
    /// 
    /// Capturing enables your app to obtain mouse events globally, instead of just
    /// within your window. Not all video targets support this function. When
    /// capturing is enabled, the current window will get all mouse events, but
    /// unlike relative mode, no change is made to the cursor and it is not
    /// restrained to your window.
    /// 
    /// This function may also deny mouse input to other windows--both those in
    /// your application and others on the system--so you should use this function
    /// sparingly, and in small bursts. For example, you might want to track the
    /// mouse while the user is dragging something, until the user releases a mouse
    /// button. It is not recommended that you capture the mouse for long periods
    /// of time, such as the entire time your app is running. For that, you should
    /// probably use SDL_SetWindowRelativeMouseMode() or SDL_SetWindowMouseGrab(),
    /// depending on your goals.
    /// 
    /// While captured, mouse events still report coordinates relative to the
    /// current (foreground) window, but those coordinates may be outside the
    /// bounds of the window (including negative values). Capturing is only allowed
    /// for the foreground window. If the window loses focus while capturing, the
    /// capture will be disabled automatically.
    /// 
    /// While capturing is enabled, the current window will have the
    /// `SDL_WINDOW_MOUSE_CAPTURE` flag set.
    /// 
    /// Please note that SDL will attempt to "auto capture" the mouse while the
    /// user is pressing a button; this is to try and make mouse behavior more
    /// consistent between platforms, and deal with the common case of a user
    /// dragging the mouse outside of the window. This means that if you are
    /// calling SDL_CaptureMouse() only to deal with this situation, you do not
    /// have to (although it is safe to do so). If this causes problems for your
    /// app, you can disable auto capture by setting the
    /// `SDL_HINT_MOUSE_AUTO_CAPTURE` hint to zero.
    /// 
    /// \param enabled true to enable capturing, false to disable.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety This function should only be called on the main thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetGlobalMouseState
    /// 
    @MainActor
    public static func capture(_ enabled: Bool) throws {
        if !SDL_CaptureMouse(enabled) {
            throw SDLError()
        }
    }
}
