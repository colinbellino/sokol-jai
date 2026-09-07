// machine generated, do not edit

/*

    sokol_app_imgui.h - debug-inspection UI for sokol_app.h using Dear ImGui

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_APP_IMGUI_IMPL

    before you include this file in *one* C or C++ file to create the
    implementation.

    NOTE that the implementation can be compiled either as C++ or as C.
    When compiled as C++, sokol_app_imgui.h will directly call into the
    Dear ImGui C++ API. When compiled as C, sokol_app_imgui.h will call
    cimgui.h functions instead.

    Include the following file(s) before including sokol_app_imgui.h:

        sokol_app.h

    Additionally, include the following headers before including the
    implementation:

    If the implementation is compiled as C++:
        imgui.h

    If the implementation is compiled as C:
        cimgui.h

    Before including the sokol_app_imgui.h implementation, optionally
    override the following macros:

        SOKOL_ASSERT(c)     -- your own assert macro, default: assert(c)
        SOKOL_UNREACHABLE   -- your own macro to annotate unreachable code,
                               default: SOKOL_ASSERT(false)
        SOKOL_APP_IMGUI_API_DECL    - public function declaration prefix (default: extern)
        SOKOL_APP_IMGUI_CPREFIX     - defines the function prefix for the Dear ImGui C bindings (default: ig)
        SOKOL_API_DECL      - same as SOKOL_GFX_IMGUI_API_DECL
        SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_app_imgui.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_APP_IMGUI_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    STEP BY STEP
    ============
    - call sappimgui_setup() before any other sappimgui functions:

        sappimgui_setup();

    - in your sokol-app event event handler callback, this records
      the events for the event-viewer window:

        sappimgui_track_event(ev);

    - somewhere at the start of your sokol-app frame callback, this
      records the frame duration for the debug hud:

        sappimgui_track_frame();

    - inside Dear ImGui's BeginMainMenuBar/EndMainMenuBar

        sappimgui_draw_menu("sokol-app");

    - and somewhere in your Dear ImGui top-level rendering code:

        sappimgui_draw();

    ALTERNATIVE DRAWING FUNCTIONS:
    ==============================
    Instead of the convenient but all-in-one sappimgui_draw() function,
    you can also use the following granular functions which might allow
    better integration with your existing UI:

    The following functions only render the window *content* (so you
    can integrate the UI into you own windows):

        void sappimgui_draw_hud_window_content(void);
        void sappimgui_draw_publicstate_window_content(void);
        void sappimgui_draw_event_window_content(void);

    And these are the 'full window' drawing functions:

        void sappimgui_draw_hud_window(const char* title);
        void sappimgui_draw_publicstate_window(const char* title);
        void sappimgui_draw_event_window(const char* title);

    To draw the individual menu items:

        void sappimgui_draw_hud_menu_item(const char* label);
        void sappimgui_draw_publicstate_menu_item(const char* label);
        void sappimgui_draw_event_menu_item(const char* label);

    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2026 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.

*/
#import,dir "../app"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_appimgui_clib :: #library "sokol_appimgui_windows_x64_gl_debug";   }
            else       { sokol_appimgui_clib :: #library "sokol_appimgui_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_appimgui_clib :: #library "sokol_appimgui_windows_x64_d3d11_debug";   }
            else       { sokol_appimgui_clib :: #library "sokol_appimgui_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_windows_x64_gl_debug";   }
            else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_windows_x64_d3d11_debug";   }
            else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_appimgui_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_arm64_gl_debug";   }
                else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_x64_gl_debug";   }
                else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_arm64_metal_debug";   }
                else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_x64_metal_debug";   }
                else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_linux_x64_gl_debug";   }
    else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_wasm_gl_debug";   }
    else       { sokol_appimgui_clib :: #library,no_dll "sokol_appimgui_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sappimgui_setup :: () -> void #foreign sokol_appimgui_clib;
sappimgui_shutdown :: () -> void #foreign sokol_appimgui_clib;
sappimgui_track_frame :: () -> void #foreign sokol_appimgui_clib;
sappimgui_track_event :: (ev: *sapp_event) -> void #foreign sokol_appimgui_clib;
sappimgui_draw :: () -> void #foreign sokol_appimgui_clib;
sappimgui_draw_menu :: (title: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_hud_window_content :: () -> void #foreign sokol_appimgui_clib;
sappimgui_draw_publicstate_window_content :: () -> void #foreign sokol_appimgui_clib;
sappimgui_draw_event_window_content :: () -> void #foreign sokol_appimgui_clib;
sappimgui_draw_hud_window :: (title: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_publicstate_window :: (title: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_event_window :: (title: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_hud_menu_item :: (label: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_publicstate_menu_item :: (label: *u8) -> void #foreign sokol_appimgui_clib;
sappimgui_draw_event_menu_item :: (label: *u8) -> void #foreign sokol_appimgui_clib;

