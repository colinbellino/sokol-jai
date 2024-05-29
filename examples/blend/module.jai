//------------------------------------------------------------------------------
//  blend/module.jai
//
//  Test/demonstrate blend modes.
//------------------------------------------------------------------------------
#import "Basic";
#import "Math";
#import,dir "../../sokol/log"(USE_GL=USE_GL);
#import,dir "../../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../../sokol/app"(USE_GL=USE_GL);
#import,dir "../../sokol/glue"(USE_GL=USE_GL);
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
    push_context default_context {
        desc := sg_desc.{
            pipeline_pool_size = NUM_BLEND_FACTORS * NUM_BLEND_FACTORS + 1,
            environment = xx sglue_environment(),
            logger = .{ func = slog_func },
        };
        sg_setup(*desc);

        // a quad vertex buffer
        vertices := float.[
            // pos            color
            -1.0, -1.0, 0.0,  1.0, 0.0, 0.0, 0.5,
            +1.0, -1.0, 0.0,  0.0, 1.0, 0.0, 0.5,
            -1.0, +1.0, 0.0,  0.0, 0.0, 1.0, 0.5,
            +1.0, +1.0, 0.0,  1.0, 1.0, 0.0, 0.5,
        ];
        buffer := sg_buffer_desc.{ data = .{ ptr = *vertices, size = vertices.count * size_of(float) } };
        state.bind.vertex_buffers[0] = sg_make_buffer(*buffer);

        // shader and pipeline object for rendering the background quad
        bg_pip_desc: sg_pipeline_desc;
        bg_pip_desc.shader = sg_make_shader(*bg_shader_desc(sg_query_backend()));
        // we use the same vertex buffer as for the colored 3D quads,
        // but only the first two floats from the position, need to
        // provide a stride to skip the gap to the next vertex
        bg_pip_desc.layout.buffers[0] = .{ stride = 28 };
        bg_pip_desc.layout.attrs[ATTR_vs_bg_position] = .{ format = .FLOAT2 };
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
        pip_desc.layout.attrs[ATTR_vs_quad_position] = .{ format = .FLOAT3 };
        pip_desc.layout.attrs[ATTR_vs_quad_color0]   = .{ format = .FLOAT4 };
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
}

frame :: () #c_call {
    push_context default_context {
        t := cast(float) (sapp_frame_duration() * 60.0);
        state.r += 0.6 * t;
        state.bg_fs_params.tick += 1.0 * t;

        // view-projection matrix
        proj := persp_mat4(fov = 90.0, aspect = sapp_widthf() / sapp_heightf(), near = 0.01, far = 100.0);
        view := lookat_mat4(eye = .{ 0.0, 0.0, 25.0 }, center = .{}, up = .{ 0.0, 1.0, 0.0 } );
        view_proj := multiply_mat4(proj, view);

        // start rendering
        pass := sg_pass.{ action = state.pass_action, swapchain = xx sglue_swapchain() };
        sg_begin_pass(*pass);

        // draw a background quad
        sg_apply_pipeline(state.bg_pip);
        sg_apply_bindings(*state.bind);
        range := sg_range.{ ptr = *state.bg_fs_params, size = size_of(Bg_Fs_Params) };
        sg_apply_uniforms(.FS, SLOT_bg_fs_params, *range);
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
                range := sg_range.{ ptr = *state.quad_vs_params, size = size_of(Quad_Vs_Params) };
                sg_apply_uniforms(.VS, SLOT_quad_vs_params, *range);
                sg_draw(0, 4, 1);
            }
        }
        sg_end_pass();
        sg_commit();
    }
}

cleanup :: () #c_call {
    sg_shutdown();
}

main :: () {
    desc := sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 800,
        height = 600,
        sample_count = 4,
        window_title = "blend",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    };
    sapp_run(*desc);
}

persp_mat4 :: (fov: float, aspect: float, near: float, far: float) -> Matrix4 {
    m := Matrix4_Identity;
    t := tan(fov * (PI / 360));
    m.coef[0][0] = 1.0 / t;
    m.coef[1][1] = aspect / t;
    m.coef[2][3] = -1.0;
    m.coef[2][2] = (near + far) / (near - far);
    m.coef[3][2] = (2.0 * near * far) / (near - far);
    m.coef[3][3] = 0;
    return m;
}
lookat_mat4 :: (eye: Vector3, center: Vector3, up: Vector3) -> Matrix4 {
    m: Matrix4;
    f := normalize(center - eye);
    s := normalize(cross(f, up));
    u := cross(s, f);

    m.coef[0][0] = s.x;
    m.coef[0][1] = u.x;
    m.coef[0][2] = -f.x;

    m.coef[1][0] = s.y;
    m.coef[1][1] = u.y;
    m.coef[1][2] = -f.y;

    m.coef[2][0] = s.z;
    m.coef[2][1] = u.z;
    m.coef[2][2] = -f.z;

    m.coef[3][0] = -dot(s, eye);
    m.coef[3][1] = -dot(u, eye);
    m.coef[3][2] = dot(f, eye);
    m.coef[3][3] = 1.0;

    return m;
}
multiply_mat4 :: (left: Matrix4, right: Matrix4) -> Matrix4 {
    m: Matrix4;
    for col : 0 .. 3 {
        for row : 0 .. 3 {
            m.coef[col][row] = left.coef[0][row] * right.coef[col][0] +
                               left.coef[1][row] * right.coef[col][1] +
                               left.coef[2][row] * right.coef[col][2] +
                               left.coef[3][row] * right.coef[col][3];
        }
    }
    return m;
}
rotate_mat4 :: (angle: float, axis_unorm: Vector3) -> Matrix4 {
    m := Matrix4_Identity;

    axis := normalize(axis_unorm);
    sin_theta := sin(radians(angle));
    cos_theta := cos(radians(angle));
    cos_value := 1.0 - cos_theta;

    m.coef[0][0] = (axis.x * axis.x * cos_value) + cos_theta;
    m.coef[0][1] = (axis.x * axis.y * cos_value) + (axis.z * sin_theta);
    m.coef[0][2] = (axis.x * axis.z * cos_value) - (axis.y * sin_theta);
    m.coef[1][0] = (axis.y * axis.x * cos_value) - (axis.z * sin_theta);
    m.coef[1][1] = (axis.y * axis.y * cos_value) + cos_theta;
    m.coef[1][2] = (axis.y * axis.z * cos_value) + (axis.x * sin_theta);
    m.coef[2][0] = (axis.z * axis.x * cos_value) + (axis.y * sin_theta);
    m.coef[2][1] = (axis.z * axis.y * cos_value) - (axis.x * sin_theta);
    m.coef[2][2] = (axis.z * axis.z * cos_value) + cos_theta;

    return m;
}
translate_mat4 :: (translation: Vector3) -> Matrix4 {
    m := Matrix4_Identity;
    m.coef[3][0] = translation.x;
    m.coef[3][1] = translation.y;
    m.coef[3][2] = translation.z;
    return m;
}
radians :: (degrees: float) -> float { return degrees * TAU / 360.0; }
