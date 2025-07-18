// grep '#define SDL_HINT' /usr/include/SDL3/SDL_hints.h | sed -E 's/^#define SDL_HINT_(\w*) .*$/    public static var \1: String? {\n        get {\n            if let ptr = SDL_GetHint(SDL_HINT_\1) {\n                return String(cString: ptr)\n            } else {\n                return nil\n            }\n        } set (value) {\n            SDL_SetHint(SDL_HINT_\1, value)\n        }\n    }\n/g' | lua -e 'for line in io.lines() do io.write(line:gsub("var ([%w_]+)", function(s) return "var " .. s:gsub("%u", string.lower):gsub("_(%a)", string.upper) end) .. "\n") end'
import SDL3_Native

public enum SDLHint {
    public static var allowAltTabWhileGrabbed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED, value)
        }
    }

    public static var androidAllowRecreateActivity: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_ALLOW_RECREATE_ACTIVITY, value)
        }
    }

    public static var androidBlockOnPause: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_BLOCK_ON_PAUSE, value)
        }
    }

    public static var androidLowLatencyAudio: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ANDROID_LOW_LATENCY_AUDIO) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_LOW_LATENCY_AUDIO, value)
        }
    }

    public static var androidTrapBackButton: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ANDROID_TRAP_BACK_BUTTON) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ANDROID_TRAP_BACK_BUTTON, value)
        }
    }

    public static var appId: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_APP_ID) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_APP_ID, value)
        }
    }

    public static var appName: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_APP_NAME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_APP_NAME, value)
        }
    }

    public static var appleTvControllerUiEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_APPLE_TV_CONTROLLER_UI_EVENTS, value)
        }
    }

    public static var appleTvRemoteAllowRotation: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_APPLE_TV_REMOTE_ALLOW_ROTATION, value)
        }
    }

    public static var audioAlsaDefaultDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_DEVICE, value)
        }
    }

    public static var audioAlsaDefaultPlaybackDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_PLAYBACK_DEVICE, value)
        }
    }

    public static var audioAlsaDefaultRecordingDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_ALSA_DEFAULT_RECORDING_DEVICE, value)
        }
    }

    public static var audioCategory: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_CATEGORY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_CATEGORY, value)
        }
    }

    public static var audioChannels: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_CHANNELS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_CHANNELS, value)
        }
    }

    public static var audioDeviceAppIconName: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DEVICE_APP_ICON_NAME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_APP_ICON_NAME, value)
        }
    }

    public static var audioDeviceSampleFrames: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DEVICE_SAMPLE_FRAMES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_SAMPLE_FRAMES, value)
        }
    }

    public static var audioDeviceStreamName: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DEVICE_STREAM_NAME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_STREAM_NAME, value)
        }
    }

    public static var audioDeviceStreamRole: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DEVICE_STREAM_ROLE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DEVICE_STREAM_ROLE, value)
        }
    }

    public static var audioDiskInputFile: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DISK_INPUT_FILE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DISK_INPUT_FILE, value)
        }
    }

    public static var audioDiskOutputFile: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DISK_OUTPUT_FILE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DISK_OUTPUT_FILE, value)
        }
    }

    public static var audioDiskTimescale: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DISK_TIMESCALE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DISK_TIMESCALE, value)
        }
    }

    public static var audioDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DRIVER, value)
        }
    }

    public static var audioDummyTimescale: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_DUMMY_TIMESCALE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_DUMMY_TIMESCALE, value)
        }
    }

    public static var audioFormat: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_FORMAT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_FORMAT, value)
        }
    }

    public static var audioFrequency: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_FREQUENCY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_FREQUENCY, value)
        }
    }

    public static var audioIncludeMonitors: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUDIO_INCLUDE_MONITORS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUDIO_INCLUDE_MONITORS, value)
        }
    }

    public static var autoUpdateJoysticks: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUTO_UPDATE_JOYSTICKS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUTO_UPDATE_JOYSTICKS, value)
        }
    }

    public static var autoUpdateSensors: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_AUTO_UPDATE_SENSORS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_AUTO_UPDATE_SENSORS, value)
        }
    }

    public static var bmpSaveLegacyFormat: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_BMP_SAVE_LEGACY_FORMAT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_BMP_SAVE_LEGACY_FORMAT, value)
        }
    }

    public static var cameraDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_CAMERA_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_CAMERA_DRIVER, value)
        }
    }

    public static var cpuFeatureMask: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_CPU_FEATURE_MASK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_CPU_FEATURE_MASK, value)
        }
    }

    public static var joystickDirectinput: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_DIRECTINPUT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_DIRECTINPUT, value)
        }
    }

    public static var fileDialogDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_FILE_DIALOG_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_FILE_DIALOG_DRIVER, value)
        }
    }

    public static var displayUsableBounds: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_DISPLAY_USABLE_BOUNDS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_DISPLAY_USABLE_BOUNDS, value)
        }
    }

    public static var emscriptenAsyncify: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EMSCRIPTEN_ASYNCIFY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_ASYNCIFY, value)
        }
    }

    public static var emscriptenCanvasSelector: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_CANVAS_SELECTOR, value)
        }
    }

    public static var emscriptenKeyboardElement: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EMSCRIPTEN_KEYBOARD_ELEMENT, value)
        }
    }

    public static var enableScreenKeyboard: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ENABLE_SCREEN_KEYBOARD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ENABLE_SCREEN_KEYBOARD, value)
        }
    }

    public static var evdevDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EVDEV_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EVDEV_DEVICES, value)
        }
    }

    public static var eventLogging: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EVENT_LOGGING) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EVENT_LOGGING, value)
        }
    }

    public static var forceRaisewindow: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_FORCE_RAISEWINDOW) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_FORCE_RAISEWINDOW, value)
        }
    }

    public static var framebufferAcceleration: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_FRAMEBUFFER_ACCELERATION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_FRAMEBUFFER_ACCELERATION, value)
        }
    }

    public static var gamecontrollerconfig: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLERCONFIG) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERCONFIG, value)
        }
    }

    public static var gamecontrollerconfigFile: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLERCONFIG_FILE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERCONFIG_FILE, value)
        }
    }

    public static var gamecontrollertype: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLERTYPE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLERTYPE, value)
        }
    }

    public static var gamecontrollerIgnoreDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES, value)
        }
    }

    public static var gamecontrollerIgnoreDevicesExcept: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT, value)
        }
    }

    public static var gamecontrollerSensorFusion: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GAMECONTROLLER_SENSOR_FUSION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GAMECONTROLLER_SENSOR_FUSION, value)
        }
    }

    public static var gdkTextinputDefaultText: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_DEFAULT_TEXT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_DEFAULT_TEXT, value)
        }
    }

    public static var gdkTextinputDescription: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_DESCRIPTION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_DESCRIPTION, value)
        }
    }

    public static var gdkTextinputMaxLength: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_MAX_LENGTH, value)
        }
    }

    public static var gdkTextinputScope: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_SCOPE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_SCOPE, value)
        }
    }

    public static var gdkTextinputTitle: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GDK_TEXTINPUT_TITLE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GDK_TEXTINPUT_TITLE, value)
        }
    }

    public static var hidapiLibusb: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_HIDAPI_LIBUSB) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_LIBUSB, value)
        }
    }

    public static var hidapiLibusbWhitelist: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_HIDAPI_LIBUSB_WHITELIST) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_LIBUSB_WHITELIST, value)
        }
    }

    public static var hidapiUdev: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_HIDAPI_UDEV) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_UDEV, value)
        }
    }

    public static var gpuDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_GPU_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_GPU_DRIVER, value)
        }
    }

    public static var hidapiEnumerateOnlyControllers: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_ENUMERATE_ONLY_CONTROLLERS, value)
        }
    }

    public static var hidapiIgnoreDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_HIDAPI_IGNORE_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_HIDAPI_IGNORE_DEVICES, value)
        }
    }

    public static var imeImplementedUi: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_IME_IMPLEMENTED_UI) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_IME_IMPLEMENTED_UI, value)
        }
    }

    public static var iosHideHomeIndicator: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_IOS_HIDE_HOME_INDICATOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_IOS_HIDE_HOME_INDICATOR, value)
        }
    }

    public static var joystickAllowBackgroundEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, value)
        }
    }

    public static var joystickArcadestickDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES, value)
        }
    }

    public static var joystickArcadestickDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ARCADESTICK_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickBlacklistDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_BLACKLIST_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_BLACKLIST_DEVICES, value)
        }
    }

    public static var joystickBlacklistDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_BLACKLIST_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_DEVICE, value)
        }
    }

    public static var joystickEnhancedReports: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ENHANCED_REPORTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ENHANCED_REPORTS, value)
        }
    }

    public static var joystickFlightstickDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES, value)
        }
    }

    public static var joystickFlightstickDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_FLIGHTSTICK_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickGameinput: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_GAMEINPUT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_GAMEINPUT, value)
        }
    }

    public static var joystickGamecubeDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_GAMECUBE_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_GAMECUBE_DEVICES, value)
        }
    }

    public static var joystickGamecubeDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_GAMECUBE_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickHidapi: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI, value)
        }
    }

    public static var joystickHidapiCombineJoyCons: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_COMBINE_JOY_CONS, value)
        }
    }

    public static var joystickHidapiGamecube: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE, value)
        }
    }

    public static var joystickHidapiGamecubeRumbleBrake: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_GAMECUBE_RUMBLE_BRAKE, value)
        }
    }

    public static var joystickHidapiJoyCons: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_JOY_CONS, value)
        }
    }

    public static var joystickHidapiJoyconHomeLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_JOYCON_HOME_LED, value)
        }
    }

    public static var joystickHidapiLuna: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_LUNA) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_LUNA, value)
        }
    }

    public static var joystickHidapiNintendoClassic: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_NINTENDO_CLASSIC, value)
        }
    }

    public static var joystickHidapiPs3: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3, value)
        }
    }

    public static var joystickHidapiPs3SixaxisDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS3_SIXAXIS_DRIVER, value)
        }
    }

    public static var joystickHidapiPs4: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4, value)
        }
    }

    public static var joystickHidapiPs4ReportInterval: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS4_REPORT_INTERVAL, value)
        }
    }

    public static var joystickHidapiPs5: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5, value)
        }
    }

    public static var joystickHidapiPs5PlayerLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_PS5_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiShield: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SHIELD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SHIELD, value)
        }
    }

    public static var joystickHidapiStadia: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STADIA) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STADIA, value)
        }
    }

    public static var joystickHidapiSteam: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM, value)
        }
    }

    public static var joystickHidapiSteamHomeLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM_HOME_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM_HOME_LED, value)
        }
    }

    public static var joystickHidapiSteamdeck: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAMDECK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAMDECK, value)
        }
    }

    public static var joystickHidapiSteamHori: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM_HORI) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_STEAM_HORI, value)
        }
    }

    public static var joystickHidapiSwitch: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH, value)
        }
    }

    public static var joystickHidapiSwitchHomeLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_HOME_LED, value)
        }
    }

    public static var joystickHidapiSwitchPlayerLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_SWITCH_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiVerticalJoyCons: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS, value)
        }
    }

    public static var joystickHidapiWii: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_WII) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_WII, value)
        }
    }

    public static var joystickHidapiWiiPlayerLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_WII_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiXbox: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX, value)
        }
    }

    public static var joystickHidapiXbox_360: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360, value)
        }
    }

    public static var joystickHidapiXbox_360PlayerLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_PLAYER_LED, value)
        }
    }

    public static var joystickHidapiXbox_360Wireless: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_360_WIRELESS, value)
        }
    }

    public static var joystickHidapiXboxOne: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE, value)
        }
    }

    public static var joystickHidapiXboxOneHomeLed: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HIDAPI_XBOX_ONE_HOME_LED, value)
        }
    }

    public static var joystickIokit: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_IOKIT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_IOKIT, value)
        }
    }

    public static var joystickLinuxClassic: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_LINUX_CLASSIC) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_LINUX_CLASSIC, value)
        }
    }

    public static var joystickLinuxDeadzones: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_LINUX_DEADZONES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_LINUX_DEADZONES, value)
        }
    }

    public static var joystickLinuxDigitalHats: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_LINUX_DIGITAL_HATS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_LINUX_DIGITAL_HATS, value)
        }
    }

    public static var joystickLinuxHatDeadzones: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_LINUX_HAT_DEADZONES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_LINUX_HAT_DEADZONES, value)
        }
    }

    public static var joystickMfi: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_MFI) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_MFI, value)
        }
    }

    public static var joystickRawinput: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_RAWINPUT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_RAWINPUT, value)
        }
    }

    public static var joystickRawinputCorrelateXinput: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_RAWINPUT_CORRELATE_XINPUT, value)
        }
    }

    public static var joystickRogChakram: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ROG_CHAKRAM) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ROG_CHAKRAM, value)
        }
    }

    public static var joystickThread: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_THREAD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_THREAD, value)
        }
    }

    public static var joystickThrottleDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_THROTTLE_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_THROTTLE_DEVICES, value)
        }
    }

    public static var joystickThrottleDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_THROTTLE_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_THROTTLE_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickWgi: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_WGI) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_WGI, value)
        }
    }

    public static var joystickWheelDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_WHEEL_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_WHEEL_DEVICES, value)
        }
    }

    public static var joystickWheelDevicesExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_WHEEL_DEVICES_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_WHEEL_DEVICES_EXCLUDED, value)
        }
    }

    public static var joystickZeroCenteredDevices: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_ZERO_CENTERED_DEVICES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_ZERO_CENTERED_DEVICES, value)
        }
    }

    public static var joystickHapticAxes: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_JOYSTICK_HAPTIC_AXES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_JOYSTICK_HAPTIC_AXES, value)
        }
    }

    public static var keycodeOptions: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_KEYCODE_OPTIONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_KEYCODE_OPTIONS, value)
        }
    }

    public static var kmsdrmDeviceIndex: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_KMSDRM_DEVICE_INDEX) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_KMSDRM_DEVICE_INDEX, value)
        }
    }

    public static var kmsdrmRequireDrmMaster: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_KMSDRM_REQUIRE_DRM_MASTER, value)
        }
    }

    public static var logging: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_LOGGING) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_LOGGING, value)
        }
    }

    public static var macBackgroundApp: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAC_BACKGROUND_APP) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_BACKGROUND_APP, value)
        }
    }

    public static var macCtrlClickEmulateRightClick: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK, value)
        }
    }

    public static var macOpenglAsyncDispatch: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_OPENGL_ASYNC_DISPATCH, value)
        }
    }

    public static var macOptionAsAlt: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAC_OPTION_AS_ALT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_OPTION_AS_ALT, value)
        }
    }

    public static var macScrollMomentum: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAC_SCROLL_MOMENTUM) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAC_SCROLL_MOMENTUM, value)
        }
    }

    public static var mainCallbackRate: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MAIN_CALLBACK_RATE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MAIN_CALLBACK_RATE, value)
        }
    }

    public static var mouseAutoCapture: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_AUTO_CAPTURE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_AUTO_CAPTURE, value)
        }
    }

    public static var mouseDoubleClickRadius: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_RADIUS, value)
        }
    }

    public static var mouseDoubleClickTime: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_TIME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_DOUBLE_CLICK_TIME, value)
        }
    }

    public static var mouseDefaultSystemCursor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_DEFAULT_SYSTEM_CURSOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_DEFAULT_SYSTEM_CURSOR, value)
        }
    }

    public static var mouseEmulateWarpWithRelative: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_EMULATE_WARP_WITH_RELATIVE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_EMULATE_WARP_WITH_RELATIVE, value)
        }
    }

    public static var mouseFocusClickthrough: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, value)
        }
    }

    public static var mouseNormalSpeedScale: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_NORMAL_SPEED_SCALE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_NORMAL_SPEED_SCALE, value)
        }
    }

    public static var mouseRelativeModeCenter: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_MODE_CENTER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_MODE_CENTER, value)
        }
    }

    public static var mouseRelativeSpeedScale: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_SPEED_SCALE, value)
        }
    }

    public static var mouseRelativeSystemScale: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_SYSTEM_SCALE, value)
        }
    }

    public static var mouseRelativeWarpMotion: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_WARP_MOTION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_WARP_MOTION, value)
        }
    }

    public static var mouseRelativeCursorVisible: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_RELATIVE_CURSOR_VISIBLE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_RELATIVE_CURSOR_VISIBLE, value)
        }
    }

    public static var mouseTouchEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MOUSE_TOUCH_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MOUSE_TOUCH_EVENTS, value)
        }
    }

    public static var muteConsoleKeyboard: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_MUTE_CONSOLE_KEYBOARD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_MUTE_CONSOLE_KEYBOARD, value)
        }
    }

    public static var noSignalHandlers: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_NO_SIGNAL_HANDLERS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, value)
        }
    }

    public static var openglLibrary: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_OPENGL_LIBRARY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_OPENGL_LIBRARY, value)
        }
    }

    public static var eglLibrary: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_EGL_LIBRARY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_EGL_LIBRARY, value)
        }
    }

    public static var openglEsDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_OPENGL_ES_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_OPENGL_ES_DRIVER, value)
        }
    }

    public static var openvrLibrary: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_OPENVR_LIBRARY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_OPENVR_LIBRARY, value)
        }
    }

    public static var orientations: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ORIENTATIONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ORIENTATIONS, value)
        }
    }

    public static var pollSentinel: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_POLL_SENTINEL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_POLL_SENTINEL, value)
        }
    }

    public static var preferredLocales: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_PREFERRED_LOCALES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_PREFERRED_LOCALES, value)
        }
    }

    public static var quitOnLastWindowClose: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_QUIT_ON_LAST_WINDOW_CLOSE, value)
        }
    }

    public static var renderDirect3dThreadsafe: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_DIRECT3D_THREADSAFE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DIRECT3D_THREADSAFE, value)
        }
    }

    public static var renderDirect3d11Debug: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_DIRECT3D11_DEBUG) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DIRECT3D11_DEBUG, value)
        }
    }

    public static var renderVulkanDebug: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_VULKAN_DEBUG) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_VULKAN_DEBUG, value)
        }
    }

    public static var renderGpuDebug: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_GPU_DEBUG) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_GPU_DEBUG, value)
        }
    }

    public static var renderGpuLowPower: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_GPU_LOW_POWER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_GPU_LOW_POWER, value)
        }
    }

    public static var renderDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_DRIVER, value)
        }
    }

    public static var renderLineMethod: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_LINE_METHOD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_LINE_METHOD, value)
        }
    }

    public static var renderMetalPreferLowPowerDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_METAL_PREFER_LOW_POWER_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_METAL_PREFER_LOW_POWER_DEVICE, value)
        }
    }

    public static var renderVsync: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RENDER_VSYNC) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RENDER_VSYNC, value)
        }
    }

    public static var returnKeyHidesIme: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RETURN_KEY_HIDES_IME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RETURN_KEY_HIDES_IME, value)
        }
    }

    public static var rogGamepadMice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ROG_GAMEPAD_MICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ROG_GAMEPAD_MICE, value)
        }
    }

    public static var rogGamepadMiceExcluded: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ROG_GAMEPAD_MICE_EXCLUDED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ROG_GAMEPAD_MICE_EXCLUDED, value)
        }
    }

    public static var rpiVideoLayer: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_RPI_VIDEO_LAYER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_RPI_VIDEO_LAYER, value)
        }
    }

    public static var screensaverInhibitActivityName: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_SCREENSAVER_INHIBIT_ACTIVITY_NAME, value)
        }
    }

    public static var shutdownDbusOnQuit: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_SHUTDOWN_DBUS_ON_QUIT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_SHUTDOWN_DBUS_ON_QUIT, value)
        }
    }

    public static var storageTitleDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_STORAGE_TITLE_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_STORAGE_TITLE_DRIVER, value)
        }
    }

    public static var storageUserDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_STORAGE_USER_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_STORAGE_USER_DRIVER, value)
        }
    }

    public static var threadForceRealtimeTimeCritical: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL, value)
        }
    }

    public static var threadPriorityPolicy: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_THREAD_PRIORITY_POLICY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_THREAD_PRIORITY_POLICY, value)
        }
    }

    public static var timerResolution: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_TIMER_RESOLUTION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_TIMER_RESOLUTION, value)
        }
    }

    public static var touchMouseEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_TOUCH_MOUSE_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, value)
        }
    }

    public static var trackpadIsTouchOnly: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_TRACKPAD_IS_TOUCH_ONLY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_TRACKPAD_IS_TOUCH_ONLY, value)
        }
    }

    public static var tvRemoteAsJoystick: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_TV_REMOTE_AS_JOYSTICK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_TV_REMOTE_AS_JOYSTICK, value)
        }
    }

    public static var videoAllowScreensaver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, value)
        }
    }

    public static var videoDisplayPriority: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_DISPLAY_PRIORITY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DISPLAY_PRIORITY, value)
        }
    }

    public static var videoDoubleBuffer: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_DOUBLE_BUFFER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DOUBLE_BUFFER, value)
        }
    }

    public static var videoDriver: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_DRIVER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DRIVER, value)
        }
    }

    public static var videoDummySaveFrames: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_DUMMY_SAVE_FRAMES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_DUMMY_SAVE_FRAMES, value)
        }
    }

    public static var videoEglAllowGetdisplayFallback: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_EGL_ALLOW_GETDISPLAY_FALLBACK, value)
        }
    }

    public static var videoForceEgl: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_FORCE_EGL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_FORCE_EGL, value)
        }
    }

    public static var videoMacFullscreenSpaces: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_SPACES, value)
        }
    }

    public static var videoMacFullscreenMenuVisibility: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_MAC_FULLSCREEN_MENU_VISIBILITY, value)
        }
    }

    public static var videoMinimizeOnFocusLoss: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, value)
        }
    }

    public static var videoOffscreenSaveFrames: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_OFFSCREEN_SAVE_FRAMES) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_OFFSCREEN_SAVE_FRAMES, value)
        }
    }

    public static var videoSyncWindowOperations: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_SYNC_WINDOW_OPERATIONS, value)
        }
    }

    public static var videoWaylandAllowLibdecor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_ALLOW_LIBDECOR, value)
        }
    }

    public static var videoWaylandModeEmulation: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_MODE_EMULATION, value)
        }
    }

    public static var videoWaylandModeScaling: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_MODE_SCALING) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_MODE_SCALING, value)
        }
    }

    public static var videoWaylandPreferLibdecor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_PREFER_LIBDECOR, value)
        }
    }

    public static var videoWaylandScaleToDisplay: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WAYLAND_SCALE_TO_DISPLAY, value)
        }
    }

    public static var videoWinD3dcompiler: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_WIN_D3DCOMPILER) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_WIN_D3DCOMPILER, value)
        }
    }

    public static var videoX11NetWmBypassCompositor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR, value)
        }
    }

    public static var videoX11NetWmPing: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_NET_WM_PING) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_NET_WM_PING, value)
        }
    }

    public static var videoX11Nodirectcolor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_NODIRECTCOLOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_NODIRECTCOLOR, value)
        }
    }

    public static var videoX11ScalingFactor: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_SCALING_FACTOR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_SCALING_FACTOR, value)
        }
    }

    public static var videoX11Visualid: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_VISUALID) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_VISUALID, value)
        }
    }

    public static var videoX11WindowVisualid: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_WINDOW_VISUALID) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_WINDOW_VISUALID, value)
        }
    }

    public static var videoX11Xrandr: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VIDEO_X11_XRANDR) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VIDEO_X11_XRANDR, value)
        }
    }

    public static var vitaEnableBackTouch: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_ENABLE_BACK_TOUCH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_ENABLE_BACK_TOUCH, value)
        }
    }

    public static var vitaEnableFrontTouch: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_ENABLE_FRONT_TOUCH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_ENABLE_FRONT_TOUCH, value)
        }
    }

    public static var vitaModulePath: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_MODULE_PATH) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_MODULE_PATH, value)
        }
    }

    public static var vitaPvrInit: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_PVR_INIT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_PVR_INIT, value)
        }
    }

    public static var vitaResolution: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_RESOLUTION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_RESOLUTION, value)
        }
    }

    public static var vitaPvrOpengl: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_PVR_OPENGL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_PVR_OPENGL, value)
        }
    }

    public static var vitaTouchMouseDevice: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VITA_TOUCH_MOUSE_DEVICE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VITA_TOUCH_MOUSE_DEVICE, value)
        }
    }

    public static var vulkanDisplay: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VULKAN_DISPLAY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VULKAN_DISPLAY, value)
        }
    }

    public static var vulkanLibrary: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_VULKAN_LIBRARY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_VULKAN_LIBRARY, value)
        }
    }

    public static var waveFactChunk: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WAVE_FACT_CHUNK) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_FACT_CHUNK, value)
        }
    }

    public static var waveChunkLimit: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WAVE_CHUNK_LIMIT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_CHUNK_LIMIT, value)
        }
    }

    public static var waveRiffChunkSize: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WAVE_RIFF_CHUNK_SIZE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_RIFF_CHUNK_SIZE, value)
        }
    }

    public static var waveTruncation: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WAVE_TRUNCATION) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WAVE_TRUNCATION, value)
        }
    }

    public static var windowActivateWhenRaised: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_RAISED, value)
        }
    }

    public static var windowActivateWhenShown: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_ACTIVATE_WHEN_SHOWN, value)
        }
    }

    public static var windowAllowTopmost: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOW_ALLOW_TOPMOST) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_ALLOW_TOPMOST, value)
        }
    }

    public static var windowFrameUsableWhileCursorHidden: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN, value)
        }
    }

    public static var windowsCloseOnAltF4: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_CLOSE_ON_ALT_F4, value)
        }
    }

    public static var windowsEnableMenuMnemonics: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_ENABLE_MENU_MNEMONICS, value)
        }
    }

    public static var windowsEnableMessageloop: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_ENABLE_MESSAGELOOP, value)
        }
    }

    public static var windowsGameinput: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_GAMEINPUT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_GAMEINPUT, value)
        }
    }

    public static var windowsRawKeyboard: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_RAW_KEYBOARD) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_RAW_KEYBOARD, value)
        }
    }

    public static var windowsForceSemaphoreKernel: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_FORCE_SEMAPHORE_KERNEL, value)
        }
    }

    public static var windowsIntresourceIcon: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON, value)
        }
    }

    public static var windowsIntresourceIconSmall: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_INTRESOURCE_ICON_SMALL, value)
        }
    }

    public static var windowsUseD3d9ex: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_USE_D3D9EX) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_USE_D3D9EX, value)
        }
    }

    public static var windowsEraseBackgroundMode: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_WINDOWS_ERASE_BACKGROUND_MODE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_WINDOWS_ERASE_BACKGROUND_MODE, value)
        }
    }

    public static var x11ForceOverrideRedirect: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_X11_FORCE_OVERRIDE_REDIRECT, value)
        }
    }

    public static var x11WindowType: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_X11_WINDOW_TYPE) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_X11_WINDOW_TYPE, value)
        }
    }

    public static var x11XcbLibrary: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_X11_XCB_LIBRARY) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_X11_XCB_LIBRARY, value)
        }
    }

    public static var xinputEnabled: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_XINPUT_ENABLED) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_XINPUT_ENABLED, value)
        }
    }

    public static var assert: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_ASSERT) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_ASSERT, value)
        }
    }

    public static var penMouseEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_PEN_MOUSE_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_PEN_MOUSE_EVENTS, value)
        }
    }

    public static var penTouchEvents: String? {
        get {
            if let ptr = SDL_GetHint(SDL_HINT_PEN_TOUCH_EVENTS) {
                return String(cString: ptr)
            } else {
                return nil
            }
        } set (value) {
            SDL_SetHint(SDL_HINT_PEN_TOUCH_EVENTS, value)
        }
    }
}
