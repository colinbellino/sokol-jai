//------------------------------------------------------------------------------
//  blend.jai
//
//  Test/demonstrate blend modes.
//------------------------------------------------------------------------------
#import "Basic";
#import "Math";
#import,dir "../sokol/log"(USE_GL=USE_GL);
#import,dir "../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../sokol/app"(USE_GL=USE_GL);
#import,dir "../sokol/glue"(USE_GL=USE_GL);

NUM_BLEND_FACTORS :: 15;
ATTR_vs_bg_position :: 0;
ATTR_vs_quad_position :: 0;
ATTR_vs_quad_color0 :: 1;
SLOT_bg_fs_params :: 0;
SLOT_quad_vs_params :: 0;
Bg_Fs_Params :: struct {
    tick: float;
    _:    [12]u8;
}
Quad_Vs_Params :: struct {
    mvp: Matrix4;
}

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

bg_shader_desc :: (backend: sg_backend) -> sg_shader_desc {
    desc: sg_shader_desc;
    desc.label = "bg_shader";
    if backend == {
        case .GLCORE;
            vs_bg_source_glsl330 :: #string VS_END
                #version 330

                layout(location = 0) in vec2 position;

                void main()
                {
                    gl_Position = vec4(position, 0.5, 1.0);
                }
            VS_END
            fs_bg_source_glsl330 :: #string FS_END
                #version 330

                uniform vec4 bg_fs_params[1];
                out vec4 frag_color;

                void main()
                {
                    vec2 _28 = fract((gl_FragCoord.xy - vec2(bg_fs_params[0].x)) * vec2(0.0199999995529651641845703125));
                    float _39 = _28.x * _28.y;
                    frag_color = vec4(_39, _39, _39, 1.0);
                }
            FS_END

            desc.attrs[0].name = "position";
            desc.vs.source = vs_bg_source_glsl330;
            desc.vs.entry = "main";
            desc.fs.source = fs_bg_source_glsl330;
            desc.fs.entry = "main";
            desc.fs.uniform_blocks[0].size = 16;
            desc.fs.uniform_blocks[0].layout = .STD140;
            desc.fs.uniform_blocks[0].uniforms[0].name = "bg_fs_params";
            desc.fs.uniform_blocks[0].uniforms[0].type = .FLOAT4;
            desc.fs.uniform_blocks[0].uniforms[0].array_count = 1;
        case .D3D11;
            // FIXME:
            // desc.attrs[0].sem_name = "TEXCOORD";
            // desc.attrs[0].sem_index = 0;
            // desc.vs.source = vs_bg_source_hlsl5;
            // desc.vs.d3d11_target = "vs_5_0";
            // desc.vs.entry = "main";
            // desc.fs.source = fs_bg_source_hlsl5;
            // desc.fs.d3d11_target = "ps_5_0";
            // desc.fs.entry = "main";
            // desc.fs.uniform_blocks[0].size = 16;
            // desc.fs.uniform_blocks[0].layout = .STD140;
        case .METAL_MACOS;
            fs_bg_source_metal_macos :: #string FS_END
                #include <metal_stdlib>
                #include <simd/simd.h>

                using namespace metal;

                struct bg_fs_params
                {
                    float tick;
                };

                struct main0_out
                {
                    float4 frag_color [[color(0)]];
                };

                fragment main0_out main0(constant bg_fs_params& _17 [[buffer(0)]], float4 gl_FragCoord [[position]])
                {
                    main0_out out = {};
                    float2 _28 = fract((gl_FragCoord.xy - float2(_17.tick)) * float2(0.0199999995529651641845703125));
                    float _39 = _28.x * _28.y;
                    out.frag_color = float4(_39, _39, _39, 1.0);
                    return out;
                }
            FS_END
            vs_bg_source_metal_macos :: #string VS_END
                #include <metal_stdlib>
                #include <simd/simd.h>

                using namespace metal;

                struct main0_out
                {
                    float4 gl_Position [[position]];
                };

                struct main0_in
                {
                    float2 position [[attribute(0)]];
                };

                vertex main0_out main0(main0_in in [[stage_in]])
                {
                    main0_out out = {};
                    out.gl_Position = float4(in.position, 0.5, 1.0);
                    return out;
                }
            VS_END
            desc.vs.source = vs_bg_source_metal_macos;
            desc.vs.entry = "main0";
            desc.fs.source = fs_bg_source_metal_macos;
            desc.fs.entry = "main0";
            desc.fs.uniform_blocks[0].size = 16;
            desc.fs.uniform_blocks[0].layout = .STD140;
    }
    return desc;
}
quad_shader_desc :: (backend: sg_backend) -> sg_shader_desc {
    desc: sg_shader_desc;
    desc.label = "quad_shader";
    if backend == {
        case .GLCORE;
            vs_quad_source_glsl330 :: #string VS_END
                #version 330

                uniform vec4 quad_vs_params[4];
                in vec4 position;
                in vec4 color0;
                out vec4 color;

                void main()
                {
                    gl_Position = mat4(quad_vs_params[0], quad_vs_params[1], quad_vs_params[2], quad_vs_params[3]) * position;
                    color = color0;
                }
            VS_END
            fs_quad_source_glsl330 :: #string FS_END
                #version 330

                in vec4 color;
                out vec4 frag_color;

                void main()
                {
                    frag_color = color;
                }
            FS_END
            desc.attrs[0].name = "position";
            desc.attrs[1].name = "color0";
            desc.vs.source = vs_quad_source_glsl330;
            desc.vs.entry = "main";
            desc.vs.uniform_blocks[0].size = 64;
            desc.vs.uniform_blocks[0].layout = .STD140;
            desc.vs.uniform_blocks[0].uniforms[0].name = "quad_vs_params";
            desc.vs.uniform_blocks[0].uniforms[0].type = .FLOAT4;
            desc.vs.uniform_blocks[0].uniforms[0].array_count = 4;
            desc.fs.source = fs_quad_source_glsl330;
            desc.fs.entry = "main";
        case .D3D11;
            // desc.attrs[0].sem_name = "TEXCOORD";
            // desc.attrs[0].sem_index = 0;
            // desc.attrs[1].sem_name = "TEXCOORD";
            // desc.attrs[1].sem_index = 1;
            // desc.vs.source = vs_quad_source_hlsl5;
            // desc.vs.d3d11_target = "vs_5_0";
            // desc.vs.entry = "main";
            // desc.vs.uniform_blocks[0].size = 64;
            // desc.vs.uniform_blocks[0].layout = .STD140;
            // desc.fs.source = fs_quad_source_hlsl5;
            // desc.fs.d3d11_target = "ps_5_0";
            // desc.fs.entry = "main";
        case .METAL_MACOS;
            vs_quad_source_metal_macos :: #string VS_END
                #include <metal_stdlib>
                #include <simd/simd.h>

                using namespace metal;

                struct quad_vs_params
                {
                    float4x4 mvp;
                };

                struct main0_out
                {
                    float4 color [[user(locn0)]];
                    float4 gl_Position [[position]];
                };

                struct main0_in
                {
                    float4 position [[attribute(0)]];
                    float4 color0 [[attribute(1)]];
                };

                vertex main0_out main0(main0_in in [[stage_in]], constant quad_vs_params& _19 [[buffer(0)]])
                {
                    main0_out out = {};
                    out.gl_Position = _19.mvp * in.position;
                    out.color = in.color0;
                    return out;
                }
            VS_END
            fs_quad_source_metal_macos :: #string FS_END
                #include <metal_stdlib>
                #include <simd/simd.h>

                using namespace metal;

                struct main0_out
                {
                    float4 frag_color [[color(0)]];
                };

                struct main0_in
                {
                    float4 color [[user(locn0)]];
                };

                fragment main0_out main0(main0_in in [[stage_in]])
                {
                    main0_out out = {};
                    out.frag_color = in.color;
                    return out;
                }
            FS_END
            desc.vs.source = vs_quad_source_metal_macos;
            desc.vs.entry = "main0";
            desc.vs.uniform_blocks[0].size = 64;
            desc.vs.uniform_blocks[0].layout = .STD140;
            desc.fs.source = fs_quad_source_metal_macos;
            desc.fs.entry = "main0";
    }
    return desc;
}
