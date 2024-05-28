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
            
            #if  DEBUG { sokol_time_clib :: #library "sokol_time_windows_x64_gl_debug";   }
            else       { sokol_time_clib :: #library "sokol_time_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_time_clib :: #library "sokol_time_windows_x64_d3d11_debug";   }
            else       { sokol_time_clib :: #library "sokol_time_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_windows_x64_gl_debug";   }
            else       { sokol_time_clib :: #library,no_dll "sokol_time_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_windows_x64_d3d11_debug";   }
            else       { sokol_time_clib :: #library,no_dll "sokol_time_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_time_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_macos_arm64_gl_debug";   }
                else       { sokol_time_clib :: #library,no_dll "sokol_time_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_macos_x64_gl_debug";   }
                else       { sokol_time_clib :: #library,no_dll "sokol_time_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_macos_arm64_metal_debug";   }
                else       { sokol_time_clib :: #library,no_dll "sokol_time_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_macos_x64_metal_debug";   }
                else       { sokol_time_clib :: #library,no_dll "sokol_time_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_time_clib :: #library,no_dll "sokol_time_linux_x64_gl_debug";   }
    else       { sokol_time_clib :: #library,no_dll "sokol_time_linux_x64_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

stm_setup :: () -> void #foreign sokol_time_clib;
stm_now :: () -> u64 #foreign sokol_time_clib;
stm_diff :: (new_ticks: u64, old_ticks: u64) -> u64 #foreign sokol_time_clib;
stm_since :: (start_ticks: u64) -> u64 #foreign sokol_time_clib;
stm_laptime :: (last_time: *u64) -> u64 #foreign sokol_time_clib;
stm_round_to_common_refresh_rate :: (frame_ticks: u64) -> u64 #foreign sokol_time_clib;
stm_sec :: (ticks: u64) -> float64 #foreign sokol_time_clib;
stm_ms :: (ticks: u64) -> float64 #foreign sokol_time_clib;
stm_us :: (ticks: u64) -> float64 #foreign sokol_time_clib;
stm_ns :: (ticks: u64) -> float64 #foreign sokol_time_clib;

