// machine generated, do not edit
#import,dir "../gfx"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

sdtx_printf :: (s: string, args: ..Any) {
    #import "Basic";
    fstr := tprint(s, ..args);
    sdtx_putr(to_c_string(fstr), xx fstr.count);
}
#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_debugtext_clib :: #library "sokol_debugtext_windows_x64_gl_debug";   }
            else       { sokol_debugtext_clib :: #library "sokol_debugtext_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_debugtext_clib :: #library "sokol_debugtext_windows_x64_d3d11_debug";   }
            else       { sokol_debugtext_clib :: #library "sokol_debugtext_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_windows_x64_gl_debug";   }
            else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_windows_x64_d3d11_debug";   }
            else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_debugtext_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_arm64_gl_debug";   }
                else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_x64_gl_debug";   }
                else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_arm64_metal_debug";   }
                else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_x64_metal_debug";   }
                else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_linux_x64_gl_debug";   }
    else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_wasm_gl_debug";   }
    else       { sokol_debugtext_clib :: #library,no_dll "sokol_debugtext_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sdtx_setup :: (desc: *sdtx_desc_t) -> void #foreign sokol_debugtext_clib;
sdtx_shutdown :: () -> void #foreign sokol_debugtext_clib;
sdtx_font_kc853 :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_font_kc854 :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_font_z1013 :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_font_cpc :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_font_c64 :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_font_oric :: () -> sdtx_font_desc_t #foreign sokol_debugtext_clib;
sdtx_make_context :: (desc: *sdtx_context_desc_t) -> sdtx_context #foreign sokol_debugtext_clib;
sdtx_destroy_context :: (ctx: sdtx_context) -> void #foreign sokol_debugtext_clib;
sdtx_set_context :: (ctx: sdtx_context) -> void #foreign sokol_debugtext_clib;
sdtx_get_context :: () -> sdtx_context #foreign sokol_debugtext_clib;
sdtx_default_context :: () -> sdtx_context #foreign sokol_debugtext_clib;
sdtx_draw :: () -> void #foreign sokol_debugtext_clib;
sdtx_context_draw :: (ctx: sdtx_context) -> void #foreign sokol_debugtext_clib;
sdtx_draw_layer :: (layer_id: s32) -> void #foreign sokol_debugtext_clib;
sdtx_context_draw_layer :: (ctx: sdtx_context, layer_id: s32) -> void #foreign sokol_debugtext_clib;
sdtx_layer :: (layer_id: s32) -> void #foreign sokol_debugtext_clib;
sdtx_font :: (font_index: s32) -> void #foreign sokol_debugtext_clib;
sdtx_canvas :: (w: float, h: float) -> void #foreign sokol_debugtext_clib;
sdtx_origin :: (x: float, y: float) -> void #foreign sokol_debugtext_clib;
sdtx_home :: () -> void #foreign sokol_debugtext_clib;
sdtx_pos :: (x: float, y: float) -> void #foreign sokol_debugtext_clib;
sdtx_pos_x :: (x: float) -> void #foreign sokol_debugtext_clib;
sdtx_pos_y :: (y: float) -> void #foreign sokol_debugtext_clib;
sdtx_move :: (dx: float, dy: float) -> void #foreign sokol_debugtext_clib;
sdtx_move_x :: (dx: float) -> void #foreign sokol_debugtext_clib;
sdtx_move_y :: (dy: float) -> void #foreign sokol_debugtext_clib;
sdtx_crlf :: () -> void #foreign sokol_debugtext_clib;
sdtx_color3b :: (r: u8, g: u8, b: u8) -> void #foreign sokol_debugtext_clib;
sdtx_color3f :: (r: float, g: float, b: float) -> void #foreign sokol_debugtext_clib;
sdtx_color4b :: (r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_debugtext_clib;
sdtx_color4f :: (r: float, g: float, b: float, a: float) -> void #foreign sokol_debugtext_clib;
sdtx_color1i :: (rgba: u32) -> void #foreign sokol_debugtext_clib;
sdtx_putc :: (c: u8) -> void #foreign sokol_debugtext_clib;
sdtx_puts :: (str: *u8) -> void #foreign sokol_debugtext_clib;
sdtx_putr :: (str: *u8, len: s32) -> void #foreign sokol_debugtext_clib;

sdtx_log_item_t :: enum u32 {
    OK;
    MALLOC_FAILED;
    ADD_COMMIT_LISTENER_FAILED;
    COMMAND_BUFFER_FULL;
    CONTEXT_POOL_EXHAUSTED;
    CANNOT_DESTROY_DEFAULT_CONTEXT;
}

sdtx_logger_t :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sdtx_context :: struct {
    id : u32;
}

sdtx_range :: struct {
    ptr : *void;
    size : u64;
}

sdtx_font_desc_t :: struct {
    data : sdtx_range;
    first_char : u8;
    last_char : u8;
}

sdtx_context_desc_t :: struct {
    max_commands : s32;
    char_buf_size : s32;
    canvas_width : float;
    canvas_height : float;
    tab_width : s32;
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
}

sdtx_allocator_t :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sdtx_desc_t :: struct {
    context_pool_size : s32;
    printf_buf_size : s32;
    fonts : [8]sdtx_font_desc_t;
    ctx : sdtx_context_desc_t;
    allocator : sdtx_allocator_t;
    logger : sdtx_logger_t;
}

