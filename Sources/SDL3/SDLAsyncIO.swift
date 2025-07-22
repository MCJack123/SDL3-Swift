import SDL3_Native

/// 
/// The asynchronous I/O operation structure.
/// 
/// This operates as an opaque handle. One can then request read or write
/// operations on it.
/// 
/// \since This struct is available since SDL 3.2.0.
/// 
/// \sa SDL_AsyncIOFromFile
/// 
public class SDLAsyncIO {
    /// 
    /// Possible outcomes of an asynchronous I/O task.
    /// 
    /// \since This enum is available since SDL 3.2.0.
    /// 
    public enum Result: Sendable {
        /// request was completed without error
        case complete
        /// request failed for some reason; check SDL_GetError()!
        case failure(error: SDLError)
        /// request was canceled before completing.
        case canceled
    }

    /// 
    /// Information about a completed asynchronous I/O request.
    /// 
    /// \since This struct is available since SDL 3.2.0.
    /// 
    fileprivate actor Outcome: Sendable {
        public let result: Result
        nonisolated(unsafe) public let buffer: UnsafeMutableRawBufferPointer?
        public let requested: UInt64
        public init(result: Result, buffer: UnsafeMutableRawBufferPointer?, requested: UInt64) {
            self.result = result
            self.buffer = buffer
            self.requested = requested
        }
        deinit {
            if let buffer = buffer {
                SDL_free(buffer.baseAddress)
            }
        }
        public var count: Int {
            if let buffer = buffer {
                return buffer.count
            } else {
                return 0
            }
        }
        public var array: [UInt8]? {
            if let buffer = buffer {
                return [UInt8](unsafeUninitializedCapacity: Int(buffer.count)) { _buffer, _count in
                    _ = _buffer.initialize(from: buffer.assumingMemoryBound(to: UInt8.self))
                    _count = Int(buffer.count)
                }
            } else {
                return nil
            }
        }
    }

    /// Open flags for use with file-related functions.
    public enum OpenFlags: String {
        case read = "r"
        case write = "w"
        case readWrite = "r+"
        case createReadWrite = "w+"
    }

    /// 
    /// A queue of completed asynchronous I/O tasks.
    /// 
    /// When starting an asynchronous operation, you specify a queue for the new
    /// task. A queue can be asked later if any tasks in it have completed,
    /// allowing an app to manage multiple pending tasks in one place, in whatever
    /// order they complete.
    /// 
    /// \since This struct is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CreateAsyncIOQueue
    /// \sa SDL_ReadAsyncIO
    /// \sa SDL_WriteAsyncIO
    /// \sa SDL_GetAsyncIOResult
    /// \sa SDL_WaitAsyncIOResult
    ///
    public actor Queue {
        fileprivate class Continuation {
            public let value: CheckedContinuation<Outcome, Never>
            public init(from continuation: CheckedContinuation<Outcome, Never>) {
                value = continuation
            }
        }

        fileprivate let pointer: SendablePointer
        private var waitTask: Task<(), Never>!
        private var running: Bool = true

        /// 
        /// Create a task queue for tracking multiple I/O operations.
        /// 
        /// Async I/O operations are assigned to a queue when started. The queue can be
        /// checked for completed tasks thereafter.
        /// 
        /// \returns a new task queue object or NULL if there was an error; call
        ///          SDL_GetError() for more information.
        /// 
        /// \threadsafety It is safe to call this function from any thread.
        /// 
        /// \since This function is available since SDL 3.2.0.
        /// 
        /// \sa SDL_DestroyAsyncIOQueue
        /// \sa SDL_GetAsyncIOResult
        /// \sa SDL_WaitAsyncIOResult
        /// 
        init() async throws {
            if let pointer = SDL_CreateAsyncIOQueue() {
                self.pointer = pointer.sendable
            } else {
                throw SDLError()
            }
            let task = Task.detached(priority: .background) {
                await self.run()
            }
            self.setTask(task)
        }

        // TODO: is there a retain cycle in the task? FIX THAT
        
        deinit {
            running = false
            SDL_SignalAsyncIOQueue(pointer.pointer)
            waitTask.cancel()
        }

        private func setTask(_ task: Task<(), Never>) {
            waitTask = task
        }

        private func run() async {
            while running {
                var outcome = SDL_AsyncIOOutcome()
                if SDL_WaitAsyncIOResult(self.pointer.pointer, &outcome, -1) {
                    let continuation = Unmanaged<Continuation>.fromOpaque(outcome.userdata).takeRetainedValue()
                    let result: Result
                    switch outcome.result {
                        case SDL_ASYNCIO_COMPLETE: result = .complete
                        case SDL_ASYNCIO_FAILURE: result = .failure(error: SDLError())
                        case SDL_ASYNCIO_CANCELED: result = .canceled
                        default: result = .failure(error: SDLError(message: "Unknown error"))
                    }
                    if let ptr = outcome.buffer {
                        // waaaaaaaa this is horrible
                        nonisolated(unsafe) let buffer = UnsafeMutableRawBufferPointer?(UnsafeMutableRawBufferPointer(start: ptr, count: Int(outcome.bytes_transferred)))
                        continuation.value.resume(returning: Outcome(result: result, buffer: buffer, requested: outcome.bytes_requested))
                    } else {
                        continuation.value.resume(returning: Outcome(result: result, buffer: nil, requested: outcome.bytes_requested))
                    }
                    break
                }
            }
            SDL_DestroyAsyncIOQueue(pointer.pointer)
        }

        /// 
        /// Load all the data from a file path, asynchronously.
        /// 
        /// This function returns as quickly as possible; it does not wait for the read
        /// to complete. On a successful return, this work will continue in the
        /// background. If the work begins, even failure is asynchronous: a failing
        /// return value from this function only means the work couldn't start at all.
        /// 
        /// The data is allocated with a zero byte at the end (null terminated) for
        /// convenience. This extra byte is not included in SDL_AsyncIOOutcome's
        /// bytes_transferred value.
        /// 
        /// This function will allocate the buffer to contain the file. It must be
        /// deallocated by calling SDL_free() on SDL_AsyncIOOutcome's buffer field
        /// after completion.
        /// 
        /// An SDL_AsyncIOQueue must be specified. The newly-created task will be added
        /// to it when it completes its work.
        /// 
        /// \param file the path to read all available data from.
        /// \returns true on success or false on failure; call SDL_GetError() for more
        ///          information.
        /// 
        /// \since This function is available since SDL 3.2.0.
        /// 
        /// \sa SDL_LoadFile_IO
        /// 
        public func load(file: String) async throws -> [UInt8] {
            let outcome = await withCheckedContinuation { continuation in
                let wrapper = Continuation(from: continuation)
                if !SDL_LoadFileAsync(file, pointer.pointer, Unmanaged<Continuation>.passRetained(wrapper).toOpaque()) {
                    continuation.resume(returning: Outcome(result: .failure(error: SDLError()), buffer: nil, requested: 0))
                }
            }
            switch outcome.result {
                case .complete: return await outcome.array!
                case .failure(let error): throw error
                case .canceled: throw SDLError(message: "Operation canceled")
            }
        }
    }

    private var pointer: SendablePointer?

    /// 
    /// Use this function to create a new SDL_AsyncIO object for reading from
    /// and/or writing to a named file.
    /// 
    /// The `mode` string understands the following values:
    /// 
    /// - "r": Open a file for reading only. It must exist.
    /// - "w": Open a file for writing only. It will create missing files or
    ///   truncate existing ones.
    /// - "r+": Open a file for update both reading and writing. The file must
    ///   exist.
    /// - "w+": Create an empty file for both reading and writing. If a file with
    ///   the same name already exists its content is erased and the file is
    ///   treated as a new empty file.
    /// 
    /// There is no "b" mode, as there is only "binary" style I/O, and no "a" mode
    /// for appending, since you specify the position when starting a task.
    /// 
    /// This function supports Unicode filenames, but they must be encoded in UTF-8
    /// format, regardless of the underlying operating system.
    /// 
    /// This call is _not_ asynchronous; it will open the file before returning,
    /// under the assumption that doing so is generally a fast operation. Future
    /// reads and writes to the opened file will be async, however.
    /// 
    /// \param file a UTF-8 string representing the filename to open.
    /// \param mode an ASCII string representing the mode to be used for opening
    ///             the file.
    /// \returns a pointer to the SDL_AsyncIO structure that is created or NULL on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_CloseAsyncIO
    /// \sa SDL_ReadAsyncIO
    /// \sa SDL_WriteAsyncIO
    /// 
    public init(from file: String, with mode: OpenFlags) throws {
        if let ptr = SDL_AsyncIOFromFile(file, mode.rawValue) {
            pointer = ptr.sendable
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to get the size of the data stream in an SDL_AsyncIO.
    /// 
    /// This call is _not_ asynchronous; it assumes that obtaining this info is a
    /// non-blocking operation in most reasonable cases.
    /// 
    /// \returns the size of the data stream in the SDL_IOStream on success or a
    ///          negative error code on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    public var size: Int64 {
        get throws {
            if let pointer = pointer {
                let size = SDL_GetAsyncIOSize(pointer.pointer)
                if size < 0 {
                    throw SDLError()
                }
                return size
            } else {
                throw SDLError(message: "File is already closed")
            }
        }
    }

    /// 
    /// Start an async read.
    /// 
    /// This function reads up to `size` bytes from `offset` position in the data
    /// source to the area pointed at by `ptr`. This function may read less bytes
    /// than requested.
    /// 
    /// This function returns as quickly as possible; it does not wait for the read
    /// to complete. On a successful return, this work will continue in the
    /// background. If the work begins, even failure is asynchronous: a failing
    /// return value from this function only means the work couldn't start at all.
    /// 
    /// `ptr` must remain available until the work is done, and may be accessed by
    /// the system at any time until then. Do not allocate it on the stack, as this
    /// might take longer than the life of the calling function to complete!
    /// 
    /// An SDL_AsyncIOQueue must be specified. The newly-created task will be added
    /// to it when it completes its work.
    /// 
    /// \param count the number of bytes to read from the data source.
    /// \param from the position to start reading in the data source.
    /// \param on a queue to add the new SDL_AsyncIO to.
    /// \returns the bytes read from the source
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_WriteAsyncIO
    /// \sa SDL_CreateAsyncIOQueue
    /// 
    public func read(count: Int, from offset: UInt64, on queue: Queue) async throws -> [UInt8] {
        if let pointer = pointer {
            guard let buffer = SDL_malloc(count) else {
                throw SDLError()
            }
            let outcome = await withCheckedContinuation { continuation in
                let wrapper = Queue.Continuation(from: continuation)
                if !SDL_ReadAsyncIO(pointer.pointer, buffer, UInt64(offset), UInt64(count), queue.pointer.pointer, Unmanaged<Queue.Continuation>.passRetained(wrapper).toOpaque()) {
                    continuation.resume(returning: Outcome(result: .failure(error: SDLError()), buffer: nil, requested: 0))
                }
            }
            switch outcome.result {
                case .complete: return await outcome.array!
                case .failure(let error): throw error
                case .canceled: throw SDLError(message: "Operation canceled")
            }
        } else {
            throw SDLError(message: "File is already closed")
        }
    }

    /// 
    /// Start an async write.
    /// 
    /// This function writes `size` bytes from `offset` position in the data source
    /// to the area pointed at by `ptr`.
    /// 
    /// This function returns as quickly as possible; it does not wait for the
    /// write to complete. On a successful return, this work will continue in the
    /// background. If the work begins, even failure is asynchronous: a failing
    /// return value from this function only means the work couldn't start at all.
    /// 
    /// `ptr` must remain available until the work is done, and may be accessed by
    /// the system at any time until then. Do not allocate it on the stack, as this
    /// might take longer than the life of the calling function to complete!
    /// 
    /// An SDL_AsyncIOQueue must be specified. The newly-created task will be added
    /// to it when it completes its work.
    /// 
    /// \param from a pointer to a buffer to write data from.
    /// \param to the position to start writing to the data source.
    /// \param on a queue to add the new SDL_AsyncIO to.
    /// \returns the number of bytes written
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety It is safe to call this function from any thread.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_ReadAsyncIO
    /// \sa SDL_CreateAsyncIOQueue
    /// 
    public func write(from bytes: [UInt8], to offset: UInt64, on queue: Queue) async throws -> Int {
        if let pointer = pointer {
            guard let buffer = SDL_malloc(bytes.count) else {
                throw SDLError()
            }
            bytes.withContiguousStorageIfAvailable { _bytes in
                buffer.copyMemory(from: _bytes.baseAddress!, byteCount: _bytes.count)
            }!
            let outcome = await withCheckedContinuation { continuation in
                let wrapper = Queue.Continuation(from: continuation)
                if !SDL_WriteAsyncIO(pointer.pointer, buffer, UInt64(offset), UInt64(bytes.count), queue.pointer.pointer, Unmanaged<Queue.Continuation>.passRetained(wrapper).toOpaque()) {
                    continuation.resume(returning: Outcome(result: .failure(error: SDLError()), buffer: nil, requested: 0))
                }
            }
            switch outcome.result {
                case .complete: return await outcome.count
                case .failure(let error): throw error
                case .canceled: throw SDLError(message: "Operation canceled")
            }
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Close and free any allocated resources for an async I/O object.
    /// 
    /// Closing a file is _also_ an asynchronous task! If a write failure were to
    /// happen during the closing process, for example, the task results will
    /// report it as usual.
    /// 
    /// Closing a file that has been written to does not guarantee the data has
    /// made it to physical media; it may remain in the operating system's file
    /// cache, for later writing to disk. This means that a successfully-closed
    /// file can be lost if the system crashes or loses power in this small window.
    /// To prevent this, call this function with the `flush` parameter set to true.
    /// This will make the operation take longer, and perhaps increase system load
    /// in general, but a successful result guarantees that the data has made it to
    /// physical storage. Don't use this for temporary files, caches, and
    /// unimportant data, and definitely use it for crucial irreplaceable files,
    /// like game saves.
    /// 
    /// This function guarantees that the close will happen after any other pending
    /// tasks to `asyncio`, so it's safe to open a file, start several operations,
    /// close the file immediately, then check for all results later. This function
    /// will not block until the tasks have completed.
    /// 
    /// Once this function returns true, `asyncio` is no longer valid, regardless
    /// of any future outcomes. Any completed tasks might still contain this
    /// pointer in their SDL_AsyncIOOutcome data, in case the app was using this
    /// value to track information, but it should not be used again.
    /// 
    /// If this function returns false, the close wasn't started at all, and it's
    /// safe to attempt to close again later.
    /// 
    /// An SDL_AsyncIOQueue must be specified. The newly-created task will be added
    /// to it when it completes its work.
    /// 
    /// \param flush true if data should sync to disk before the task completes.
    /// \param queue a queue to add the new SDL_AsyncIO to.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \threadsafety It is safe to call this function from any thread, but two
    ///               threads should not attempt to close the same object.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    public func close(flushing: Bool, on queue: Queue) async throws {
        if let pointer = pointer {
            self.pointer = nil
            let outcome = await withCheckedContinuation { continuation in
                let wrapper = Queue.Continuation(from: continuation)
                if !SDL_CloseAsyncIO(pointer.pointer, flushing, queue.pointer.pointer, Unmanaged<Queue.Continuation>.passRetained(wrapper).toOpaque()) {
                    continuation.resume(returning: Outcome(result: .failure(error: SDLError()), buffer: nil, requested: 0))
                }
            }
            switch outcome.result {
                case .complete: return
                case .failure(let error): throw error
                case .canceled: throw SDLError(message: "Operation canceled")
            }
        } else {
            throw SDLError()
        }
    }
}