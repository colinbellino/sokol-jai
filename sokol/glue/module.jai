// machine generated, do not edit

/*

    sokol_glue.h -- glue helper functions for sokol headers

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_GLUE_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    ...optionally provide the following macros to override defaults:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_GLUE_API_DECL - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_GLUE_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_glue.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_GLUE_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    OVERVIEW
    ========
    sokol_glue.h provides glue helper functions between sokol_gfx.h and sokol_app.h,
    so that sokol_gfx.h doesn't need to depend on sokol_app.h but can be
    used with different window system glue libraries.

    PROVIDED FUNCTIONS
    ==================

    sg_environment sglue_environment(void)

        Returns an sg_environment struct initialized by calling sokol_app.h
        functions. Use this in the sg_setup() call like this:

        sg_setup(&(sg_desc){
            .environment = sglue_environment(),
            ...
        });

    sg_swapchain sglue_swapchain(void)

        Returns an sg_swapchain struct initialized by calling sokol_app.h
        functions. Use this in sg_begin_pass() for a 'swapchain pass' like
        this:

        sg_begin_pass(&(sg_pass){ .swapchain = sglue_swapchain(), ... });

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
#import,dir "../gfx"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_glue_clib :: #library "sokol_glue_windows_x64_gl_debug";   }
            else       { sokol_glue_clib :: #library "sokol_glue_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_glue_clib :: #library "sokol_glue_windows_x64_d3d11_debug";   }
            else       { sokol_glue_clib :: #library "sokol_glue_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_windows_x64_gl_debug";   }
            else       { sokol_glue_clib :: #library,no_dll "sokol_glue_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_windows_x64_d3d11_debug";   }
            else       { sokol_glue_clib :: #library,no_dll "sokol_glue_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_glue_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_arm64_gl_debug";   }
                else       { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_x64_gl_debug";   }
                else       { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_arm64_metal_debug";   }
                else       { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_x64_metal_debug";   }
                else       { sokol_glue_clib :: #library,no_dll "sokol_glue_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_linux_x64_gl_debug";   }
    else       { sokol_glue_clib :: #library,no_dll "sokol_glue_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_glue_clib :: #library,no_dll "sokol_glue_wasm_gl_debug";   }
    else       { sokol_glue_clib :: #library,no_dll "sokol_glue_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sglue_environment :: () -> sg_environment #foreign sokol_glue_clib;
sglue_swapchain :: () -> sg_swapchain #foreign sokol_glue_clib;

