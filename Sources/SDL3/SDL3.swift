import SDL3_Native

public struct SDLError: Error {
    public let message: String
    internal init(message msg: String) {
        message = msg
    }
    internal init() {
        self.init(message: String(cString: SDL_GetError()!))
    }
}

internal func nullCheck(_ val: OpaquePointer!) -> OpaquePointer? {
    if val == OpaquePointer(bitPattern: 0) {return nil}
    return val
}

internal func nullCheck<T>(_ val: UnsafePointer<T>!) -> UnsafePointer<T>? {
    if val == UnsafePointer<T>(bitPattern: 0) {return nil}
    return val
}

internal func nullCheck<T>(_ val: UnsafeMutablePointer<T>!) -> UnsafeMutablePointer<T>? {
    if val == UnsafeMutablePointer<T>(bitPattern: 0) {return nil}
    return val
}

internal func nullCheck(_ val: UnsafeRawPointer!) -> UnsafeRawPointer? {
    if val == UnsafeRawPointer(bitPattern: 0) {return nil}
    return val
}

internal func nullCheck(_ val: UnsafeMutableRawPointer!) -> UnsafeMutableRawPointer? {
    if val == UnsafeMutableRawPointer(bitPattern: 0) {return nil}
    return val
}

internal struct SendableUnsafePointer<T>: @unchecked Sendable {
    public let pointer: UnsafePointer<T>
    public var pointee: T {
        return pointer.pointee
    }
}

internal struct SendableUnsafeMutablePointer<T>: @unchecked Sendable {
    public let pointer: UnsafeMutablePointer<T>
    public var pointee: T {
        return pointer.pointee
    }
}

internal struct SendableMutableRawPointer: @unchecked Sendable {
    public let pointer: UnsafeMutableRawPointer
}

public struct SendableMutableRawBufferPointer: @unchecked Sendable {
    public let pointer: UnsafeMutableRawBufferPointer
}

internal struct SendablePointer: @unchecked Sendable {
    public let pointer: OpaquePointer
}

internal extension UnsafePointer {
    func qpointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
        guard let offset = MemoryLayout<Pointee>.offset(of: property) else { return nil }
        return (UnsafeRawPointer(self) + offset).assumingMemoryBound(to: Property.self)
    }

    var sendable: SendableUnsafePointer<Pointee> {
        return SendableUnsafePointer(pointer: self)
    }
}

internal extension UnsafeMutablePointer {
    func qpointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafeMutablePointer<Property>? {
        guard let offset = MemoryLayout<Pointee>.offset(of: property) else { return nil }
        return (UnsafeMutableRawPointer(self) + offset).assumingMemoryBound(to: Property.self)
    }

    var sendable: SendableUnsafeMutablePointer<Pointee> {
        return SendableUnsafeMutablePointer(pointer: self)
    }
}

internal extension UnsafeMutableRawPointer {
    var sendable: SendableMutableRawPointer {
        return SendableMutableRawPointer(pointer: self)
    }
}

internal extension UnsafeMutableRawBufferPointer {
    var sendable: SendableMutableRawBufferPointer {
        return SendableMutableRawBufferPointer(pointer: self)
    }
}

internal extension OpaquePointer {
    var sendable: SendablePointer {
        return SendablePointer(pointer: self)
    }
}

@attached(extension, names: named(sdl), named(sdlValue))
internal macro EnumWrapper(_ type: Any) = #externalMacro(module: "SDL3Macros", type: "EnumWrapper")

public struct SDLInitFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue val: UInt32) {rawValue = val}
    public static let audio = SDLInitFlags(rawValue: SDL_INIT_AUDIO)
    public static let video = SDLInitFlags(rawValue: SDL_INIT_VIDEO)
    public static let joystick = SDLInitFlags(rawValue: SDL_INIT_JOYSTICK)
    public static let haptic = SDLInitFlags(rawValue: SDL_INIT_HAPTIC)
    public static let gamepad = SDLInitFlags(rawValue: SDL_INIT_GAMEPAD)
    public static let events = SDLInitFlags(rawValue: SDL_INIT_EVENTS)
    public static let sensor = SDLInitFlags(rawValue: SDL_INIT_SENSOR)
    public static let camera = SDLInitFlags(rawValue: SDL_INIT_CAMERA)
    public static let everything = SDLInitFlags([.audio, .video, .joystick, .haptic, .gamepad, .events, .sensor, .camera])
}

public func SDLInit(for flags: SDLInitFlags = .everything) throws {
    if !SDL_Init(flags.rawValue) {
        throw SDLError()
    }
}

public var SDLWasInit: SDLInitFlags {
    return SDLInitFlags(rawValue: SDL_WasInit(0))
}

public func SDLQuit() {
    SDL_Quit()
}
