// machine generated, do not edit

/*

    sokol_framebuffer.h -- pixel framebuffer for CPU rendering

    Project URL: https://github.com/floooh/sokol

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)     - your own assert macro (default: assert(c))
    SOKOL_FRAMEBUFFER_API_DECL - public function declaration prefix (default: extern)
    SOKOL_API_DECL      - same as SOKOL_FRAMEBUFFER_API_DECL
    SOKOL_API_IMPL      - public function implementation prefix (default: -)

    If sokol_framebuffer.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    NOTE: the implementation is written in C99 and cannot be compiled in C++ mode,
    the declaration can be used from C++ though.

    WHAT
    ====
    Provides old-school pixel framebuffers for CPU rendering in two pixel format:

    - direct RGBA8 (32 bits per pixel)
    - 8-bits per pixel indexing a 256-entry RGBA8 color palette

    HOW
    ===
    First initialize sokol_framebuffer.h via:

        sfb_setup(&(sfb_desc){
            .logger.func = slog_func,
        });

    If you need more than 8 framebuffers at the same time, increase the
    framebuffer pool:

        sfb_setup(&(sfb_desc){
            .framebuffer_pool_size = 129,
            .logger.func = slog_func,
        });

    You can also provide a custom allocator:

        sfb_setup(&(sfb_desc){
            .framebuffer_pool_size = 129,
            .allocator = {
                .alloc_fn = my_malloc,
                .free_fn = my_free,
                .user_data = my_user_data,
            }
            .logger.func = slog_func,
        });

    Next, create one or more framebuffers. You need to provide at least
    a width and height:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
        });

    By default this creates an RGBA8 framebuffer. To get the paletted format
    (1 byte per pixel and 256 color palette entries):

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
        });

    You can also provide a 'prescale factor'. This allows to balance
    pixel crispiness against bluriness. E.g. if you want your final rendered
    framebuffer to look less blurry but not quite have the harsh look
    of nearest filtering, try a prescale factor of 2:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
        });

    You can rotate the framebuffer by 90 degrees, this is mainly useful to
    emulate some classic arcade machines where a regular 4:3 CRT was installed
    in 'portrait mode':

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
        });

    You can define a sub-rectangle of the framebuffer to be rendered. For instance
    to only render the upper-left quadrant of a 320x256 framebuffer:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 512
            .height = 512,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
            .cliprect = {
                .x = 0,
                .y = 0,
                .width = 160,
                .height = 128,
            }
        });

    Finally if you plan to render the framebuffer in a render pass with different
    properties than the default swapchain format, you'll need to provide
    a color- and depth-pixelformat and a sample count which matches the
    properties of the render pass:

        sfb_framebuffer fb = sfb_make_framebuffer(&(sfb_framebuffer_desc){
            .width = 320,
            .height = 256,
            .format = SFB_FORMAT_PALETTE8,
            .prescale = 2,
            .rotate90 = true,
            .render_pass = {
                .color_format = SG_PIXELFORMAT_...
                .depth_format = SG_PIXELFORMAT_...
                .sample_count = ...,
            },
        });

    The actual pixel buffer and color palette are owned by you. For a 320x256
    framebuffer with 32-bits per pixel (SFB_FORMAT_RGBA8), use an uint32_t
    buffer like this:

        uint32_t pixels[256][320];

    For the paletted format (1 byte per pixel and a 256 entry color palette):

        uint8_t pixels[256][320];
        uint32_t palette[256];

    ...now 'render' into the pixel and palette buffers with the CPU.

    An RGBA8 pixel or palette entry split into red, green, blue, alpha like this:

        |AAAAAAAA|BBBBBBBB|GGGGGGGG|RRRRRRRR|

    E.g. bits 24 to 31 are the alpha component, bits 16 to 23 the blue component,
    bits 8 to 15 to green component and bits 0 to 7 the red component. Or typically:

        uint8_t a = 255;
        uint8_t r = ...;
        uint8_t g = ...;
        uint8_t b = ...;
        uint32 pixel = (a << 24) | (b << 16) | (g << 8) | r;

    Whenever the pixel buffer or color palette content changes, call sfb_update()
    outside a sokol-gfx render pass, and ONLY ONCE PER FRAME at most:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
            .palette = SG_RANGE(palette),
        });

    Of course for an RGBA8 framebuffer you'd only provide the pixels:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
        });

    ...but even for a paletted framebuffer you can omit the data that doesn't
    change. E.g. when only the palette changes but not the pixel data:

        sfb_update(fb, &(sfb_update_desc){
            .palette = SG_RANGE(palette),
        });

    ...or vice versa when only the pixels but not the palette entries change:

        sfb_update(fb, &(sfb_update_desc){
            .pixels = SG_RANGE(pixels),
        });

    The sfb_update() function will do up to two calls to the sokol-gfx
    function sg_update_image() - once for the pixel data and once for the
    palette data (this is why the function must only be called at most
    once per frame), and then do an render pass into an internal color attachment
    texture (this is why the function must be called outside any sokol-gfx
    pass).

    Finally, to render your framebuffer to the display, call sfb_render()
    *inside* a sokol-gfx render pass:

        sg_begin_pass(...);
        sfb_render(fb);
        ...
        sg_end_pass();

    This will stretch the framebuffer to the whole canvas which might distort
    its aspect ratio. If you want a fixed aspect ratio consider setting a
    viewport with the help of sokol_letterbox.h.

    For more control over the rendering process, call sfb_render_ex() instead.
    For instance to override the default sampler with linear filtering and
    instead use a builtin sampler with nearest filtering:

        sfb_render_ex(fb, &(sfb_render_desc){
            .use_nearest_filter = true,
        });

    Note though that the prescale factor provided in the sfb_make_framebuffer()
    call is a better way to tweak bluriness vs crispiness. Only use the
    nearest-filter override if you want a 100% pixelized look.

    The main purpose of sfb_render_ex() is to inject a more advanced shader though
    (like a CRT shader).

    TODO: refer to a future sokol_crt.h header.

    If any of the sizing properties of the framebuffer changes, call:

        bool size_changed = sfb_resize(fb, &(sfb_resize_desc){
            .width = new_width,
            .height = new_height,
            .prescale = new_prescale,
            .cliprect = new_cliprect
        });

    The sfb_resize() function is 'lazy', it will only destroy and recreate internal
    objects when actually needed (e.g. the size of image objects has changed). In
    that case, true is returned. When the function returns false, it was
    basically a cheap no-op.

    If you want to do the final rendering entirely yourself you can get handles
    to all the internally used resources of a framebuffer object via:

        sfb_framebuffer_info info = sfb_query_framebuffer_info(fb);

    This returns handles to all internal image, view and sampler objects
    as well as image sizes and pixel formats.

    To query the current 'resource state' of a framebuffer:

        sfb_resoure_state state = sfb_query_framebuffer_state(fb);

    ...this is mainly useful to check whether framebuffer creation via
    sfb_make_framebuffer() had failed.

    To get a copy the the sfb_framebuffer_desc struct (patched with defaults)
    of a framebuffer object:

        sfb_framebuffer_desc desc = sfb_query_framebuffer_desc(fb);

    To destroy a framebuffer object:

        sfb_destroy_framebuffer(fb);

    ...calling sfb_shutdown() will also destroy any remaining framebuffer
    objects:

        sfb_shutdown();


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
#import,dir "../gfx"(DEBUG = USE_DLL, USE_GL = USE_DLL, USE_DLL = USE_DLL);

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            
            #if  DEBUG { sokol_framebuffer_clib :: #library "sokol_framebuffer_windows_x64_gl_debug";   }
            else       { sokol_framebuffer_clib :: #library "sokol_framebuffer_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_framebuffer_clib :: #library "sokol_framebuffer_windows_x64_d3d11_debug";   }
            else       { sokol_framebuffer_clib :: #library "sokol_framebuffer_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            
            #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_windows_x64_gl_debug";   }
            else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_windows_x64_gl_release"; }
        } else {
            
            #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_windows_x64_d3d11_debug";   }
            else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_framebuffer_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_arm64_gl_debug";   }
                else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_x64_gl_debug";   }
                else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_x64_gl_release"; }
            }
        } else {
            
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_arm64_metal_debug";   }
                else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_x64_metal_debug";   }
                else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_linux_x64_gl_debug";   }
    else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_wasm_gl_debug";   }
    else       { sokol_framebuffer_clib :: #library,no_dll "sokol_framebuffer_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

// setup sokol-framebuffer
sfb_setup :: (desc: *sfb_desc) -> void #foreign sokol_framebuffer_clib;
// shutdown sokol-framebuffer
sfb_shutdown :: () -> void #foreign sokol_framebuffer_clib;
// create a framebuffer object
sfb_make_framebuffer :: (desc: *sfb_framebuffer_desc) -> sfb_framebuffer #foreign sokol_framebuffer_clib;
// destroy framebuffer object
sfb_destroy_framebuffer :: (fb: sfb_framebuffer) -> void #foreign sokol_framebuffer_clib;
// resize internal images (no-op if resize isn't needed), return true when images had to be re-created
sfb_resize :: (fb: sfb_framebuffer, desc: *sfb_resize_desc) -> bool #foreign sokol_framebuffer_clib;
// update framebuffer and/or color palette content (must be called outside any sokol-gfx pass)
sfb_update :: (fb: sfb_framebuffer, desc: *sfb_update_desc) -> void #foreign sokol_framebuffer_clib;
// draw framebuffer content with default shader (must be called inside a sokol-gfx render pass)
sfb_render :: (fb: sfb_framebuffer) -> void #foreign sokol_framebuffer_clib;
// draw framebuffer content with injected shader (must be called inside a sokol-gfx render pass)
sfb_render_ex :: (fb: sfb_framebuffer, desc: *sfb_render_desc) -> void #foreign sokol_framebuffer_clib;
// query framebuffer resource state (valid or failed)
sfb_query_framebuffer_state :: (fb: sfb_framebuffer) -> sfb_resource_state #foreign sokol_framebuffer_clib;
// query current framebuffer properties
sfb_query_framebuffer_info :: (fb: sfb_framebuffer) -> sfb_framebuffer_info #foreign sokol_framebuffer_clib;
// query the framebuffer desc, with default values patched in
sfb_query_framebuffer_desc :: (fb: sfb_framebuffer) -> sfb_framebuffer_desc #foreign sokol_framebuffer_clib;

INVALID_ID :: 0;

sfb_framebuffer :: struct {
    id : u32;
}

/*
    sfb_resource_state

    The state of a framebuffer object, obtainable via sfg_query_framebuffer_state().
    Publicly visible values are only SFB_RESOURCESTATE_VALID
    and SFB_RESOURCESTATE_FAILED.
*/
sfb_resource_state :: enum u32 {
    INITIAL;
    ALLOC;
    VALID;
    FAILED;
    INVALID;
}

/*
    sfb_format

    The framebuffer pixel format. Either RGBA8 direct color where each
    pixel is an uint32_t, or paletted format with uint8_t pixels as
    index into a 256 entry color palette.
*/
sfb_format :: enum u32 {
    DEFAULT :: 0;
    RGBA8;
    PALETTE8;
}

sfb_rect :: struct {
    x : s32;
    y : s32;
    width : s32;
    height : s32;
}

sfb_render_pass_desc :: struct {
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
}

sfb_framebuffer_desc :: struct {
    width : s32;
    height : s32;
    prescale : s32;
    format : sfb_format;
    cliprect : sfb_rect;
    rotate90 : bool;
    render_pass : sfb_render_pass_desc;
}

sfb_resize_desc :: struct {
    width : s32;
    height : s32;
    prescale : s32;
    cliprect : sfb_rect;
}

sfb_update_desc :: struct {
    pixels : sg_range;
    palette : sg_range;
}

sfb_render_desc :: struct {
    use_nearest_filter : bool;
    pip : sg_pipeline;
    views : [32]sg_view;
    samplers : [12]sg_sampler;
    uniforms : [8]sg_range;
}

sfb_texture_info :: struct {
    width : s32;
    height : s32;
    pixel_format : sg_pixel_format;
    image : sg_image;
    tex_view : sg_view;
}

sfb_framebuffer_info :: struct {
    update : sfb_texture_info;
    offscreen : sfb_texture_info;
    palette : sfb_texture_info;
    nearest_sampler : sg_sampler;
    linear_sampler : sg_sampler;
}

sfb_allocator :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sfb_logger :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sfb_desc :: struct {
    framebuffer_pool_size : s32;
    allocator : sfb_allocator;
    logger : sfb_logger;
}

