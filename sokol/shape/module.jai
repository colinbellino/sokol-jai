// machine generated, do not edit

/*

    sokol_shape.h -- create simple primitive shapes for sokol_gfx.h

    Project URL: https://github.com/floooh/sokol

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_SHAPE_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    Include the following headers before including sokol_shape.h:

        sokol_gfx.h

    ...optionally provide the following macros to override defaults:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_SHAPE_API_DECL- public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_SHAPE_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_shape.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_SHAPE_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    FEATURE OVERVIEW
    ================
    sokol_shape.h creates vertices and indices for simple shapes and
    builds structs which can be plugged into sokol-gfx resource
    creation functions:

    The following shape types are supported:

        - plane
        - cube
        - sphere (with poles, not geodesic)
        - cylinder
        - torus (donut)

    Generated vertices look like this:

        typedef struct sshape_vertex_t {
            float x, y, z;
            uint32_t normal;        // packed normal as BYTE4N
            uint16_t u, v;          // packed uv coords as USHORT2N
            uint32_t color;         // packed color as UBYTE4N (r,g,b,a);
        } sshape_vertex_t;

    Indices are generally 16-bits wide (SG_INDEXTYPE_UINT16) and the indices
    are written as triangle-lists (SG_PRIMITIVETYPE_TRIANGLES).

    EXAMPLES:
    =========

    Create multiple shapes into the same vertex- and index-buffer and
    render with separate draw calls:

    https://github.com/floooh/sokol-samples/blob/master/sapp/shapes-sapp.c

    Same as the above, but pre-transform shapes and merge them into a single
    shape that's rendered with a single draw call.

    https://github.com/floooh/sokol-samples/blob/master/sapp/shapes-transform-sapp.c

    STEP-BY-STEP:
    =============

    Setup an sshape_buffer_t struct with pointers to memory buffers where
    generated vertices and indices will be written to:

    ```c
    sshape_vertex_t vertices[512];
    uint16_t indices[4096];

    sshape_buffer_t buf = {
        .vertices = {
            .buffer = SSHAPE_RANGE(vertices),
        },
        .indices = {
            .buffer = SSHAPE_RANGE(indices),
        }
    };
    ```

    To find out how big those memory buffers must be (in case you want
    to allocate dynamically) call the following functions:

    ```c
    sshape_sizes_t sshape_plane_sizes(uint32_t tiles);
    sshape_sizes_t sshape_box_sizes(uint32_t tiles);
    sshape_sizes_t sshape_sphere_sizes(uint32_t slices, uint32_t stacks);
    sshape_sizes_t sshape_cylinder_sizes(uint32_t slices, uint32_t stacks);
    sshape_sizes_t sshape_torus_sizes(uint32_t sides, uint32_t rings);
    ```

    The returned sshape_sizes_t struct contains vertex- and index-counts
    as well as the equivalent buffer sizes in bytes. For instance:

    ```c
    sshape_sizes_t sizes = sshape_sphere_sizes(36, 12);
    uint32_t num_vertices = sizes.vertices.num;
    uint32_t num_indices = sizes.indices.num;
    uint32_t vertex_buffer_size = sizes.vertices.size;
    uint32_t index_buffer_size = sizes.indices.size;
    ```

    With the sshape_buffer_t struct that was setup earlier, call any
    of the shape-builder functions:

    ```c
    sshape_buffer_t sshape_build_plane(const sshape_buffer_t* buf, const sshape_plane_t* params);
    sshape_buffer_t sshape_build_box(const sshape_buffer_t* buf, const sshape_box_t* params);
    sshape_buffer_t sshape_build_sphere(const sshape_buffer_t* buf, const sshape_sphere_t* params);
    sshape_buffer_t sshape_build_cylinder(const sshape_buffer_t* buf, const sshape_cylinder_t* params);
    sshape_buffer_t sshape_build_torus(const sshape_buffer_t* buf, const sshape_torus_t* params);
    ```

    Note how the sshape_buffer_t struct is both an input value and the
    return value. This can be used to append multiple shapes into the
    same vertex- and index-buffers (more on this later).

    The second argument is a struct which holds creation parameters.

    For instance to build a sphere with radius 2, 36 "cake slices" and 12 stacks:

    ```c
    sshape_buffer_t buf = ...;
    buf = sshape_build_sphere(&buf, &(sshape_sphere_t){
        .radius = 2.0f,
        .slices = 36,
        .stacks = 12,
    });
    ```

    If the provided buffers are big enough to hold all generated vertices and
    indices, the "valid" field in the result will be true:

    ```c
    assert(buf.valid);
    ```

    The shape creation parameters have "useful defaults", refer to the
    actual C struct declarations below to look up those defaults.

    You can also provide additional creation parameters, like a common vertex
    color, a debug-helper to randomize colors, tell the shape builder function
    to merge the new shape with the previous shape into the same draw-element-range,
    or a 4x4 transform matrix to move, rotate and scale the generated vertices:

    ```c
    sshape_buffer_t buf = ...;
    buf = sshape_build_sphere(&buf, &(sshape_sphere_t){
        .radius = 2.0f,
        .slices = 36,
        .stacks = 12,
        // merge with previous shape into a single element-range
        .merge = true,
        // set vertex color to red+opaque
        .color = sshape_color_4f(1.0f, 0.0f, 0.0f, 1.0f),
        // set position to y = 2.0
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                { 0.0f, 2.0f, 0.0f, 1.0f },
            }
        }
    });
    assert(buf.valid);
    ```

    The following helper functions can be used to build a packed
    color value or to convert from external matrix types:

    ```c
    uint32_t sshape_color_4f(float r, float g, float b, float a);
    uint32_t sshape_color_3f(float r, float g, float b);
    uint32_t sshape_color_4b(uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    uint32_t sshape_color_3b(uint8_t r, uint8_t g, uint8_t b);
    sshape_mat4_t sshape_mat4(const float m[16]);
    sshape_mat4_t sshape_mat4_transpose(const float m[16]);
    ```

    After the shape builder function has been called, the following functions
    are used to extract the build result for plugging into sokol_gfx.h:

    ```c
    sshape_element_range_t sshape_element_range(const sshape_buffer_t* buf);
    sg_buffer_desc sshape_vertex_buffer_desc(const sshape_buffer_t* buf);
    sg_buffer_desc sshape_index_buffer_desc(const sshape_buffer_t* buf);
    sg_vertex_buffer_layout_state sshape_vertex_buffer_layout_state(void);
    sg_vertex_attr_state sshape_position_vertex_attr_state(void);
    sg_vertex_attr_state sshape_normal_vertex_attr_state(void);
    sg_vertex_attr_state sshape_texcoord_vertex_attr_state(void);
    sg_vertex_attr_state sshape_color_vertex_attr_state(void);
    ```

    The sshape_element_range_t struct contains the base-index and number of
    indices which can be plugged into the sg_draw() call:

    ```c
    sshape_element_range_t elms = sshape_element_range(&buf);
    ...
    sg_draw(elms.base_element, elms.num_elements, 1);
    ```

    To create sokol-gfx vertex- and index-buffers from the generated
    shape data:

    ```c
    // create sokol-gfx vertex buffer
    sg_buffer_desc vbuf_desc = sshape_vertex_buffer_desc(&buf);
    sg_buffer vbuf = sg_make_buffer(&vbuf_desc);

    // create sokol-gfx index buffer
    sg_buffer_desc ibuf_desc = sshape_index_buffer_desc(&buf);
    sg_buffer ibuf = sg_make_buffer(&ibuf_desc);
    ```

    The remaining functions are used to populate the vertex-layout item
    in sg_pipeline_desc, note that these functions don't depend on the
    created geometry, they always return the same result:

    ```c
    sg_pipeline pip = sg_make_pipeline(&(sg_pipeline_desc){
        .layout = {
            .buffers[0] = sshape_vertex_buffer_layout_state(),
            .attrs = {
                [0] = sshape_position_vertex_attr_state(),
                [1] = ssape_normal_vertex_attr_state(),
                [2] = sshape_texcoord_vertex_attr_state(),
                [3] = sshape_color_vertex_attr_state()
            }
        },
        ...
    });
    ```

    Note that you don't have to use all generated vertex attributes in the
    pipeline's vertex layout, the sg_vertex_buffer_layout_state struct returned
    by sshape_vertex_buffer_layout_state() contains the correct vertex stride
    to skip vertex components.

    WRITING MULTIPLE SHAPES INTO THE SAME BUFFER
    ============================================
    You can merge multiple shapes into the same vertex- and
    index-buffers and either render them as a single shape, or
    in separate draw calls.

    To build a single shape made of two cubes which can be rendered
    in a single draw-call:

    ```
    sshape_vertex_t vertices[128];
    uint16_t indices[16];

    sshape_buffer_t buf = {
        .vertices.buffer = SSHAPE_RANGE(vertices),
        .indices.buffer  = SSHAPE_RANGE(indices)
    };

    // first cube at pos x=-2.0 (with default size of 1x1x1)
    buf = sshape_build_cube(&buf, &(sshape_box_t){
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                {-2.0f, 0.0f, 0.0f, 1.0f },
            }
        }
    });
    // ...and append another cube at pos pos=+1.0
    // NOTE the .merge = true, this tells the shape builder
    // function to not advance the current shape start offset
    buf = sshape_build_cube(&buf, &(sshape_box_t){
        .merge = true,
        .transform = {
            .m = {
                { 1.0f, 0.0f, 0.0f, 0.0f },
                { 0.0f, 1.0f, 0.0f, 0.0f },
                { 0.0f, 0.0f, 1.0f, 0.0f },
                {-2.0f, 0.0f, 0.0f, 1.0f },
            }
        }
    });
    assert(buf.valid);

    // skipping buffer- and pipeline-creation...

    sshape_element_range_t elms = sshape_element_range(&buf);
    sg_draw(elms.base_element, elms.num_elements, 1);
    ```

    To render the two cubes in separate draw-calls, the element-ranges used
    in the sg_draw() calls must be captured right after calling the
    builder-functions:

    ```c
    sshape_vertex_t vertices[128];
    uint16_t indices[16];
    sshape_buffer_t buf = {
        .vertices.buffer = SSHAPE_RANGE(vertices),
        .indices.buffer = SSHAPE_RANGE(indices)
    };

    // build a red cube...
    buf = sshape_build_cube(&buf, &(sshape_box_t){
        .color = sshape_color_3b(255, 0, 0)
    });
    sshape_element_range_t red_cube = sshape_element_range(&buf);

    // append a green cube to the same vertex-/index-buffer:
    buf = sshape_build_cube(&bud, &sshape_box_t){
        .color = sshape_color_3b(0, 255, 0);
    });
    sshape_element_range_t green_cube = sshape_element_range(&buf);

    // skipping buffer- and pipeline-creation...

    sg_draw(red_cube.base_element, red_cube.num_elements, 1);
    sg_draw(green_cube.base_element, green_cube.num_elements, 1);
    ```

    ...that's about all :)

    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2020 Andre Weissflog

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
    #if  DEBUG { sokol_shape_clib :: #library,no_dll "sokol_shape_wasm_gl_debug";   }
    else       { sokol_shape_clib :: #library,no_dll "sokol_shape_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

// shape builder functions
sshape_build_plane :: (buf: *sshape_buffer_t, params: *sshape_plane_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_box :: (buf: *sshape_buffer_t, params: *sshape_box_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_sphere :: (buf: *sshape_buffer_t, params: *sshape_sphere_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_cylinder :: (buf: *sshape_buffer_t, params: *sshape_cylinder_t) -> sshape_buffer_t #foreign sokol_shape_clib;
sshape_build_torus :: (buf: *sshape_buffer_t, params: *sshape_torus_t) -> sshape_buffer_t #foreign sokol_shape_clib;
// query required vertex- and index-buffer sizes in bytes
sshape_plane_sizes :: (tiles: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_box_sizes :: (tiles: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_sphere_sizes :: (slices: u32, stacks: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_cylinder_sizes :: (slices: u32, stacks: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
sshape_torus_sizes :: (sides: u32, rings: u32) -> sshape_sizes_t #foreign sokol_shape_clib;
// extract sokol-gfx desc structs and primitive ranges from build state
sshape_element_range :: (buf: *sshape_buffer_t) -> sshape_element_range_t #foreign sokol_shape_clib;
sshape_vertex_buffer_desc :: (buf: *sshape_buffer_t) -> sg_buffer_desc #foreign sokol_shape_clib;
sshape_index_buffer_desc :: (buf: *sshape_buffer_t) -> sg_buffer_desc #foreign sokol_shape_clib;
sshape_vertex_buffer_layout_state :: () -> sg_vertex_buffer_layout_state #foreign sokol_shape_clib;
sshape_position_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_normal_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_texcoord_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
sshape_color_vertex_attr_state :: () -> sg_vertex_attr_state #foreign sokol_shape_clib;
// helper functions to build packed color value from floats or bytes
sshape_color_4f :: (r: float, g: float, b: float, a: float) -> u32 #foreign sokol_shape_clib;
sshape_color_3f :: (r: float, g: float, b: float) -> u32 #foreign sokol_shape_clib;
sshape_color_4b :: (r: u8, g: u8, b: u8, a: u8) -> u32 #foreign sokol_shape_clib;
sshape_color_3b :: (r: u8, g: u8, b: u8) -> u32 #foreign sokol_shape_clib;
// adapter function for filling matrix struct from generic float[16] array
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

