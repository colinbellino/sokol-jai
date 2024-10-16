// machine generated, do not edit
#import,dir "../gfx"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_shape_clib :: #library "sokol_shape_windows_x64_gl_debug";   }
            else       { sokol_shape_clib :: #library "sokol_shape_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_shape_clib :: #library "sokol_shape_windows_x64_d3d11_debug";   }
            else       { sokol_shape_clib :: #library "sokol_shape_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_windows_x64_gl_debug";   }
            else       { sokol_shape_clib :: #library,no_dll "sokol_shape_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_windows_x64_d3d11_debug";   }
            else       { sokol_shape_clib :: #library,no_dll "sokol_shape_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_shape_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_arm64_gl_debug";   }
                else       { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_x64_gl_debug";   }
                else       { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_arm64_metal_debug";   }
                else       { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_x64_metal_debug";   }
                else       { sokol_shape_clib :: #library,no_dll "sokol_shape_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_linux_x64_gl_debug";   }
    else       { sokol_shape_clib :: #library,no_dll "sokol_shape_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_wasm_wgpu_debug";   }
    else       { sokol_shape_clib :: #library,no_dll "sokol_shape_wasm_wgpu_release"; }
} else {
    log_error("This OS is currently not supported");
}

sshape_build_plane :: (buf: *sshape_buffer_t, params: *sshape_plane_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_box :: (buf: *sshape_buffer_t, params: *sshape_box_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_sphere :: (buf: *sshape_buffer_t, params: *sshape_sphere_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_cylinder :: (buf: *sshape_buffer_t, params: *sshape_cylinder_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_torus :: (buf: *sshape_buffer_t, params: *sshape_torus_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_plane_sizes :: (tiles: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_box_sizes :: (tiles: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_sphere_sizes :: (slices: u32, stacks: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_cylinder_sizes :: (slices: u32, stacks: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_torus_sizes :: (sides: u32, rings: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_element_range :: (buf: *sshape_buffer_t) -> sshape_element_range_t #foreign sokol_shape_clib;
sshape_vertex_buffer_desc :: (buf: *sshape_buffer_t) -> sg_buffer_desc #foreign sokol_shape_clib;
sshape_index_buffer_desc :: (buf: *sshape_buffer_t) -> sg_buffer_desc #foreign sokol_shape_clib;
sshape_vertex_buffer_layout_state :: () -> sg_vertex_buffer_layout_state #foreign sokol_shape_clib;
sshape_position_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_normal_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_texcoord_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_color_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_color_4f :: (r: float, g: float, b: float, a: float) -> u32 #foreign sokol_shape_clib;
sshape_color_3f :: (r: float, g: float, b: float) -> u32 #foreign sokol_shape_clib;
sshape_color_4b :: (r: u8, g: u8, b: u8, a: u8) -> u32 #foreign sokol_shape_clib;
sshape_color_3b :: (r: u8, g: u8, b: u8) -> u32 #foreign sokol_shape_clib;
sshape_mat4 :: (m: *float) -> sshape_mat4_t #foreign sokol_shape_clib;
sshape_mat4_transpose :: (m: *float) -> sshape_mat4_t #foreign sokol_shape_clib;

sshape_range :: struct {
    ptr : *void;
    size : u64;
}

sshape_mat4_t :: struct {
    m : [4][4]float;
}

sshape_vertex_t :: struct {
    x : float;
    y : float;
    z : float;
    normal : u32;
    u : u16;
    v : u16;
    color : u32;
}

sshape_element_range_t :: struct {
    base_element : s32;
    num_elements : s32;
}

sshape_sizes_item_t :: struct {
    num : u32;
    size : u32;
}

sshape_sizes_t :: struct {
    vertices : sshape_sizes_item_t;
    indices : sshape_sizes_item_t;
}

sshape_buffer_item_t :: struct {
    buffer : sshape_range;
    data_size : u64;
    shape_offset : u64;
}

sshape_buffer_t :: struct {
    valid : bool;
    vertices : sshape_buffer_item_t;
    indices : sshape_buffer_item_t;
}

sshape_plane_t :: struct {
    width : float;
    depth : float;
    tiles : u16;
    color : u32;
    random_colors : bool;
    merge : bool;
    transform : sshape_mat4_t;
}

sshape_box_t :: struct {
    width : float;
    height : float;
    depth : float;
    tiles : u16;
    color : u32;
    random_colors : bool;
    merge : bool;
    transform : sshape_mat4_t;
}

sshape_sphere_t :: struct {
    radius : float;
    slices : u16;
    stacks : u16;
    color : u32;
    random_colors : bool;
    merge : bool;
    transform : sshape_mat4_t;
}

sshape_cylinder_t :: struct {
    radius : float;
    height : float;
    slices : u16;
    stacks : u16;
    color : u32;
    random_colors : bool;
    merge : bool;
    transform : sshape_mat4_t;
}

sshape_torus_t :: struct {
    radius : float;
    ring_radius : float;
    sides : u16;
    rings : u16;
    color : u32;
    random_colors : bool;
    merge : bool;
    transform : sshape_mat4_t;
}

