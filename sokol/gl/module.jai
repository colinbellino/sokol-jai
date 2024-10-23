// machine generated, do not edit
#import,dir "../gfx"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_gl_clib :: #library "sokol_gl_windows_x64_gl_debug";   }
            else       { sokol_gl_clib :: #library "sokol_gl_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_gl_clib :: #library "sokol_gl_windows_x64_d3d11_debug";   }
            else       { sokol_gl_clib :: #library "sokol_gl_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_windows_x64_gl_debug";   }
            else       { sokol_gl_clib :: #library,no_dll "sokol_gl_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_windows_x64_d3d11_debug";   }
            else       { sokol_gl_clib :: #library,no_dll "sokol_gl_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_gl_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_arm64_gl_debug";   }
                else       { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_x64_gl_debug";   }
                else       { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_arm64_metal_debug";   }
                else       { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_x64_metal_debug";   }
                else       { sokol_gl_clib :: #library,no_dll "sokol_gl_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_linux_x64_gl_debug";   }
    else       { sokol_gl_clib :: #library,no_dll "sokol_gl_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_gl_clib :: #library,no_dll "sokol_gl_wasm_gl_debug";   }
    else       { sokol_gl_clib :: #library,no_dll "sokol_gl_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sgl_setup :: (desc: *sgl_desc_t) -> void #foreign sokol_gl_clib;
sgl_shutdown :: () -> void #foreign sokol_gl_clib;
sgl_rad :: (deg: float) -> float #foreign sokol_gl_clib;
sgl_deg :: (rad: float) -> float #foreign sokol_gl_clib;
sgl_error :: () -> sgl_error_t #foreign sokol_gl_clib;
sgl_context_error :: (ctx: sgl_context) -> sgl_error_t #foreign sokol_gl_clib;
sgl_make_context :: (desc: *sgl_context_desc_t) -> sgl_context #foreign sokol_gl_clib;
sgl_destroy_context :: (ctx: sgl_context) -> void #foreign sokol_gl_clib;
sgl_set_context :: (ctx: sgl_context) -> void #foreign sokol_gl_clib;
sgl_get_context :: () -> sgl_context #foreign sokol_gl_clib;
sgl_default_context :: () -> sgl_context #foreign sokol_gl_clib;
sgl_num_vertices :: () -> s32 #foreign sokol_gl_clib;
sgl_num_commands :: () -> s32 #foreign sokol_gl_clib;
sgl_draw :: () -> void #foreign sokol_gl_clib;
sgl_context_draw :: (ctx: sgl_context) -> void #foreign sokol_gl_clib;
sgl_draw_layer :: (layer_id: s32) -> void #foreign sokol_gl_clib;
sgl_context_draw_layer :: (ctx: sgl_context, layer_id: s32) -> void #foreign sokol_gl_clib;
sgl_make_pipeline :: (desc: *sg_pipeline_desc) -> sgl_pipeline #foreign sokol_gl_clib;
sgl_context_make_pipeline :: (ctx: sgl_context, desc: *sg_pipeline_desc) -> sgl_pipeline #foreign sokol_gl_clib;
sgl_destroy_pipeline :: (pip: sgl_pipeline) -> void #foreign sokol_gl_clib;
sgl_defaults :: () -> void #foreign sokol_gl_clib;
sgl_viewport :: (x: s32, y: s32, w: s32, h: s32, origin_top_left: bool) -> void #foreign sokol_gl_clib;
sgl_viewportf :: (x: float, y: float, w: float, h: float, origin_top_left: bool) -> void #foreign sokol_gl_clib;
sgl_scissor_rect :: (x: s32, y: s32, w: s32, h: s32, origin_top_left: bool) -> void #foreign sokol_gl_clib;
sgl_scissor_rectf :: (x: float, y: float, w: float, h: float, origin_top_left: bool) -> void #foreign sokol_gl_clib;
sgl_enable_texture :: () -> void #foreign sokol_gl_clib;
sgl_disable_texture :: () -> void #foreign sokol_gl_clib;
sgl_texture :: (img: sg_image, smp: sg_sampler) -> void #foreign sokol_gl_clib;
sgl_layer :: (layer_id: s32) -> void #foreign sokol_gl_clib;
sgl_load_default_pipeline :: () -> void #foreign sokol_gl_clib;
sgl_load_pipeline :: (pip: sgl_pipeline) -> void #foreign sokol_gl_clib;
sgl_push_pipeline :: () -> void #foreign sokol_gl_clib;
sgl_pop_pipeline :: () -> void #foreign sokol_gl_clib;
sgl_matrix_mode_modelview :: () -> void #foreign sokol_gl_clib;
sgl_matrix_mode_projection :: () -> void #foreign sokol_gl_clib;
sgl_matrix_mode_texture :: () -> void #foreign sokol_gl_clib;
sgl_load_identity :: () -> void #foreign sokol_gl_clib;
sgl_load_matrix :: (m: *float) -> void #foreign sokol_gl_clib;
sgl_load_transpose_matrix :: (m: *float) -> void #foreign sokol_gl_clib;
sgl_mult_matrix :: (m: *float) -> void #foreign sokol_gl_clib;
sgl_mult_transpose_matrix :: (m: *float) -> void #foreign sokol_gl_clib;
sgl_rotate :: (angle_rad: float, x: float, y: float, z: float) -> void #foreign sokol_gl_clib;
sgl_scale :: (x: float, y: float, z: float) -> void #foreign sokol_gl_clib;
sgl_translate :: (x: float, y: float, z: float) -> void #foreign sokol_gl_clib;
sgl_frustum :: (l: float, r: float, b: float, t: float, n: float, f: float) -> void #foreign sokol_gl_clib;
sgl_ortho :: (l: float, r: float, b: float, t: float, n: float, f: float) -> void #foreign sokol_gl_clib;
sgl_perspective :: (fov_y: float, aspect: float, z_near: float, z_far: float) -> void #foreign sokol_gl_clib;
sgl_lookat :: (eye_x: float, eye_y: float, eye_z: float, center_x: float, center_y: float, center_z: float, up_x: float, up_y: float, up_z: float) -> void #foreign sokol_gl_clib;
sgl_push_matrix :: () -> void #foreign sokol_gl_clib;
sgl_pop_matrix :: () -> void #foreign sokol_gl_clib;
sgl_t2f :: (u: float, v: float) -> void #foreign sokol_gl_clib;
sgl_c3f :: (r: float, g: float, b: float) -> void #foreign sokol_gl_clib;
sgl_c4f :: (r: float, g: float, b: float, a: float) -> void #foreign sokol_gl_clib;
sgl_c3b :: (r: u8, g: u8, b: u8) -> void #foreign sokol_gl_clib;
sgl_c4b :: (r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_gl_clib;
sgl_c1i :: (rgba: u32) -> void #foreign sokol_gl_clib;
sgl_point_size :: (s: float) -> void #foreign sokol_gl_clib;
sgl_begin_points :: () -> void #foreign sokol_gl_clib;
sgl_begin_lines :: () -> void #foreign sokol_gl_clib;
sgl_begin_line_strip :: () -> void #foreign sokol_gl_clib;
sgl_begin_triangles :: () -> void #foreign sokol_gl_clib;
sgl_begin_triangle_strip :: () -> void #foreign sokol_gl_clib;
sgl_begin_quads :: () -> void #foreign sokol_gl_clib;
sgl_v2f :: (x: float, y: float) -> void #foreign sokol_gl_clib;
sgl_v3f :: (x: float, y: float, z: float) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f :: (x: float, y: float, u: float, v: float) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f :: (x: float, y: float, z: float, u: float, v: float) -> void #foreign sokol_gl_clib;
sgl_v2f_c3f :: (x: float, y: float, r: float, g: float, b: float) -> void #foreign sokol_gl_clib;
sgl_v2f_c3b :: (x: float, y: float, r: u8, g: u8, b: u8) -> void #foreign sokol_gl_clib;
sgl_v2f_c4f :: (x: float, y: float, r: float, g: float, b: float, a: float) -> void #foreign sokol_gl_clib;
sgl_v2f_c4b :: (x: float, y: float, r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_gl_clib;
sgl_v2f_c1i :: (x: float, y: float, rgba: u32) -> void #foreign sokol_gl_clib;
sgl_v3f_c3f :: (x: float, y: float, z: float, r: float, g: float, b: float) -> void #foreign sokol_gl_clib;
sgl_v3f_c3b :: (x: float, y: float, z: float, r: u8, g: u8, b: u8) -> void #foreign sokol_gl_clib;
sgl_v3f_c4f :: (x: float, y: float, z: float, r: float, g: float, b: float, a: float) -> void #foreign sokol_gl_clib;
sgl_v3f_c4b :: (x: float, y: float, z: float, r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_gl_clib;
sgl_v3f_c1i :: (x: float, y: float, z: float, rgba: u32) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f_c3f :: (x: float, y: float, u: float, v: float, r: float, g: float, b: float) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f_c3b :: (x: float, y: float, u: float, v: float, r: u8, g: u8, b: u8) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f_c4f :: (x: float, y: float, u: float, v: float, r: float, g: float, b: float, a: float) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f_c4b :: (x: float, y: float, u: float, v: float, r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_gl_clib;
sgl_v2f_t2f_c1i :: (x: float, y: float, u: float, v: float, rgba: u32) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f_c3f :: (x: float, y: float, z: float, u: float, v: float, r: float, g: float, b: float) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f_c3b :: (x: float, y: float, z: float, u: float, v: float, r: u8, g: u8, b: u8) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f_c4f :: (x: float, y: float, z: float, u: float, v: float, r: float, g: float, b: float, a: float) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f_c4b :: (x: float, y: float, z: float, u: float, v: float, r: u8, g: u8, b: u8, a: u8) -> void #foreign sokol_gl_clib;
sgl_v3f_t2f_c1i :: (x: float, y: float, z: float, u: float, v: float, rgba: u32) -> void #foreign sokol_gl_clib;
sgl_end :: () -> void #foreign sokol_gl_clib;

sgl_log_item_t :: enum u32 {
    OK;
    MALLOC_FAILED;
    MAKE_PIPELINE_FAILED;
    PIPELINE_POOL_EXHAUSTED;
    ADD_COMMIT_LISTENER_FAILED;
    CONTEXT_POOL_EXHAUSTED;
    CANNOT_DESTROY_DEFAULT_CONTEXT;
}

sgl_logger_t :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sgl_pipeline :: struct {
    id : u32;
}

sgl_context :: struct {
    id : u32;
}

sgl_error_t :: struct {
    any : bool;
    vertices_full : bool;
    uniforms_full : bool;
    commands_full : bool;
    stack_overflow : bool;
    stack_underflow : bool;
    no_context : bool;
}

sgl_context_desc_t :: struct {
    max_vertices : s32;
    max_commands : s32;
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
}

sgl_allocator_t :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sgl_desc_t :: struct {
    max_vertices : s32;
    max_commands : s32;
    context_pool_size : s32;
    pipeline_pool_size : s32;
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
    face_winding : sg_face_winding;
    allocator : sgl_allocator_t;
    logger : sgl_logger_t;
}

