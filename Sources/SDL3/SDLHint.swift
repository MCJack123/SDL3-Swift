import SDL3_Native

public struct SDLHint {
    public static var accelerometerAsJoystick: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ACCELEROMETER_AS_JOYSTICK))
        } set (value) {
            SDL_SetHint(SDL_HINT_ACCELEROMETER_AS_JOYSTICK, value)
        }
    }

    public static var allowAltTabWhileGrabbed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED))
        } set (value) {
            SDL_SetHint(SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED, value)
        }
    }

    public static var allowTopmost: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ALLOW_TOPMOST))
        } set (value) {
            SDL_SetHint(SDL_HINT_ALLOW_TOPMOST, value)
        }
    }

    public static var androidBlockOnPause: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE))
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE, value)
        }
    }

    public static var androidBlockOnPausePauseaudio: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE_PAUSEAUDIO))
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE_PAUSEAUDIO, value)
        }
    }

    public static var androidTrapBackButton: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ANDROID_TRAP_BACK_BUTTON))
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_TRAP_BACK_BUTTON, value)
        }
    }

    public static var androidAllowRecreateActivity: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY))
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY, value)
        }
    }

    public static var appId: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_APP_ID))
        } set (value) {
            SDL_SetHint(SDL_HINT_APP_ID, value)
        }
    }

    public static var appName: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_APP_NAME))
        } set (value) {
            SDL_SetHint(SDL_HINT_APP_NAME, value)
        }
    }

    public static var appleTvControllerUiEvents: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS))
        } set (value) {
            SDL_SetHint(SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS, value)
        }
    }

    public static var appleTvRemoteAllowRotation: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION))
        } set (value) {
            SDL_SetHint(SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION, value)
        }
    }

    public static var audioCategory: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_CATEGORY))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_CATEGORY, value)
        }
    }

    public static var audioDeviceAppName: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_DEVICE_APP_NAME))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_APP_NAME, value)
        }
    }

    public static var audioDeviceStreamName: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_DEVICE_STREAM_NAME))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_STREAM_NAME, value)
        }
    }

    public static var audioDeviceStreamRole: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_DEVICE_STREAM_ROLE))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_STREAM_ROLE, value)
        }
    }

    public static var autoUpdateJoysticks: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUTO_UPDATE_JOYSTICKS))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUTO_UPDATE_JOYSTICKS, value)
        }
    }

    public static var autoUpdateSensors: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUTO_UPDATE_SENSORS))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUTO_UPDATE_SENSORS, value)
        }
    }

    public static var bmpSaveLegacyFormat: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_BMP_SAVE_LEGACY_FORMAT))
        } set (value) {
            SDL_SetHint(SDL_HINT_BMP_SAVE_LEGACY_FORMAT, value)
        }
    }

    public static var displayUsableBounds: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_DISPLAY_USABLE_BOUNDS))
        } set (value) {
            SDL_SetHint(SDL_HINT_DISPLAY_USABLE_BOUNDS, value)
        }
    }

    public static var emscriptenAsyncify: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_EMSCRIPTEN_ASYNCIFY))
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_ASYNCIFY, value)
        }
    }

    public static var emscriptenCanvasSelector: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR, value)
        }
    }

    public static var emscriptenKeyboardElement: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT))
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT, value)
        }
    }

    public static var enableScreenKeyboard: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ENABLE_SCREEN_KEYBOARD))
        } set (value) {
            SDL_SetHint(SDL_HINT_ENABLE_SCREEN_KEYBOARD, value)
        }
    }

    public static var eventLogging: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_EVENT_LOGGING))
        } set (value) {
            SDL_SetHint(SDL_HINT_EVENT_LOGGING, value)
        }
    }

    public static var forceRaisewindow: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_FORCE_RAISEWINDOW))
        } set (value) {
            SDL_SetHint(SDL_HINT_FORCE_RAISEWINDOW, value)
        }
    }

    public static var windowActivateWhenRaised: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED, value)
        }
    }

    public static var framebufferAcceleration: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_FRAMEBUFFER_ACCELERATION))
        } set (value) {
            SDL_SetHint(SDL_HINT_FRAMEBUFFER_ACCELERATION, value)
        }
    }

    public static var gamecontrollerconfig: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLERCONFIG))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERCONFIG, value)
        }
    }

    public static var gamecontrollerconfigFile: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLERCONFIG_FILE))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERCONFIG_FILE, value)
        }
    }

    public static var gamecontrollertype: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLERTYPE))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERTYPE, value)
        }
    }

    public static var gamecontrollerIgnoreDevices: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES, value)
        }
    }

    public static var gamecontrollerIgnoreDevicesExcept: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT, value)
        }
    }

    public static var gamecontrollerUseButtonLabels: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLER_USE_BUTTON_LABELS))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_USE_BUTTON_LABELS, value)
        }
    }

    public static var gamecontrollerSensorFusion: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GAMECONTROLLER_SENSOR_FUSION))
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_SENSOR_FUSION, value)
        }
    }

    public static var grabKeyboard: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GRAB_KEYBOARD))
        } set (value) {
            SDL_SetHint(SDL_HINT_GRAB_KEYBOARD, value)
        }
    }

    public static var hidapiEnumerateOnlyControllers: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS))
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS, value)
        }
    }

    public static var hidapiIgnoreDevices: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_HIDAPI_IGNORE_DEVICES))
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_IGNORE_DEVICES, value)
        }
    }

    public static var imeInternalEditing: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_IME_INTERNAL_EDITING))
        } set (value) {
            SDL_SetHint(SDL_HINT_IME_INTERNAL_EDITING, value)
        }
    }

    public static var imeShowUi: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_IME_SHOW_UI))
        } set (value) {
            SDL_SetHint(SDL_HINT_IME_SHOW_UI, value)
        }
    }

    public static var imeSupportExtendedText: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_IME_SUPPORT_EXTENDED_TEXT))
        } set (value) {
            SDL_SetHint(SDL_HINT_IME_SUPPORT_EXTENDED_TEXT, value)
        }
    }

    public static var iosHideHomeIndicator: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_IOS_HIDE_HOME_INDICATOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_IOS_HIDE_HOME_INDICATOR, value)
        }
    }

    public static var joystickAllowBackgroundEvents: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, value)
        }
    }

    public static var joystickHidapi: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI, value)
        }
    }

    public static var joystickHidapiGamecube: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE, value)
        }
    }

    public static var joystickGamecubeRumbleBrake: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_GAMECUBE_RUMBLE_BRAKE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_GAMECUBE_RUMBLE_BRAKE, value)
        }
    }

    public static var joystickHidapiJoyCons: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS, value)
        }
    }

    public static var joystickHidapiCombineJoyCons: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS, value)
        }
    }

    public static var joystickHidapiVerticalJoyCons: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS, value)
        }
    }

    public static var joystickHidapiLuna: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_LUNA))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_LUNA, value)
        }
    }

    public static var joystickHidapiNintendoClassic: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC, value)
        }
    }

    public static var joystickHidapiShield: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SHIELD))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SHIELD, value)
        }
    }

    public static var joystickHidapiPs3: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3, value)
        }
    }

    public static var joystickHidapiPs4: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4, value)
        }
    }

    public static var joystickHidapiPs4Rumble: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4_RUMBLE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4_RUMBLE, value)
        }
    }

    public static var joystickHidapiPs5: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5, value)
        }
    }

    public static var joystickHidapiPs5PlayerLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiPs5Rumble: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_RUMBLE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_RUMBLE, value)
        }
    }

    public static var joystickHidapiStadia: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STADIA))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STADIA, value)
        }
    }

    public static var joystickHidapiSteam: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM, value)
        }
    }

    public static var joystickHidapiSwitch: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH, value)
        }
    }

    public static var joystickHidapiSwitchHomeLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED, value)
        }
    }

    public static var joystickHidapiJoyconHomeLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED, value)
        }
    }

    public static var joystickHidapiSwitchPlayerLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiWii: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_WII))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_WII, value)
        }
    }

    public static var joystickHidapiWiiPlayerLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiXbox: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX, value)
        }
    }

    public static var joystickHidapiXbox360: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360, value)
        }
    }

    public static var joystickHidapiXbox360PlayerLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiXbox360Wireless: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS, value)
        }
    }

    public static var joystickHidapiXboxOne: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE, value)
        }
    }

    public static var joystickHidapiXboxOneHomeLed: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED, value)
        }
    }

    public static var joystickRawinput: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_RAWINPUT))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_RAWINPUT, value)
        }
    }

    public static var joystickRawinputCorrelateXinput: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT, value)
        }
    }

    public static var joystickRogChakram: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_ROG_CHAKRAM))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ROG_CHAKRAM, value)
        }
    }

    public static var joystickThread: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_THREAD))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_THREAD, value)
        }
    }

    public static var joystickWgi: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_WGI))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_WGI, value)
        }
    }

    public static var kmsdrmRequireDrmMaster: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER))
        } set (value) {
            SDL_SetHint(SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER, value)
        }
    }

    public static var joystickDevice: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_JOYSTICK_DEVICE))
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_DEVICE, value)
        }
    }

    public static var linuxDigitalHats: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_LINUX_DIGITAL_HATS))
        } set (value) {
            SDL_SetHint(SDL_HINT_LINUX_DIGITAL_HATS, value)
        }
    }

    public static var linuxHatDeadzones: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_LINUX_HAT_DEADZONES))
        } set (value) {
            SDL_SetHint(SDL_HINT_LINUX_HAT_DEADZONES, value)
        }
    }

    public static var linuxJoystickClassic: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_LINUX_JOYSTICK_CLASSIC))
        } set (value) {
            SDL_SetHint(SDL_HINT_LINUX_JOYSTICK_CLASSIC, value)
        }
    }

    public static var linuxJoystickDeadzones: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_LINUX_JOYSTICK_DEADZONES))
        } set (value) {
            SDL_SetHint(SDL_HINT_LINUX_JOYSTICK_DEADZONES, value)
        }
    }

    public static var macBackgroundApp: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MAC_BACKGROUND_APP))
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_BACKGROUND_APP, value)
        }
    }

    public static var macCtrlClickEmulateRightClick: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK))
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK, value)
        }
    }

    public static var macOpenglAsyncDispatch: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH))
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH, value)
        }
    }

    public static var mouseDoubleClickRadius: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS, value)
        }
    }

    public static var mouseDoubleClickTime: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_TIME))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_TIME, value)
        }
    }

    public static var mouseFocusClickthrough: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, value)
        }
    }

    public static var mouseNormalSpeedScale: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_NORMAL_SPEED_SCALE))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_NORMAL_SPEED_SCALE, value)
        }
    }

    public static var mouseRelativeModeCenter: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_MODE_CENTER))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_MODE_CENTER, value)
        }
    }

    public static var mouseRelativeModeWarp: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_MODE_WARP))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_MODE_WARP, value)
        }
    }

    public static var mouseRelativeSpeedScale: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE, value)
        }
    }

    public static var mouseRelativeSystemScale: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE, value)
        }
    }

    public static var mouseRelativeWarpMotion: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_WARP_MOTION))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_WARP_MOTION, value)
        }
    }

    public static var mouseTouchEvents: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_TOUCH_EVENTS))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_TOUCH_EVENTS, value)
        }
    }

    public static var mouseAutoCapture: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_MOUSE_AUTO_CAPTURE))
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_AUTO_CAPTURE, value)
        }
    }

    public static var noSignalHandlers: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_NO_SIGNAL_HANDLERS))
        } set (value) {
            SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, value)
        }
    }

    public static var openglEsDriver: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_OPENGL_ES_DRIVER))
        } set (value) {
            SDL_SetHint(SDL_HINT_OPENGL_ES_DRIVER, value)
        }
    }

    public static var orientations: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_ORIENTATIONS))
        } set (value) {
            SDL_SetHint(SDL_HINT_ORIENTATIONS, value)
        }
    }

    public static var pollSentinel: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_POLL_SENTINEL))
        } set (value) {
            SDL_SetHint(SDL_HINT_POLL_SENTINEL, value)
        }
    }

    public static var preferredLocales: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_PREFERRED_LOCALES))
        } set (value) {
            SDL_SetHint(SDL_HINT_PREFERRED_LOCALES, value)
        }
    }

    public static var qtwaylandContentOrientation: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_QTWAYLAND_CONTENT_ORIENTATION))
        } set (value) {
            SDL_SetHint(SDL_HINT_QTWAYLAND_CONTENT_ORIENTATION, value)
        }
    }

    public static var qtwaylandWindowFlags: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_QTWAYLAND_WINDOW_FLAGS))
        } set (value) {
            SDL_SetHint(SDL_HINT_QTWAYLAND_WINDOW_FLAGS, value)
        }
    }

    public static var renderBatching: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_BATCHING))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_BATCHING, value)
        }
    }

    public static var renderLineMethod: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_LINE_METHOD))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_LINE_METHOD, value)
        }
    }

    public static var renderDirect3d11Debug: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_DIRECT3D11_DEBUG))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DIRECT3D11_DEBUG, value)
        }
    }

    public static var renderDirect3dThreadsafe: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_DIRECT3D_THREADSAFE))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DIRECT3D_THREADSAFE, value)
        }
    }

    public static var renderDriver: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_DRIVER))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DRIVER, value)
        }
    }

    public static var renderOpenglShaders: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_OPENGL_SHADERS))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_OPENGL_SHADERS, value)
        }
    }

    public static var renderScaleQuality: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_SCALE_QUALITY))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, value)
        }
    }

    public static var renderVsync: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RENDER_VSYNC))
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_VSYNC, value)
        }
    }

    public static var ps2DynamicVsync: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_PS2_DYNAMIC_VSYNC))
        } set (value) {
            SDL_SetHint(SDL_HINT_PS2_DYNAMIC_VSYNC, value)
        }
    }

    public static var returnKeyHidesIme: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RETURN_KEY_HIDES_IME))
        } set (value) {
            SDL_SetHint(SDL_HINT_RETURN_KEY_HIDES_IME, value)
        }
    }

    public static var rpiVideoLayer: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_RPI_VIDEO_LAYER))
        } set (value) {
            SDL_SetHint(SDL_HINT_RPI_VIDEO_LAYER, value)
        }
    }

    public static var screensaverInhibitActivityName: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME))
        } set (value) {
            SDL_SetHint(SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME, value)
        }
    }

    public static var threadForceRealtimeTimeCritical: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL))
        } set (value) {
            SDL_SetHint(SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL, value)
        }
    }

    public static var threadPriorityPolicy: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_THREAD_PRIORITY_POLICY))
        } set (value) {
            SDL_SetHint(SDL_HINT_THREAD_PRIORITY_POLICY, value)
        }
    }

    public static var threadStackSize: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_THREAD_STACK_SIZE))
        } set (value) {
            SDL_SetHint(SDL_HINT_THREAD_STACK_SIZE, value)
        }
    }

    public static var timerResolution: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_TIMER_RESOLUTION))
        } set (value) {
            SDL_SetHint(SDL_HINT_TIMER_RESOLUTION, value)
        }
    }

    public static var touchMouseEvents: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_TOUCH_MOUSE_EVENTS))
        } set (value) {
            SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, value)
        }
    }

    public static var vitaTouchMouseDevice: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VITA_TOUCH_MOUSE_DEVICE))
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_TOUCH_MOUSE_DEVICE, value)
        }
    }

    public static var tvRemoteAsJoystick: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_TV_REMOTE_AS_JOYSTICK))
        } set (value) {
            SDL_SetHint(SDL_HINT_TV_REMOTE_AS_JOYSTICK, value)
        }
    }

    public static var videoAllowScreensaver: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, value)
        }
    }

    public static var videoDoubleBuffer: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_DOUBLE_BUFFER))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DOUBLE_BUFFER, value)
        }
    }

    public static var videoEglAllowGetdisplayFallback: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK, value)
        }
    }

    public static var videoExternalContext: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_EXTERNAL_CONTEXT))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_EXTERNAL_CONTEXT, value)
        }
    }

    public static var videoMacFullscreenSpaces: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES, value)
        }
    }

    public static var videoMinimizeOnFocusLoss: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, value)
        }
    }

    public static var videoWaylandAllowLibdecor: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR, value)
        }
    }

    public static var videoWaylandPreferLibdecor: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR, value)
        }
    }

    public static var videoWaylandModeEmulation: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION, value)
        }
    }

    public static var videoWaylandModeScaling: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_MODE_SCALING))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_MODE_SCALING, value)
        }
    }

    public static var videoWaylandEmulateMouseWarp: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_EMULATE_MOUSE_WARP))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_EMULATE_MOUSE_WARP, value)
        }
    }

    public static var videoWindowSharePixelFormat: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT, value)
        }
    }

    public static var videoForeignWindowOpengl: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_FOREIGN_WINDOW_OPENGL))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_FOREIGN_WINDOW_OPENGL, value)
        }
    }

    public static var videoForeignWindowVulkan: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_FOREIGN_WINDOW_VULKAN))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_FOREIGN_WINDOW_VULKAN, value)
        }
    }

    public static var videoWinD3dcompiler: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_WIN_D3DCOMPILER))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WIN_D3DCOMPILER, value)
        }
    }

    public static var videoForceEgl: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_FORCE_EGL))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_FORCE_EGL, value)
        }
    }

    public static var videoX11NetWmBypassCompositor: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR, value)
        }
    }

    public static var videoX11NetWmPing: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_X11_NET_WM_PING))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_NET_WM_PING, value)
        }
    }

    public static var videoX11WindowVisualid: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_X11_WINDOW_VISUALID))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_WINDOW_VISUALID, value)
        }
    }

    public static var videoX11ScalingFactor: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_X11_SCALING_FACTOR))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_SCALING_FACTOR, value)
        }
    }

    public static var videoX11Xrandr: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_X11_XRANDR))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_XRANDR, value)
        }
    }

    public static var waveFactChunk: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WAVE_FACT_CHUNK))
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_FACT_CHUNK, value)
        }
    }

    public static var waveRiffChunkSize: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WAVE_RIFF_CHUNK_SIZE))
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_RIFF_CHUNK_SIZE, value)
        }
    }

    public static var waveTruncation: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WAVE_TRUNCATION))
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_TRUNCATION, value)
        }
    }

    public static var windowsDisableThreadNaming: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_DISABLE_THREAD_NAMING))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_DISABLE_THREAD_NAMING, value)
        }
    }

    public static var windowsEnableMenuMnemonics: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS, value)
        }
    }

    public static var windowsEnableMessageloop: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP, value)
        }
    }

    public static var windowsForceMutexCriticalSections: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_FORCE_MUTEX_CRITICAL_SECTIONS))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_FORCE_MUTEX_CRITICAL_SECTIONS, value)
        }
    }

    public static var windowsForceSemaphoreKernel: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL, value)
        }
    }

    public static var windowsIntresourceIcon: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON, value)
        }
    }

    public static var windowsIntresourceIconSmall: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL, value)
        }
    }

    public static var windowsNoCloseOnAltF4: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_NO_CLOSE_ON_ALT_F4))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_NO_CLOSE_ON_ALT_F4, value)
        }
    }

    public static var windowsUseD3d9ex: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOWS_USE_D3D9EX))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_USE_D3D9EX, value)
        }
    }

    public static var windowFrameUsableWhileCursorHidden: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN, value)
        }
    }

    public static var windowActivateWhenShown: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN, value)
        }
    }

    public static var winrtHandleBackButton: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINRT_HANDLE_BACK_BUTTON))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINRT_HANDLE_BACK_BUTTON, value)
        }
    }

    public static var winrtPrivacyPolicyLabel: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINRT_PRIVACY_POLICY_LABEL))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINRT_PRIVACY_POLICY_LABEL, value)
        }
    }

    public static var winrtPrivacyPolicyUrl: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_WINRT_PRIVACY_POLICY_URL))
        } set (value) {
            SDL_SetHint(SDL_HINT_WINRT_PRIVACY_POLICY_URL, value)
        }
    }

    public static var x11ForceOverrideRedirect: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT))
        } set (value) {
            SDL_SetHint(SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT, value)
        }
    }

    public static var xinputEnabled: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_XINPUT_ENABLED))
        } set (value) {
            SDL_SetHint(SDL_HINT_XINPUT_ENABLED, value)
        }
    }

    public static var directinputEnabled: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_DIRECTINPUT_ENABLED))
        } set (value) {
            SDL_SetHint(SDL_HINT_DIRECTINPUT_ENABLED, value)
        }
    }

    public static var xinputUseOldJoystickMapping: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_XINPUT_USE_OLD_JOYSTICK_MAPPING))
        } set (value) {
            SDL_SetHint(SDL_HINT_XINPUT_USE_OLD_JOYSTICK_MAPPING, value)
        }
    }

    public static var audioIncludeMonitors: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_INCLUDE_MONITORS))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_INCLUDE_MONITORS, value)
        }
    }

    public static var x11WindowType: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_X11_WINDOW_TYPE))
        } set (value) {
            SDL_SetHint(SDL_HINT_X11_WINDOW_TYPE, value)
        }
    }

    public static var quitOnLastWindowClose: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE))
        } set (value) {
            SDL_SetHint(SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE, value)
        }
    }

    public static var videoDriver: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_VIDEO_DRIVER))
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DRIVER, value)
        }
    }

    public static var audioDriver: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_AUDIO_DRIVER))
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DRIVER, value)
        }
    }

    public static var kmsdrmDeviceIndex: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_KMSDRM_DEVICE_INDEX))
        } set (value) {
            SDL_SetHint(SDL_HINT_KMSDRM_DEVICE_INDEX, value)
        }
    }

    public static var trackpadIsTouchOnly: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_TRACKPAD_IS_TOUCH_ONLY))
        } set (value) {
            SDL_SetHint(SDL_HINT_TRACKPAD_IS_TOUCH_ONLY, value)
        }
    }

    public static var gdkTextinputTitle: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_TITLE))
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_TITLE, value)
        }
    }

    public static var gdkTextinputDescription: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_DESCRIPTION))
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_DESCRIPTION, value)
        }
    }

    public static var gdkTextinputDefault: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_DEFAULT))
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_DEFAULT, value)
        }
    }

    public static var gdkTextinputScope: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_SCOPE))
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_SCOPE, value)
        }
    }

    public static var gdkTextinputMaxLength: String {
        get {
            return String(cString: SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH))
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH, value)
        }
    }
}
