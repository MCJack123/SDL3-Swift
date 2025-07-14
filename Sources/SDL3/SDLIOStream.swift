import SDL3_Native

/// 
/// The functions that drive an SDLIOStream.
/// 
/// Applications can provide this struct to SDL_OpenIO() to create their own
/// implementation of SDL_IOStream. This is not necessarily required, as SDL
/// already offers several common types of I/O streams, via functions like
/// SDL_IOFromFile() and SDL_IOFromMem().
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
public protocol SDLIOStreamDelegate {
    func size() -> Int64
    func seek(offset: Int64, whence: SDLIOStream.SeekWhence) -> Int64
    func read(into: UnsafeMutableRawPointer, size: Int) -> (SDLIOStream.Status, Int)
    func write(from: UnsafeRawPointer, size: Int) -> (SDLIOStream.Status, Int)
    func flush() -> (SDLIOStream.Status, Bool)
    func close() -> Bool
}

fileprivate class SDLIOStreamDelegateBox {
    public let delegate: any SDLIOStreamDelegate
    public init(delegate: any SDLIOStreamDelegate) {self.delegate = delegate}
}

/// 
/// The read/write operation structure.
/// 
/// This operates as an opaque handle. There are several APIs to create various
/// types of I/O streams, or an app can supply an SDL_IOStreamInterface to
/// SDL_OpenIO() to provide their own stream implementation behind this
/// struct's abstract interface.
/// 
/// - Since: This struct is available since SDL 3.2.0.
/// 
public actor SDLIOStream {
    /// The global actor that file I/O functions run on.
    ///
    /// The underlying SDL routines for opening files are not thread-safe, so to
    /// maintain data race safety, they are isolated to this actor. You should not
    /// need to enqueue tasks on this actor manually.
    @globalActor
    public actor IOStreamActor: GlobalActor {
        public static let shared = IOStreamActor()
    }

    /// Open flags for use with file-related functions.
    public enum OpenFlags: String {
        case read = "r"
        case readBinary = "rb"
        case write = "w"
        case writeBinary = "wb"
        case append = "a"
        case appendBinary = "ab"
        case readWrite = "r+"
        case readWriteBinary = "rb+"
        case createReadWrite = "w+"
        case createReadWriteBinary = "wb+"
        case readAppend = "a+"
        case readAppendBinary = "ab+"
    }

    /// 
    /// Possible `whence` values for SDL_IOStream seeking.
    /// 
    /// These map to the same "whence" concept that `fseek` or `lseek` use in the
    /// standard C runtime.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    /// 
    public enum SeekWhence: UInt32 {
        case set
        case current
        case end
    }

    /// 
    /// SDL_IOStream status, set by a read or write operation.
    /// 
    /// - Since: This enum is available since SDL 3.2.0.
    /// 
    public enum Status: UInt32 {
        case ready
        case error
        case eof
        case notReady
        case readOnly
        case writeOnly
    }

    internal let sdlIOStream: OpaquePointer
    fileprivate let delegate: SDLIOStreamDelegateBox!

    /// 
    /// Create a custom SDL_IOStream.
    /// 
    /// Applications do not need to use this function unless they are providing
    /// their own SDL_IOStream implementation. If you just need an SDL_IOStream to
    /// read/write a common data source, you should use the built-in
    /// implementations in SDL, like SDL_IOFromFile() or SDL_IOFromMem(), etc.
    /// 
    /// This function makes a copy of `iface` and the caller does not need to keep
    /// it around after this call.
    /// 
    /// - Parameter for: the interface that implements this SDLIOStream.
    /// - Returns: a pointer to the allocated memory on success or NULL on failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CloseIO
    /// - See: SDL_INIT_INTERFACE
    /// - See: SDL_IOFromConstMem
    /// - See: SDL_IOFromFile
    /// - See: SDL_IOFromMem
    /// 
    public init(for delegate: any SDLIOStreamDelegate) throws {
        self.delegate = SDLIOStreamDelegateBox(delegate: delegate)
        if let ptr = nullCheck(SDL_OpenIO(&IOStreamImpl, Unmanaged.passUnretained(self.delegate).toOpaque())) {
            self.sdlIOStream = ptr
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to create a new SDL_IOStream structure for reading from
    /// and/or writing to a named file.
    /// 
    /// The `mode` string is treated roughly the same as in a call to the C
    /// library's fopen(), even if SDL doesn't happen to use fopen() behind the
    /// scenes.
    /// 
    /// Available `mode` strings:
    /// 
    /// - "r": Open a file for reading. The file must exist.
    /// - "w": Create an empty file for writing. If a file with the same name
    ///   already exists its content is erased and the file is treated as a new
    ///   empty file.
    /// - "a": Append to a file. Writing operations append data at the end of the
    ///   file. The file is created if it does not exist.
    /// - "r+": Open a file for update both reading and writing. The file must
    ///   exist.
    /// - "w+": Create an empty file for both reading and writing. If a file with
    ///   the same name already exists its content is erased and the file is
    ///   treated as a new empty file.
    /// - "a+": Open a file for reading and appending. All writing operations are
    ///   performed at the end of the file, protecting the previous content to be
    ///   overwritten. You can reposition (fseek, rewind) the internal pointer to
    ///   anywhere in the file for reading, but writing operations will move it
    ///   back to the end of file. The file is created if it does not exist.
    /// 
    /// **NOTE**: In order to open a file as a binary file, a "b" character has to
    /// be included in the `mode` string. This additional "b" character can either
    /// be appended at the end of the string (thus making the following compound
    /// modes: "rb", "wb", "ab", "r+b", "w+b", "a+b") or be inserted between the
    /// letter and the "+" sign for the mixed modes ("rb+", "wb+", "ab+").
    /// Additional characters may follow the sequence, although they should have no
    /// effect. For example, "t" is sometimes appended to make explicit the file is
    /// a text file.
    /// 
    /// This function supports Unicode filenames, but they must be encoded in UTF-8
    /// format, regardless of the underlying operating system.
    /// 
    /// In Android, SDL_IOFromFile() can be used to open content:// URIs. As a
    /// fallback, SDL_IOFromFile() will transparently open a matching filename in
    /// the app's `assets`.
    /// 
    /// Closing the SDL_IOStream will close SDL's internal file handle.
    /// 
    /// The following properties may be set at creation time by SDL:
    /// 
    /// - `SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER`: a pointer, that can be cast
    ///   to a win32 `HANDLE`, that this SDL_IOStream is using to access the
    ///   filesystem. If the program isn't running on Windows, or SDL used some
    ///   other method to access the filesystem, this property will not be set.
    /// - `SDL_PROP_IOSTREAM_STDIO_FILE_POINTER`: a pointer, that can be cast to a
    ///   stdio `FILE *`, that this SDL_IOStream is using to access the filesystem.
    ///   If SDL used some other method to access the filesystem, this property
    ///   will not be set. PLEASE NOTE that if SDL is using a different C runtime
    ///   than your app, trying to use this pointer will almost certainly result in
    ///   a crash! This is mostly a problem on Windows; make sure you build SDL and
    ///   your app with the same compiler and settings to avoid it.
    /// - `SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER`: a file descriptor that this
    ///   SDL_IOStream is using to access the filesystem.
    /// - `SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER`: a pointer, that can be cast
    ///   to an Android NDK `AAsset *`, that this SDL_IOStream is using to access
    ///   the filesystem. If SDL used some other method to access the filesystem,
    ///   this property will not be set.
    /// 
    /// - Parameter at: a UTF-8 string representing the filename to open.
    /// - Parameter mode: an ASCII string representing the mode to be used for opening
    ///             the file.
    /// - Returns: a pointer to the SDL_IOStream structure that is created or NULL on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CloseIO
    /// - See: SDL_FlushIO
    /// - See: SDL_ReadIO
    /// - See: SDL_SeekIO
    /// - See: SDL_TellIO
    /// - See: SDL_WriteIO
    /// 
    @IOStreamActor
    public init(at path: String, mode: OpenFlags) throws {
        if let ptr = nullCheck(SDL_IOFromFile(path, mode.rawValue)) {
            self.init(with: ptr)
        } else {
            throw SDLError()
        }
    }

    private init(with sdlIOStream: OpaquePointer) {
        self.sdlIOStream = sdlIOStream
        delegate = nil
    }

    /// 
    /// Use this function to prepare a read-write memory buffer for use with
    /// SDL_IOStream.
    /// 
    /// This function sets up an SDL_IOStream struct based on a memory area of a
    /// certain size, for both read and write access.
    /// 
    /// This memory buffer is not copied by the SDL_IOStream; the pointer you
    /// provide must remain valid until you close the stream. Closing the stream
    /// will not free the original buffer.
    /// 
    /// If you need to make sure the SDL_IOStream never writes to the memory
    /// buffer, you should use SDL_IOFromConstMem() with a read-only buffer of
    /// memory instead.
    /// 
    /// The following properties will be set at creation time by SDL:
    /// 
    /// - `SDL_PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
    ///   was passed to this function.
    /// - `SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
    ///   that was passed to this function.
    /// 
    /// - Parameter mem: a pointer to a buffer to feed an SDL_IOStream stream.
    /// - Parameter size: the buffer size, in bytes.
    /// - Returns: a pointer to a new SDL_IOStream structure or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_IOFromConstMem
    /// - See: SDL_CloseIO
    /// - See: SDL_FlushIO
    /// - See: SDL_ReadIO
    /// - See: SDL_SeekIO
    /// - See: SDL_TellIO
    /// - See: SDL_WriteIO
    /// 
    public init(with mem: UnsafeMutableRawPointer, size: Int) throws {
        if let ptr = nullCheck(SDL_IOFromMem(mem, size)) {
            sdlIOStream = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to prepare a read-only memory buffer for use with
    /// SDL_IOStream.
    /// 
    /// This function sets up an SDL_IOStream struct based on a memory area of a
    /// certain size. It assumes the memory area is not writable.
    /// 
    /// Attempting to write to this SDL_IOStream stream will report an error
    /// without writing to the memory buffer.
    /// 
    /// This memory buffer is not copied by the SDL_IOStream; the pointer you
    /// provide must remain valid until you close the stream. Closing the stream
    /// will not free the original buffer.
    /// 
    /// If you need to write to a memory buffer, you should use SDL_IOFromMem()
    /// with a writable buffer of memory instead.
    /// 
    /// The following properties will be set at creation time by SDL:
    /// 
    /// - `SDL_PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
    ///   was passed to this function.
    /// - `SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
    ///   that was passed to this function.
    /// 
    /// - Parameter mem: a pointer to a read-only buffer to feed an SDL_IOStream stream.
    /// - Parameter size: the buffer size, in bytes.
    /// - Returns: a pointer to a new SDL_IOStream structure or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_IOFromMem
    /// - See: SDL_CloseIO
    /// - See: SDL_ReadIO
    /// - See: SDL_SeekIO
    /// - See: SDL_TellIO
    /// 
    public init(with mem: UnsafeRawPointer, size: Int) throws {
        if let ptr = nullCheck(SDL_IOFromConstMem(mem, size)) {
            sdlIOStream = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to create an SDL_IOStream that is backed by dynamically
    /// allocated memory.
    /// 
    /// This supports the following properties to provide access to the memory and
    /// control over allocations:
    /// 
    /// - `SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER`: a pointer to the internal
    ///   memory of the stream. This can be set to NULL to transfer ownership of
    ///   the memory to the application, which should free the memory with
    ///   SDL_free(). If this is done, the next operation on the stream must be
    ///   SDL_CloseIO().
    /// - `SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER`: memory will be allocated in
    ///   multiples of this size, defaulting to 1024.
    /// 
    /// - Returns: a pointer to a new SDL_IOStream structure or NULL on failure; call
    ///          SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_CloseIO
    /// - See: SDL_ReadIO
    /// - See: SDL_SeekIO
    /// - See: SDL_TellIO
    /// - See: SDL_WriteIO
    /// 
    public init() throws {
        if let ptr = nullCheck(SDL_IOFromDynamicMem()) {
            sdlIOStream = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    // SDL_CloseIO is not thread safe, deinit should be isolated if available
    #if swift(>=6.2)
    isolated
    #endif
    deinit {
        SDL_CloseIO(sdlIOStream)
    }

    // TODO: SDL_GetIOProperties

    @available(*, unavailable, message: "IOStreams may only be closed when destroyed")
    public func close() {}

    /// 
    /// Query the stream status of an SDL_IOStream.
    /// 
    /// This information can be useful to decide if a short read or write was due
    /// to an error, an EOF, or a non-blocking operation that isn't yet ready to
    /// complete.
    /// 
    /// An SDL_IOStream's status is only expected to change after a SDL_ReadIO or
    /// SDL_WriteIO call; don't expect it to change if you just call this query
    /// function in a tight loop.
    /// 
    /// - Returns: an SDL_IOStatus enum with the current state.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public var status: Status {
        return Status(rawValue: SDL_GetIOStatus(sdlIOStream).rawValue)!
    }

    /// 
    /// Use this function to get the size of the data stream in an SDL_IOStream.
    /// 
    /// - Parameter context: the SDL_IOStream to get the size of the data stream from.
    /// - Returns: the size of the data stream in the SDL_IOStream on success or a
    ///          negative error code on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public var size: Int64 {
        get throws {
            let res = SDL_GetIOSize(sdlIOStream)
            if res < 0 {
                throw SDLError()
            }
            return res
        }
    }

    /// 
    /// Seek within an SDL_IOStream data stream.
    /// 
    /// This function seeks to byte `offset`, relative to `whence`.
    /// 
    /// `whence` may be any of the following values:
    /// 
    /// - `SDL_IO_SEEK_SET`: seek from the beginning of data
    /// - `SDL_IO_SEEK_CUR`: seek relative to current read point
    /// - `SDL_IO_SEEK_END`: seek relative to the end of data
    /// 
    /// If this stream can not seek, it will return -1.
    /// 
    /// - Parameter to: an offset in bytes, relative to `whence` location; can be
    ///               negative.
    /// - Parameter from: any of `SDL_IO_SEEK_SET`, `SDL_IO_SEEK_CUR`,
    ///               `SDL_IO_SEEK_END`.
    /// - Returns: the final offset in the data stream after the seek or -1 on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_TellIO
    /// 
    public func seek(to offset: Int64, from whence: SeekWhence) -> Int64 {
        return SDL_SeekIO(sdlIOStream, offset, SDL_IOWhence(rawValue: whence.rawValue))
    }

    /// 
    /// Determine the current read/write offset in an SDL_IOStream data stream.
    /// 
    /// SDL_TellIO is actually a wrapper function that calls the SDL_IOStream's
    /// `seek` method, with an offset of 0 bytes from `SDL_IO_SEEK_CUR`, to
    /// simplify application development.
    /// 
    /// - Parameter context: an SDL_IOStream data stream object from which to get the
    ///                current offset.
    /// - Returns: the current offset in the stream, or -1 if the information can not
    ///          be determined.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SeekIO
    /// 
    public var tell: Int64? {
        let res = SDL_TellIO(sdlIOStream)
        if res == -1 {
            return nil
        }
        return res
    }

    /// 
    /// Read from a data source.
    /// 
    /// This function reads up `size` bytes from the data source to the area
    /// pointed at by `ptr`. This function may read less bytes than requested.
    /// 
    /// This function will return zero when the data stream is completely read, and
    /// SDL_GetIOStatus() will return SDL_IO_STATUS_EOF. If zero is returned and
    /// the stream is not at EOF, SDL_GetIOStatus() will return a different error
    /// value and SDL_GetError() will offer a human-readable message.
    /// 
    /// - Parameter size: the number of bytes to read from the data source.
    /// - Returns: the number of bytes read, or 0 on end of file or other failure;
    ///          call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_WriteIO
    /// - See: SDL_GetIOStatus
    /// 
    public func read(size: Int) throws -> [UInt8]? {
        var data = [UInt8](repeating: 0, count: size)
        let read = data.withContiguousMutableStorageIfAvailable({_data in
            SDL_ReadIO(self.sdlIOStream, _data.baseAddress, size)
        })!
        if read == 0 {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        if read < data.count {
            return data.dropLast(data.count - read)
        }
        return data
    }

    /// 
    /// Write to an SDL_IOStream data stream.
    /// 
    /// This function writes exactly `size` bytes from the area pointed at by `ptr`
    /// to the stream. If this fails for any reason, it'll return less than `size`
    /// to demonstrate how far the write progressed. On success, it returns `size`.
    /// 
    /// On error, this function still attempts to write as much as possible, so it
    /// might return a positive value less than the requested write size.
    /// 
    /// The caller can use SDL_GetIOStatus() to determine if the problem is
    /// recoverable, such as a non-blocking write that can simply be retried later,
    /// or a fatal error.
    /// 
    /// - Parameter data: a buffer containing data to write.
    /// - Returns: the number of bytes written, which will be less than `size` on
    ///          failure; call SDL_GetError() for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_IOprintf
    /// - See: SDL_ReadIO
    /// - See: SDL_SeekIO
    /// - See: SDL_FlushIO
    /// - See: SDL_GetIOStatus
    /// 
    public func write(data: [UInt8]) throws {
        let res = data.withContiguousStorageIfAvailable {_data in
            SDL_WriteIO(self.sdlIOStream, _data.baseAddress, data.count)
        }!
        if res < data.count {
            throw SDLError()
        }
    }

    /// 
    /// Print to an SDL_IOStream data stream.
    /// 
    /// This function does formatted printing to the stream.
    /// 
    /// - Parameter fmt: a printf() style format string.
    /// \param ... additional parameters matching % tokens in the `fmt` string, if
    ///            any.
    /// - Returns: the number of bytes written or 0 on failure; call SDL_GetError()
    ///          for more information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_IOvprintf
    /// - See: SDL_WriteIO
    /// 
    public func printf(with format: String, _ args: any CVarArg...) throws {
        let count = withVaList(args) { _args in
            SDL_IOvprintf(self.sdlIOStream, format, _args)
        }
        if count == 0 {
            throw SDLError()
        }
    }

    /// 
    /// Flush any buffered data in the stream.
    /// 
    /// This function makes sure that any buffered data is written to the stream.
    /// Normally this isn't necessary but if the stream is a pipe or socket it
    /// guarantees that any pending data is sent.
    /// 
    /// - Returns: true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_OpenIO
    /// - See: SDL_WriteIO
    /// 
    public func flush() throws {
        if !SDL_FlushIO(sdlIOStream) {
            throw SDLError()
        }
    }

    /// 
    /// Load all the data from an SDL data stream.
    /// 
    /// The data is allocated with a zero byte at the end (null terminated) for
    /// convenience. This extra byte is not included in the value reported via
    /// `datasize`.
    /// 
    /// The data should be freed with SDL_free().
    /// 
    /// - Returns: the data or NULL on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_LoadFile
    /// - See: SDL_SaveFile_IO
    /// 
    public func load() throws -> [UInt8] {
        var size: Int = 0
        if let ptr = nullCheck(SDL_LoadFile_IO(self.sdlIOStream, &size, false)) {
            let retval = [UInt8](unsafeUninitializedCapacity: size) {(_ptr, sz) in
                _ptr.baseAddress!.initialize(from: UnsafePointer<UInt8>(OpaquePointer(ptr)), count: size)
            }
            SDL_free(ptr)
            return retval
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Load all the data from a file path.
    /// 
    /// The data is allocated with a zero byte at the end (null terminated) for
    /// convenience. This extra byte is not included in the value reported via
    /// `datasize`.
    /// 
    /// The data should be freed with SDL_free().
    /// 
    /// - Parameter at: the path to read all available data from.
    /// - Returns: the data or NULL on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_LoadFile_IO
    /// - See: SDL_SaveFile
    /// 
    @IOStreamActor
    public static func load(at path: String) throws -> [UInt8] {
        var size: Int = 0
        if let ptr = nullCheck(SDL_LoadFile(path, &size)) {
            let retval = [UInt8](unsafeUninitializedCapacity: size) {(_ptr, sz) in
                _ptr.baseAddress!.initialize(from: UnsafePointer<UInt8>(OpaquePointer(ptr)), count: size)
            }
            SDL_free(ptr)
            return retval
        } else {
            throw SDLError()
        }
    }

    /// 
    /// Save all the data into an SDL data stream.
    /// 
    /// - Parameter data: the data to be written. If datasize is 0, may be NULL or a
    ///             invalid pointer.
    /// - Returns: true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SaveFile
    /// - See: SDL_LoadFile_IO
    /// 
    public func save(data: [UInt8]) throws {
        guard let ok = data.withContiguousStorageIfAvailable({ _data in
            SDL_SaveFile_IO(self.sdlIOStream, _data.baseAddress, data.count, false)
        }) else {throw SDLError(message: "Could not get contiguous storage")}
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Save all the data into a file path.
    /// 
    /// - Parameter file: the path to write all available data into.
    /// - Parameter data: the data to be written. If datasize is 0, may be NULL or a
    ///             invalid pointer.
    /// - Returns: true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    /// - See: SDL_SaveFile_IO
    /// - See: SDL_LoadFile
    /// 
    @IOStreamActor
    public static func save(to path: String, data: [UInt8]) throws {
        guard let ok = data.withContiguousStorageIfAvailable({ _data in
            SDL_SaveFile(path, _data.baseAddress, data.count)
        }) else {throw SDLError(message: "Could not get contiguous storage")}
        if !ok {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to read a byte from an ``SDLIOStream``.
    /// 
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU8() throws -> UInt8? {
        var res: UInt8 = 0
        if !SDL_ReadU8(self.sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read a signed byte from an ``SDLIOStream``.
    /// 
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS8() throws -> Int8? {
        var res: Int8 = 0
        if !SDL_ReadS8(self.sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 16 bits of little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU16LE() throws -> UInt16? {
        var res: UInt16 = 0
        if !SDL_ReadU16LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 16 bits of big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU16BE() throws -> UInt16? {
        var res: UInt16 = 0
        if !SDL_ReadU16BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 16 bits of signed little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS16LE() throws -> Int16? {
        var res: Int16 = 0
        if !SDL_ReadS16LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 16 bits of signed big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS16BE() throws -> Int16? {
        var res: Int16 = 0
        if !SDL_ReadS16BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 32 bits of little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU32LE() throws -> UInt32? {
        var res: UInt32 = 0
        if !SDL_ReadU32LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 32 bits of big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU32BE() throws -> UInt32? {
        var res: UInt32 = 0
        if !SDL_ReadU32BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 32 bits of signed little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS32LE() throws -> Int32? {
        var res: Int32 = 0
        if !SDL_ReadS32LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 32 bits of signed big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS32BE() throws -> Int32? {
        var res: Int32 = 0
        if !SDL_ReadS32BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 64 bits of little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU64LE() throws -> UInt64? {
        var res: UInt64 = 0
        if !SDL_ReadU64LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 64 bits of big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readU64BE() throws -> UInt64? {
        var res: UInt64 = 0
        if !SDL_ReadU64BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 64 bits of signed little-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS64LE() throws -> Int64? {
        var res: Int64 = 0
        if !SDL_ReadS64LE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to read 64 bits of signed big-endian data from an
    /// ``SDLIOStream`` and return in native format.
    /// 
    /// SDL byteswaps the data only if necessary, so the data returned will be in
    /// the native byte order.
    ///
    /// This function will return `nil` when the data stream is completely read,
    /// and ``status`` will return `.eof`. If any other error occurs, this function
    /// will throw an error.
    /// 
    /// - Returns: The value read, or `nil` on EOF.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func readS64BE() throws -> Int64? {
        var res: Int64 = 0
        if !SDL_ReadS64BE(sdlIOStream, &res) {
            if SDL_GetIOStatus(sdlIOStream) == SDL_IO_STATUS_EOF {
                return nil
            } else {
                throw SDLError()
            }
        }
        return res
    }

    /// 
    /// Use this function to write a byte to an ``SDLIOStream``.
    /// 
    /// - Parameter value: the value to write.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func write(_ val: UInt8) throws {
        if !SDL_WriteU8(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write a signed byte to an ``SDLIOStream``.
    /// 
    /// - Parameter value: the value to write.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func write(_ val: Int8) throws {
        if !SDL_WriteS8(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 16 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: UInt16) throws {
        if !SDL_WriteU16LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 32 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: UInt32) throws {
        if !SDL_WriteU32LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 64 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: UInt64) throws {
        if !SDL_WriteU64LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 16 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: Int16) throws {
        if !SDL_WriteS16LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 32 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: Int32) throws {
        if !SDL_WriteS32LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 64 bits in native format to an ``SDLIOStream`` as
    /// little-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeLE(_ val: Int64) throws {
        if !SDL_WriteS64LE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 16 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: UInt16) throws {
        if !SDL_WriteU16BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 32 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: UInt32) throws {
        if !SDL_WriteU32BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 64 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: UInt64) throws {
        if !SDL_WriteU64BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 16 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: Int16) throws {
        if !SDL_WriteS16BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 32 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: Int32) throws {
        if !SDL_WriteS32BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    /// 
    /// Use this function to write 64 bits in native format to an ``SDLIOStream`` as
    /// big-endian data.
    /// 
    /// SDL byteswaps the data only if necessary, so the application always
    /// specifies native format, and the data written will be in the correct
    /// format.
    /// 
    /// - Parameter value: the data to be written, in native format.
    /// - Throws: ``SDLError`` if the function fails.
    /// 
    /// - Since: This function is available since SDL 3.2.0.
    /// 
    public func writeBE(_ val: Int64) throws {
        if !SDL_WriteS64BE(sdlIOStream, val) {
            throw SDLError()
        }
    }

    internal struct SurfacePointer: @unchecked Sendable {
        public let pointer: UnsafeMutablePointer<SDL_Surface>
    }

    internal func loadBMP() throws -> SurfacePointer {
        if let surf = nullCheck(SDL_LoadBMP_IO(sdlIOStream, false)) {
            return SurfacePointer(pointer: surf)
        } else {
            throw SDLError()
        }
    }

    internal func saveBMP(_ surf: SurfacePointer) throws {
        if !SDL_SaveBMP_IO(surf.pointer, sdlIOStream, false) {
            throw SDLError()
        }
    }
}

fileprivate func IOStream_size(_ context: UnsafeMutableRawPointer?) -> Int64 {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    return delegate.size()
}

fileprivate func IOStream_seek(_ context: UnsafeMutableRawPointer?, _ offset: Int64, _ whence: SDL_IOWhence) -> Int64 {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    return delegate.seek(offset: offset, whence: SDLIOStream.SeekWhence(rawValue: whence.rawValue)!)
}

fileprivate func IOStream_read(_ context: UnsafeMutableRawPointer?, _ ptr: UnsafeMutableRawPointer?, _ size: Int, _ status: UnsafeMutablePointer<SDL_IOStatus>?) -> Int {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    let res = delegate.read(into: ptr!, size: size)
    status!.pointee = SDL_IOStatus(rawValue: res.0.rawValue)
    return res.1
}

fileprivate func IOStream_write(_ context: UnsafeMutableRawPointer?, _ ptr: UnsafeRawPointer?, _ size: Int, _ status: UnsafeMutablePointer<SDL_IOStatus>?) -> Int {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    let res = delegate.write(from: ptr!, size: size)
    status!.pointee = SDL_IOStatus(rawValue: res.0.rawValue)
    return res.1
}

fileprivate func IOStream_flush(_ context: UnsafeMutableRawPointer?, _ status: UnsafeMutablePointer<SDL_IOStatus>?) -> Bool {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    let res = delegate.flush()
    status!.pointee = SDL_IOStatus(rawValue: res.0.rawValue)
    return res.1
}

fileprivate func IOStream_close(_ context: UnsafeMutableRawPointer?) -> Bool {
    let delegate = Unmanaged<SDLIOStreamDelegateBox>.fromOpaque(context!).takeUnretainedValue().delegate
    return delegate.close()
}

fileprivate var IOStreamImpl = SDL_IOStreamInterface(
    version: UInt32(MemoryLayout<SDL_IOStreamInterface>.size),
    size: IOStream_size,
    seek: IOStream_seek,
    read: IOStream_read,
    write: IOStream_write,
    flush: IOStream_flush,
    close: IOStream_close
)
