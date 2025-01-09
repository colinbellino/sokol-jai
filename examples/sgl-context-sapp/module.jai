//------------------------------------------------------------------------------
//  sgl-context-sapp/module.jai
//
//  Demonstrates how to render in different render passes with sokol_gl.h
//  using sokol-gl contexts.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#import,dir "../../sokol/shape"(USE_GL=USE_GL);
#import,dir "../../sokol/gl"(USE_GL=USE_GL);
#load "../math.jai";

SGL_DEFAULT_CONTEXT :: sgl_context.{ 0x00010001 };

OFFSCREEN_PIXELFORMAT :: sg_pixel_format.RGBA8;
OFFSCREEN_SAMPLECOUNT :: 1;
OFFSCREEN_WIDTH :: 32;
OFFSCREEN_HEIGHT :: 32;

state: struct {
    angle_deg: float64;
    offscreen: struct {
        pass_action: sg_pass_action;
        attachments: sg_attachments;
        img: sg_image;
        sgl_ctx: sgl_context;
    };
    display: struct {
        pass_action: sg_pass_action;
        smp: sg_sampler;
        sgl_pip: sgl_pipeline;
    };
}

init :: () #c_call {
    push_context,defer_pop;

    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger.func = slog_func,
    }));

    // setup sokol-gl with the default context compatible with the default render pass
    sgl_setup(*(sgl_desc_t.{
        max_vertices = 64,
        max_commands = 16,
        logger.func = slog_func,
    }));

    // pass action and pipeline for the default render pass
    state.display.pass_action = .{
        colors[0] = .{
            load_action = .CLEAR,
            clear_value = .{ 0.5, 0.7, 1.0, 1.0 },
        },
    };
    state.display.sgl_pip = sgl_context_make_pipeline(sgl_default_context(), xx *(sg_pipeline_desc.{
        cull_mode = .BACK,
        depth = .{
            write_enabled = true,
            compare = .LESS_EQUAL,
        },
    }));

    // create a sokol-gl context compatible with the offscreen render pass
    // (specific color pixel format, no depth-stencil-surface, no MSAA)
    state.offscreen.sgl_ctx = sgl_make_context(*(sgl_context_desc_t.{
        max_vertices = 8,
        max_commands = 4,
        color_format = xx OFFSCREEN_PIXELFORMAT,
        depth_format = .NONE,
        sample_count = OFFSCREEN_SAMPLECOUNT,
    }));

    // create an offscreen render target texture, pass, and pass_action
    state.offscreen.img = sg_make_image(*(sg_image_desc.{
        render_target = true,
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        pixel_format = xx OFFSCREEN_PIXELFORMAT,
        sample_count = xx OFFSCREEN_SAMPLECOUNT,
    }));
    state.offscreen.attachments = sg_make_attachments(*(sg_attachments_desc.{
        colors[0].image = state.offscreen.img,
    }));
    state.offscreen.pass_action = .{
        colors[0] = .{
            load_action = .CLEAR,
            clear_value = .{ 0.0, 0.0, 0.0, 1.0 },
        },
    };

    // a sampler for sampling the offscreen render target
    state.display.smp = sg_make_sampler(*(sg_sampler_desc.{
        wrap_u = .CLAMP_TO_EDGE,
        wrap_v = .CLAMP_TO_EDGE,
        min_filter = .NEAREST,
        mag_filter = .NEAREST,
    }));
}

frame :: () #c_call {
    push_context,defer_pop;

    state.angle_deg += sapp_frame_duration() * 60.0;
    a := sgl_rad(cast(float) state.angle_deg);

    // draw a rotating quad into the offscreen render target texture
    sgl_set_context(state.offscreen.sgl_ctx);
    sgl_defaults();
    sgl_matrix_mode_modelview();
    sgl_rotate(a, 0.0, 0.0, 1.0);
    draw_quad();

    // draw a rotating 3D cube, using the offscreen render target as texture
    sgl_set_context(SGL_DEFAULT_CONTEXT);
    sgl_defaults();
    sgl_enable_texture();
    sgl_texture(xx,force state.offscreen.img, xx,force state.display.smp);
    sgl_load_pipeline(state.display.sgl_pip);
    sgl_matrix_mode_projection();
    sgl_perspective(sgl_rad(45.0), sapp_widthf()/sapp_heightf(), 0.1, 100.0);
    eye := float.[ sin(a) * 6.0, sin(a) * 3.0, cos(a) * 6.0 ];
    sgl_matrix_mode_modelview();
    sgl_lookat(eye[0], eye[1], eye[2], 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    draw_cube();

    // do the actual offscreen and display rendering in sokol-gfx passes
    sg_begin_pass(*(sg_pass.{ action = state.offscreen.pass_action, attachments = state.offscreen.attachments }));
        sgl_context_draw(state.offscreen.sgl_ctx);
    sg_end_pass();
    sg_begin_pass(*(sg_pass.{ action = state.display.pass_action, swapchain = xx,force sglue_swapchain() }));
        sgl_context_draw(SGL_DEFAULT_CONTEXT);
    sg_end_pass();
    sg_commit();
}

// helper function to draw a colored quad with sokol-gl
draw_quad :: () {
    sgl_begin_quads();
    sgl_v2f_c3b( 0.0, -1.0, 255, 0, 0);
    sgl_v2f_c3b( 1.0,  0.0, 0, 0, 255);
    sgl_v2f_c3b( 0.0,  1.0, 0, 255, 255);
    sgl_v2f_c3b(-1.0,  0.0, 0, 255, 0);
    sgl_end();
}

// helper function to draw a textured cube with sokol-gl
draw_cube :: () {
    sgl_begin_quads();
    sgl_v3f_t2f(-1.0,  1.0, -1.0, 0.0, 1.0);
    sgl_v3f_t2f( 1.0,  1.0, -1.0, 1.0, 1.0);
    sgl_v3f_t2f( 1.0, -1.0, -1.0, 1.0, 0.0);
    sgl_v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl_v3f_t2f(-1.0, -1.0,  1.0, 0.0, 1.0);
    sgl_v3f_t2f( 1.0, -1.0,  1.0, 1.0, 1.0);
    sgl_v3f_t2f( 1.0,  1.0,  1.0, 1.0, 0.0);
    sgl_v3f_t2f(-1.0,  1.0,  1.0, 0.0, 0.0);
    sgl_v3f_t2f(-1.0, -1.0,  1.0, 0.0, 1.0);
    sgl_v3f_t2f(-1.0,  1.0,  1.0, 1.0, 1.0);
    sgl_v3f_t2f(-1.0,  1.0, -1.0, 1.0, 0.0);
    sgl_v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl_v3f_t2f( 1.0, -1.0,  1.0, 0.0, 1.0);
    sgl_v3f_t2f( 1.0, -1.0, -1.0, 1.0, 1.0);
    sgl_v3f_t2f( 1.0,  1.0, -1.0, 1.0, 0.0);
    sgl_v3f_t2f( 1.0,  1.0,  1.0, 0.0, 0.0);
    sgl_v3f_t2f( 1.0, -1.0, -1.0, 0.0, 1.0);
    sgl_v3f_t2f( 1.0, -1.0,  1.0, 1.0, 1.0);
    sgl_v3f_t2f(-1.0, -1.0,  1.0, 1.0, 0.0);
    sgl_v3f_t2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl_v3f_t2f(-1.0,  1.0, -1.0, 0.0, 1.0);
    sgl_v3f_t2f(-1.0,  1.0,  1.0, 1.0, 1.0);
    sgl_v3f_t2f( 1.0,  1.0,  1.0, 1.0, 0.0);
    sgl_v3f_t2f( 1.0,  1.0, -1.0, 0.0, 0.0);
    sgl_end();
}

cleanup :: () #c_call {
    sgl_shutdown();
    sg_shutdown();
}

main :: () {
    sapp_run(*(sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "sokol-gl contexts (sapp)",
        icon.sokol_default = true,
        logger.func = slog_func,
    }));
}
