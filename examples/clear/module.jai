//------------------------------------------------------------------------------
//  clear/module.jai
//
//  Minimal sample which just clears the default framebuffer
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);

pass_action: sg_pass_action;

init :: () #c_call {
    push_context,defer_pop;

    sg_setup(*(sg_desc.{
        environment = xx,force sglue_environment(),
        logger = .{ func = slog_func },
    }));
    pass_action.colors[0] = .{ load_action = .CLEAR, clear_value = .{ 1.0, 0.0, 0.0, 1.0 } };

    // just some debug output what backend we're running on
    if sg_query_backend() == {
        case .D3D11; print(">> using D3D11 backend");
        case .GLCORE; #through;
        case .GLES3; print(">> using GL backend");
        case .METAL_MACOS; #through;
        case .METAL_IOS; #through;
        case .METAL_SIMULATOR; print(">> using Metal backend");
        case .WGPU; print(">> using WebGPU backend");
        case .DUMMY; print(">> using dummy backend");
    }
}

frame :: () #c_call {
    g := pass_action.colors[0].clear_value.g + 0.01;
    pass_action.colors[0].clear_value.g = ifx(g > 1.0) then 0.0 else g;
    sg_begin_pass(*(sg_pass.{ action = pass_action, swapchain = xx,force sglue_swapchain() }));
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
        width = 400,
        height = 300,
        window_title = "clear",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
