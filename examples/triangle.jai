//------------------------------------------------------------------------------
//  triangle.jai
//
//  Hello Triangle sample.
//------------------------------------------------------------------------------
#import "Basic";
#import,dir "../sokol/log"(USE_GL=USE_GL);
#import,dir "../sokol/gfx"(USE_GL=USE_GL);
#import,dir "../sokol/app"(USE_GL=USE_GL);
#import,dir "../sokol/glue"(USE_GL=USE_GL);

default_context: Context;
state: struct {
    pip:         sg_pipeline;
    bind:        sg_bindings;
    pass_action: sg_pass_action;
}

init :: () #c_call {
    push_context default_context {
        desc := sg_desc.{
            environment = xx sglue_environment(),
            logger = .{ func = slog_func },
        };
        sg_setup(*desc);

        // a vertex buffer with 3 vertices
        vertices := float.[
            // positions         // colors
            0.0,  0.5, 0.5,     1.0, 0.0, 0.0, 1.0,
            0.5, -0.5, 0.5,     0.0, 1.0, 0.0, 1.0,
            -0.5, -0.5, 0.5,    0.0, 0.0, 1.0, 1.0,
        ];
        buffer := sg_buffer_desc.{ data = .{ ptr = *vertices, size = vertices.count * size_of(float) } };
        state.bind.vertex_buffers[0] = sg_make_buffer(*buffer);

        // create a shader and pipeline object (default render states are fine for triangle)
        ATTR_vs_position :: 0;
        ATTR_vs_color    :: 1;
        pipeline: sg_pipeline_desc;
        pipeline.shader = sg_make_shader(*triangle_shader_desc(sg_query_backend()));
        pipeline.layout.attrs[ATTR_vs_position] = .{ format = .FLOAT3 };
        pipeline.layout.attrs[ATTR_vs_color]    = .{ format = .FLOAT4 };
        state.pip = sg_make_pipeline(*pipeline);

        // a pass action to clear framebuffer to black
        state.pass_action.colors[0] = .{ load_action = .CLEAR, clear_value = .{ r = 0, g = 0, b = 0, a = 1 } };
    }
}

frame :: () #c_call {
    pass := sg_pass.{ action = state.pass_action, swapchain = xx sglue_swapchain() };
    sg_begin_pass(*pass);
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
    desc := sapp_desc.{
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = 640,
        height = 480,
        window_title = "triangle",
        icon = .{ sokol_default = true },
        logger = .{ func = slog_func },
    };
    sapp_run(*desc);
}

triangle_shader_desc :: (backend: sg_backend) -> sg_shader_desc {
    desc: sg_shader_desc;
    desc.label = "triangle_shader";
    if backend == {
        case .GLCORE; {
            vs_source_glsl330 :: #string VS_END
                #version 330

                layout(location = 0) in vec2 position;
                layout(location = 1) in vec4 color;
                out vec4 v_color;

                void main() {
                    gl_Position = vec4(position, 0.0, 1.0);
                    v_color = color;
                }
            VS_END
            fs_source_glsl330 :: #string FS_END
                #version 330

                layout(location = 0) out vec4 frag_color;
                in vec4 v_color;

                void main() {
                    frag_color = v_color;
                }
            FS_END
            desc.attrs[0].name = "position";
            desc.attrs[1].name = "color";
            desc.vs.source = vs_source_glsl330;
            desc.vs.entry = "main";
            desc.fs.source = fs_source_glsl330;
            desc.fs.entry = "main";
        }
        case .D3D11; {
            // FIXME:
            // desc.attrs[0].sem_name = "TEXCOORD";
            // desc.attrs[0].sem_index = 0;
            // desc.attrs[1].sem_name = "TEXCOORD";
            // desc.attrs[1].sem_index = 1;
            // desc.vs.source = xx *vs_source_hlsl5;
            // desc.vs.d3d11_target = "vs_5_0";
            // desc.vs.entry = "main";
            // desc.fs.source = xx *fs_source_hlsl5;
            // desc.fs.d3d11_target = "ps_5_0";
            // desc.fs.entry = "main";
        }
        case .METAL_MACOS; {
            vs_source_metal_macos :: #string VS_END
                #include <metal_stdlib>
                #include <simd/simd.h>

                using namespace metal;

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

                vertex main0_out main0(main0_in in [[stage_in]])
                {
                    main0_out out = {};
                    out.gl_Position = in.position;
                    out.color = in.color0;
                    return out;
                }
            VS_END
            fs_source_metal_macos :: #string FS_END
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
            desc.vs.source = vs_source_metal_macos;
            desc.vs.entry = "main0";
            desc.fs.source = fs_source_metal_macos;
            desc.fs.entry = "main0";
        }
    }
    return desc;
}
