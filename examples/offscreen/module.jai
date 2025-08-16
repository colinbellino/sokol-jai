//------------------------------------------------------------------------------
//  offscreen/main.jai
//
//  Render to an offscreen rendertarget texture, and use this texture
//  for rendering to the display.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#import,dir "../../sokol/shape"(USE_GL=USE_GL);
#load "../math.jai";
#load "./shader.jai";

OFFSCREEN_SAMPLE_COUNT :: 1;
OFFSCREEN_WIDTH :: 256;
OFFSCREEN_HEIGHT :: 256;

state: struct {
    offscreen: struct {
        pass: sg_pass;
        pip:  sg_pipeline;
        bind: sg_bindings;
    };
    display: struct {
        pass_action: sg_pass_action;
        pip:         sg_pipeline;
        bind:        sg_bindings;
    };
    donut:    sshape_element_range_t;
    sphere:   sshape_element_range_t;
    rx, ry:   float;
    vertices: [4000]sshape_vertex_t;
    indices:  [24000]u16;
}

init :: () #c_call {
    push_context,defer_pop;

    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger = .{ func = slog_func },
    }));

    // display render pass action: clear to blue-ish
    state.display.pass_action = .{
        colors[0] = .{ load_action = .CLEAR, clear_value = .{ 0.25, 0.45, 0.65, 1.0 } },
    };

    // offscreen pass action: clear to grey
    state.offscreen.pass.action = .{
        colors[0] = .{ load_action = .CLEAR, clear_value = .{ 0.25, 0.25, 0.25, 1.0 } },
    };

    // setup the color- and depth-stencil-attachment images and video
    color_img := sg_make_image(*(sg_image_desc.{
        usage = .{ color_attachment = true },
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        pixel_format = .RGBA8,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
    }));
    depth_img := sg_make_image(*(sg_image_desc.{
        usage = .{ depth_stencil_attachment = true },
        width = OFFSCREEN_WIDTH,
        height = OFFSCREEN_HEIGHT,
        pixel_format = .DEPTH,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
    }));

    // the offscreen render pass needs a color- and a depth-stencil-attachment view
    state.offscreen.pass.attachments.colors[0] = sg_make_view(*(sg_view_desc.{
        color_attachment = .{ image = color_img },
    }));
    state.offscreen.pass.attachments.depth_stencil = sg_make_view(*(sg_view_desc.{
        depth_stencil_attachments = .{ image = depth_img },
    }));

    // the display render pass needs a texture view on the color image
    state.display.bind.views[VIEW_tex] = sg_make_view(*(sg_view_desc.{
        .texture = .{ image = color_img },
    });

    // a donut shape which is rendered into the offscreen render target, and
    // a sphere shape which is rendered into the default framebuffer
    buf := sshape_buffer_t.{
        vertices = .{ buffer = .{ ptr = *state.vertices, size = size_of(type_of(state.vertices)) } },
        indices  = .{ buffer = .{ ptr = *state.indices,  size = size_of(type_of(state.indices)) } },
    };

    buf = sshape_build_torus(*buf, *(sshape_torus_t.{
        radius = 0.5,
        ring_radius = 0.3,
        sides = 20,
        rings = 30,
    }));
    state.donut = sshape_element_range(*buf);

    buf = sshape_build_sphere(*buf, *(sshape_sphere_t.{
        radius = 0.5,
        slices = 72,
        stacks = 40,
    }));
    state.sphere = sshape_element_range(*buf);

    vbuf := sg_make_buffer(xx,force *sshape_vertex_buffer_desc(*buf));
    state.offscreen.bind.vertex_buffers[0] = vbuf;
    state.display.bind.vertex_buffers[0] = vbuf;
    ibuf := sg_make_buffer(xx,force *sshape_index_buffer_desc(*buf));
    state.offscreen.bind.index_buffer = ibuf;
    state.display.bind.index_buffer = ibuf;

    // pipeline-state-object for offscreen-rendered donut, don't need texture coord here
    offscreen_pip_desc := sg_pipeline_desc.{
        shader = sg_make_shader(*offscreen_shader_desc(sg_query_backend())),
        index_type = .UINT16,
        cull_mode = .BACK,
        sample_count = OFFSCREEN_SAMPLE_COUNT,
        depth = .{
            pixel_format = .DEPTH,
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
        colors[0] = .{ pixel_format = .RGBA8 },
    };
    offscreen_pip_desc.layout.buffers[0] = xx,force sshape_vertex_buffer_layout_state();
    offscreen_pip_desc.layout.attrs[ATTR_offscreen_position] = xx,force sshape_position_vertex_attr_state();
    offscreen_pip_desc.layout.attrs[ATTR_offscreen_normal] = xx,force sshape_normal_vertex_attr_state();
    state.offscreen.pip = sg_make_pipeline(*offscreen_pip_desc);

    // and another pipeline-state-object for the default pass
    display_pip_desc := sg_pipeline_desc.{
        shader = sg_make_shader(*default_shader_desc(sg_query_backend())),
        index_type = .UINT16,
        cull_mode = .BACK,
        depth = .{
            compare = .LESS_EQUAL,
            write_enabled = true,
        },
    };
    display_pip_desc.layout.buffers[0] = xx,force sshape_vertex_buffer_layout_state();
    display_pip_desc.layout.attrs[ATTR_default_position] = xx,force sshape_position_vertex_attr_state();
    display_pip_desc.layout.attrs[ATTR_default_normal] = xx,force sshape_normal_vertex_attr_state();
    display_pip_desc.layout.attrs[ATTR_default_texcoord0] = xx,force sshape_texcoord_vertex_attr_state();
    state.display.pip = sg_make_pipeline(*display_pip_desc);

    // a sampler object for sampling the render target as texture
    state.display.bind.samplers[SMP_smp] := sg_make_sampler(*(sg_sampler_desc.{
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        wrap_u = .REPEAT,
        wrap_v = .REPEAT,
    }));
}

frame :: () #c_call {
    push_context,defer_pop;

    t := cast(float) (sapp_frame_duration() * 60.0);
    state.rx += 1.0 * t;
    state.ry += 2.0 * t;

    // the offscreen pass, rendering an rotating, untextured donut into a render target image
    vs_params := Vs_Params.{
        mvp = compute_mvp(rx = state.rx, ry = state.ry, aspect = 1.0, eye_dist = 2.5),
    };
    sg_begin_pass(*state.offscreen.pass);
    sg_apply_pipeline(state.offscreen.pip);
    sg_apply_bindings(*state.offscreen.bind);
    sg_apply_uniforms(UB_vs_params, *(sg_range.{ ptr = *vs_params, size = size_of(type_of(vs_params)) }));
    sg_draw(state.donut.base_element, state.donut.num_elements, 1);
    sg_end_pass();

    // and the display-pass, rendering a rotating textured sphere which uses the
    // previously rendered offscreen render-target as texture
    vs_params = Vs_Params.{
        mvp = compute_mvp(
            rx = -state.rx * 0.25,
            ry = state.ry * 0.25,
            aspect = sapp_widthf() / sapp_heightf(),
            eye_dist = 2.0,
        ),
    };
    sg_begin_pass(*(sg_pass.{ action = state.display.pass_action, swapchain = xx,force sglue_swapchain() }));
    sg_apply_pipeline(state.display.pip);
    sg_apply_bindings(*state.display.bind);
    sg_apply_uniforms(UB_vs_params, *(sg_range.{ ptr = *vs_params, size = size_of(type_of(vs_params)) }));
    sg_draw(state.sphere.base_element, state.sphere.num_elements, 1);
    sg_end_pass();

    sg_commit();
}

compute_mvp :: (rx: float, ry: float, aspect: float, eye_dist: float) -> Matrix4 {
    proj := persp_mat4(fov = 45.0, aspect = aspect, near = 0.01, far = 10.0);
    view := lookat_mat4(eye = .{ 0.0, 0.0, eye_dist }, center = .{}, up = .{ 0.0, 1.0, 0.0 });
    view_proj := multiply_mat4(proj, view);
    rxm := rotate_mat4(rx, .{ 1.0, 0.0, 0.0 });
    rym := rotate_mat4(ry, .{ 0.0, 1.0, 0.0 });
    model := multiply_mat4(rym, rxm);
    mvp := multiply_mat4(view_proj, model);
    return mvp;
}

cleanup :: () #c_call {
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
        window_title = "offscreen",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
