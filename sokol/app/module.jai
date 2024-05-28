// machine generated, do not edit

#scope_module;
SOKOL_DEBUG :: true;

DEBUG :: true;
USE_GL :: true;
USE_DLL :: false;

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_app_clib :: #library "sokol_app_windows_x64_gl_debug";   }
            else       { sokol_app_clib :: #library "sokol_app_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_app_clib :: #library "sokol_app_windows_x64_d3d11_debug";   }
            else       { sokol_app_clib :: #library "sokol_app_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_windows_x64_gl_debug";   }
            else       { sokol_app_clib :: #library,no_dll "sokol_app_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_windows_x64_d3d11_debug";   }
            else       { sokol_app_clib :: #library,no_dll "sokol_app_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_app_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_macos_arm64_gl_debug";   }
                else       { sokol_app_clib :: #library,no_dll "sokol_app_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_macos_x64_gl_debug";   }
                else       { sokol_app_clib :: #library,no_dll "sokol_app_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_macos_arm64_metal_debug";   }
                else       { sokol_app_clib :: #library,no_dll "sokol_app_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_macos_x64_metal_debug";   }
                else       { sokol_app_clib :: #library,no_dll "sokol_app_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_app_clib :: #library,no_dll "sokol_app_linux_x64_gl_debug";   }
    else       { sokol_app_clib :: #library,no_dll "sokol_app_linux_x64_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sapp_isvalid :: () -> bool #foreign sokol_app_clib;
sapp_width :: () -> s32 #foreign sokol_app_clib;
sapp_widthf :: () -> float #foreign sokol_app_clib;
sapp_height :: () -> s32 #foreign sokol_app_clib;
sapp_heightf :: () -> float #foreign sokol_app_clib;
sapp_color_format :: () -> s32 #foreign sokol_app_clib;
sapp_depth_format :: () -> s32 #foreign sokol_app_clib;
sapp_sample_count :: () -> s32 #foreign sokol_app_clib;
sapp_high_dpi :: () -> bool #foreign sokol_app_clib;
sapp_dpi_scale :: () -> float #foreign sokol_app_clib;
sapp_show_keyboard :: (show: bool) -> void #foreign sokol_app_clib;
sapp_keyboard_shown :: () -> bool #foreign sokol_app_clib;
sapp_is_fullscreen :: () -> bool #foreign sokol_app_clib;
sapp_toggle_fullscreen :: () -> void #foreign sokol_app_clib;
sapp_show_mouse :: (show: bool) -> void #foreign sokol_app_clib;
sapp_mouse_shown :: () -> bool #foreign sokol_app_clib;
sapp_lock_mouse :: (lock: bool) -> void #foreign sokol_app_clib;
sapp_mouse_locked :: () -> bool #foreign sokol_app_clib;
sapp_set_mouse_cursor :: (cursor: sapp_mouse_cursor) -> void #foreign sokol_app_clib;
sapp_get_mouse_cursor :: () -> sapp_mouse_cursor #foreign sokol_app_clib;
sapp_userdata :: () -> *void #foreign sokol_app_clib;
sapp_query_desc :: () -> sapp_desc #foreign sokol_app_clib;
sapp_request_quit :: () -> void #foreign sokol_app_clib;
sapp_cancel_quit :: () -> void #foreign sokol_app_clib;
sapp_quit :: () -> void #foreign sokol_app_clib;
sapp_consume_event :: () -> void #foreign sokol_app_clib;
sapp_frame_count :: () -> u64 #foreign sokol_app_clib;
sapp_frame_duration :: () -> float64 #foreign sokol_app_clib;
sapp_set_clipboard_string :: (str: *u8) -> void #foreign sokol_app_clib;
sapp_get_clipboard_string :: () -> *u8 #foreign sokol_app_clib;
sapp_set_window_title :: (str: *u8) -> void #foreign sokol_app_clib;
sapp_set_icon :: (icon_desc: *sapp_icon_desc) -> void #foreign sokol_app_clib;
sapp_get_num_dropped_files :: () -> s32 #foreign sokol_app_clib;
sapp_get_dropped_file_path :: (index: s32) -> *u8 #foreign sokol_app_clib;
sapp_run :: (desc: *sapp_desc) -> void #foreign sokol_app_clib;
sapp_egl_get_display :: () -> *void #foreign sokol_app_clib;
sapp_egl_get_context :: () -> *void #foreign sokol_app_clib;
sapp_html5_ask_leave_site :: (ask: bool) -> void #foreign sokol_app_clib;
sapp_html5_get_dropped_file_size :: (index: s32) -> u32 #foreign sokol_app_clib;
sapp_html5_fetch_dropped_file :: (request: *sapp_html5_fetch_request) -> void #foreign sokol_app_clib;
sapp_metal_get_device :: () -> *void #foreign sokol_app_clib;
sapp_metal_get_current_drawable :: () -> *void #foreign sokol_app_clib;
sapp_metal_get_depth_stencil_texture :: () -> *void #foreign sokol_app_clib;
sapp_metal_get_msaa_color_texture :: () -> *void #foreign sokol_app_clib;
sapp_macos_get_window :: () -> *void #foreign sokol_app_clib;
sapp_ios_get_window :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_device :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_device_context :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_swap_chain :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_render_view :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_resolve_view :: () -> *void #foreign sokol_app_clib;
sapp_d3d11_get_depth_stencil_view :: () -> *void #foreign sokol_app_clib;
sapp_win32_get_hwnd :: () -> *void #foreign sokol_app_clib;
sapp_wgpu_get_device :: () -> *void #foreign sokol_app_clib;
sapp_wgpu_get_render_view :: () -> *void #foreign sokol_app_clib;
sapp_wgpu_get_resolve_view :: () -> *void #foreign sokol_app_clib;
sapp_wgpu_get_depth_stencil_view :: () -> *void #foreign sokol_app_clib;
sapp_gl_get_framebuffer :: () -> u32 #foreign sokol_app_clib;
sapp_gl_get_major_version :: () -> s32 #foreign sokol_app_clib;
sapp_gl_get_minor_version :: () -> s32 #foreign sokol_app_clib;
sapp_android_get_native_activity :: () -> *void #foreign sokol_app_clib;

MAX_TOUCHPOINTS :: 8;
MAX_MOUSEBUTTONS :: 3;
MAX_KEYCODES :: 512;
MAX_ICONIMAGES :: 8;

sapp_event_type :: enum u32 {
    INVALID;
    KEY_DOWN;
    KEY_UP;
    CHAR;
    MOUSE_DOWN;
    MOUSE_UP;
    MOUSE_SCROLL;
    MOUSE_MOVE;
    MOUSE_ENTER;
    MOUSE_LEAVE;
    TOUCHES_BEGAN;
    TOUCHES_MOVED;
    TOUCHES_ENDED;
    TOUCHES_CANCELLED;
    RESIZED;
    ICONIFIED;
    RESTORED;
    FOCUSED;
    UNFOCUSED;
    SUSPENDED;
    RESUMED;
    QUIT_REQUESTED;
    CLIPBOARD_PASTED;
    FILES_DROPPED;
}

sapp_keycode :: enum u32 {
    INVALID :: 0;
    SPACE :: 32;
    APOSTROPHE :: 39;
    COMMA :: 44;
    MINUS :: 45;
    PERIOD :: 46;
    SLASH :: 47;
    _0 :: 48;
    _1 :: 49;
    _2 :: 50;
    _3 :: 51;
    _4 :: 52;
    _5 :: 53;
    _6 :: 54;
    _7 :: 55;
    _8 :: 56;
    _9 :: 57;
    SEMICOLON :: 59;
    EQUAL :: 61;
    A :: 65;
    B :: 66;
    C :: 67;
    D :: 68;
    E :: 69;
    F :: 70;
    G :: 71;
    H :: 72;
    I :: 73;
    J :: 74;
    K :: 75;
    L :: 76;
    M :: 77;
    N :: 78;
    O :: 79;
    P :: 80;
    Q :: 81;
    R :: 82;
    S :: 83;
    T :: 84;
    U :: 85;
    V :: 86;
    W :: 87;
    X :: 88;
    Y :: 89;
    Z :: 90;
    LEFT_BRACKET :: 91;
    BACKSLASH :: 92;
    RIGHT_BRACKET :: 93;
    GRAVE_ACCENT :: 96;
    WORLD_1 :: 161;
    WORLD_2 :: 162;
    ESCAPE :: 256;
    ENTER :: 257;
    TAB :: 258;
    BACKSPACE :: 259;
    INSERT :: 260;
    DELETE :: 261;
    RIGHT :: 262;
    LEFT :: 263;
    DOWN :: 264;
    UP :: 265;
    PAGE_UP :: 266;
    PAGE_DOWN :: 267;
    HOME :: 268;
    END :: 269;
    CAPS_LOCK :: 280;
    SCROLL_LOCK :: 281;
    NUM_LOCK :: 282;
    PRINT_SCREEN :: 283;
    PAUSE :: 284;
    F1 :: 290;
    F2 :: 291;
    F3 :: 292;
    F4 :: 293;
    F5 :: 294;
    F6 :: 295;
    F7 :: 296;
    F8 :: 297;
    F9 :: 298;
    F10 :: 299;
    F11 :: 300;
    F12 :: 301;
    F13 :: 302;
    F14 :: 303;
    F15 :: 304;
    F16 :: 305;
    F17 :: 306;
    F18 :: 307;
    F19 :: 308;
    F20 :: 309;
    F21 :: 310;
    F22 :: 311;
    F23 :: 312;
    F24 :: 313;
    F25 :: 314;
    KP_0 :: 320;
    KP_1 :: 321;
    KP_2 :: 322;
    KP_3 :: 323;
    KP_4 :: 324;
    KP_5 :: 325;
    KP_6 :: 326;
    KP_7 :: 327;
    KP_8 :: 328;
    KP_9 :: 329;
    KP_DECIMAL :: 330;
    KP_DIVIDE :: 331;
    KP_MULTIPLY :: 332;
    KP_SUBTRACT :: 333;
    KP_ADD :: 334;
    KP_ENTER :: 335;
    KP_EQUAL :: 336;
    LEFT_SHIFT :: 340;
    LEFT_CONTROL :: 341;
    LEFT_ALT :: 342;
    LEFT_SUPER :: 343;
    RIGHT_SHIFT :: 344;
    RIGHT_CONTROL :: 345;
    RIGHT_ALT :: 346;
    RIGHT_SUPER :: 347;
    MENU :: 348;
}

sapp_android_tooltype :: enum u32 {
    UNKNOWN :: 0;
    FINGER :: 1;
    STYLUS :: 2;
    MOUSE :: 3;
}

sapp_touchpoint :: struct {
    identifier : u64;
    pos_x : float;
    pos_y : float;
    android_tooltype : sapp_android_tooltype;
    changed : bool;
}

sapp_mousebutton :: enum u32 {
    LEFT :: 0;
    RIGHT :: 1;
    MIDDLE :: 2;
    INVALID :: 256;
}

MODIFIER_SHIFT :: 1;
MODIFIER_CTRL :: 2;
MODIFIER_ALT :: 4;
MODIFIER_SUPER :: 8;
MODIFIER_LMB :: 256;
MODIFIER_RMB :: 512;
MODIFIER_MMB :: 1024;

sapp_event :: struct {
    frame_count : u64;
    type : sapp_event_type;
    key_code : sapp_keycode;
    char_code : u32;
    key_repeat : bool;
    modifiers : u32;
    mouse_button : sapp_mousebutton;
    mouse_x : float;
    mouse_y : float;
    mouse_dx : float;
    mouse_dy : float;
    scroll_x : float;
    scroll_y : float;
    num_touches : s32;
    touches : [8]sapp_touchpoint;
    window_width : s32;
    window_height : s32;
    framebuffer_width : s32;
    framebuffer_height : s32;
}

sapp_range :: struct {
    ptr : *void;
    size : u64;
}

sapp_image_desc :: struct {
    width : s32;
    height : s32;
    pixels : sapp_range;
}

sapp_icon_desc :: struct {
    sokol_default : bool;
    images : [8]sapp_image_desc;
}

sapp_allocator :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sapp_log_item :: enum u32 {
    OK;
    MALLOC_FAILED;
    MACOS_INVALID_NSOPENGL_PROFILE;
    WIN32_LOAD_OPENGL32_DLL_FAILED;
    WIN32_CREATE_HELPER_WINDOW_FAILED;
    WIN32_HELPER_WINDOW_GETDC_FAILED;
    WIN32_DUMMY_CONTEXT_SET_PIXELFORMAT_FAILED;
    WIN32_CREATE_DUMMY_CONTEXT_FAILED;
    WIN32_DUMMY_CONTEXT_MAKE_CURRENT_FAILED;
    WIN32_GET_PIXELFORMAT_ATTRIB_FAILED;
    WIN32_WGL_FIND_PIXELFORMAT_FAILED;
    WIN32_WGL_DESCRIBE_PIXELFORMAT_FAILED;
    WIN32_WGL_SET_PIXELFORMAT_FAILED;
    WIN32_WGL_ARB_CREATE_CONTEXT_REQUIRED;
    WIN32_WGL_ARB_CREATE_CONTEXT_PROFILE_REQUIRED;
    WIN32_WGL_OPENGL_3_2_NOT_SUPPORTED;
    WIN32_WGL_OPENGL_PROFILE_NOT_SUPPORTED;
    WIN32_WGL_INCOMPATIBLE_DEVICE_CONTEXT;
    WIN32_WGL_CREATE_CONTEXT_ATTRIBS_FAILED_OTHER;
    WIN32_D3D11_CREATE_DEVICE_AND_SWAPCHAIN_WITH_DEBUG_FAILED;
    WIN32_D3D11_GET_IDXGIFACTORY_FAILED;
    WIN32_D3D11_GET_IDXGIADAPTER_FAILED;
    WIN32_D3D11_QUERY_INTERFACE_IDXGIDEVICE1_FAILED;
    WIN32_REGISTER_RAW_INPUT_DEVICES_FAILED_MOUSE_LOCK;
    WIN32_REGISTER_RAW_INPUT_DEVICES_FAILED_MOUSE_UNLOCK;
    WIN32_GET_RAW_INPUT_DATA_FAILED;
    LINUX_GLX_LOAD_LIBGL_FAILED;
    LINUX_GLX_LOAD_ENTRY_POINTS_FAILED;
    LINUX_GLX_EXTENSION_NOT_FOUND;
    LINUX_GLX_QUERY_VERSION_FAILED;
    LINUX_GLX_VERSION_TOO_LOW;
    LINUX_GLX_NO_GLXFBCONFIGS;
    LINUX_GLX_NO_SUITABLE_GLXFBCONFIG;
    LINUX_GLX_GET_VISUAL_FROM_FBCONFIG_FAILED;
    LINUX_GLX_REQUIRED_EXTENSIONS_MISSING;
    LINUX_GLX_CREATE_CONTEXT_FAILED;
    LINUX_GLX_CREATE_WINDOW_FAILED;
    LINUX_X11_CREATE_WINDOW_FAILED;
    LINUX_EGL_BIND_OPENGL_API_FAILED;
    LINUX_EGL_BIND_OPENGL_ES_API_FAILED;
    LINUX_EGL_GET_DISPLAY_FAILED;
    LINUX_EGL_INITIALIZE_FAILED;
    LINUX_EGL_NO_CONFIGS;
    LINUX_EGL_NO_NATIVE_VISUAL;
    LINUX_EGL_GET_VISUAL_INFO_FAILED;
    LINUX_EGL_CREATE_WINDOW_SURFACE_FAILED;
    LINUX_EGL_CREATE_CONTEXT_FAILED;
    LINUX_EGL_MAKE_CURRENT_FAILED;
    LINUX_X11_OPEN_DISPLAY_FAILED;
    LINUX_X11_QUERY_SYSTEM_DPI_FAILED;
    LINUX_X11_DROPPED_FILE_URI_WRONG_SCHEME;
    ANDROID_UNSUPPORTED_INPUT_EVENT_INPUT_CB;
    ANDROID_UNSUPPORTED_INPUT_EVENT_MAIN_CB;
    ANDROID_READ_MSG_FAILED;
    ANDROID_WRITE_MSG_FAILED;
    ANDROID_MSG_CREATE;
    ANDROID_MSG_RESUME;
    ANDROID_MSG_PAUSE;
    ANDROID_MSG_FOCUS;
    ANDROID_MSG_NO_FOCUS;
    ANDROID_MSG_SET_NATIVE_WINDOW;
    ANDROID_MSG_SET_INPUT_QUEUE;
    ANDROID_MSG_DESTROY;
    ANDROID_UNKNOWN_MSG;
    ANDROID_LOOP_THREAD_STARTED;
    ANDROID_LOOP_THREAD_DONE;
    ANDROID_NATIVE_ACTIVITY_ONSTART;
    ANDROID_NATIVE_ACTIVITY_ONRESUME;
    ANDROID_NATIVE_ACTIVITY_ONSAVEINSTANCESTATE;
    ANDROID_NATIVE_ACTIVITY_ONWINDOWFOCUSCHANGED;
    ANDROID_NATIVE_ACTIVITY_ONPAUSE;
    ANDROID_NATIVE_ACTIVITY_ONSTOP;
    ANDROID_NATIVE_ACTIVITY_ONNATIVEWINDOWCREATED;
    ANDROID_NATIVE_ACTIVITY_ONNATIVEWINDOWDESTROYED;
    ANDROID_NATIVE_ACTIVITY_ONINPUTQUEUECREATED;
    ANDROID_NATIVE_ACTIVITY_ONINPUTQUEUEDESTROYED;
    ANDROID_NATIVE_ACTIVITY_ONCONFIGURATIONCHANGED;
    ANDROID_NATIVE_ACTIVITY_ONLOWMEMORY;
    ANDROID_NATIVE_ACTIVITY_ONDESTROY;
    ANDROID_NATIVE_ACTIVITY_DONE;
    ANDROID_NATIVE_ACTIVITY_ONCREATE;
    ANDROID_CREATE_THREAD_PIPE_FAILED;
    ANDROID_NATIVE_ACTIVITY_CREATE_SUCCESS;
    WGPU_SWAPCHAIN_CREATE_SURFACE_FAILED;
    WGPU_SWAPCHAIN_CREATE_SWAPCHAIN_FAILED;
    WGPU_SWAPCHAIN_CREATE_DEPTH_STENCIL_TEXTURE_FAILED;
    WGPU_SWAPCHAIN_CREATE_DEPTH_STENCIL_VIEW_FAILED;
    WGPU_SWAPCHAIN_CREATE_MSAA_TEXTURE_FAILED;
    WGPU_SWAPCHAIN_CREATE_MSAA_VIEW_FAILED;
    WGPU_REQUEST_DEVICE_STATUS_ERROR;
    WGPU_REQUEST_DEVICE_STATUS_UNKNOWN;
    WGPU_REQUEST_ADAPTER_STATUS_UNAVAILABLE;
    WGPU_REQUEST_ADAPTER_STATUS_ERROR;
    WGPU_REQUEST_ADAPTER_STATUS_UNKNOWN;
    WGPU_CREATE_INSTANCE_FAILED;
    IMAGE_DATA_SIZE_MISMATCH;
    DROPPED_FILE_PATH_TOO_LONG;
    CLIPBOARD_STRING_TOO_BIG;
}

sapp_logger :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sapp_desc :: struct {
    init_cb : () #c_call;
    frame_cb : () #c_call;
    cleanup_cb : () #c_call;
    event_cb : (a0: *sapp_event) #c_call;
    user_data : *void;
    init_userdata_cb : (a0: *void) #c_call;
    frame_userdata_cb : (a0: *void) #c_call;
    cleanup_userdata_cb : (a0: *void) #c_call;
    event_userdata_cb : (a0: *sapp_event, a1: *void) #c_call;
    width : s32;
    height : s32;
    sample_count : s32;
    swap_interval : s32;
    high_dpi : bool;
    fullscreen : bool;
    alpha : bool;
    window_title : *u8;
    enable_clipboard : bool;
    clipboard_size : s32;
    enable_dragndrop : bool;
    max_dropped_files : s32;
    max_dropped_file_path_length : s32;
    icon : sapp_icon_desc;
    allocator : sapp_allocator;
    logger : sapp_logger;
    gl_major_version : s32;
    gl_minor_version : s32;
    win32_console_utf8 : bool;
    win32_console_create : bool;
    win32_console_attach : bool;
    html5_canvas_name : *u8;
    html5_canvas_resize : bool;
    html5_preserve_drawing_buffer : bool;
    html5_premultiplied_alpha : bool;
    html5_ask_leave_site : bool;
    html5_bubble_mouse_events : bool;
    html5_bubble_touch_events : bool;
    html5_bubble_wheel_events : bool;
    html5_bubble_key_events : bool;
    html5_bubble_char_events : bool;
    html5_use_emsc_set_main_loop : bool;
    html5_emsc_set_main_loop_simulate_infinite_loop : bool;
    ios_keyboard_resizes_canvas : bool;
}

sapp_html5_fetch_error :: enum u32 {
    FETCH_ERROR_NO_ERROR;
    FETCH_ERROR_BUFFER_TOO_SMALL;
    FETCH_ERROR_OTHER;
}

sapp_html5_fetch_response :: struct {
    succeeded : bool;
    error_code : sapp_html5_fetch_error;
    file_index : s32;
    data : sapp_range;
    buffer : sapp_range;
    user_data : *void;
}

sapp_html5_fetch_request :: struct {
    dropped_file_index : s32;
    callback : (a0: *sapp_html5_fetch_response) #c_call;
    buffer : sapp_range;
    user_data : *void;
}

sapp_mouse_cursor :: enum u32 {
    DEFAULT :: 0;
    ARROW;
    IBEAM;
    CROSSHAIR;
    POINTING_HAND;
    RESIZE_EW;
    RESIZE_NS;
    RESIZE_NWSE;
    RESIZE_NESW;
    RESIZE_ALL;
    NOT_ALLOWED;
}

