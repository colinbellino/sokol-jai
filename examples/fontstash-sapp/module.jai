//------------------------------------------------------------------------------
//  fontstash-sapp/module.jai
//
//  Text rendering via fontstash, stb_truetype and sokol_fontstash.h
//------------------------------------------------------------------------------
#import "Basic";
#import "File";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
#import,dir "../../sokol/gl"(USE_GL=USE_GL);
#import,dir "../../sokol/fontstash"(USE_GL=USE_GL);

default_context: Context;
state: struct {
    fons: *FONScontext;
    dpi_scale: float;
    font_normal: s32;
    font_italic: s32;
    font_bold: s32;
    font_japanese: s32;
    font_normal_data: [256 * 1024]u8;
    font_italic_data: [256 * 1024]u8;
    font_bold_data: [256 * 1024]u8;
    font_japanese_data: [2 * 1024 * 1024]u8;
}

// round to next power of 2 (see bit-twiddling-hacks)
round_pow2 :: (v: float) -> s32 {
    vi := (cast(u32) v) - 1;
    for i : 0..4 {
        vi |= (vi >> (1<<i));
    }
    return cast(s32) (vi + 1);
}


line :: (sx: float, sy: float, ex: float, ey: float) #c_call {
    sgl_begin_lines();
    sgl_c4b(255, 255, 0, 128);
    sgl_v2f(sx, sy);
    sgl_v2f(ex, ey);
    sgl_end();
}

init :: () #c_call {
    push_context,defer_pop default_context;

    state.dpi_scale = sapp_dpi_scale();
    sg_setup(*(sg_desc.{
        environment = xx sglue_environment(),
        logger = .{ func = slog_func },
    }));
    sgl_setup(*(sgl_desc_t.{
        logger = .{ func = slog_func },
    }));

    atlas_dim := round_pow2(512.0 * state.dpi_scale);
    fons_context := sfons_create(*(sfons_desc_t.{
        width = atlas_dim,
        height = atlas_dim,
    }));
    state.fons = fons_context;
    state.font_normal = FONS_INVALID;
    state.font_italic = FONS_INVALID;
    state.font_bold = FONS_INVALID;
    state.font_japanese = FONS_INVALID;

    {
        file_data := read_entire_file("../examples/fontstash-sapp/DroidSerif-Regular.ttf");
        state.font_normal = fonsAddFontMem(state.fons, "sans", *file_data[0], xx file_data.count, 0);
    }
    {
        file_data := read_entire_file("../examples/fontstash-sapp/DroidSerif-Italic.ttf");
        state.font_italic = fonsAddFontMem(state.fons, "sans-italic", *file_data[0], xx file_data.count, 0);
    }
    {
        file_data := read_entire_file("../examples/fontstash-sapp/DroidSerif-Bold.ttf");
        state.font_bold = fonsAddFontMem(state.fons, "sans-bold", *file_data[0], xx file_data.count, 0);
    }
    {
        file_data := read_entire_file("../examples/fontstash-sapp/DroidSansJapanese.ttf");
        state.font_japanese = fonsAddFontMem(state.fons, "sans-japanese", *file_data[0], xx file_data.count, 0);
    }
}

frame :: () #c_call {
    dpis := state.dpi_scale;

    white := sfons_rgba(255, 255, 255, 255);
    black := sfons_rgba(0, 0, 0, 255);
    brown := sfons_rgba(192, 128, 0, 128);
    blue  := sfons_rgba(0, 192, 255, 255);
    fonsClearState(state.fons);

    sgl_defaults();
    sgl_matrix_mode_projection();
    sgl_ortho(0.0, sapp_widthf(), sapp_heightf(), 0.0, -1.0, +1.0);

    sx := 50*dpis;
    sy := 50*dpis;
    dx := sx;
    dy := sy;
    lh : float = 0.0;

    fs := state.fons;
    if (state.font_normal != FONS_INVALID) {
        fonsSetFont(fs, state.font_normal);
        fonsSetSize(fs, 124.0*dpis);
        fonsVertMetrics(fs, null, null, *lh);
        dx = sx;
        dy += lh;
        fonsSetColor(fs, white);
        dx = fonsDrawText(fs, dx, dy, "The quick ", null);
    }
    if (state.font_italic != FONS_INVALID) {
        fonsSetFont(fs, state.font_italic);
        fonsSetSize(fs, 48.0*dpis);
        fonsSetColor(fs, brown);
        dx = fonsDrawText(fs, dx, dy, "brown ", null);
    }
    if (state.font_normal != FONS_INVALID) {
        fonsSetFont(fs, state.font_normal);
        fonsSetSize(fs, 24.0*dpis);
        fonsSetColor(fs, white);
        dx = fonsDrawText(fs, dx, dy,"fox ", null);
    }
    if ((state.font_normal != FONS_INVALID) && (state.font_italic != FONS_INVALID) && (state.font_bold != FONS_INVALID)) {
        fonsVertMetrics(fs, null, null, *lh);
        dx = sx;
        dy += lh*1.2;
        fonsSetFont(fs, state.font_italic);
        dx = fonsDrawText(fs, dx, dy, "jumps over ",null);
        fonsSetFont(fs, state.font_bold);
        dx = fonsDrawText(fs, dx, dy, "the lazy ",null);
        fonsSetFont(fs, state.font_normal);
        dx = fonsDrawText(fs, dx, dy, "dog.",null);
    }
    if (state.font_normal != FONS_INVALID) {
        dx = sx;
        dy += lh*1.2;
        fonsSetSize(fs, 12.0*dpis);
        fonsSetFont(fs, state.font_normal);
        fonsSetColor(fs, blue);
        fonsDrawText(fs, dx,dy,"Now is the time for all good men to come to the aid of the party.",null);
    }
    if (state.font_italic != FONS_INVALID) {
        fonsVertMetrics(fs, null, null, *lh);
        dx = sx;
        dy += lh*1.2*2;
        fonsSetSize(fs, 18.0*dpis);
        fonsSetFont(fs, state.font_italic);
        fonsSetColor(fs, white);
        fonsDrawText(fs, dx, dy, "Ég get etið gler án þess að meiða mig.", null);
    }
    if (state.font_japanese != FONS_INVALID) {
        fonsVertMetrics(fs, null,null,*lh);
        dx = sx;
        dy += lh*1.2;
        fonsSetFont(fs, state.font_japanese);
        fonsDrawText(fs, dx,dy,"私はガラスを食べられます。それは私を傷つけません。",null);
    }

    // Font alignment
    if (state.font_normal != FONS_INVALID) {
        fonsSetSize(fs, 18.0*dpis);
        fonsSetFont(fs, state.font_normal);
        fonsSetColor(fs, white);
        dx = 50*dpis; dy = 350*dpis;
        line(dx-10*dpis,dy,dx+250*dpis,dy);
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_TOP);
        dx = fonsDrawText(fs, dx,dy,"Top",null);
        dx += 10*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_MIDDLE);
        dx = fonsDrawText(fs, dx,dy,"Middle",null);
        dx += 10*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_BASELINE);
        dx = fonsDrawText(fs, dx,dy,"Baseline",null);
        dx += 10*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_BOTTOM);
        fonsDrawText(fs, dx,dy,"Bottom",null);
        dx = 150*dpis; dy = 400*dpis;
        line(dx,dy-30*dpis,dx,dy+80.0*dpis);
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_BASELINE);
        fonsDrawText(fs, dx,dy,"Left",null);
        dy += 30*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_CENTER | FONS_ALIGN_BASELINE);
        fonsDrawText(fs, dx,dy,"Center",null);
        dy += 30*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_RIGHT | FONS_ALIGN_BASELINE);
        fonsDrawText(fs, dx,dy,"Right",null);
    }

    // Blur
    if (state.font_italic != FONS_INVALID) {
        dx = 500*dpis; dy = 350*dpis;
        fonsSetAlign(fs, xx FONS_ALIGN_LEFT | FONS_ALIGN_BASELINE);
        fonsSetSize(fs, 60.0*dpis);
        fonsSetFont(fs, state.font_italic);
        fonsSetColor(fs, white);
        fonsSetSpacing(fs, 5.0*dpis);
        fonsSetBlur(fs, 10.0);
        fonsDrawText(fs, dx,dy,"Blurry...",null);
    }

    if (state.font_bold != FONS_INVALID) {
        dy += 50.0*dpis;
        fonsSetSize(fs, 18.0*dpis);
        fonsSetFont(fs, state.font_bold);
        fonsSetColor(fs, black);
        fonsSetSpacing(fs, 0.0);
        fonsSetBlur(fs, 3.0);
        fonsDrawText(fs, dx,dy+2,"DROP THAT SHADOW",null);
        fonsSetColor(fs, white);
        fonsSetBlur(fs, 0);
        fonsDrawText(fs, dx,dy,"DROP THAT SHADOW",null);
    }

    // flush fontstash's font atlas to sokol-gfx texture
    sfons_flush(fs);

    // render pass
    pass := sg_pass.{
        action = .{
            colors[0] = .{
                load_action = .CLEAR,
                clear_value = .{ 0.3, 0.3, 0.32, 1.0 },
            },
        },
        swapchain = xx sglue_swapchain(),
    };
    sg_begin_pass(*pass);
    sgl_draw();
    // __dbgui_draw();
    sg_end_pass();
    sg_commit();
}

cleanup :: () #c_call {
    sfons_destroy(state.fons);
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
        window_title = "fontstash",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    }));
}
