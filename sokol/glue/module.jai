// machine generated, do not edit
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
} else {
    log_error("This OS is currently not supported");
}

sglue_environment :: () -> sg_environment #foreign sokol_glue_clib;
sglue_swapchain :: () -> sg_swapchain #foreign sokol_glue_clib;

