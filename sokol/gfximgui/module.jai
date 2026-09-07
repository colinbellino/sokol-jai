// machine generated, do not edit

/*

    sokol_gfx_imgui.h -- debug-inspection UI for sokol_gfx.h using Dear ImGui

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_GFX_IMGUI_IMPL

    before you include this file in *one* C or C++ file to create the
    implementation.

    NOTE that the implementation can be compiled either as C++ or as C.
    When compiled as C++, sokol_gfx_imgui.h will directly call into the
    Dear ImGui C++ API. When compiled as C, sokol_gfx_imgui.h will call
    cimgui.h functions instead.

    Include the following file(s) before including sokol_gfx_imgui.h:

        sokol_gfx.h

    Additionally, include the following headers before including the
    implementation:

    If the implementation is compiled as C++:
        imgui.h

    If the implementation is compiled as C:
        cimgui.h

    The sokol_gfx.h implementation must be compiled with debug trace hooks
    enabled by defining:

        SOKOL_TRACE_HOOKS

    ...before including the sokol_gfx.h implementation.

    Before including the sokol_gfx_imgui.h implementation, optionally
    override the following macros:

        SOKOL_ASSERT(c)     -- your own assert macro, default: assert(c)
        SOKOL_UNREACHABLE   -- your own macro to annotate unreachable code,
                               default: SOKOL_ASSERT(false)
        SOKOL_GFX_IMGUI_API_DECL    - public function declaration prefix (default: extern)
        SOKOL_GFX_IMGUI_CPREFIX     - defines the function prefix for the Dear ImGui C bindings (default: ig)
        SOKOL_API_DECL      - same as SOKOL_GFX_IMGUI_API_DECL
        SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_gfx_imgui.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_GFX_IMGUI_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    STEP BY STEP:
    =============
    --- call sgimgui_setup() with optional allocator overrides:

            sgimgui_setup(&(sgimgui_desc_t){
                .allocator = {
                    .alloc_fn = my_malloc,
                    .free_fn = my_free,
                }
            });

    --- somewhere in the per-frame code call:

            sgimgui_draw()

        this won't draw anything yet, since no windows are open.

    --- call the convenience function sgimgui_draw_menu(ctx, title)
        to render a menu which allows to open/close the provided debug windows

            sgimgui_draw_menu("sokol-gfx");

    --- alternatively the individual single menu items via:

        if (ImGui::BeginMainMenuBar()) {
            if (ImGui::BeginMenu("sokol-gfx")) {
                sgimgui_draw_buffer_window_menu_item("Buffers");
                sgimgui_draw_image_window_menu_item("Images");
                sgimgui_draw_sampler_window_menu_item("Samplers");
                sgimgui_draw_shader_window_menu_item("Shaders");
                sgimgui_draw_pipeline_window_menu_item("Pipelines");
                sgimgui_draw_view_window_menu_item("Views");
                sgimgui_draw_capture_window_menu_item("Calls");
                sgimgui_draw_capabilities_window_menu_item("Capabilities");
                sgimgui_draw_frame_stats_window_menu_item("Frame Stats");
                ImGui::EndMenu();
            }
            ImGui::EndMainMenuBar();
        }

    --- before application shutdown, call:

            sgimgui_shutdown();

        ...this is not strictly necessary because the application exits
        anyway, but not doing this may trigger memory leak detection tools.

    --- finally, your application needs an ImGui renderer, you can either
        provide your own, or drop in the sokol_imgui.h utility header

    ALTERNATIVE DRAWING FUNCTIONS:
    ==============================
    Instead of the convenient but all-in-one sgimgui_draw() function,
    you can also use the following granular functions which might allow
    better integration with your existing UI:

    The following functions only render the window *content* (so you
    can integrate the UI into you own windows):

        void sgimgui_draw_buffer_window_content(void);
        void sgimgui_draw_image_window_content(void);
        void sgimgui_draw_sampler_window_content(void);
        void sgimgui_draw_shader_window_content(void);
        void sgimgui_draw_pipeline_window_content(void);
        void sgimgui_draw_view_window_content(void);
        void sgimgui_draw_capture_window_content(void);
        void sgimgui_draw_capabilities_window_content(void);
        void sgimgui_draw_frame_stats_window_content(void);

    And these are the 'full window' drawing functions:

        void sgimgui_draw_buffer_window(const char* title);
        void sgimgui_draw_image_window(const char* title);
        void sgimgui_draw_sampler_window(const char* title);
        void sgimgui_draw_shader_window(const char* title);
        void sgimgui_draw_pipeline_window(const char* title);
        void sgimgui_draw_view_window(const char* title);
        void sgimgui_draw_capture_window(const char* title);
        void sgimgui_draw_capabilities_window(const char* title);
        void sgimgui_draw_frame_stats_window(const char* title);

    To draw the individual menu items:

        void sgimgui_draw_buffer_menu_item(const char* label);
        void sgimgui_draw_image_menu_item(const char* label);
        void sgimgui_draw_sampler_menu_item(const char* label);
        void sgimgui_draw_shader_menu_item(const char* label);
        void sgimgui_draw_pipeline_menu_item(const char* label);
        void sgimgui_draw_view_menu_item(const char* label);
        void sgimgui_draw_capture_menu_item(const char* label);
        void sgimgui_draw_capabilities_menu_item(const char* label);
        void sgimgui_draw_frame_stats_menu_item(const char* label);

    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2018 Andre Weissflog

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

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_gfximgui_clib :: #library "sokol_gfximgui_windows_x64_gl_debug";   }
            else       { sokol_gfximgui_clib :: #library "sokol_gfximgui_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_gfximgui_clib :: #library "sokol_gfximgui_windows_x64_d3d11_debug";   }
            else       { sokol_gfximgui_clib :: #library "sokol_gfximgui_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_windows_x64_gl_debug";   }
            else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_windows_x64_d3d11_debug";   }
            else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_gfximgui_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_arm64_gl_debug";   }
                else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_x64_gl_debug";   }
                else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_arm64_metal_debug";   }
                else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_x64_metal_debug";   }
                else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_linux_x64_gl_debug";   }
    else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_wasm_gl_debug";   }
    else       { sokol_gfximgui_clib :: #library,no_dll "sokol_gfximgui_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sgimgui_setup :: (desc: *sgimgui_desc_t) -> void #foreign sokol_gfximgui_clib;
sgimgui_shutdown :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_menu :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_buffer_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_image_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_sampler_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_shader_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_pipeline_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_view_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capture_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capabilities_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_frame_stats_window_content :: () -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_buffer_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_image_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_sampler_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_shader_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_pipeline_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_view_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capture_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capabilities_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_frame_stats_window :: (title: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_buffer_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_image_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_sampler_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_shader_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_pipeline_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_view_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capture_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_capabilities_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;
sgimgui_draw_frame_stats_menu_item :: (label: *u8) -> void #foreign sokol_gfximgui_clib;

sgimgui_allocator_t :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sgimgui_desc_t :: struct {
    allocator : sgimgui_allocator_t;
}

