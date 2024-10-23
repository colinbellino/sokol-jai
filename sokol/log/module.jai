// machine generated, do not edit

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_log_clib :: #library "sokol_log_windows_x64_gl_debug";   }
            else       { sokol_log_clib :: #library "sokol_log_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_log_clib :: #library "sokol_log_windows_x64_d3d11_debug";   }
            else       { sokol_log_clib :: #library "sokol_log_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_windows_x64_gl_debug";   }
            else       { sokol_log_clib :: #library,no_dll "sokol_log_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_windows_x64_d3d11_debug";   }
            else       { sokol_log_clib :: #library,no_dll "sokol_log_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_log_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_macos_arm64_gl_debug";   }
                else       { sokol_log_clib :: #library,no_dll "sokol_log_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_macos_x64_gl_debug";   }
                else       { sokol_log_clib :: #library,no_dll "sokol_log_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_macos_arm64_metal_debug";   }
                else       { sokol_log_clib :: #library,no_dll "sokol_log_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_macos_x64_metal_debug";   }
                else       { sokol_log_clib :: #library,no_dll "sokol_log_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_linux_x64_gl_debug";   }
    else       { sokol_log_clib :: #library,no_dll "sokol_log_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_log_clib :: #library,no_dll "sokol_log_wasm_gl_debug";   }
    else       { sokol_log_clib :: #library,no_dll "sokol_log_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

slog_func :: (tag: *u8, log_level: u32, log_item: u32, message: *u8, line_nr: u32, filename: *u8, user_data: *void) -> void #foreign sokol_log_clib;

