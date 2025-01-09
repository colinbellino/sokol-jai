//------------------------------------------------------------------------------
//  saudio/module.jai
//  Test sokol-audio.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#import,dir "../../sokol/debugtext"(USE_GL=USE_GL);
#import,dir "../../sokol/audio";

NUM_SAMPLES :: 32;

state: struct {
    pass_action: sg_pass_action;
    even_odd:    u32;
    sample_pos:  int;
    samples:     [NUM_SAMPLES]float;
} = .{
    pass_action = .{
        colors = .[ .{ load_action = .CLEAR, clear_value = .{ 1.0, 0.5, 0.0, 1.0 }, }, .{}, .{}, .{}, ],
    },
};

init :: () #c_call {
    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger = .{ func = slog_func },
    }));
    saudio_setup(*(saudio_desc.{
        logger = .{ func = slog_func },
    }));
}

frame :: () #c_call {
    num_frames := saudio_expect();
    for i : 0 .. num_frames - 1 {
        state.even_odd += 1;
        state.samples[state.sample_pos] = ifx((state.even_odd & (1<<5)) == 0) then 0.05 else -0.05;
        state.sample_pos += 1;
        if state.sample_pos == NUM_SAMPLES {
            state.sample_pos = 0;
            saudio_push(*state.samples[0], NUM_SAMPLES);
        }
    }

    sg_begin_pass(*(sg_pass.{ action = state.pass_action, swapchain = xx,force sglue_swapchain() }));
    sg_end_pass();
    sg_commit();
}

cleanup :: () #c_call {
    saudio_shutdown();
    sg_shutdown();
}

main :: () {
    sapp_run(*(sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 400,
        height = 300,
        window_title = "saudio",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
