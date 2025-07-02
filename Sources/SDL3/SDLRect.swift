import SDL3_Native

public struct SDLPoint: Equatable {
    public var x: Int32 = 0
    public var y: Int32 = 0

    public init() {}

    public init(x _x: Int32, y _y: Int32) {
        x = _x
        y = _y
    }

    internal init(from point: SDL_Point) {
        x = point.x
        y = point.y
    }

    internal var sdlPoint: SDL_Point {
        get {
            return SDL_Point(x: x, y: y)
        }
    }
}

public struct SDLSize: Equatable {
    public var width: Int32 = 0
    public var height: Int32 = 0

    public init() {}

    public init(width _width: Int32, height _height: Int32) {
        width = _width
        height = _height
    }
}

public struct SDLRect: Equatable {
    public var x: Int32 = 0
    public var y: Int32 = 0
    public var width: Int32 = 0
    public var height: Int32 = 0

    public static func enclosing(points: [SDLPoint], clip rect: SDLRect? = nil) -> SDLRect? {
        let _points = UnsafeMutablePointer<SDL_Point>.allocate(capacity: points.count)
        defer {_points.deallocate()}
        for i in 0..<points.count {
            _points[i] = points[i].sdlPoint
        }
        var res = SDL_Rect()
        let ok: Bool
        if var clip = rect?.sdlRect {
            ok = SDL_GetRectEnclosingPoints(_points, Int32(points.count), &clip, &res)
        } else {
            ok = SDL_GetRectEnclosingPoints(_points, Int32(points.count), nil, &res)
        }
        if ok {
            return SDLRect(from: res)
        } else {
            return nil
        }
    }

    public init() {}

    public init(x _x: Int32, y _y: Int32, width _width: Int32, height _height: Int32) {
        x = _x
        y = _y
        width = _width
        height = _height
    }

    internal init(from rect: SDL_Rect) {
        x = rect.x
        y = rect.y
        width = rect.w
        height = rect.h
    }

    internal var sdlRect: SDL_Rect {
        get {
            return SDL_Rect(x: x, y: y, w: width, h: height)
        }
    }

    public var isEmpty: Bool {
        get {
            return width <= 0 || height <= 0
        }
    }

    public var origin: SDLPoint {
        get {
            return SDLPoint(x: x, y: y)
        }
    }

    public var size: SDLSize {
        get {
            return SDLSize(width: width, height: height)
        }
    }

    public func inRect(point: SDLPoint) -> Bool {
        return ((point.x >= x) && (point.x < (x + width)) && (point.y >= y) && (point.y < (y + height)))
    }

    public func intersects(with rect: SDLRect) -> Bool {
        var a = self.sdlRect
        var b = rect.sdlRect
        return SDL_HasRectIntersection(&a, &b)
    }

    public func intersection(with rect: SDLRect) -> SDLRect? {
        var a = self.sdlRect
        var b = rect.sdlRect
        var res = SDL_Rect()
        if SDL_GetRectIntersection(&a, &b, &res) {
            return SDLRect(from: res)
        } else {
            return nil
        }
    }

    public func union(with rect: SDLRect) throws -> SDLRect {
        var a = self.sdlRect
        var b = rect.sdlRect
        var res = SDL_Rect()
        if SDL_GetRectUnion(&a, &b, &res) {
            return SDLRect(from: res)
        } else {
            throw SDLError()
        }
    }

    public func lineIntersection(from a: SDLPoint, to b: SDLPoint) -> (SDLPoint, SDLPoint)? {
        var x1 = a.x
        var y1 = a.y
        var x2 = b.x
        var y2 = b.y
        var rect = self.sdlRect
        if SDL_GetRectAndLineIntersection(&rect, &x1, &y1, &x2, &y2) {
            return (SDLPoint(x: x1, y: y1), SDLPoint(x: x2, y: y2))
        } else {
            return nil
        }
    }
}

public struct SDLFPoint: Equatable {
    public var x: Float = 0
    public var y: Float = 0

    public init() {}

    public init(x _x: Float, y _y: Float) {
        x = _x
        y = _y
    }

    internal init(from point: SDL_FPoint) {
        x = point.x
        y = point.y
    }

    internal var sdlPoint: SDL_FPoint {
        get {
            return SDL_FPoint(x: x, y: y)
        }
    }
}

internal extension SDL_FRect {
    static let NULL = UnsafePointer<SDL_FRect>(bitPattern: 0)
}

public struct SDLFRect: Equatable {
    public var x: Float = 0
    public var y: Float = 0
    public var width: Float = 0
    public var height: Float = 0

    public static func enclosing(points: [SDLFPoint], clip rect: SDLFRect? = nil) -> SDLFRect? {
        let _points = UnsafeMutablePointer<SDL_FPoint>.allocate(capacity: points.count)
        defer {_points.deallocate()}
        for i in 0..<points.count {
            _points[i] = points[i].sdlPoint
        }
        var res = SDL_FRect()
        let ok: Bool
        if var clip = rect?.sdlRect {
            ok = SDL_GetRectEnclosingPointsFloat(_points, Int32(points.count), &clip, &res)
        } else {
            ok = SDL_GetRectEnclosingPointsFloat(_points, Int32(points.count), nil, &res)
        }
        if ok {
            return SDLFRect(from: res)
        } else {
            return nil
        }
    }

    public init() {}

    public init(x _x: Float, y _y: Float, width _width: Float, height _height: Float) {
        x = _x
        y = _y
        width = _width
        height = _height
    }

    internal init(from rect: SDL_FRect) {
        x = rect.x
        y = rect.y
        width = rect.w
        height = rect.h
    }

    internal var sdlRect: SDL_FRect {
        get {
            return SDL_FRect(x: x, y: y, w: width, h: height)
        }
    }

    public var isEmpty: Bool {
        get {
            return width <= 0 || height <= 0
        }
    }

    public func inRect(point: SDLFPoint) -> Bool {
        return ((point.x >= x) && (point.x < (x + width)) && (point.y >= y) && (point.y < (y + height)))
    }

    public func intersects(with rect: SDLFRect) -> Bool {
        var a = self.sdlRect
        var b = rect.sdlRect
        return SDL_HasRectIntersectionFloat(&a, &b)
    }

    public func intersection(with rect: SDLFRect) -> SDLFRect? {
        var a = self.sdlRect
        var b = rect.sdlRect
        var res = SDL_FRect()
        if SDL_GetRectIntersectionFloat(&a, &b, &res) {
            return SDLFRect(from: res)
        } else {
            return nil
        }
    }

    public func union(with rect: SDLFRect) throws -> SDLFRect {
        var a = self.sdlRect
        var b = rect.sdlRect
        var res = SDL_FRect()
        if SDL_GetRectUnionFloat(&a, &b, &res) {
            return SDLFRect(from: res)
        } else {
            throw SDLError()
        }
    }

    public func lineIntersection(from a: SDLFPoint, to b: SDLFPoint) -> (SDLFPoint, SDLFPoint)? {
        var x1 = a.x
        var y1 = a.y
        var x2 = b.x
        var y2 = b.y
        var rect = self.sdlRect
        if SDL_GetRectAndLineIntersectionFloat(&rect, &x1, &y1, &x2, &y2) {
            return (SDLFPoint(x: x1, y: y1), SDLFPoint(x: x2, y: y2))
        } else {
            return nil
        }
    }
}
