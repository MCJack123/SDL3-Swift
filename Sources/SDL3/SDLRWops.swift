import SDL3_Native

public protocol SDLRWopsDelegate {
    func size() -> Int64
    func seek(offset: Int64, whence: SDLRWops.SeekWhence) -> Int64
    func read(into: UnsafeMutableRawPointer, size: Int) -> Int
    func write(from: UnsafeRawPointer, size: Int) -> Int
    func close() -> Bool
}

public class SDLRWops {
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

    public enum SeekWhence: Int32 {
        case set = 0
        case current = 1
        case end = 2
    }

    internal let sdlRWops: UnsafeMutablePointer<SDL_RWops>
    fileprivate let delegate: SDLRWopsDelegate?

    init(for delegate: SDLRWopsDelegate) throws {
        self.delegate = delegate
        if let ptr = nullCheck(SDL_CreateRW()) {
            self.sdlRWops = ptr
            ptr.pointee.hidden.unknown.data1 = Unmanaged.passUnretained(self).toOpaque()
            ptr.pointee.size = RWops_size
            ptr.pointee.seek = RWops_seek
            ptr.pointee.read = RWops_read
            ptr.pointee.write = RWops_write
            ptr.pointee.close = RWops_close
        } else {
            throw SDLError()
        }
    }

    init(at path: String, mode: OpenFlags) throws {
        if let ptr = nullCheck(SDL_RWFromFile(path, mode.rawValue)) {
            sdlRWops = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    init(with mem: UnsafeMutableRawPointer, size: Int) throws {
        if let ptr = nullCheck(SDL_RWFromMem(mem, size)) {
            sdlRWops = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    init(with mem: UnsafeRawPointer, size: Int) throws {
        if let ptr = nullCheck(SDL_RWFromConstMem(mem, size)) {
            sdlRWops = ptr
            delegate = nil
        } else {
            throw SDLError()
        }
    }

    deinit {
        if delegate != nil {
            SDL_DestroyRW(sdlRWops)
        }
    }

    public func size() -> Int64 {
        return SDL_RWsize(sdlRWops)
    }

    public func seek(to offset: Int64, from whence: SeekWhence) -> Int64 {
        return SDL_RWseek(sdlRWops, offset, whence.rawValue)
    }

    public func tell() -> Int64 {
        return SDL_RWtell(sdlRWops)
    }

    public func read(size: Int) -> [UInt8]? {
        var data = [UInt8](repeating: 0, count: size)
        if let read = data.withContiguousMutableStorageIfAvailable({_data in
            SDL_RWread(self.sdlRWops, _data.baseAddress, size)
        }) {
            if read == 0 {
                return nil
            }
            if read < data.count {
                return data.dropLast(data.count - read)
            }
            return data
        } else {
            return nil
        }
    }

    public func write(data: [UInt8]) -> Int {
        return data.withContiguousStorageIfAvailable {_data in
            SDL_RWwrite(self.sdlRWops, _data.baseAddress, data.count)
        } ?? 0
    }

    public func close() -> Bool {
        return SDL_RWclose(sdlRWops) == 0
    }

    public func load(shouldClose: Bool = false) -> [UInt8]? {
        var size: Int = 0
        let ptr = withUnsafeMutablePointer(to: &size) {_size in
            SDL_LoadFile_RW(self.sdlRWops, _size, shouldClose ? SDL_TRUE : SDL_FALSE)
        }
        if let ptr = nullCheck(ptr) {
            let retval = [UInt8](unsafeUninitializedCapacity: size) {(_ptr, sz) in
                _ptr.baseAddress!.initialize(from: UnsafePointer<UInt8>(OpaquePointer(ptr)), count: size)
            }
            SDL_free(ptr)
            return retval
        } else {
            return nil
        }
    }

    public static func load(at path: String) -> [UInt8]? {
        var size: Int = 0
        let ptr = withUnsafeMutablePointer(to: &size) {_size in
            SDL_LoadFile(path, _size)
        }
        if let ptr = nullCheck(ptr) {
            let retval = [UInt8](unsafeUninitializedCapacity: size) {(_ptr, sz) in
                _ptr.baseAddress!.initialize(from: UnsafePointer<UInt8>(OpaquePointer(ptr)), count: size)
            }
            SDL_free(ptr)
            return retval
        } else {
            return nil
        }
    }

    public func readU8() -> UInt8? {
        var res: UInt8 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU8(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU16LE() -> UInt16? {
        var res: UInt16 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU16LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU16BE() -> UInt16? {
        var res: UInt16 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU16BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS16LE() -> Int16? {
        var res: Int16 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS16LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS16BE() -> Int16? {
        var res: Int16 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS16BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU32LE() -> UInt32? {
        var res: UInt32 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU32LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU32BE() -> UInt32? {
        var res: UInt32 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU32BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS32LE() -> Int32? {
        var res: Int32 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS32LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS32BE() -> Int32? {
        var res: Int32 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS32BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU64LE() -> UInt64? {
        var res: UInt64 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU64LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readU64BE() -> UInt64? {
        var res: UInt64 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadU64BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS64LE() -> Int64? {
        var res: Int64 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS64LE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func readS64BE() -> Int64? {
        var res: Int64 = 0
        if !withUnsafeMutablePointer(to: &res, {_res in
            SDL_ReadS64BE(self.sdlRWops, _res) == SDL_TRUE
        }) {
            return nil
        }
        return res
    }

    public func write(_ val: UInt8) -> Bool {
        return SDL_WriteU8(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: UInt16) -> Bool {
        return SDL_WriteU16LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: UInt32) -> Bool {
        return SDL_WriteU32LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: UInt64) -> Bool {
        return SDL_WriteU64LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: Int16) -> Bool {
        return SDL_WriteS16LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: Int32) -> Bool {
        return SDL_WriteS32LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeLE(_ val: Int64) -> Bool {
        return SDL_WriteS64LE(sdlRWops, val) == SDL_TRUE
    }

    public func writeBE(_ val: UInt16) -> Bool {
        return SDL_WriteU16BE(sdlRWops, val) == SDL_TRUE
    }

    public func writeBE(_ val: UInt32) -> Bool {
        return SDL_WriteU32BE(sdlRWops, val) == SDL_TRUE
    }

    public func writeBE(_ val: UInt64) -> Bool {
        return SDL_WriteU64BE(sdlRWops, val) == SDL_TRUE
    }

    public func writeBE(_ val: Int16) -> Bool {
        return SDL_WriteS16BE(sdlRWops, val) == SDL_TRUE
    }

    public func writeBE(_ val: Int32) -> Bool {
        return SDL_WriteS32BE(sdlRWops, val) == SDL_TRUE
    }

    /*public func writeBE(_ val: Int64) -> Bool {
        return SDL_WriteS64BE(sdlRWops, val) == SDL_TRUE
    }*/ // currently bugged in the header
}

fileprivate func RWops_size(_ context: UnsafeMutablePointer<SDL_RWops>?) -> Int64 {
    let obj = Unmanaged<SDLRWops>.fromOpaque(context!.pointee.hidden.unknown.data1).takeUnretainedValue()
    if let delegate = obj.delegate {
        return delegate.size()
    }
    return 0
}

fileprivate func RWops_seek(_ context: UnsafeMutablePointer<SDL_RWops>?, _ offset: Int64, _ whence: Int32) -> Int64 {
    let obj = Unmanaged<SDLRWops>.fromOpaque(context!.pointee.hidden.unknown.data1).takeUnretainedValue()
    if let delegate = obj.delegate {
        return delegate.seek(offset: offset, whence: SDLRWops.SeekWhence(rawValue: whence)!)
    }
    return -1
}

fileprivate func RWops_read(_ context: UnsafeMutablePointer<SDL_RWops>?, _ ptr: UnsafeMutableRawPointer?, _ size: Int) -> Int {
    let obj = Unmanaged<SDLRWops>.fromOpaque(context!.pointee.hidden.unknown.data1).takeUnretainedValue()
    if let delegate = obj.delegate {
        return delegate.read(into: ptr!, size: size)
    }
    return 0
}

fileprivate func RWops_write(_ context: UnsafeMutablePointer<SDL_RWops>?, _ ptr: UnsafeRawPointer?, _ size: Int) -> Int {
    let obj = Unmanaged<SDLRWops>.fromOpaque(context!.pointee.hidden.unknown.data1).takeUnretainedValue()
    if let delegate = obj.delegate {
        return delegate.write(from: ptr!, size: size)
    }
    return 0
}

fileprivate func RWops_close(_ context: UnsafeMutablePointer<SDL_RWops>?) -> Int32 {
    let obj = Unmanaged<SDLRWops>.fromOpaque(context!.pointee.hidden.unknown.data1).takeUnretainedValue()
    if let delegate = obj.delegate {
        return delegate.close() ? 0 : -1
    }
    return -1
}
