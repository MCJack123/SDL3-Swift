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
        if let ptr = SDL_CreateSystemCursor(SDL_SystemCursor(rawValue: id.rawValue)) {
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

public func SDLGetMouseState() -> (SDLMouseButtons, SDLFPoint) {
    var mask: UInt32!
    let pos = twoPointers {_x, _y in
        mask = SDL_GetMouseState(_x, _y)
    }
    return (SDLMouseButtons(rawValue: mask), SDLFPoint(x: pos.0, y: pos.1))
}

public func SDLGetGlobalMouseState() -> (SDLMouseButtons, SDLFPoint) {
    var mask: UInt32!
    let pos = twoPointers {_x, _y in
        mask = SDL_GetGlobalMouseState(_x, _y)
    }
    return (SDLMouseButtons(rawValue: mask), SDLFPoint(x: pos.0, y: pos.1))
}

public func SDLGetRelativeMouseState() -> (SDLMouseButtons, SDLFPoint) {
    var mask: UInt32!
    let pos = twoPointers {_x, _y in
        mask = SDL_GetRelativeMouseState(_x, _y)
    }
    return (SDLMouseButtons(rawValue: mask), SDLFPoint(x: pos.0, y: pos.1))
}

public func SDLWarpMouse(to point: SDLFPoint) {
    SDL_WarpMouseGlobal(point.x, point.y)
}

public var SDLRelativeMouseMode: Bool {
    get {
        return SDL_GetRelativeMouseMode()
    } set (value) {
        SDL_SetRelativeMouseMode(value ? SDL_bool(SDL_TRUE) : SDL_bool(SDL_FALSE))
    }
}

/// Get a snapshot of the current state of the keyboard.
///
/// This variable gives you the current state after all events have been
/// processed, so if a key or button has been pressed and released before you
/// process events, then the pressed state will never show up in the
/// SDLKeyboardState calls.
///
/// Note: This variable doesn't take into account whether shift has been
/// pressed or not.
public var SDLKeyboardState: [SDLScancode: Bool] {
    var res = [SDLScancode: Bool]()
    var ptr: UnsafePointer<UInt8>!
    let size = pointer {_size in
        ptr = SDL_GetKeyboardState(_size)
    }
    for i in 0..<Int(size) {
        if let code = SDLScancode(rawValue: UInt32(i)) {
            res[code] = ptr[i] != 0
        }
    }
    return res
}

/// Clear the state of the keyboard
///
/// This function will generate key up events for all pressed keys.
public func SDLResetKeyboard() {
    SDL_ResetKeyboard()
}

public var SDLKeyboardModifiers: SDLKeyModifiers {
    get {
        return SDLKeyModifiers(rawValue: UInt16(SDL_GetModState().rawValue))
    } set (value) {
        SDL_SetModState(SDL_Keymod(rawValue: UInt32(value.rawValue)))
    }
}

public func SDLStartTextInput() {
    SDL_StartTextInput()
}

public func SDLStopTextInput() {
    SDL_StopTextInput()
}

public var SDLTextInputActive: Bool {
    return SDL_TextInputActive()
}

public func SDLClearComposition() {
    SDL_ClearComposition()
}

public var SDLTextInputShown: Bool {
    return SDL_TextInputShown()
}

public func SDLSetTextInput(rect: SDLRect) throws {
    let ptr = rect.sdlRect
    let ok = withUnsafePointer(to: ptr) {_ptr in
        SDL_SetTextInputRect(_ptr) == 0
    }
    if !ok {
        throw SDLError()
    }
}

public var SDLHasScreenKeyboardSupport: Bool {
    return SDL_HasScreenKeyboardSupport()
}
