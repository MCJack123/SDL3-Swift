import SDL3_Native

public class SDLSharedLibrary {
    private let pointer: OpaquePointer
    public init(from path: String) throws {
        if let ptr = SDL_LoadObject(path) {
            pointer = ptr
        } else {
            throw SDLError()
        }
    }
    deinit {
        SDL_UnloadObject(pointer)
    }
    public func function<T>(named name: String, type: T.Type) throws -> T {
        if let fn = SDL_LoadFunction(pointer, name) {
            return unsafeBitCast(fn, to: T.self)
        } else {
            throw SDLError()
        }
    }
}