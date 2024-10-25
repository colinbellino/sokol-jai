//------------------------------------------------------------------------------
//  blend/module.jai
//
//  Test/demonstrate blend modes.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#load "../math.jai";
#load "./shader.jai";

NUM_BLEND_FACTORS :: 15;

default_context: Context;
state: struct {
    pass_action:    sg_pass_action;
    bind:           sg_bindings;
    pips:           [NUM_BLEND_FACTORS][NUM_BLEND_FACTORS]sg_pipeline;
    bg_pip:         sg_pipeline;
    r:              float;
    quad_vs_params: Quad_Vs_Params;
    bg_fs_params:   Bg_Fs_Params;
}

init :: () #c_call {
    push_context,defer_pop default_context;
    sg_setup(*(sg_desc.{
        pipeline_pool_size = NUM_BLEND_FACTORS * NUM_BLEND_FACTORS + 1,
        environment = xx sglue_environment(),
        logger = .{ func = slog_func },
    }));

    // a quad vertex buffer
    vertices := float.[
        // pos            color
        -1.0, -1.0, 0.0,  1.0, 0.0, 0.0, 0.5,
        +1.0, -1.0, 0.0,  0.0, 1.0, 0.0, 0.5,
        -1.0, +1.0, 0.0,  0.0, 0.0, 1.0, 0.5,
        +1.0, +1.0, 0.0,  1.0, 1.0, 0.0, 0.5,
    ];
    buffer := sg_buffer_desc.{ data = .{ ptr = *vertices, size = size_of(type_of(vertices)) } };
    state.bind.vertex_buffers[0] = sg_make_buffer(*buffer);

    // shader and pipeline object for rendering the background quad
    bg_pip_desc: sg_pipeline_desc;
    bg_pip_desc.shader = sg_make_shader(*bg_shader_desc(sg_query_backend()));
    // we use the same vertex buffer as for the colored 3D quads,
    // but only the first two floats from the position, need to
    // provide a stride to skip the gap to the next vertex
    bg_pip_desc.layout.buffers[0] = .{ stride = 28 };
    bg_pip_desc.layout.attrs[ATTR_bg_position] = .{ format = .FLOAT2 };
    bg_pip_desc.primitive_type = .TRIANGLE_STRIP;
    state.bg_pip = sg_make_pipeline(*bg_pip_desc);

    // a shader for the blended quads
    quad_shd := sg_make_shader(*quad_shader_desc(sg_query_backend()));

    // one pipeline object per blend-factor combination
    pip_desc := sg_pipeline_desc.{
        shader = quad_shd,
        primitive_type = .TRIANGLE_STRIP,
        blend_color = .{ 1.0, 0.0, 0.0, 1.0 },
    };
    pip_desc.layout.attrs[ATTR_quad_position] = .{ format = .FLOAT3 };
    pip_desc.layout.attrs[ATTR_quad_color0]   = .{ format = .FLOAT4 };
    for src : 0 .. NUM_BLEND_FACTORS-1 {
        for dst : 0 .. NUM_BLEND_FACTORS-1 {
            pip_desc.colors[0].blend = .{
                enabled = true,
                src_factor_rgb = cast(sg_blend_factor) (src + 1),
                dst_factor_rgb = cast(sg_blend_factor) (dst + 1),
                src_factor_alpha = .ONE,
                dst_factor_alpha = .ZERO,
            };
            state.pips[src][dst] = sg_make_pipeline(*pip_desc);
        }
    }
}

frame :: () #c_call {
    push_context,defer_pop default_context;
    t := cast(float) (sapp_frame_duration() * 60.0);
    state.r += 0.6 * t;
    state.bg_fs_params.tick += 1.0 * t;

    // view-projection matrix
    proj := persp_mat4(fov = 90.0, aspect = sapp_widthf() / sapp_heightf(), near = 0.01, far = 100.0);
    view := lookat_mat4(eye = .{ 0.0, 0.0, 25.0 }, center = .{}, up = .{ 0.0, 1.0, 0.0 });
    view_proj := multiply_mat4(proj, view);

    // start rendering
    sg_begin_pass(*(sg_pass.{ action = state.pass_action, swapchain = xx sglue_swapchain() }));

    // draw a background quad
    sg_apply_pipeline(state.bg_pip);
    sg_apply_bindings(*state.bind);
    sg_apply_uniforms(UB_bg_fs_params, *(sg_range.{ ptr = *state.bg_fs_params, size = size_of(Bg_Fs_Params) }));
    sg_draw(0, 4, 1);

    // draw the blended quads
    r0 := state.r;
    for src : 0 .. NUM_BLEND_FACTORS - 1 {
        for dst : 0 .. NUM_BLEND_FACTORS - 1 {
            // compute model-view-proj matrix
            rm := rotate_mat4(r0, .{ 0.0, 1.0, 0.0 });
            x := cast(float) (dst - NUM_BLEND_FACTORS/2) * 3.0;
            y := cast(float) (src - NUM_BLEND_FACTORS/2) * 2.2;
            model := multiply_mat4(translate_mat4(.{ x, y, 0.0 }), rm);
            state.quad_vs_params.mvp = multiply_mat4(view_proj, model);

            sg_apply_pipeline(state.pips[src][dst]);
            sg_apply_bindings(*state.bind);
            sg_apply_uniforms(UB_quad_vs_params, *(sg_range.{ ptr = *state.quad_vs_params, size = size_of(Quad_Vs_Params) }));
            sg_draw(0, 4, 1);
        }
    }
    sg_end_pass();
    sg_commit();
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
        window_title = "blend",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
