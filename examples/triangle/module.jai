//------------------------------------------------------------------------------
//  triangle/module.jai
//
//  Hello Triangle sample.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#load "./shader.jai";

state: struct {
    pip:         sg_pipeline;
    bind:        sg_bindings;
    pass_action: sg_pass_action;
}

init :: () #c_call {
    push_context,defer_pop;

    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger = .{ func = slog_func },
    }));

    // a vertex buffer with 3 vertices
    vertices := float.[
        // positions         // colors
        0.0,  0.5, 0.5,     1.0, 0.0, 0.0, 1.0,
        0.5, -0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5,    0.0, 0.0, 1.0, 1.0,
    ];
    buffer := sg_buffer_desc.{ data = .{ ptr = *vertices, size = size_of(type_of(vertices)) } };
    state.bind.vertex_buffers[0] = sg_make_buffer(*buffer);

    // create shader from code-generated sg_shader_desc
    shd := sg_make_shader(*triangle_shader_desc(sg_query_backend()));

    // create a shader and pipeline object (default render states are fine for triangle)
    pipeline: sg_pipeline_desc;
    pipeline.shader = shd;
    pipeline.layout.attrs[ATTR_triangle_position] = .{ format = .FLOAT3 };
    pipeline.layout.attrs[ATTR_triangle_color0]   = .{ format = .FLOAT4 };
    state.pip = sg_make_pipeline(*pipeline);

    // a pass action to clear framebuffer to black
    state.pass_action.colors[0] = .{ load_action = .CLEAR, clear_value = .{ 0, 0, 0,1 } };
}

frame :: () #c_call {
    sg_begin_pass(*(sg_pass.{ action = state.pass_action, swapchain = xx,force sglue_swapchain() }));
    sg_apply_pipeline(state.pip);
    sg_apply_bindings(*state.bind);
    sg_draw(0, 3, 1);
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
        width = 640,
        height = 480,
        window_title = "triangle",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
