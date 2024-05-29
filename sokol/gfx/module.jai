// machine generated, do not edit

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            #system_library "gdi32"; #system_library "dxguid"; #system_library "user32"; #system_library "shell32";
            #if  DEBUG { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_gl_debug";   }
            else       { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_gl_release"; }
        } else {
            #system_library "gdi32"; #system_library "dxguid"; #system_library "user32"; #system_library "shell32"; #system_library "d3d11";
            #if  DEBUG { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_d3d11_debug";   }
            else       { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            #system_library "gdi32"; #system_library "dxguid"; #system_library "user32"; #system_library "shell32";
            #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_gl_debug";   }
            else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_gl_release"; }
        } else {
            #system_library "gdi32"; #system_library "dxguid"; #system_library "user32"; #system_library "shell32"; #system_library "d3d11";
            #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_d3d11_debug";   }
            else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            #system_library "Cocoa"; #system_library "QuartzCore"; #system_library "OpenGL";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_gl_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_gl_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_gl_release"; }
            }
        } else {
            #library "../libclang_rt.osx"; #system_library "Cocoa"; #system_library "QuartzCore"; #system_library "Metal"; #system_library "MetalKit";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_metal_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_metal_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #system_library "libXcursor"; #system_library "libX11"; #system_library "libXi"; #system_library "libGL";
    #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_linux_x64_gl_debug";   }
    else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_linux_x64_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

sg_setup :: (desc: *sg_desc) -> void #foreign sokol_gfx_clib;
sg_shutdown :: () -> void #foreign sokol_gfx_clib;
sg_isvalid :: () -> bool #foreign sokol_gfx_clib;
sg_reset_state_cache :: () -> void #foreign sokol_gfx_clib;
sg_push_debug_group :: (name: *u8) -> void #foreign sokol_gfx_clib;
sg_pop_debug_group :: () -> void #foreign sokol_gfx_clib;
sg_add_commit_listener :: (listener: sg_commit_listener) -> bool #foreign sokol_gfx_clib;
sg_remove_commit_listener :: (listener: sg_commit_listener) -> bool #foreign sokol_gfx_clib;
sg_make_buffer :: (desc: *sg_buffer_desc) -> sg_buffer #foreign sokol_gfx_clib;
sg_make_image :: (desc: *sg_image_desc) -> sg_image #foreign sokol_gfx_clib;
sg_make_sampler :: (desc: *sg_sampler_desc) -> sg_sampler #foreign sokol_gfx_clib;
sg_make_shader :: (desc: *sg_shader_desc) -> sg_shader #foreign sokol_gfx_clib;
sg_make_pipeline :: (desc: *sg_pipeline_desc) -> sg_pipeline #foreign sokol_gfx_clib;
sg_make_attachments :: (desc: *sg_attachments_desc) -> sg_attachments #foreign sokol_gfx_clib;
sg_destroy_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_destroy_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_destroy_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_destroy_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_destroy_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_destroy_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_update_buffer :: (buf: sg_buffer, data: *sg_range) -> void #foreign sokol_gfx_clib;
sg_update_image :: (img: sg_image, data: *sg_image_data) -> void #foreign sokol_gfx_clib;
sg_append_buffer :: (buf: sg_buffer, data: *sg_range) -> s32 #foreign sokol_gfx_clib;
sg_query_buffer_overflow :: (buf: sg_buffer) -> bool #foreign sokol_gfx_clib;
sg_query_buffer_will_overflow :: (buf: sg_buffer, size: u64) -> bool #foreign sokol_gfx_clib;
sg_begin_pass :: (pass: *sg_pass) -> void #foreign sokol_gfx_clib;
sg_apply_viewport :: (x: s32, y: s32, width: s32, height: s32, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_viewportf :: (x: float, y: float, width: float, height: float, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_scissor_rect :: (x: s32, y: s32, width: s32, height: s32, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_scissor_rectf :: (x: float, y: float, width: float, height: float, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_apply_bindings :: (bindings: *sg_bindings) -> void #foreign sokol_gfx_clib;
sg_apply_uniforms :: (stage: sg_shader_stage, ub_index: s32, data: *sg_range) -> void #foreign sokol_gfx_clib;
sg_draw :: (base_element: s32, num_elements: s32, num_instances: s32) -> void #foreign sokol_gfx_clib;
sg_end_pass :: () -> void #foreign sokol_gfx_clib;
sg_commit :: () -> void #foreign sokol_gfx_clib;
sg_query_desc :: () -> sg_desc #foreign sokol_gfx_clib;
sg_query_backend :: () -> sg_backend #foreign sokol_gfx_clib;
sg_query_features :: () -> sg_features #foreign sokol_gfx_clib;
sg_query_limits :: () -> sg_limits #foreign sokol_gfx_clib;
sg_query_pixelformat :: (fmt: sg_pixel_format) -> sg_pixelformat_info #foreign sokol_gfx_clib;
sg_query_row_pitch :: (fmt: sg_pixel_format, width: s32, row_align_bytes: s32) -> s32 #foreign sokol_gfx_clib;
sg_query_surface_pitch :: (fmt: sg_pixel_format, width: s32, height: s32, row_align_bytes: s32) -> s32 #foreign sokol_gfx_clib;
sg_query_buffer_state :: (buf: sg_buffer) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_image_state :: (img: sg_image) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_sampler_state :: (smp: sg_sampler) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_shader_state :: (shd: sg_shader) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_pipeline_state :: (pip: sg_pipeline) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_attachments_state :: (atts: sg_attachments) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_buffer_info :: (buf: sg_buffer) -> sg_buffer_info #foreign sokol_gfx_clib;
sg_query_image_info :: (img: sg_image) -> sg_image_info #foreign sokol_gfx_clib;
sg_query_sampler_info :: (smp: sg_sampler) -> sg_sampler_info #foreign sokol_gfx_clib;
sg_query_shader_info :: (shd: sg_shader) -> sg_shader_info #foreign sokol_gfx_clib;
sg_query_pipeline_info :: (pip: sg_pipeline) -> sg_pipeline_info #foreign sokol_gfx_clib;
sg_query_attachments_info :: (atts: sg_attachments) -> sg_attachments_info #foreign sokol_gfx_clib;
sg_query_buffer_desc :: (buf: sg_buffer) -> sg_buffer_desc #foreign sokol_gfx_clib;
sg_query_image_desc :: (img: sg_image) -> sg_image_desc #foreign sokol_gfx_clib;
sg_query_sampler_desc :: (smp: sg_sampler) -> sg_sampler_desc #foreign sokol_gfx_clib;
sg_query_shader_desc :: (shd: sg_shader) -> sg_shader_desc #foreign sokol_gfx_clib;
sg_query_pipeline_desc :: (pip: sg_pipeline) -> sg_pipeline_desc #foreign sokol_gfx_clib;
sg_query_attachments_desc :: (atts: sg_attachments) -> sg_attachments_desc #foreign sokol_gfx_clib;
sg_query_buffer_defaults :: (desc: *sg_buffer_desc) -> sg_buffer_desc #foreign sokol_gfx_clib;
sg_query_image_defaults :: (desc: *sg_image_desc) -> sg_image_desc #foreign sokol_gfx_clib;
sg_query_sampler_defaults :: (desc: *sg_sampler_desc) -> sg_sampler_desc #foreign sokol_gfx_clib;
sg_query_shader_defaults :: (desc: *sg_shader_desc) -> sg_shader_desc #foreign sokol_gfx_clib;
sg_query_pipeline_defaults :: (desc: *sg_pipeline_desc) -> sg_pipeline_desc #foreign sokol_gfx_clib;
sg_query_attachments_defaults :: (desc: *sg_attachments_desc) -> sg_attachments_desc #foreign sokol_gfx_clib;
sg_alloc_buffer :: () -> sg_buffer #foreign sokol_gfx_clib;
sg_alloc_image :: () -> sg_image #foreign sokol_gfx_clib;
sg_alloc_sampler :: () -> sg_sampler #foreign sokol_gfx_clib;
sg_alloc_shader :: () -> sg_shader #foreign sokol_gfx_clib;
sg_alloc_pipeline :: () -> sg_pipeline #foreign sokol_gfx_clib;
sg_alloc_attachments :: () -> sg_attachments #foreign sokol_gfx_clib;
sg_dealloc_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_dealloc_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_dealloc_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_dealloc_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_dealloc_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_dealloc_attachments :: (attachments: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_init_buffer :: (buf: sg_buffer, desc: *sg_buffer_desc) -> void #foreign sokol_gfx_clib;
sg_init_image :: (img: sg_image, desc: *sg_image_desc) -> void #foreign sokol_gfx_clib;
sg_init_sampler :: (smg: sg_sampler, desc: *sg_sampler_desc) -> void #foreign sokol_gfx_clib;
sg_init_shader :: (shd: sg_shader, desc: *sg_shader_desc) -> void #foreign sokol_gfx_clib;
sg_init_pipeline :: (pip: sg_pipeline, desc: *sg_pipeline_desc) -> void #foreign sokol_gfx_clib;
sg_init_attachments :: (attachments: sg_attachments, desc: *sg_attachments_desc) -> void #foreign sokol_gfx_clib;
sg_uninit_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_uninit_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_uninit_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_uninit_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_uninit_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_uninit_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_fail_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_fail_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_fail_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_fail_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_fail_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_fail_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_enable_frame_stats :: () -> void #foreign sokol_gfx_clib;
sg_disable_frame_stats :: () -> void #foreign sokol_gfx_clib;
sg_frame_stats_enabled :: () -> bool #foreign sokol_gfx_clib;
sg_query_frame_stats :: () -> sg_frame_stats #foreign sokol_gfx_clib;
sg_d3d11_device :: () -> *void #foreign sokol_gfx_clib;
sg_d3d11_device_context :: () -> *void #foreign sokol_gfx_clib;
sg_d3d11_query_buffer_info :: (buf: sg_buffer) -> sg_d3d11_buffer_info #foreign sokol_gfx_clib;
sg_d3d11_query_image_info :: (img: sg_image) -> sg_d3d11_image_info #foreign sokol_gfx_clib;
sg_d3d11_query_sampler_info :: (smp: sg_sampler) -> sg_d3d11_sampler_info #foreign sokol_gfx_clib;
sg_d3d11_query_shader_info :: (shd: sg_shader) -> sg_d3d11_shader_info #foreign sokol_gfx_clib;
sg_d3d11_query_pipeline_info :: (pip: sg_pipeline) -> sg_d3d11_pipeline_info #foreign sokol_gfx_clib;
sg_d3d11_query_attachments_info :: (atts: sg_attachments) -> sg_d3d11_attachments_info #foreign sokol_gfx_clib;
sg_mtl_device :: () -> *void #foreign sokol_gfx_clib;
sg_mtl_render_command_encoder :: () -> *void #foreign sokol_gfx_clib;
sg_mtl_query_buffer_info :: (buf: sg_buffer) -> sg_mtl_buffer_info #foreign sokol_gfx_clib;
sg_mtl_query_image_info :: (img: sg_image) -> sg_mtl_image_info #foreign sokol_gfx_clib;
sg_mtl_query_sampler_info :: (smp: sg_sampler) -> sg_mtl_sampler_info #foreign sokol_gfx_clib;
sg_mtl_query_shader_info :: (shd: sg_shader) -> sg_mtl_shader_info #foreign sokol_gfx_clib;
sg_mtl_query_pipeline_info :: (pip: sg_pipeline) -> sg_mtl_pipeline_info #foreign sokol_gfx_clib;
sg_wgpu_device :: () -> *void #foreign sokol_gfx_clib;
sg_wgpu_queue :: () -> *void #foreign sokol_gfx_clib;
sg_wgpu_command_encoder :: () -> *void #foreign sokol_gfx_clib;
sg_wgpu_render_pass_encoder :: () -> *void #foreign sokol_gfx_clib;
sg_wgpu_query_buffer_info :: (buf: sg_buffer) -> sg_wgpu_buffer_info #foreign sokol_gfx_clib;
sg_wgpu_query_image_info :: (img: sg_image) -> sg_wgpu_image_info #foreign sokol_gfx_clib;
sg_wgpu_query_sampler_info :: (smp: sg_sampler) -> sg_wgpu_sampler_info #foreign sokol_gfx_clib;
sg_wgpu_query_shader_info :: (shd: sg_shader) -> sg_wgpu_shader_info #foreign sokol_gfx_clib;
sg_wgpu_query_pipeline_info :: (pip: sg_pipeline) -> sg_wgpu_pipeline_info #foreign sokol_gfx_clib;
sg_wgpu_query_attachments_info :: (atts: sg_attachments) -> sg_wgpu_attachments_info #foreign sokol_gfx_clib;
sg_gl_query_buffer_info :: (buf: sg_buffer) -> sg_gl_buffer_info #foreign sokol_gfx_clib;
sg_gl_query_image_info :: (img: sg_image) -> sg_gl_image_info #foreign sokol_gfx_clib;
sg_gl_query_sampler_info :: (smp: sg_sampler) -> sg_gl_sampler_info #foreign sokol_gfx_clib;
sg_gl_query_shader_info :: (shd: sg_shader) -> sg_gl_shader_info #foreign sokol_gfx_clib;
sg_gl_query_attachments_info :: (atts: sg_attachments) -> sg_gl_attachments_info #foreign sokol_gfx_clib;

sg_buffer :: struct {
    id : u32;
}

sg_image :: struct {
    id : u32;
}

sg_sampler :: struct {
    id : u32;
}

sg_shader :: struct {
    id : u32;
}

sg_pipeline :: struct {
    id : u32;
}

sg_attachments :: struct {
    id : u32;
}

sg_range :: struct {
    ptr : *void;
    size : u64;
}

INVALID_ID :: 0;
NUM_SHADER_STAGES :: 2;
NUM_INFLIGHT_FRAMES :: 2;
MAX_COLOR_ATTACHMENTS :: 4;
MAX_VERTEX_BUFFERS :: 8;
MAX_SHADERSTAGE_IMAGES :: 12;
MAX_SHADERSTAGE_SAMPLERS :: 8;
MAX_SHADERSTAGE_IMAGESAMPLERPAIRS :: 12;
MAX_SHADERSTAGE_STORAGEBUFFERS :: 8;
MAX_SHADERSTAGE_UBS :: 4;
MAX_UB_MEMBERS :: 16;
MAX_VERTEX_ATTRIBUTES :: 16;
MAX_MIPMAPS :: 16;
MAX_TEXTUREARRAY_LAYERS :: 128;

sg_color :: struct {
    r : float;
    g : float;
    b : float;
    a : float;
}

sg_backend :: enum u32 {
    GLCORE;
    GLES3;
    D3D11;
    METAL_IOS;
    METAL_MACOS;
    METAL_SIMULATOR;
    WGPU;
    DUMMY;
}

sg_pixel_format :: enum u32 {
    DEFAULT;
    NONE;
    R8;
    R8SN;
    R8UI;
    R8SI;
    R16;
    R16SN;
    R16UI;
    R16SI;
    R16F;
    RG8;
    RG8SN;
    RG8UI;
    RG8SI;
    R32UI;
    R32SI;
    R32F;
    RG16;
    RG16SN;
    RG16UI;
    RG16SI;
    RG16F;
    RGBA8;
    SRGB8A8;
    RGBA8SN;
    RGBA8UI;
    RGBA8SI;
    BGRA8;
    RGB10A2;
    RG11B10F;
    RGB9E5;
    RG32UI;
    RG32SI;
    RG32F;
    RGBA16;
    RGBA16SN;
    RGBA16UI;
    RGBA16SI;
    RGBA16F;
    RGBA32UI;
    RGBA32SI;
    RGBA32F;
    DEPTH;
    DEPTH_STENCIL;
    BC1_RGBA;
    BC2_RGBA;
    BC3_RGBA;
    BC3_SRGBA;
    BC4_R;
    BC4_RSN;
    BC5_RG;
    BC5_RGSN;
    BC6H_RGBF;
    BC6H_RGBUF;
    BC7_RGBA;
    BC7_SRGBA;
    PVRTC_RGB_2BPP;
    PVRTC_RGB_4BPP;
    PVRTC_RGBA_2BPP;
    PVRTC_RGBA_4BPP;
    ETC2_RGB8;
    ETC2_SRGB8;
    ETC2_RGB8A1;
    ETC2_RGBA8;
    ETC2_SRGB8A8;
    EAC_R11;
    EAC_R11SN;
    EAC_RG11;
    EAC_RG11SN;
    ASTC_4x4_RGBA;
    ASTC_4x4_SRGBA;
}

sg_pixelformat_info :: struct {
    sample : bool;
    filter : bool;
    render : bool;
    blend : bool;
    msaa : bool;
    depth : bool;
    compressed : bool;
    bytes_per_pixel : s32;
}

sg_features :: struct {
    origin_top_left : bool;
    image_clamp_to_border : bool;
    mrt_independent_blend_state : bool;
    mrt_independent_write_mask : bool;
    storage_buffer : bool;
}

sg_limits :: struct {
    max_image_size_2d : s32;
    max_image_size_cube : s32;
    max_image_size_3d : s32;
    max_image_size_array : s32;
    max_image_array_layers : s32;
    max_vertex_attrs : s32;
    gl_max_vertex_uniform_components : s32;
    gl_max_combined_texture_image_units : s32;
}

sg_resource_state :: enum u32 {
    INITIAL;
    ALLOC;
    VALID;
    FAILED;
    INVALID;
}

sg_usage :: enum u32 {
    DEFAULT;
    IMMUTABLE;
    DYNAMIC;
    STREAM;
}

sg_buffer_type :: enum u32 {
    DEFAULT;
    VERTEXBUFFER;
    INDEXBUFFER;
    STORAGEBUFFER;
}

sg_index_type :: enum u32 {
    DEFAULT;
    NONE;
    UINT16;
    UINT32;
}

sg_image_type :: enum u32 {
    DEFAULT;
    _2D;
    CUBE;
    _3D;
    ARRAY;
}

sg_image_sample_type :: enum u32 {
    DEFAULT;
    FLOAT;
    DEPTH;
    SINT;
    UINT;
    UNFILTERABLE_FLOAT;
}

sg_sampler_type :: enum u32 {
    DEFAULT;
    FILTERING;
    NONFILTERING;
    COMPARISON;
}

sg_cube_face :: enum u32 {
    POS_X;
    NEG_X;
    POS_Y;
    NEG_Y;
    POS_Z;
    NEG_Z;
}

sg_shader_stage :: enum u32 {
    VS;
    FS;
}

sg_primitive_type :: enum u32 {
    DEFAULT;
    POINTS;
    LINES;
    LINE_STRIP;
    TRIANGLES;
    TRIANGLE_STRIP;
}

sg_filter :: enum u32 {
    DEFAULT;
    NONE;
    NEAREST;
    LINEAR;
}

sg_wrap :: enum u32 {
    DEFAULT;
    REPEAT;
    CLAMP_TO_EDGE;
    CLAMP_TO_BORDER;
    MIRRORED_REPEAT;
}

sg_border_color :: enum u32 {
    DEFAULT;
    TRANSPARENT_BLACK;
    OPAQUE_BLACK;
    OPAQUE_WHITE;
}

sg_vertex_format :: enum u32 {
    INVALID;
    FLOAT;
    FLOAT2;
    FLOAT3;
    FLOAT4;
    BYTE4;
    BYTE4N;
    UBYTE4;
    UBYTE4N;
    SHORT2;
    SHORT2N;
    USHORT2N;
    SHORT4;
    SHORT4N;
    USHORT4N;
    UINT10_N2;
    HALF2;
    HALF4;
}

sg_vertex_step :: enum u32 {
    DEFAULT;
    PER_VERTEX;
    PER_INSTANCE;
}

sg_uniform_type :: enum u32 {
    INVALID;
    FLOAT;
    FLOAT2;
    FLOAT3;
    FLOAT4;
    INT;
    INT2;
    INT3;
    INT4;
    MAT4;
}

sg_uniform_layout :: enum u32 {
    DEFAULT;
    NATIVE;
    STD140;
}

sg_cull_mode :: enum u32 {
    DEFAULT;
    NONE;
    FRONT;
    BACK;
}

sg_face_winding :: enum u32 {
    DEFAULT;
    CCW;
    CW;
}

sg_compare_func :: enum u32 {
    DEFAULT;
    NEVER;
    LESS;
    EQUAL;
    LESS_EQUAL;
    GREATER;
    NOT_EQUAL;
    GREATER_EQUAL;
    ALWAYS;
}

sg_stencil_op :: enum u32 {
    DEFAULT;
    KEEP;
    ZERO;
    REPLACE;
    INCR_CLAMP;
    DECR_CLAMP;
    INVERT;
    INCR_WRAP;
    DECR_WRAP;
}

sg_blend_factor :: enum u32 {
    DEFAULT;
    ZERO;
    ONE;
    SRC_COLOR;
    ONE_MINUS_SRC_COLOR;
    SRC_ALPHA;
    ONE_MINUS_SRC_ALPHA;
    DST_COLOR;
    ONE_MINUS_DST_COLOR;
    DST_ALPHA;
    ONE_MINUS_DST_ALPHA;
    SRC_ALPHA_SATURATED;
    BLEND_COLOR;
    ONE_MINUS_BLEND_COLOR;
    BLEND_ALPHA;
    ONE_MINUS_BLEND_ALPHA;
}

sg_blend_op :: enum u32 {
    DEFAULT;
    ADD;
    SUBTRACT;
    REVERSE_SUBTRACT;
}

sg_color_mask :: enum u32 {
    DEFAULT :: 0;
    NONE :: 16;
    R :: 1;
    G :: 2;
    RG :: 3;
    B :: 4;
    RB :: 5;
    GB :: 6;
    RGB :: 7;
    A :: 8;
    RA :: 9;
    GA :: 10;
    RGA :: 11;
    BA :: 12;
    RBA :: 13;
    GBA :: 14;
    RGBA :: 15;
}

sg_load_action :: enum u32 {
    DEFAULT;
    CLEAR;
    LOAD;
    DONTCARE;
}

sg_store_action :: enum u32 {
    DEFAULT;
    STORE;
    DONTCARE;
}

sg_color_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : sg_color;
}

sg_depth_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : float;
}

sg_stencil_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : u8;
}

sg_pass_action :: struct {
    colors : [4]sg_color_attachment_action;
    depth : sg_depth_attachment_action;
    stencil : sg_stencil_attachment_action;
}

sg_metal_swapchain :: struct {
    current_drawable : *void;
    depth_stencil_texture : *void;
    msaa_color_texture : *void;
}

sg_d3d11_swapchain :: struct {
    render_view : *void;
    resolve_view : *void;
    depth_stencil_view : *void;
}

sg_wgpu_swapchain :: struct {
    render_view : *void;
    resolve_view : *void;
    depth_stencil_view : *void;
}

sg_gl_swapchain :: struct {
    framebuffer : u32;
}

sg_swapchain :: struct {
    width : s32;
    height : s32;
    sample_count : s32;
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    metal : sg_metal_swapchain;
    d3d11 : sg_d3d11_swapchain;
    wgpu : sg_wgpu_swapchain;
    gl : sg_gl_swapchain;
}

sg_pass :: struct {
    _ : u32;
    action : sg_pass_action;
    attachments : sg_attachments;
    swapchain : sg_swapchain;
    label : *u8;
    _ : u32;
}

sg_stage_bindings :: struct {
    images : [12]sg_image;
    samplers : [8]sg_sampler;
    storage_buffers : [8]sg_buffer;
}

sg_bindings :: struct {
    _ : u32;
    vertex_buffers : [8]sg_buffer;
    vertex_buffer_offsets : [8]s32;
    index_buffer : sg_buffer;
    index_buffer_offset : s32;
    vs : sg_stage_bindings;
    fs : sg_stage_bindings;
    _ : u32;
}

sg_buffer_desc :: struct {
    _ : u32;
    size : u64;
    type : sg_buffer_type;
    usage : sg_usage;
    data : sg_range;
    label : *u8;
    gl_buffers : [2]u32;
    mtl_buffers : [2]*void;
    d3d11_buffer : *void;
    wgpu_buffer : *void;
    _ : u32;
}

sg_image_data :: struct {
    subimage : [6][16]sg_range;
}

sg_image_desc :: struct {
    _ : u32;
    type : sg_image_type;
    render_target : bool;
    width : s32;
    height : s32;
    num_slices : s32;
    num_mipmaps : s32;
    usage : sg_usage;
    pixel_format : sg_pixel_format;
    sample_count : s32;
    data : sg_image_data;
    label : *u8;
    gl_textures : [2]u32;
    gl_texture_target : u32;
    mtl_textures : [2]*void;
    d3d11_texture : *void;
    d3d11_shader_resource_view : *void;
    wgpu_texture : *void;
    wgpu_texture_view : *void;
    _ : u32;
}

sg_sampler_desc :: struct {
    _ : u32;
    min_filter : sg_filter;
    mag_filter : sg_filter;
    mipmap_filter : sg_filter;
    wrap_u : sg_wrap;
    wrap_v : sg_wrap;
    wrap_w : sg_wrap;
    min_lod : float;
    max_lod : float;
    border_color : sg_border_color;
    compare : sg_compare_func;
    max_anisotropy : u32;
    label : *u8;
    gl_sampler : u32;
    mtl_sampler : *void;
    d3d11_sampler : *void;
    wgpu_sampler : *void;
    _ : u32;
}

sg_shader_attr_desc :: struct {
    name : *u8;
    sem_name : *u8;
    sem_index : s32;
}

sg_shader_uniform_desc :: struct {
    name : *u8;
    type : sg_uniform_type;
    array_count : s32;
}

sg_shader_uniform_block_desc :: struct {
    size : u64;
    layout : sg_uniform_layout;
    uniforms : [16]sg_shader_uniform_desc;
}

sg_shader_storage_buffer_desc :: struct {
    used : bool;
    readonly : bool;
}

sg_shader_image_desc :: struct {
    used : bool;
    multisampled : bool;
    image_type : sg_image_type;
    sample_type : sg_image_sample_type;
}

sg_shader_sampler_desc :: struct {
    used : bool;
    sampler_type : sg_sampler_type;
}

sg_shader_image_sampler_pair_desc :: struct {
    used : bool;
    image_slot : s32;
    sampler_slot : s32;
    glsl_name : *u8;
}

sg_shader_stage_desc :: struct {
    source : *u8;
    bytecode : sg_range;
    entry : *u8;
    d3d11_target : *u8;
    uniform_blocks : [4]sg_shader_uniform_block_desc;
    storage_buffers : [8]sg_shader_storage_buffer_desc;
    images : [12]sg_shader_image_desc;
    samplers : [8]sg_shader_sampler_desc;
    image_sampler_pairs : [12]sg_shader_image_sampler_pair_desc;
}

sg_shader_desc :: struct {
    _ : u32;
    attrs : [16]sg_shader_attr_desc;
    vs : sg_shader_stage_desc;
    fs : sg_shader_stage_desc;
    label : *u8;
    _ : u32;
}

sg_vertex_buffer_layout_state :: struct {
    stride : s32;
    step_func : sg_vertex_step;
    step_rate : s32;
}

sg_vertex_attr_state :: struct {
    buffer_index : s32;
    offset : s32;
    format : sg_vertex_format;
}

sg_vertex_layout_state :: struct {
    buffers : [8]sg_vertex_buffer_layout_state;
    attrs : [16]sg_vertex_attr_state;
}

sg_stencil_face_state :: struct {
    compare : sg_compare_func;
    fail_op : sg_stencil_op;
    depth_fail_op : sg_stencil_op;
    pass_op : sg_stencil_op;
}

sg_stencil_state :: struct {
    enabled : bool;
    front : sg_stencil_face_state;
    back : sg_stencil_face_state;
    read_mask : u8;
    write_mask : u8;
    ref : u8;
}

sg_depth_state :: struct {
    pixel_format : sg_pixel_format;
    compare : sg_compare_func;
    write_enabled : bool;
    bias : float;
    bias_slope_scale : float;
    bias_clamp : float;
}

sg_blend_state :: struct {
    enabled : bool;
    src_factor_rgb : sg_blend_factor;
    dst_factor_rgb : sg_blend_factor;
    op_rgb : sg_blend_op;
    src_factor_alpha : sg_blend_factor;
    dst_factor_alpha : sg_blend_factor;
    op_alpha : sg_blend_op;
}

sg_color_target_state :: struct {
    pixel_format : sg_pixel_format;
    write_mask : sg_color_mask;
    blend : sg_blend_state;
}

sg_pipeline_desc :: struct {
    _ : u32;
    shader : sg_shader;
    layout : sg_vertex_layout_state;
    depth : sg_depth_state;
    stencil : sg_stencil_state;
    color_count : s32;
    colors : [4]sg_color_target_state;
    primitive_type : sg_primitive_type;
    index_type : sg_index_type;
    cull_mode : sg_cull_mode;
    face_winding : sg_face_winding;
    sample_count : s32;
    blend_color : sg_color;
    alpha_to_coverage_enabled : bool;
    label : *u8;
    _ : u32;
}

sg_attachment_desc :: struct {
    image : sg_image;
    mip_level : s32;
    slice : s32;
}

sg_attachments_desc :: struct {
    _ : u32;
    colors : [4]sg_attachment_desc;
    resolves : [4]sg_attachment_desc;
    depth_stencil : sg_attachment_desc;
    label : *u8;
    _ : u32;
}

sg_slot_info :: struct {
    state : sg_resource_state;
    res_id : u32;
}

sg_buffer_info :: struct {
    slot : sg_slot_info;
    update_frame_index : u32;
    append_frame_index : u32;
    append_pos : s32;
    append_overflow : bool;
    num_slots : s32;
    active_slot : s32;
}

sg_image_info :: struct {
    slot : sg_slot_info;
    upd_frame_index : u32;
    num_slots : s32;
    active_slot : s32;
}

sg_sampler_info :: struct {
    slot : sg_slot_info;
}

sg_shader_info :: struct {
    slot : sg_slot_info;
}

sg_pipeline_info :: struct {
    slot : sg_slot_info;
}

sg_attachments_info :: struct {
    slot : sg_slot_info;
}

sg_frame_stats_gl :: struct {
    num_bind_buffer : u32;
    num_active_texture : u32;
    num_bind_texture : u32;
    num_bind_sampler : u32;
    num_use_program : u32;
    num_render_state : u32;
    num_vertex_attrib_pointer : u32;
    num_vertex_attrib_divisor : u32;
    num_enable_vertex_attrib_array : u32;
    num_disable_vertex_attrib_array : u32;
    num_uniform : u32;
}

sg_frame_stats_d3d11_pass :: struct {
    num_om_set_render_targets : u32;
    num_clear_render_target_view : u32;
    num_clear_depth_stencil_view : u32;
    num_resolve_subresource : u32;
}

sg_frame_stats_d3d11_pipeline :: struct {
    num_rs_set_state : u32;
    num_om_set_depth_stencil_state : u32;
    num_om_set_blend_state : u32;
    num_ia_set_primitive_topology : u32;
    num_ia_set_input_layout : u32;
    num_vs_set_shader : u32;
    num_vs_set_constant_buffers : u32;
    num_ps_set_shader : u32;
    num_ps_set_constant_buffers : u32;
}

sg_frame_stats_d3d11_bindings :: struct {
    num_ia_set_vertex_buffers : u32;
    num_ia_set_index_buffer : u32;
    num_vs_set_shader_resources : u32;
    num_ps_set_shader_resources : u32;
    num_vs_set_samplers : u32;
    num_ps_set_samplers : u32;
}

sg_frame_stats_d3d11_uniforms :: struct {
    num_update_subresource : u32;
}

sg_frame_stats_d3d11_draw :: struct {
    num_draw_indexed_instanced : u32;
    num_draw_indexed : u32;
    num_draw_instanced : u32;
    num_draw : u32;
}

sg_frame_stats_d3d11 :: struct {
    pass : sg_frame_stats_d3d11_pass;
    pipeline : sg_frame_stats_d3d11_pipeline;
    bindings : sg_frame_stats_d3d11_bindings;
    uniforms : sg_frame_stats_d3d11_uniforms;
    draw : sg_frame_stats_d3d11_draw;
    num_map : u32;
    num_unmap : u32;
}

sg_frame_stats_metal_idpool :: struct {
    num_added : u32;
    num_released : u32;
    num_garbage_collected : u32;
}

sg_frame_stats_metal_pipeline :: struct {
    num_set_blend_color : u32;
    num_set_cull_mode : u32;
    num_set_front_facing_winding : u32;
    num_set_stencil_reference_value : u32;
    num_set_depth_bias : u32;
    num_set_render_pipeline_state : u32;
    num_set_depth_stencil_state : u32;
}

sg_frame_stats_metal_bindings :: struct {
    num_set_vertex_buffer : u32;
    num_set_vertex_texture : u32;
    num_set_vertex_sampler_state : u32;
    num_set_fragment_buffer : u32;
    num_set_fragment_texture : u32;
    num_set_fragment_sampler_state : u32;
}

sg_frame_stats_metal_uniforms :: struct {
    num_set_vertex_buffer_offset : u32;
    num_set_fragment_buffer_offset : u32;
}

sg_frame_stats_metal :: struct {
    idpool : sg_frame_stats_metal_idpool;
    pipeline : sg_frame_stats_metal_pipeline;
    bindings : sg_frame_stats_metal_bindings;
    uniforms : sg_frame_stats_metal_uniforms;
}

sg_frame_stats_wgpu_uniforms :: struct {
    num_set_bindgroup : u32;
    size_write_buffer : u32;
}

sg_frame_stats_wgpu_bindings :: struct {
    num_set_vertex_buffer : u32;
    num_skip_redundant_vertex_buffer : u32;
    num_set_index_buffer : u32;
    num_skip_redundant_index_buffer : u32;
    num_create_bindgroup : u32;
    num_discard_bindgroup : u32;
    num_set_bindgroup : u32;
    num_skip_redundant_bindgroup : u32;
    num_bindgroup_cache_hits : u32;
    num_bindgroup_cache_misses : u32;
    num_bindgroup_cache_collisions : u32;
    num_bindgroup_cache_hash_vs_key_mismatch : u32;
}

sg_frame_stats_wgpu :: struct {
    uniforms : sg_frame_stats_wgpu_uniforms;
    bindings : sg_frame_stats_wgpu_bindings;
}

sg_frame_stats :: struct {
    frame_index : u32;
    num_passes : u32;
    num_apply_viewport : u32;
    num_apply_scissor_rect : u32;
    num_apply_pipeline : u32;
    num_apply_bindings : u32;
    num_apply_uniforms : u32;
    num_draw : u32;
    num_update_buffer : u32;
    num_append_buffer : u32;
    num_update_image : u32;
    size_apply_uniforms : u32;
    size_update_buffer : u32;
    size_append_buffer : u32;
    size_update_image : u32;
    gl : sg_frame_stats_gl;
    d3d11 : sg_frame_stats_d3d11;
    metal : sg_frame_stats_metal;
    wgpu : sg_frame_stats_wgpu;
}

sg_log_item :: enum u32 {
    OK;
    MALLOC_FAILED;
    GL_TEXTURE_FORMAT_NOT_SUPPORTED;
    GL_3D_TEXTURES_NOT_SUPPORTED;
    GL_ARRAY_TEXTURES_NOT_SUPPORTED;
    GL_SHADER_COMPILATION_FAILED;
    GL_SHADER_LINKING_FAILED;
    GL_VERTEX_ATTRIBUTE_NOT_FOUND_IN_SHADER;
    GL_TEXTURE_NAME_NOT_FOUND_IN_SHADER;
    GL_FRAMEBUFFER_STATUS_UNDEFINED;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_ATTACHMENT;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MISSING_ATTACHMENT;
    GL_FRAMEBUFFER_STATUS_UNSUPPORTED;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MULTISAMPLE;
    GL_FRAMEBUFFER_STATUS_UNKNOWN;
    D3D11_CREATE_BUFFER_FAILED;
    D3D11_CREATE_BUFFER_SRV_FAILED;
    D3D11_CREATE_DEPTH_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_DEPTH_TEXTURE_FAILED;
    D3D11_CREATE_2D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_2D_TEXTURE_FAILED;
    D3D11_CREATE_2D_SRV_FAILED;
    D3D11_CREATE_3D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_3D_TEXTURE_FAILED;
    D3D11_CREATE_3D_SRV_FAILED;
    D3D11_CREATE_MSAA_TEXTURE_FAILED;
    D3D11_CREATE_SAMPLER_STATE_FAILED;
    D3D11_LOAD_D3DCOMPILER_47_DLL_FAILED;
    D3D11_SHADER_COMPILATION_FAILED;
    D3D11_SHADER_COMPILATION_OUTPUT;
    D3D11_CREATE_CONSTANT_BUFFER_FAILED;
    D3D11_CREATE_INPUT_LAYOUT_FAILED;
    D3D11_CREATE_RASTERIZER_STATE_FAILED;
    D3D11_CREATE_DEPTH_STENCIL_STATE_FAILED;
    D3D11_CREATE_BLEND_STATE_FAILED;
    D3D11_CREATE_RTV_FAILED;
    D3D11_CREATE_DSV_FAILED;
    D3D11_MAP_FOR_UPDATE_BUFFER_FAILED;
    D3D11_MAP_FOR_APPEND_BUFFER_FAILED;
    D3D11_MAP_FOR_UPDATE_IMAGE_FAILED;
    METAL_CREATE_BUFFER_FAILED;
    METAL_TEXTURE_FORMAT_NOT_SUPPORTED;
    METAL_CREATE_TEXTURE_FAILED;
    METAL_CREATE_SAMPLER_FAILED;
    METAL_SHADER_COMPILATION_FAILED;
    METAL_SHADER_CREATION_FAILED;
    METAL_SHADER_COMPILATION_OUTPUT;
    METAL_VERTEX_SHADER_ENTRY_NOT_FOUND;
    METAL_FRAGMENT_SHADER_ENTRY_NOT_FOUND;
    METAL_CREATE_RPS_FAILED;
    METAL_CREATE_RPS_OUTPUT;
    METAL_CREATE_DSS_FAILED;
    WGPU_BINDGROUPS_POOL_EXHAUSTED;
    WGPU_BINDGROUPSCACHE_SIZE_GREATER_ONE;
    WGPU_BINDGROUPSCACHE_SIZE_POW2;
    WGPU_CREATEBINDGROUP_FAILED;
    WGPU_CREATE_BUFFER_FAILED;
    WGPU_CREATE_TEXTURE_FAILED;
    WGPU_CREATE_TEXTURE_VIEW_FAILED;
    WGPU_CREATE_SAMPLER_FAILED;
    WGPU_CREATE_SHADER_MODULE_FAILED;
    WGPU_SHADER_TOO_MANY_IMAGES;
    WGPU_SHADER_TOO_MANY_SAMPLERS;
    WGPU_SHADER_TOO_MANY_STORAGEBUFFERS;
    WGPU_SHADER_CREATE_BINDGROUP_LAYOUT_FAILED;
    WGPU_CREATE_PIPELINE_LAYOUT_FAILED;
    WGPU_CREATE_RENDER_PIPELINE_FAILED;
    WGPU_ATTACHMENTS_CREATE_TEXTURE_VIEW_FAILED;
    IDENTICAL_COMMIT_LISTENER;
    COMMIT_LISTENER_ARRAY_FULL;
    TRACE_HOOKS_NOT_ENABLED;
    DEALLOC_BUFFER_INVALID_STATE;
    DEALLOC_IMAGE_INVALID_STATE;
    DEALLOC_SAMPLER_INVALID_STATE;
    DEALLOC_SHADER_INVALID_STATE;
    DEALLOC_PIPELINE_INVALID_STATE;
    DEALLOC_ATTACHMENTS_INVALID_STATE;
    INIT_BUFFER_INVALID_STATE;
    INIT_IMAGE_INVALID_STATE;
    INIT_SAMPLER_INVALID_STATE;
    INIT_SHADER_INVALID_STATE;
    INIT_PIPELINE_INVALID_STATE;
    INIT_ATTACHMENTS_INVALID_STATE;
    UNINIT_BUFFER_INVALID_STATE;
    UNINIT_IMAGE_INVALID_STATE;
    UNINIT_SAMPLER_INVALID_STATE;
    UNINIT_SHADER_INVALID_STATE;
    UNINIT_PIPELINE_INVALID_STATE;
    UNINIT_ATTACHMENTS_INVALID_STATE;
    FAIL_BUFFER_INVALID_STATE;
    FAIL_IMAGE_INVALID_STATE;
    FAIL_SAMPLER_INVALID_STATE;
    FAIL_SHADER_INVALID_STATE;
    FAIL_PIPELINE_INVALID_STATE;
    FAIL_ATTACHMENTS_INVALID_STATE;
    BUFFER_POOL_EXHAUSTED;
    IMAGE_POOL_EXHAUSTED;
    SAMPLER_POOL_EXHAUSTED;
    SHADER_POOL_EXHAUSTED;
    PIPELINE_POOL_EXHAUSTED;
    PASS_POOL_EXHAUSTED;
    BEGINPASS_ATTACHMENT_INVALID;
    DRAW_WITHOUT_BINDINGS;
    VALIDATE_BUFFERDESC_CANARY;
    VALIDATE_BUFFERDESC_SIZE;
    VALIDATE_BUFFERDESC_DATA;
    VALIDATE_BUFFERDESC_DATA_SIZE;
    VALIDATE_BUFFERDESC_NO_DATA;
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SUPPORTED;
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SIZE_MULTIPLE_4;
    VALIDATE_IMAGEDATA_NODATA;
    VALIDATE_IMAGEDATA_DATA_SIZE;
    VALIDATE_IMAGEDESC_CANARY;
    VALIDATE_IMAGEDESC_WIDTH;
    VALIDATE_IMAGEDESC_HEIGHT;
    VALIDATE_IMAGEDESC_RT_PIXELFORMAT;
    VALIDATE_IMAGEDESC_NONRT_PIXELFORMAT;
    VALIDATE_IMAGEDESC_MSAA_BUT_NO_RT;
    VALIDATE_IMAGEDESC_NO_MSAA_RT_SUPPORT;
    VALIDATE_IMAGEDESC_MSAA_NUM_MIPMAPS;
    VALIDATE_IMAGEDESC_MSAA_3D_IMAGE;
    VALIDATE_IMAGEDESC_DEPTH_3D_IMAGE;
    VALIDATE_IMAGEDESC_RT_IMMUTABLE;
    VALIDATE_IMAGEDESC_RT_NO_DATA;
    VALIDATE_IMAGEDESC_INJECTED_NO_DATA;
    VALIDATE_IMAGEDESC_DYNAMIC_NO_DATA;
    VALIDATE_IMAGEDESC_COMPRESSED_IMMUTABLE;
    VALIDATE_SAMPLERDESC_CANARY;
    VALIDATE_SAMPLERDESC_MINFILTER_NONE;
    VALIDATE_SAMPLERDESC_MAGFILTER_NONE;
    VALIDATE_SAMPLERDESC_ANISTROPIC_REQUIRES_LINEAR_FILTERING;
    VALIDATE_SHADERDESC_CANARY;
    VALIDATE_SHADERDESC_SOURCE;
    VALIDATE_SHADERDESC_BYTECODE;
    VALIDATE_SHADERDESC_SOURCE_OR_BYTECODE;
    VALIDATE_SHADERDESC_NO_BYTECODE_SIZE;
    VALIDATE_SHADERDESC_NO_CONT_UBS;
    VALIDATE_SHADERDESC_NO_CONT_UB_MEMBERS;
    VALIDATE_SHADERDESC_NO_UB_MEMBERS;
    VALIDATE_SHADERDESC_UB_MEMBER_NAME;
    VALIDATE_SHADERDESC_UB_SIZE_MISMATCH;
    VALIDATE_SHADERDESC_UB_ARRAY_COUNT;
    VALIDATE_SHADERDESC_UB_STD140_ARRAY_TYPE;
    VALIDATE_SHADERDESC_NO_CONT_STORAGEBUFFERS;
    VALIDATE_SHADERDESC_STORAGEBUFFER_READONLY;
    VALIDATE_SHADERDESC_NO_CONT_IMAGES;
    VALIDATE_SHADERDESC_NO_CONT_SAMPLERS;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_NAME_REQUIRED_FOR_GL;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_NAME_BUT_NOT_USED;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_IMAGE_BUT_NOT_USED;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_SAMPLER_BUT_NOT_USED;
    VALIDATE_SHADERDESC_NONFILTERING_SAMPLER_REQUIRED;
    VALIDATE_SHADERDESC_COMPARISON_SAMPLER_REQUIRED;
    VALIDATE_SHADERDESC_IMAGE_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS;
    VALIDATE_SHADERDESC_SAMPLER_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS;
    VALIDATE_SHADERDESC_NO_CONT_IMAGE_SAMPLER_PAIRS;
    VALIDATE_SHADERDESC_ATTR_STRING_TOO_LONG;
    VALIDATE_PIPELINEDESC_CANARY;
    VALIDATE_PIPELINEDESC_SHADER;
    VALIDATE_PIPELINEDESC_NO_CONT_ATTRS;
    VALIDATE_PIPELINEDESC_LAYOUT_STRIDE4;
    VALIDATE_PIPELINEDESC_ATTR_SEMANTICS;
    VALIDATE_ATTACHMENTSDESC_CANARY;
    VALIDATE_ATTACHMENTSDESC_NO_ATTACHMENTS;
    VALIDATE_ATTACHMENTSDESC_NO_CONT_COLOR_ATTS;
    VALIDATE_ATTACHMENTSDESC_IMAGE;
    VALIDATE_ATTACHMENTSDESC_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_FACE;
    VALIDATE_ATTACHMENTSDESC_LAYER;
    VALIDATE_ATTACHMENTSDESC_SLICE;
    VALIDATE_ATTACHMENTSDESC_IMAGE_NO_RT;
    VALIDATE_ATTACHMENTSDESC_COLOR_INV_PIXELFORMAT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_INV_PIXELFORMAT;
    VALIDATE_ATTACHMENTSDESC_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_IMAGE_SAMPLE_COUNTS;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_COLOR_IMAGE_MSAA;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SAMPLE_COUNT;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_FACE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_LAYER;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SLICE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_NO_RT;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_FORMAT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_DEPTH_FACE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_LAYER;
    VALIDATE_ATTACHMENTSDESC_DEPTH_SLICE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_NO_RT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SAMPLE_COUNT;
    VALIDATE_BEGINPASS_CANARY;
    VALIDATE_BEGINPASS_ATTACHMENTS_EXISTS;
    VALIDATE_BEGINPASS_ATTACHMENTS_VALID;
    VALIDATE_BEGINPASS_COLOR_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_RESOLVE_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_DEPTHSTENCIL_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_DEPTHFORMAT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_GL_EXPECT_FRAMEBUFFER_NOTSET;
    VALIDATE_APIP_PIPELINE_VALID_ID;
    VALIDATE_APIP_PIPELINE_EXISTS;
    VALIDATE_APIP_PIPELINE_VALID;
    VALIDATE_APIP_SHADER_EXISTS;
    VALIDATE_APIP_SHADER_VALID;
    VALIDATE_APIP_CURPASS_ATTACHMENTS_EXISTS;
    VALIDATE_APIP_CURPASS_ATTACHMENTS_VALID;
    VALIDATE_APIP_ATT_COUNT;
    VALIDATE_APIP_COLOR_FORMAT;
    VALIDATE_APIP_DEPTH_FORMAT;
    VALIDATE_APIP_SAMPLE_COUNT;
    VALIDATE_ABND_PIPELINE;
    VALIDATE_ABND_PIPELINE_EXISTS;
    VALIDATE_ABND_PIPELINE_VALID;
    VALIDATE_ABND_VBS;
    VALIDATE_ABND_VB_EXISTS;
    VALIDATE_ABND_VB_TYPE;
    VALIDATE_ABND_VB_OVERFLOW;
    VALIDATE_ABND_NO_IB;
    VALIDATE_ABND_IB;
    VALIDATE_ABND_IB_EXISTS;
    VALIDATE_ABND_IB_TYPE;
    VALIDATE_ABND_IB_OVERFLOW;
    VALIDATE_ABND_VS_EXPECTED_IMAGE_BINDING;
    VALIDATE_ABND_VS_IMG_EXISTS;
    VALIDATE_ABND_VS_IMAGE_TYPE_MISMATCH;
    VALIDATE_ABND_VS_IMAGE_MSAA;
    VALIDATE_ABND_VS_EXPECTED_FILTERABLE_IMAGE;
    VALIDATE_ABND_VS_EXPECTED_DEPTH_IMAGE;
    VALIDATE_ABND_VS_UNEXPECTED_IMAGE_BINDING;
    VALIDATE_ABND_VS_EXPECTED_SAMPLER_BINDING;
    VALIDATE_ABND_VS_UNEXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_VS_EXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_VS_EXPECTED_NONFILTERING_SAMPLER;
    VALIDATE_ABND_VS_UNEXPECTED_SAMPLER_BINDING;
    VALIDATE_ABND_VS_SMP_EXISTS;
    VALIDATE_ABND_VS_EXPECTED_STORAGEBUFFER_BINDING;
    VALIDATE_ABND_VS_STORAGEBUFFER_EXISTS;
    VALIDATE_ABND_VS_STORAGEBUFFER_BINDING_BUFFERTYPE;
    VALIDATE_ABND_VS_UNEXPECTED_STORAGEBUFFER_BINDING;
    VALIDATE_ABND_FS_EXPECTED_IMAGE_BINDING;
    VALIDATE_ABND_FS_IMG_EXISTS;
    VALIDATE_ABND_FS_IMAGE_TYPE_MISMATCH;
    VALIDATE_ABND_FS_IMAGE_MSAA;
    VALIDATE_ABND_FS_EXPECTED_FILTERABLE_IMAGE;
    VALIDATE_ABND_FS_EXPECTED_DEPTH_IMAGE;
    VALIDATE_ABND_FS_UNEXPECTED_IMAGE_BINDING;
    VALIDATE_ABND_FS_EXPECTED_SAMPLER_BINDING;
    VALIDATE_ABND_FS_UNEXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_FS_EXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_FS_EXPECTED_NONFILTERING_SAMPLER;
    VALIDATE_ABND_FS_UNEXPECTED_SAMPLER_BINDING;
    VALIDATE_ABND_FS_SMP_EXISTS;
    VALIDATE_ABND_FS_EXPECTED_STORAGEBUFFER_BINDING;
    VALIDATE_ABND_FS_STORAGEBUFFER_EXISTS;
    VALIDATE_ABND_FS_STORAGEBUFFER_BINDING_BUFFERTYPE;
    VALIDATE_ABND_FS_UNEXPECTED_STORAGEBUFFER_BINDING;
    VALIDATE_AUB_NO_PIPELINE;
    VALIDATE_AUB_NO_UB_AT_SLOT;
    VALIDATE_AUB_SIZE;
    VALIDATE_UPDATEBUF_USAGE;
    VALIDATE_UPDATEBUF_SIZE;
    VALIDATE_UPDATEBUF_ONCE;
    VALIDATE_UPDATEBUF_APPEND;
    VALIDATE_APPENDBUF_USAGE;
    VALIDATE_APPENDBUF_SIZE;
    VALIDATE_APPENDBUF_UPDATE;
    VALIDATE_UPDIMG_USAGE;
    VALIDATE_UPDIMG_ONCE;
    VALIDATION_FAILED;
}

sg_environment_defaults :: struct {
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
}

sg_metal_environment :: struct {
    device : *void;
}

sg_d3d11_environment :: struct {
    device : *void;
    device_context : *void;
}

sg_wgpu_environment :: struct {
    device : *void;
}

sg_environment :: struct {
    defaults : sg_environment_defaults;
    metal : sg_metal_environment;
    d3d11 : sg_d3d11_environment;
    wgpu : sg_wgpu_environment;
}

sg_commit_listener :: struct {
    func : (a0: *void) #c_call;
    user_data : *void;
}

sg_allocator :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sg_logger :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sg_desc :: struct {
    _ : u32;
    buffer_pool_size : s32;
    image_pool_size : s32;
    sampler_pool_size : s32;
    shader_pool_size : s32;
    pipeline_pool_size : s32;
    attachments_pool_size : s32;
    uniform_buffer_size : s32;
    max_commit_listeners : s32;
    disable_validation : bool;
    mtl_force_managed_storage_mode : bool;
    mtl_use_command_buffer_with_retained_references : bool;
    wgpu_disable_bindgroups_cache : bool;
    wgpu_bindgroups_cache_size : s32;
    allocator : sg_allocator;
    logger : sg_logger;
    environment : sg_environment;
    _ : u32;
}

sg_d3d11_buffer_info :: struct {
    buf : *void;
}

sg_d3d11_image_info :: struct {
    tex2d : *void;
    tex3d : *void;
    res : *void;
    srv : *void;
}

sg_d3d11_sampler_info :: struct {
    smp : *void;
}

sg_d3d11_shader_info :: struct {
    vs_cbufs : [4]*void;
    fs_cbufs : [4]*void;
    vs : *void;
    fs : *void;
}

sg_d3d11_pipeline_info :: struct {
    il : *void;
    rs : *void;
    dss : *void;
    bs : *void;
}

sg_d3d11_attachments_info :: struct {
    color_rtv : [4]*void;
    resolve_rtv : [4]*void;
    dsv : *void;
}

sg_mtl_buffer_info :: struct {
    buf : [2]*void;
    active_slot : s32;
}

sg_mtl_image_info :: struct {
    tex : [2]*void;
    active_slot : s32;
}

sg_mtl_sampler_info :: struct {
    smp : *void;
}

sg_mtl_shader_info :: struct {
    vs_lib : *void;
    fs_lib : *void;
    vs_func : *void;
    fs_func : *void;
}

sg_mtl_pipeline_info :: struct {
    rps : *void;
    dss : *void;
}

sg_wgpu_buffer_info :: struct {
    buf : *void;
}

sg_wgpu_image_info :: struct {
    tex : *void;
    view : *void;
}

sg_wgpu_sampler_info :: struct {
    smp : *void;
}

sg_wgpu_shader_info :: struct {
    vs_mod : *void;
    fs_mod : *void;
    bgl : *void;
}

sg_wgpu_pipeline_info :: struct {
    pip : *void;
}

sg_wgpu_attachments_info :: struct {
    color_view : [4]*void;
    resolve_view : [4]*void;
    ds_view : *void;
}

sg_gl_buffer_info :: struct {
    buf : [2]u32;
    active_slot : s32;
}

sg_gl_image_info :: struct {
    tex : [2]u32;
    tex_target : u32;
    msaa_render_buffer : u32;
    active_slot : s32;
}

sg_gl_sampler_info :: struct {
    smp : u32;
}

sg_gl_shader_info :: struct {
    prog : u32;
}

sg_gl_attachments_info :: struct {
    framebuffer : u32;
    msaa_resolve_framebuffer : [4]u32;
}

