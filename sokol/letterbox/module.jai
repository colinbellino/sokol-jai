// machine generated, do not edit

/*

    sokol_letterbox.h -- provide fixed-aspect viewport for random-aspect framebuffer

    Project URL: https://github.com/floooh/sokol

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_LETTERBOX_API_DECL - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_LETTERBOX_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_letterbox.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    WHAT
    ====
    Computes viewport parameters to render fixed-aspect content in a variable-aspect
    framebuffer (e.g. position a 16:9 frame in a randomly sized window) - commonly
    known as 'letterboxing'.

    Check the WASM example here:

        https://floooh.github.io/sokol-html5/letterbox-sapp.html

    HOW
    ===
    Just call slbx_letterbox() and plug the result into sg_apply_viewport().

    Takes a framebuffer width/height as input and a pointer to an slbx_letterbox_desc
    struct:

    ```c
    int w = sapp_width();
    int h = sapp_height();
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
    });
    ```

    ...then plug the resulting viewport parameters into `sg_apply_viewport()` (or
    a similar viewport function).

    ```c
    sg_apply_viewport(vp.x, vp.y, vp.width, vp.height, true);
    ```

    You can define a 'safe border' in pixels:
    ```c
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
        .border = {
            .left = 10,
            .right = 10,
            .top = 10,
            .bottom = 10,
        },
    });
    ```

    ...and finally you can anchor the content so that it sticks to an edge
    of the framebuffer (the default behaviour is to center the content):

    ```c
    slbx_viewport vp = slbx_letterbox(w, h, &(slbx_letterbox_desc){
        .content_aspect_ratio = 16.0f / 9.0f,
        .anchor = SLBX_ANCHOR_TOP,
        .border = {
            .left = 10,
            .right = 10,
            .top = 10,
            .bottom = 10,
        },
    });
    ```

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

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_letterbox_clib :: #library "sokol_letterbox_windows_x64_gl_debug";   }
            else       { sokol_letterbox_clib :: #library "sokol_letterbox_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_letterbox_clib :: #library "sokol_letterbox_windows_x64_d3d11_debug";   }
            else       { sokol_letterbox_clib :: #library "sokol_letterbox_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_windows_x64_gl_debug";   }
            else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_windows_x64_d3d11_debug";   }
            else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_letterbox_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_arm64_gl_debug";   }
                else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_x64_gl_debug";   }
                else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_arm64_metal_debug";   }
                else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_x64_metal_debug";   }
                else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_linux_x64_gl_debug";   }
    else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_wasm_gl_debug";   }
    else       { sokol_letterbox_clib :: #library,no_dll "sokol_letterbox_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

// compute viewport for 'letterboxing' fixed-aspect content in a variable-aspect framebuffer
slbx_letterbox :: (width: s32, height: s32, desc: *slbx_letterbox_desc) -> slbx_viewport #foreign sokol_letterbox_clib;

slbx_border :: struct {
    left : s32;
    right : s32;
    top : s32;
    bottom : s32;
}

/*
    Anchor the content to a side. The default is to center the content.
    Used in slbx_letterbox_desc.
*/
slbx_anchor :: enum u32 {
    CENTER :: 0;
    TOP;
    BOTTOM;
    LEFT;
    RIGHT;
}

slbx_letterbox_desc :: struct {
    content_aspect_ratio : float;
    anchor : slbx_anchor;
    border : slbx_border;
}

slbx_viewport :: struct {
    x : s32;
    y : s32;
    width : s32;
    height : s32;
}

