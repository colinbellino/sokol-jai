//------------------------------------------------------------------------------
//  debugtext-print.jai
//
//  Simple text rendering with sokol/debugtext, formatting, tabs, etc...
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log";
#import,dir "../../sokol/gfx";
#import,dir "../../sokol/app";
#import,dir "../../sokol/glue";
#import,dir "../../sokol/debugtext";

NUM_FONTS  :: 3;

Color :: struct {
    r, g, b: u8;
}

default_context: Context;
state: struct {
    pass_action: sg_pass_action;
    palette: [3]Color;
} = .{
    pass_action = .{
        colors = .[
            .{ load_action = .CLEAR, clear_value = .{ 0.0, 0.125, 0.25, 1.0 } },
            .{}, .{}, .{},
        ],
    },
    palette = .[
        .{ 0xf4, 0x43, 0x36 },
        .{ 0x21, 0x96, 0xf3 },
        .{ 0x4c, 0xaf, 0x50 },
    ],
};

init :: () #c_call {
    push_context default_context {
        desc := sg_desc.{
            environment = xx sglue_environment(),
            logger = .{ func = slog_func },
        };
        sg_setup(*desc);

        sdtx_desc := sdtx_desc_t.{
            fonts = .[
                sdtx_font_kc854(),
                sdtx_font_c64(),
                sdtx_font_oric(),
                .{}, .{}, .{}, .{}, .{},
            ],
            logger = .{ func = slog_func },
        };
        sdtx_setup(*sdtx_desc);

        // // a vertex buffer with 3 vertices
        // vertices := float.[
        //     // positions         // colors
        //     0.0,  0.5, 0.5,     1.0, 0.0, 0.0, 1.0,
        //     0.5, -0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
        //     -0.5, -0.5, 0.5,    0.0, 0.0, 1.0, 1.0,
        // ];
        // buffer := sg_buffer_desc.{ data = .{ ptr = *vertices, size = vertices.count * size_of(float) } };
        // state.bind.vertex_buffers[0] = sg_make_buffer(*buffer);

        // // create a shader and pipeline object (default render states are fine for triangle)
        // ATTR_vs_position :: 0;
        // ATTR_vs_color    :: 1;
        // pipeline: sg_pipeline_desc;
        // pipeline.shader = sg_make_shader(*triangle_shader_desc(sg_query_backend()));
        // pipeline.layout.attrs[ATTR_vs_position] = .{ format = .FLOAT3 };
        // pipeline.layout.attrs[ATTR_vs_color]    = .{ format = .FLOAT4 };
        // state.pip = sg_make_pipeline(*pipeline);

        // // a pass action to clear framebuffer to black
        // state.pass_action.colors[0] = .{ load_action = .CLEAR, clear_value = .{ r = 0, g = 0, b = 0, a = 1 } };
    }
}

frame :: () #c_call {
    frame_count := cast(u32) sapp_frame_count();
    frame_time := sapp_frame_duration() * 1000.0;

    push_context default_context {
        sdtx_canvas(sapp_widthf() * 0.5, sapp_heightf() * 0.5);
        sdtx_origin(3.0, 3.0);
        for i : 0 .. NUM_FONTS-1 {
            color := state.palette[i];
            sdtx_font(xx i);
            sdtx_color3b(color.r, color.g, color.b);
            sdtx_printf("Hello '%'!\n", ifx((frame_count & (1<<7)) == 0) then "Welt" else "World");
            sdtx_printf("\tFrame Time:\t\t%.3f\n", frame_time);
            sdtx_printf("\tFrame Count:\t%d\t0x%04X\n", frame_count, frame_count);
            sdtx_putr("Range Test 1(xyzbla)", 12);
            sdtx_putr("\nRange Test 2\n", 32);
            sdtx_move_y(2);
        }
    }

    pass := sg_pass.{ action = state.pass_action, swapchain = xx sglue_swapchain() };
    sg_begin_pass(*pass);
    sdtx_draw();
    sg_end_pass();
    sg_commit();
}

cleanup :: () #c_call {
    sdtx_shutdown();
    sg_shutdown();
}

main :: () {
    desc := sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 640,
        height = 480,
        window_title = "debugtext-printf",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    };
    sapp_run(*desc);
}
