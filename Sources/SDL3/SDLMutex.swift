import SDL3_Native

/// 
/// A means to serialize access to a resource between threads.
/// 
/// Mutexes (short for "mutual exclusion") are a synchronization primitive that
/// allows exactly one thread to proceed at a time.
/// 
/// Wikipedia has a thorough explanation of the concept:
/// 
/// https://en.wikipedia.org/wiki/Mutex
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
public class SDLMutex {
    private let mutex = SDL_CreateMutex()
    deinit {SDL_DestroyMutex(mutex)}
    /// 
    /// Lock the mutex.
    /// 
    /// This will block until the mutex is available, which is to say it is in the
    /// unlocked state and the OS has chosen the caller as the next thread to lock
    /// it. Of all threads waiting to lock the mutex, only one may do so at a time.
    /// 
    /// It is legal for the owning thread to lock an already-locked mutex. It must
    /// unlock it the same number of times before it is actually made available for
    /// other threads in the system (this is known as a "recursive mutex").
    /// 
    /// This function does not fail; if mutex is NULL, it will return immediately
    /// having locked nothing. If the mutex is valid, this function will always
    /// block until it can lock the mutex, and return with it locked.
    /// 
    /// \param body the function to call while locked.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_TryLockMutex
    /// \sa SDL_UnlockMutex
    /// 
    public func lock<R>(_ body: () throws -> R) rethrows -> R {
        SDL_LockMutex(mutex)
        defer {SDL_UnlockMutex(mutex)}
        return try body()
    }
}
