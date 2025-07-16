import SDL3_Native
import SDL3Macros

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

internal extension UnsafePointer {
    func qpointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
        guard let offset = MemoryLayout<Pointee>.offset(of: property) else { return nil }
        return (UnsafeRawPointer(self) + offset).assumingMemoryBound(to: Property.self)
    }
}

internal extension UnsafeMutablePointer {
    func qpointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafeMutablePointer<Property>? {
        guard let offset = MemoryLayout<Pointee>.offset(of: property) else { return nil }
        return (UnsafeMutableRawPointer(self) + offset).assumingMemoryBound(to: Property.self)
    }
}

@attached(extension, names: named(sdl), named(sdlValue))
internal macro EnumWrapper(_ type: Any) = #externalMacro(module: "SDL3Macros", type: "EnumWrapper")

public struct SDLInitFlags: OptionSet {
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
