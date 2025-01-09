//------------------------------------------------------------------------------
//  debugtext-print/module.jai
//
//  Simple text rendering with sokol/debugtext, formatting, tabs, etc...
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#import,dir "../../sokol/debugtext"(USE_GL=USE_GL);

NUM_FONTS  :: 3;

Color :: struct {
    r, g, b: u8;
}

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
    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger = .{ func = slog_func },
    }));

    sdtx_setup(*(sdtx_desc_t.{
        fonts[0] = sdtx_font_kc854(),
        fonts[1] = sdtx_font_c64(),
        fonts[2] = sdtx_font_oric(),
        logger = .{ func = slog_func },
    }));
}

frame :: () #c_call {
    push_context,defer_pop;

    frame_count := cast(u32) sapp_frame_count();
    frame_time := sapp_frame_duration() * 1000.0;

    sdtx_canvas(sapp_widthf() * 0.5, sapp_heightf() * 0.5);
    sdtx_origin(3.0, 3.0);
    for i : 0 .. NUM_FONTS-1 {
        color := state.palette[i];
        sdtx_font(cast(s32) i);
        sdtx_color3b(color.r, color.g, color.b);
        sdtx_printf("Hello '%'!\n", ifx((frame_count & (1<<7)) == 0) then "Welt" else "World");
        sdtx_printf("\tFrame Time:\t\t%.3f\n", frame_time);
        sdtx_printf("\tFrame Count:\t%d\t0x%04X\n", frame_count, frame_count);
        sdtx_putr("Range Test 1(xyzbla)", 12);
        sdtx_putr("\nRange Test 2\n", 32);
        sdtx_move_y(2);
    }

    sg_begin_pass(*(sg_pass.{ action = state.pass_action, swapchain = xx,force sglue_swapchain() }));
    sdtx_draw();
    sg_end_pass();
    sg_commit();
}

cleanup :: () #c_call {
    sdtx_shutdown();
    sg_shutdown();
}

main :: () {
    sapp_run(*(sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 640,
        height = 480,
        window_title = "debugtext-printf",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
