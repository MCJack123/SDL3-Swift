import SDL3_Native

internal extension Bool {
    init(_ sdlBool: SDL_bool) {
        self = sdlBool == SDL_TRUE
    }
}

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

internal func pointer<T: Numeric>(_ body: (UnsafeMutablePointer<T>) throws -> ()) rethrows -> T {
    var a: T = 0
    try withUnsafeMutablePointer(to: &a) {_a in
        try body(_a)
    }
    return a
}

internal func twoPointers<T: Numeric>(_ body: (UnsafeMutablePointer<T>, UnsafeMutablePointer<T>) throws -> ()) rethrows -> (T, T) {
    var a: T = 0
    var b: T = 0
    try withUnsafeMutablePointer(to: &a) {_a in
        try withUnsafeMutablePointer(to: &b) {_b in
            try body(_a, _b)
        }
    }
    return (a, b)
}

internal func threePointers<T: Numeric>(_ body: (UnsafeMutablePointer<T>, UnsafeMutablePointer<T>, UnsafeMutablePointer<T>) throws -> ()) rethrows -> (T, T, T) {
    var a: T = 0
    var b: T = 0
    var c: T = 0
    try withUnsafeMutablePointer(to: &a) {_a in
        try withUnsafeMutablePointer(to: &b) {_b in
            try withUnsafeMutablePointer(to: &c) {_c in
                try body(_a, _b, _c)
            }
        }
    }
    return (a, b, c)
}

internal func fourPointers<T: Numeric>(_ body: (UnsafeMutablePointer<T>, UnsafeMutablePointer<T>, UnsafeMutablePointer<T>, UnsafeMutablePointer<T>) throws -> ()) rethrows -> (T, T, T, T) {
    var a: T = 0
    var b: T = 0
    var c: T = 0
    var d: T = 0
    try withUnsafeMutablePointer(to: &a) {_a in
        try withUnsafeMutablePointer(to: &b) {_b in
            try withUnsafeMutablePointer(to: &c) {_c in
                try withUnsafeMutablePointer(to: &d) {_d in
                    try body(_a, _b, _c, _d)
                }
            }
        }
    }
    return (a, b, c, d)
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

public struct SDLInitFlags: OptionSet {
    public let rawValue: UInt32
    public init(rawValue val: UInt32) {rawValue = val}
    public static let timer = SDLInitFlags(rawValue: 0x00000001)
    public static let audio = SDLInitFlags(rawValue: 0x00000010)
    public static let video = SDLInitFlags(rawValue: 0x00000020)
    public static let joystick = SDLInitFlags(rawValue: 0x00000200)
    public static let haptic = SDLInitFlags(rawValue: 0x00001000)
    public static let gamepad = SDLInitFlags(rawValue: 0x00002000)
    public static let events = SDLInitFlags(rawValue: 0x00004000)
    public static let sensor = SDLInitFlags(rawValue: 0x00008000)
    public static let everything = SDLInitFlags([.timer, .audio, .video, .joystick, .haptic, .gamepad, .events, .sensor])
}

public func SDLInit(for flags: SDLInitFlags = .everything) throws {
    if SDL_Init(flags.rawValue) != 0 {
        throw SDLError()
    }
}

public var SDLWasInit: SDLInitFlags {
    return SDLInitFlags(rawValue: SDL_WasInit(0))
}

public func SDLQuit() {
    SDL_Quit()
}
