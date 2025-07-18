import SDL3_Native

/// The global actor that key conversion functions run on.
///
/// The underlying SDL routines for converting keys are not thread-safe, so to
/// maintain data race safety, they are isolated to this actor. You should not
/// need to enqueue tasks on this actor manually.
@globalActor
public actor SDLKeyConversionActor: GlobalActor {
    public static let shared = SDLKeyConversionActor()
}

@EnumWrapper(SDL_Scancode.self)
public enum SDLScancode: UInt32 {
    case unknown = 0
    case a = 4
    case b = 5
    case c = 6
    case d = 7
    case e = 8
    case f = 9
    case g = 10
    case h = 11
    case i = 12
    case j = 13
    case k = 14
    case l = 15
    case m = 16
    case n = 17
    case o = 18
    case p = 19
    case q = 20
    case r = 21
    case s = 22
    case t = 23
    case u = 24
    case v = 25
    case w = 26
    case x = 27
    case y = 28
    case z = 29
    case one = 30
    case two = 31
    case three = 32
    case four = 33
    case five = 34
    case six = 35
    case seven = 36
    case eight = 37
    case nine = 38
    case zero = 39
    case `return` = 40
    case escape = 41
    case backspace = 42
    case tab = 43
    case space = 44
    case minus = 45
    case equals = 46
    case leftbracket = 47
    case rightbracket = 48
    case backslash = 49
    case nonushash = 50
    case semicolon = 51
    case apostrophe = 52
    case grave = 53
    case comma = 54
    case period = 55
    case slash = 56
    case capslock = 57
    case f1 = 58
    case f2 = 59
    case f3 = 60
    case f4 = 61
    case f5 = 62
    case f6 = 63
    case f7 = 64
    case f8 = 65
    case f9 = 66
    case f10 = 67
    case f11 = 68
    case f12 = 69
    case printscreen = 70
    case scrolllock = 71
    case pause = 72
    case insert = 73
    case home = 74
    case pageup = 75
    case delete = 76
    case end = 77
    case pagedown = 78
    case right = 79
    case left = 80
    case down = 81
    case up = 82
    case numlockclear = 83
    case kp_divide = 84
    case kp_multiply = 85
    case kp_minus = 86
    case kp_plus = 87
    case kp_enter = 88
    case kp_1 = 89
    case kp_2 = 90
    case kp_3 = 91
    case kp_4 = 92
    case kp_5 = 93
    case kp_6 = 94
    case kp_7 = 95
    case kp_8 = 96
    case kp_9 = 97
    case kp_0 = 98
    case kp_period = 99
    case nonusbackslash = 100
    case application = 101
    case power = 102
    case kp_equals = 103
    case f13 = 104
    case f14 = 105
    case f15 = 106
    case f16 = 107
    case f17 = 108
    case f18 = 109
    case f19 = 110
    case f20 = 111
    case f21 = 112
    case f22 = 113
    case f23 = 114
    case f24 = 115
    case execute = 116
    case help = 117
    case menu = 118
    case select = 119
    case stop = 120
    case again = 121
    case undo = 122
    case cut = 123
    case copy = 124
    case paste = 125
    case find = 126
    case mute = 127
    case volumeup = 128
    case volumedown = 129
    case kp_comma = 133
    case kp_equalsas400 = 134
    case international1 = 135
    case international2 = 136
    case international3 = 137
    case international4 = 138
    case international5 = 139
    case international6 = 140
    case international7 = 141
    case international8 = 142
    case international9 = 143
    case lang1 = 144
    case lang2 = 145
    case lang3 = 146
    case lang4 = 147
    case lang5 = 148
    case lang6 = 149
    case lang7 = 150
    case lang8 = 151
    case lang9 = 152
    case alterase = 153
    case sysreq = 154
    case cancel = 155
    case clear = 156
    case prior = 157
    case return2 = 158
    case separator = 159
    case out = 160
    case oper = 161
    case clearagain = 162
    case crsel = 163
    case exsel = 164
    case kp_00 = 176
    case kp_000 = 177
    case thousandsseparator = 178
    case decimalseparator = 179
    case currencyunit = 180
    case currencysubunit = 181
    case kp_leftparen = 182
    case kp_rightparen = 183
    case kp_leftbrace = 184
    case kp_rightbrace = 185
    case kp_tab = 186
    case kp_backspace = 187
    case kp_a = 188
    case kp_b = 189
    case kp_c = 190
    case kp_d = 191
    case kp_e = 192
    case kp_f = 193
    case kp_xor = 194
    case kp_power = 195
    case kp_percent = 196
    case kp_less = 197
    case kp_greater = 198
    case kp_ampersand = 199
    case kp_dblampersand = 200
    case kp_verticalbar = 201
    case kp_dblverticalbar = 202
    case kp_colon = 203
    case kp_hash = 204
    case kp_space = 205
    case kp_at = 206
    case kp_exclam = 207
    case kp_memstore = 208
    case kp_memrecall = 209
    case kp_memclear = 210
    case kp_memadd = 211
    case kp_memsubtract = 212
    case kp_memmultiply = 213
    case kp_memdivide = 214
    case kp_plusminus = 215
    case kp_clear = 216
    case kp_clearentry = 217
    case kp_binary = 218
    case kp_octal = 219
    case kp_decimal = 220
    case kp_hexadecimal = 221
    case lctrl = 224
    case lshift = 225
    case lalt = 226
    case lgui = 227
    case rctrl = 228
    case rshift = 229
    case ralt = 230
    case rgui = 231
    case mode = 257
    case audionext = 258
    case audioprev = 259
    case audiostop = 260
    case audioplay = 261
    case audiomute = 262
    case mediaselect = 263
    case www = 264
    case mail = 265
    case calculator = 266
    case computer = 267
    case ac_search = 268
    case ac_home = 269
    case ac_back = 270
    case ac_forward = 271
    case ac_stop = 272
    case ac_refresh = 273
    case ac_bookmarks = 274
    case brightnessdown = 275
    case brightnessup = 276
    case displayswitch = 277
    case kbdillumtoggle = 278
    case kbdillumdown = 279
    case kbdillumup = 280
    case eject = 281
    case sleep = 282
    case app1 = 283
    case app2 = 284
    case audiorewind = 285
    case audiofastforward = 286
    case softleft = 287
    case softright = 288
    case call = 289
    case endcall = 290

    /// 
    /// Get the scancode corresponding to the given key code according to the
    /// current keyboard layout.
    /// 
    /// Note that there may be multiple scancode+modifier states that can generate
    /// this keycode, this will just return the first one found.
    /// 
    /// \param key the desired SDL_Keycode to query.
    /// \param modstate a pointer to the modifier state that would be used when the
    ///                 scancode generates this key, may be NULL.
    /// \returns the SDL_Scancode that corresponds to the given SDL_Keycode.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyFromScancode
    /// \sa SDL_GetScancodeName
    /// 
    @SDLKeyConversionActor
    static func from(keycode: SDLKeycode) -> (SDLScancode, SDLKeyModifiers) {
        var modstate: SDL_Keymod = 0
        let code = SDL_GetScancodeFromKey(SDL_Keycode(keycode.rawValue), &modstate)
        return (SDLScancode(rawValue: code.rawValue)!, SDLKeyModifiers(rawValue: modstate))
    }

    /// 
    /// Get a scancode from a human-readable name.
    /// 
    /// \param name the human-readable scancode name.
    /// \returns the SDL_Scancode, or `SDL_SCANCODE_UNKNOWN` if the name wasn't
    ///          recognized; call SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyFromName
    /// \sa SDL_GetScancodeFromKey
    /// \sa SDL_GetScancodeName
    /// 
    @SDLKeyConversionActor
    static func from(name: String) throws -> SDLScancode {
        let code = SDL_GetScancodeFromName(name)
        if code == SDL_SCANCODE_UNKNOWN {
            throw SDLError()
        }
        return SDLScancode(rawValue: code.rawValue)!
    }

    /// 
    /// Get a human-readable name for a scancode.
    /// 
    /// **Warning**: The returned name is by design not stable across platforms,
    /// e.g. the name for `SDL_SCANCODE_LGUI` is "Left GUI" under Linux but "Left
    /// Windows" under Microsoft Windows, and some scancodes like
    /// `SDL_SCANCODE_NONUSBACKSLASH` don't have any name at all. There are even
    /// scancodes that share names, e.g. `SDL_SCANCODE_RETURN` and
    /// `SDL_SCANCODE_RETURN2` (both called "Return"). This function is therefore
    /// unsuitable for creating a stable cross-platform two-way mapping between
    /// strings and scancodes.
    /// 
    /// \returns the name for the scancode. If the scancode doesn't
    ///          have a name this function returns an empty string ("").
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetScancodeFromKey
    /// \sa SDL_GetScancodeFromName
    /// \sa SDL_SetScancodeName
    /// 
    @SDLKeyConversionActor
    public var name: String {
        return String(cString: SDL_GetScancodeName(SDL_Scancode(UInt32(self.rawValue))))
    }

    /// 
    /// Set a human-readable name for a scancode.
    /// 
    /// \param scancode the desired SDL_Scancode.
    /// \param name the name to use for the scancode, encoded as UTF-8. The string
    ///             is not copied, so the pointer given to this function must stay
    ///             valid while SDL is being used.
    /// \returns true on success or false on failure; call SDL_GetError() for more
    ///          information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetScancodeName
    /// 
    @SDLKeyConversionActor
    public func set(name: String) throws {
        if !SDL_SetScancodeName(SDL_Scancode(rawValue: self.rawValue), name) {
            throw SDLError()
        }
    }
}

public enum SDLKeycode: UInt32 {
    case unknown = 0
    case `return` = 13
    case escape = 27
    case backspace = 8
    case tab = 9
    case space = 32
    case exclaim = 33
    case quotedbl = 34
    case hash = 35
    case percent = 37
    case dollar = 36
    case ampersand = 38
    case quote = 39
    case leftparen = 40
    case rightparen = 41
    case asterisk = 42
    case plus = 43
    case comma = 44
    case minus = 45
    case period = 46
    case slash = 47
    case zero = 48
    case one = 49
    case two = 50
    case three = 51
    case four = 52
    case five = 53
    case six = 54
    case seven = 55
    case eight = 56
    case nine = 57
    case colon = 58
    case semicolon = 59
    case less = 60
    case equals = 61
    case greater = 62
    case question = 63
    case at = 64
    case leftbracket = 91
    case backslash = 92
    case rightbracket = 93
    case caret = 94
    case underscore = 95
    case backquote = 96
    case a = 97
    case b = 98
    case c = 99
    case d = 100
    case e = 101
    case f = 102
    case g = 103
    case h = 104
    case i = 105
    case j = 106
    case k = 107
    case l = 108
    case m = 109
    case n = 110
    case o = 111
    case p = 112
    case q = 113
    case r = 114
    case s = 115
    case t = 116
    case u = 117
    case v = 118
    case w = 119
    case x = 120
    case y = 121
    case z = 122
    case capslock = 1073741881
    case f1 = 1073741882
    case f2 = 1073741883
    case f3 = 1073741884
    case f4 = 1073741885
    case f5 = 1073741886
    case f6 = 1073741887
    case f7 = 1073741888
    case f8 = 1073741889
    case f9 = 1073741890
    case f10 = 1073741891
    case f11 = 1073741892
    case f12 = 1073741893
    case printscreen = 1073741894
    case scrolllock = 1073741895
    case pause = 1073741896
    case insert = 1073741897
    case home = 1073741898
    case pageup = 1073741899
    case delete = 127
    case end = 1073741901
    case pagedown = 1073741902
    case right = 1073741903
    case left = 1073741904
    case down = 1073741905
    case up = 1073741906
    case numlockclear = 1073741907
    case kp_divide = 1073741908
    case kp_multiply = 1073741909
    case kp_minus = 1073741910
    case kp_plus = 1073741911
    case kp_enter = 1073741912
    case kp_1 = 1073741913
    case kp_2 = 1073741914
    case kp_3 = 1073741915
    case kp_4 = 1073741916
    case kp_5 = 1073741917
    case kp_6 = 1073741918
    case kp_7 = 1073741919
    case kp_8 = 1073741920
    case kp_9 = 1073741921
    case kp_0 = 1073741922
    case kp_period = 1073741923
    case application = 1073741925
    case power = 1073741926
    case kp_equals = 1073741927
    case f13 = 1073741928
    case f14 = 1073741929
    case f15 = 1073741930
    case f16 = 1073741931
    case f17 = 1073741932
    case f18 = 1073741933
    case f19 = 1073741934
    case f20 = 1073741935
    case f21 = 1073741936
    case f22 = 1073741937
    case f23 = 1073741938
    case f24 = 1073741939
    case execute = 1073741940
    case help = 1073741941
    case menu = 1073741942
    case select = 1073741943
    case stop = 1073741944
    case again = 1073741945
    case undo = 1073741946
    case cut = 1073741947
    case copy = 1073741948
    case paste = 1073741949
    case find = 1073741950
    case mute = 1073741951
    case volumeup = 1073741952
    case volumedown = 1073741953
    case kp_comma = 1073741957
    case kp_equalsas400 = 1073741958
    case alterase = 1073741977
    case sysreq = 1073741978
    case cancel = 1073741979
    case clear = 1073741980
    case prior = 1073741981
    case return2 = 1073741982
    case separator = 1073741983
    case out = 1073741984
    case oper = 1073741985
    case clearagain = 1073741986
    case crsel = 1073741987
    case exsel = 1073741988
    case kp_00 = 1073742000
    case kp_000 = 1073742001
    case thousandsseparator = 1073742002
    case decimalseparator = 1073742003
    case currencyunit = 1073742004
    case currencysubunit = 1073742005
    case kp_leftparen = 1073742006
    case kp_rightparen = 1073742007
    case kp_leftbrace = 1073742008
    case kp_rightbrace = 1073742009
    case kp_tab = 1073742010
    case kp_backspace = 1073742011
    case kp_a = 1073742012
    case kp_b = 1073742013
    case kp_c = 1073742014
    case kp_d = 1073742015
    case kp_e = 1073742016
    case kp_f = 1073742017
    case kp_xor = 1073742018
    case kp_power = 1073742019
    case kp_percent = 1073742020
    case kp_less = 1073742021
    case kp_greater = 1073742022
    case kp_ampersand = 1073742023
    case kp_dblampersand = 1073742024
    case kp_verticalbar = 1073742025
    case kp_dblverticalbar = 1073742026
    case kp_colon = 1073742027
    case kp_hash = 1073742028
    case kp_space = 1073742029
    case kp_at = 1073742030
    case kp_exclam = 1073742031
    case kp_memstore = 1073742032
    case kp_memrecall = 1073742033
    case kp_memclear = 1073742034
    case kp_memadd = 1073742035
    case kp_memsubtract = 1073742036
    case kp_memmultiply = 1073742037
    case kp_memdivide = 1073742038
    case kp_plusminus = 1073742039
    case kp_clear = 1073742040
    case kp_clearentry = 1073742041
    case kp_binary = 1073742042
    case kp_octal = 1073742043
    case kp_decimal = 1073742044
    case kp_hexadecimal = 1073742045
    case lctrl = 1073742048
    case lshift = 1073742049
    case lalt = 1073742050
    case lgui = 1073742051
    case rctrl = 1073742052
    case rshift = 1073742053
    case ralt = 1073742054
    case rgui = 1073742055
    case mode = 1073742081
    case audionext = 1073742082
    case audioprev = 1073742083
    case audiostop = 1073742084
    case audioplay = 1073742085
    case audiomute = 1073742086
    case mediaselect = 1073742087
    case www = 1073742088
    case mail = 1073742089
    case calculator = 1073742090
    case computer = 1073742091
    case ac_search = 1073742092
    case ac_home = 1073742093
    case ac_back = 1073742094
    case ac_forward = 1073742095
    case ac_stop = 1073742096
    case ac_refresh = 1073742097
    case ac_bookmarks = 1073742098
    case brightnessdown = 1073742099
    case brightnessup = 1073742100
    case displayswitch = 1073742101
    case kbdillumtoggle = 1073742102
    case kbdillumdown = 1073742103
    case kbdillumup = 1073742104
    case eject = 1073742105
    case sleep = 1073742106
    case app1 = 1073742107
    case app2 = 1073742108
    case audiorewind = 1073742109
    case audiofastforward = 1073742110
    case softleft = 1073742111
    case softright = 1073742112
    case call = 1073742113
    case endcall = 1073742114

    /// 
    /// Get the key code corresponding to the given scancode according to the
    /// current keyboard layout.
    /// 
    /// If you want to get the keycode as it would be delivered in key events,
    /// including options specified in SDL_HINT_KEYCODE_OPTIONS, then you should
    /// pass `key_event` as true. Otherwise this function simply translates the
    /// scancode based on the given modifier state.
    /// 
    /// \param scancode the desired SDL_Scancode to query.
    /// \param modifiers the modifier state to use when translating the scancode to
    ///                 a keycode.
    /// \param forKeyEvent true if the keycode will be used in key events.
    /// \returns the SDL_Keycode that corresponds to the given SDL_Scancode.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyName
    /// \sa SDL_GetScancodeFromKey
    /// 
    @SDLKeyConversionActor
    public static func from(scancode: SDLScancode, modifiers: SDLKeyModifiers, forKeyEvent: Bool) -> SDLKeycode {
        return SDLKeycode(rawValue: SDL_GetKeyFromScancode(SDL_Scancode(scancode.rawValue), modifiers.rawValue, forKeyEvent))!
    }

    /// 
    /// Get a key code from a human-readable name.
    /// 
    /// \param name the human-readable key name.
    /// \returns key code, or `SDLK_UNKNOWN` if the name wasn't recognized; call
    ///          SDL_GetError() for more information.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyFromScancode
    /// \sa SDL_GetKeyName
    /// \sa SDL_GetScancodeFromName
    /// 
    @SDLKeyConversionActor
    public static func from(name: String) throws -> SDLKeycode {
        let k = SDL_GetKeyFromName(name)
        if k == SDLK_UNKNOWN {
            throw SDLError()
        }
        return SDLKeycode(rawValue: k)!
    }

    /// 
    /// Get a human-readable name for a key.
    /// 
    /// If the key doesn't have a name, this function returns an empty string ("").
    /// 
    /// Letters will be presented in their uppercase form, if applicable.
    /// 
    /// \returns a UTF-8 encoded string of the key name.
    /// 
    /// \since This function is available since SDL 3.2.0.
    /// 
    /// \sa SDL_GetKeyFromName
    /// \sa SDL_GetKeyFromScancode
    /// \sa SDL_GetScancodeFromKey
    /// 
    @SDLKeyConversionActor
    public var name: String {
        return String(cString: SDL_GetKeyName(SDL_Keycode(UInt32(self.rawValue))))
    }
}

public struct SDLKeyModifiers: OptionSet {
    public let rawValue: UInt16
    public init(rawValue val: UInt16) {rawValue = val}
    public static let none = SDLKeyModifiers([])
    public static let leftShift = SDLKeyModifiers(rawValue: 0x0001)
    public static let rightShift = SDLKeyModifiers(rawValue: 0x0002)
    public static let leftCtrl = SDLKeyModifiers(rawValue: 0x0040)
    public static let rightCtrl = SDLKeyModifiers(rawValue: 0x0080)
    public static let leftAlt = SDLKeyModifiers(rawValue: 0x0100)
    public static let rightAlt = SDLKeyModifiers(rawValue: 0x0200)
    public static let leftGUI = SDLKeyModifiers(rawValue: 0x0400)
    public static let rightGUI = SDLKeyModifiers(rawValue: 0x0800)
    public static let numLock = SDLKeyModifiers(rawValue: 0x1000)
    public static let capsLock = SDLKeyModifiers(rawValue: 0x2000)
    public static let mode = SDLKeyModifiers(rawValue: 0x4000)
    public static let scrollLock = SDLKeyModifiers(rawValue: 0x8000)
    public static let ctrl = SDLKeyModifiers([.leftCtrl, .rightCtrl])
    public static let shift = SDLKeyModifiers([.leftShift, .rightShift])
    public static let alt = SDLKeyModifiers([.leftAlt, .rightAlt])
    public static let gui = SDLKeyModifiers([.leftGUI, .rightGUI])
}
