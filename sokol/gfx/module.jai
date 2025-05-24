// machine generated, do not edit

/*

    sokol_gfx.h -- simple 3D API wrapper

    Project URL: https://github.com/floooh/sokol

    Example code: https://github.com/floooh/sokol-samples

    Do this:
        #define SOKOL_IMPL or
        #define SOKOL_GFX_IMPL
    before you include this file in *one* C or C++ file to create the
    implementation.

    In the same place define one of the following to select the rendering
    backend:
        #define SOKOL_GLCORE
        #define SOKOL_GLES3
        #define SOKOL_D3D11
        #define SOKOL_METAL
        #define SOKOL_WGPU
        #define SOKOL_DUMMY_BACKEND

    I.e. for the desktop GL it should look like this:

    #include ...
    #include ...
    #define SOKOL_IMPL
    #define SOKOL_GLCORE
    #include "sokol_gfx.h"

    The dummy backend replaces the platform-specific backend code with empty
    stub functions. This is useful for writing tests that need to run on the
    command line.

    Optionally provide the following defines with your own implementations:

    SOKOL_ASSERT(c)             - your own assert macro (default: assert(c))
    SOKOL_UNREACHABLE()         - a guard macro for unreachable code (default: assert(false))
    SOKOL_GFX_API_DECL          - public function declaration prefix (default: extern)
    SOKOL_API_DECL              - same as SOKOL_GFX_API_DECL
    SOKOL_API_IMPL              - public function implementation prefix (default: -)
    SOKOL_TRACE_HOOKS           - enable trace hook callbacks (search below for TRACE HOOKS)
    SOKOL_EXTERNAL_GL_LOADER    - indicates that you're using your own GL loader, in this case
                                  sokol_gfx.h will not include any platform GL headers and disable
                                  the integrated Win32 GL loader

    If sokol_gfx.h is compiled as a DLL, define the following before
    including the declaration or implementation:

    SOKOL_DLL

    On Windows, SOKOL_DLL will define SOKOL_GFX_API_DECL as __declspec(dllexport)
    or __declspec(dllimport) as needed.

    If you want to compile without deprecated structs and functions,
    define:

    SOKOL_NO_DEPRECATED

    Optionally define the following to force debug checks and validations
    even in release mode:

    SOKOL_DEBUG - by default this is defined if _DEBUG is defined

    sokol_gfx DOES NOT:
    ===================
    - create a window, swapchain or the 3D-API context/device, you must do this
      before sokol_gfx is initialized, and pass any required information
      (like 3D device pointers) to the sokol_gfx initialization call

    - present the rendered frame, how this is done exactly usually depends
      on how the window and 3D-API context/device was created

    - provide a unified shader language, instead 3D-API-specific shader
      source-code or shader-bytecode must be provided (for the "official"
      offline shader cross-compiler / code-generator, see here:
      https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md)


    STEP BY STEP
    ============
    --- to initialize sokol_gfx, after creating a window and a 3D-API
        context/device, call:

            sg_setup(const sg_desc*)

        Depending on the selected 3D backend, sokol-gfx requires some
        information about its runtime environment, like a GPU device pointer,
        default swapchain pixel formats and so on. If you are using sokol_app.h
        for the window system glue, you can use a helper function provided in
        the sokol_glue.h header:

            #include "sokol_gfx.h"
            #include "sokol_app.h"
            #include "sokol_glue.h"
            //...
            sg_setup(&(sg_desc){
                .environment = sglue_environment(),
            });

        To get any logging output for errors and from the validation layer, you
        need to provide a logging callback. Easiest way is through sokol_log.h:

            #include "sokol_log.h"
            //...
            sg_setup(&(sg_desc){
                //...
                .logger.func = slog_func,
            });

    --- create resource objects (at least buffers, shaders and pipelines,
        and optionally images, samplers and render-pass-attachments):

            sg_buffer sg_make_buffer(const sg_buffer_desc*)
            sg_image sg_make_image(const sg_image_desc*)
            sg_sampler sg_make_sampler(const sg_sampler_desc*)
            sg_shader sg_make_shader(const sg_shader_desc*)
            sg_pipeline sg_make_pipeline(const sg_pipeline_desc*)
            sg_attachments sg_make_attachments(const sg_attachments_desc*)

    --- start a render- or compute-pass:

            sg_begin_pass(const sg_pass* pass);

        Typically, render passes render into an externally provided swapchain which
        presents the rendering result on the display. Such a 'swapchain pass'
        is started like this:

            sg_begin_pass(&(sg_pass){ .action = { ... }, .swapchain = sglue_swapchain() })

        ...where .action is an sg_pass_action struct containing actions to be performed
        at the start and end of a render pass (such as clearing the render surfaces to
        a specific color), and .swapchain is an sg_swapchain struct with all the required
        information to render into the swapchain's surfaces.

        To start an 'offscreen render pass' into sokol-gfx image objects, an sg_attachment
        object handle is required instead of an sg_swapchain struct. An offscreen
        pass is started like this (assuming attachments is an sg_attachments handle):

            sg_begin_pass(&(sg_pass){ .action = { ... }, .attachments = attachments });

        To start a compute-pass, just set the .compute item to true:

            sg_begin_pass(&(sg_pass){ .compute = true });

    --- set the pipeline state for the next draw call with:

            sg_apply_pipeline(sg_pipeline pip)

    --- fill an sg_bindings struct with the resource bindings for the next
        draw- or dispatch-call (0..N vertex buffers, 0 or 1 index buffer, 0..N images,
        samplers and storage-buffers), and call:

            sg_apply_bindings(const sg_bindings* bindings)

        to update the resource bindings. Note that in a compute pass, no vertex-
        or index-buffer bindings are allowed and will be rejected by the validation
        layer.

    --- optionally update shader uniform data with:

            sg_apply_uniforms(int ub_slot, const sg_range* data)

        Read the section 'UNIFORM DATA LAYOUT' to learn about the expected memory layout
        of the uniform data passed into sg_apply_uniforms().

    --- kick off a draw call with:

            sg_draw(int base_element, int num_elements, int num_instances)

        The sg_draw() function unifies all the different ways to render primitives
        in a single call (indexed vs non-indexed rendering, and instanced vs non-instanced
        rendering). In case of indexed rendering, base_element and num_element specify
        indices in the currently bound index buffer. In case of non-indexed rendering
        base_element and num_elements specify vertices in the currently bound
        vertex-buffer(s). To perform instanced rendering, the rendering pipeline
        must be setup for instancing (see sg_pipeline_desc below), a separate vertex buffer
        containing per-instance data must be bound, and the num_instances parameter
        must be > 1.

    --- ...or kick of a dispatch call to invoke a compute shader workload:

            sg_dispatch(int num_groups_x, int num_groups_y, int num_groups_z)

        The dispatch args define the number of 'compute workgroups' processed
        by the currently applied compute shader.

    --- finish the current pass with:

            sg_end_pass()

    --- when done with the current frame, call

            sg_commit()

    --- at the end of your program, shutdown sokol_gfx with:

            sg_shutdown()

    --- if you need to destroy resources before sg_shutdown(), call:

            sg_destroy_buffer(sg_buffer buf)
            sg_destroy_image(sg_image img)
            sg_destroy_sampler(sg_sampler smp)
            sg_destroy_shader(sg_shader shd)
            sg_destroy_pipeline(sg_pipeline pip)
            sg_destroy_attachments(sg_attachments atts)

    --- to set a new viewport rectangle, call:

            sg_apply_viewport(int x, int y, int width, int height, bool origin_top_left)

        ...or if you want to specify the viewport rectangle with float values:

            sg_apply_viewportf(float x, float y, float width, float height, bool origin_top_left)

    --- to set a new scissor rect, call:

            sg_apply_scissor_rect(int x, int y, int width, int height, bool origin_top_left)

        ...or with float values:

            sg_apply_scissor_rectf(float x, float y, float width, float height, bool origin_top_left)

        Both sg_apply_viewport() and sg_apply_scissor_rect() must be called
        inside a rendering pass (e.g. not in a compute pass, or outside a pass)

        Note that sg_begin_default_pass() and sg_begin_pass() will reset both the
        viewport and scissor rectangles to cover the entire framebuffer.

    --- to update (overwrite) the content of buffer and image resources, call:

            sg_update_buffer(sg_buffer buf, const sg_range* data)
            sg_update_image(sg_image img, const sg_image_data* data)

        Buffers and images to be updated must have been created with
        SG_USAGE_DYNAMIC or SG_USAGE_STREAM.

        Only one update per frame is allowed for buffer and image resources when
        using the sg_update_*() functions. The rationale is to have a simple
        protection from the CPU scribbling over data the GPU is currently
        using, or the CPU having to wait for the GPU

        Buffer and image updates can be partial, as long as a rendering
        operation only references the valid (updated) data in the
        buffer or image.

    --- to append a chunk of data to a buffer resource, call:

            int sg_append_buffer(sg_buffer buf, const sg_range* data)

        The difference to sg_update_buffer() is that sg_append_buffer()
        can be called multiple times per frame to append new data to the
        buffer piece by piece, optionally interleaved with draw calls referencing
        the previously written data.

        sg_append_buffer() returns a byte offset to the start of the
        written data, this offset can be assigned to
        sg_bindings.vertex_buffer_offsets[n] or
        sg_bindings.index_buffer_offset

        Code example:

        for (...) {
            const void* data = ...;
            const int num_bytes = ...;
            int offset = sg_append_buffer(buf, &(sg_range) { .ptr=data, .size=num_bytes });
            bindings.vertex_buffer_offsets[0] = offset;
            sg_apply_pipeline(pip);
            sg_apply_bindings(&bindings);
            sg_apply_uniforms(...);
            sg_draw(...);
        }

        A buffer to be used with sg_append_buffer() must have been created
        with SG_USAGE_DYNAMIC or SG_USAGE_STREAM.

        If the application appends more data to the buffer then fits into
        the buffer, the buffer will go into the "overflow" state for the
        rest of the frame.

        Any draw calls attempting to render an overflown buffer will be
        silently dropped (in debug mode this will also result in a
        validation error).

        You can also check manually if a buffer is in overflow-state by calling

            bool sg_query_buffer_overflow(sg_buffer buf)

        You can manually check to see if an overflow would occur before adding
        any data to a buffer by calling

            bool sg_query_buffer_will_overflow(sg_buffer buf, size_t size)

        NOTE: Due to restrictions in underlying 3D-APIs, appended chunks of
        data will be 4-byte aligned in the destination buffer. This means
        that there will be gaps in index buffers containing 16-bit indices
        when the number of indices in a call to sg_append_buffer() is
        odd. This isn't a problem when each call to sg_append_buffer()
        is associated with one draw call, but will be problematic when
        a single indexed draw call spans several appended chunks of indices.

    --- to check at runtime for optional features, limits and pixelformat support,
        call:

            sg_features sg_query_features()
            sg_limits sg_query_limits()
            sg_pixelformat_info sg_query_pixelformat(sg_pixel_format fmt)

    --- if you need to call into the underlying 3D-API directly, you must call:

            sg_reset_state_cache()

        ...before calling sokol_gfx functions again

    --- you can inspect the original sg_desc structure handed to sg_setup()
        by calling sg_query_desc(). This will return an sg_desc struct with
        the default values patched in instead of any zero-initialized values

    --- you can get a desc struct matching the creation attributes of a
        specific resource object via:

            sg_buffer_desc sg_query_buffer_desc(sg_buffer buf)
            sg_image_desc sg_query_image_desc(sg_image img)
            sg_sampler_desc sg_query_sampler_desc(sg_sampler smp)
            sg_shader_desc sq_query_shader_desc(sg_shader shd)
            sg_pipeline_desc sg_query_pipeline_desc(sg_pipeline pip)
            sg_attachments_desc sg_query_attachments_desc(sg_attachments atts)

        ...but NOTE that the returned desc structs may be incomplete, only
        creation attributes that are kept around internally after resource
        creation will be filled in, and in some cases (like shaders) that's
        very little. Any missing attributes will be set to zero. The returned
        desc structs might still be useful as partial blueprint for creating
        similar resources if filled up with the missing attributes.

        Calling the query-desc functions on an invalid resource will return
        completely zeroed structs (it makes sense to check  the resource state
        with sg_query_*_state() first)

    --- you can query the default resource creation parameters through the functions

            sg_buffer_desc sg_query_buffer_defaults(const sg_buffer_desc* desc)
            sg_image_desc sg_query_image_defaults(const sg_image_desc* desc)
            sg_sampler_desc sg_query_sampler_defaults(const sg_sampler_desc* desc)
            sg_shader_desc sg_query_shader_defaults(const sg_shader_desc* desc)
            sg_pipeline_desc sg_query_pipeline_defaults(const sg_pipeline_desc* desc)
            sg_attachments_desc sg_query_attachments_defaults(const sg_attachments_desc* desc)

        These functions take a pointer to a desc structure which may contain
        zero-initialized items for default values. These zero-init values
        will be replaced with their concrete values in the returned desc
        struct.

    --- you can inspect various internal resource runtime values via:

            sg_buffer_info sg_query_buffer_info(sg_buffer buf)
            sg_image_info sg_query_image_info(sg_image img)
            sg_sampler_info sg_query_sampler_info(sg_sampler smp)
            sg_shader_info sg_query_shader_info(sg_shader shd)
            sg_pipeline_info sg_query_pipeline_info(sg_pipeline pip)
            sg_attachments_info sg_query_attachments_info(sg_attachments atts)

        ...please note that the returned info-structs are tied quite closely
        to sokol_gfx.h internals, and may change more often than other
        public API functions and structs.

    --- you can query frame stats and control stats collection via:

            sg_query_frame_stats()
            sg_enable_frame_stats()
            sg_disable_frame_stats()
            sg_frame_stats_enabled()

    --- you can ask at runtime what backend sokol_gfx.h has been compiled for:

            sg_backend sg_query_backend(void)

    --- call the following helper functions to compute the number of
        bytes in a texture row or surface for a specific pixel format.
        These functions might be helpful when preparing image data for consumption
        by sg_make_image() or sg_update_image():

            int sg_query_row_pitch(sg_pixel_format fmt, int width, int int row_align_bytes);
            int sg_query_surface_pitch(sg_pixel_format fmt, int width, int height, int row_align_bytes);

        Width and height are generally in number pixels, but note that 'row' has different meaning
        for uncompressed vs compressed pixel formats: for uncompressed formats, a row is identical
        with a single line if pixels, while in compressed formats, one row is a line of *compression blocks*.

        This is why calling sg_query_surface_pitch() for a compressed pixel format and height
        N, N+1, N+2, ... may return the same result.

        The row_align_bytes parammeter is for added flexibility. For image data that goes into
        the sg_make_image() or sg_update_image() this should generally be 1, because these
        functions take tightly packed image data as input no matter what alignment restrictions
        exist in the backend 3D APIs.

    ON INITIALIZATION:
    ==================
    When calling sg_setup(), a pointer to an sg_desc struct must be provided
    which contains initialization options. These options provide two types
    of information to sokol-gfx:

        (1) upper bounds and limits needed to allocate various internal
            data structures:
                - the max number of resources of each type that can
                  be alive at the same time, this is used for allocating
                  internal pools
                - the max overall size of uniform data that can be
                  updated per frame, including a worst-case alignment
                  per uniform update (this worst-case alignment is 256 bytes)
                - the max size of all dynamic resource updates (sg_update_buffer,
                  sg_append_buffer and sg_update_image) per frame
                - the max number of compute-dispatch calls in a compute pass
            Not all of those limit values are used by all backends, but it is
            good practice to provide them none-the-less.

        (2) 3D backend "environment information" in a nested sg_environment struct:
            - pointers to backend-specific context- or device-objects (for instance
              the D3D11, WebGPU or Metal device objects)
            - defaults for external swapchain pixel formats and sample counts,
              these will be used as default values in image and pipeline objects,
              and the sg_swapchain struct passed into sg_begin_pass()
            Usually you provide a complete sg_environment struct through
            a helper function, as an example look at the sglue_environment()
            function in the sokol_glue.h header.

    See the documentation block of the sg_desc struct below for more information.


    ON RENDER PASSES
    ================
    Relevant samples:
        - https://floooh.github.io/sokol-html5/offscreen-sapp.html
        - https://floooh.github.io/sokol-html5/offscreen-msaa-sapp.html
        - https://floooh.github.io/sokol-html5/mrt-sapp.html
        - https://floooh.github.io/sokol-html5/mrt-pixelformats-sapp.html

    A render pass groups rendering commands into a set of render target images
    (called 'pass attachments'). Render target images can be used in subsequent
    passes as textures (it is invalid to use the same image both as render target
    and as texture in the same pass).

    The following sokol-gfx functions must only be called inside a render-pass:

        sg_apply_viewport[f]
        sg_apply_scissor_rect[f]
        sg_draw

    The following function may be called inside a render- or compute-pass, but
    not outside a pass:

        sg_apply_pipeline
        sg_apply_bindings
        sg_apply_uniforms

    A frame must have at least one 'swapchain render pass' which renders into an
    externally provided swapchain provided as an sg_swapchain struct to the
    sg_begin_pass() function. If you use sokol_gfx.h together with sokol_app.h,
    just call the sglue_swapchain() helper function in sokol_glue.h to
    provide the swapchain information. Otherwise the following information
    must be provided:

        - the color pixel-format of the swapchain's render surface
        - an optional depth/stencil pixel format if the swapchain
          has a depth/stencil buffer
        - an optional sample-count for MSAA rendering
        - NOTE: the above three values can be zero-initialized, in that
          case the defaults from the sg_environment struct will be used that
          had been passed to the sg_setup() function.
        - a number of backend specific objects:
            - GL/GLES3: just a GL framebuffer handle
            - D3D11:
                - an ID3D11RenderTargetView for the rendering surface
                - if MSAA is used, an ID3D11RenderTargetView as
                  MSAA resolve-target
                - an optional ID3D11DepthStencilView for the
                  depth/stencil buffer
            - WebGPU
                - a WGPUTextureView object for the rendering surface
                - if MSAA is used, a WGPUTextureView object as MSAA resolve target
                - an optional WGPUTextureView for the
            - Metal (NOTE that the roles of provided surfaces is slightly
              different in Metal than in D3D11 or WebGPU, notably, the
              CAMetalDrawable is either rendered to directly, or serves
              as MSAA resolve target):
                - a CAMetalDrawable object which is either rendered
                  into directly, or in case of MSAA rendering, serves
                  as MSAA-resolve-target
                - if MSAA is used, an multisampled MTLTexture where
                  rendering goes into
                - an optional MTLTexture for the depth/stencil buffer

    It's recommended that you create a helper function which returns an
    initialized sg_swapchain struct by value. This can then be directly plugged
    into the sg_begin_pass function like this:

        sg_begin_pass(&(sg_pass){ .swapchain = sglue_swapchain() });

    As an example for such a helper function check out the function sglue_swapchain()
    in the sokol_glue.h header.

    For offscreen render passes, the render target images used in a render pass
    are baked into an immutable sg_attachments object.

    For a simple offscreen scenario with one color-, one depth-stencil-render
    target and without multisampling, creating an attachment object looks like this:

    First create two render target images, one with a color pixel format,
    and one with the depth- or depth-stencil pixel format. Both images
    must have the same dimensions:

        const sg_image color_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 1,
        });
        const sg_image depth_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_DEPTH,
            .sample_count = 1,
        });

    NOTE: when creating render target images, have in mind that some default values
    are aligned with the default environment attributes in the sg_environment struct
    that was passed into the sg_setup() call:

        - the default value for sg_image_desc.pixel_format is taken from
          sg_environment.defaults.color_format
        - the default value for sg_image_desc.sample_count is taken from
          sg_environment.defaults.sample_count
        - the default value for sg_image_desc.num_mipmaps is always 1

    Next create an attachments object:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0].image = color_img,
            .depth_stencil.image = depth_img,
        });

    This attachments object is then passed into the sg_begin_pass() function
    in place of the swapchain struct:

        sg_begin_pass(&(sg_pass){ .attachments = atts });

    Swapchain and offscreen passes form dependency trees each with a swapchain
    pass at the root, offscreen passes as nodes, and render target images as
    dependencies between passes.

    sg_pass_action structs are used to define actions that should happen at the
    start and end of rendering passes (such as clearing pass attachments to a
    specific color or depth-value, or performing an MSAA resolve operation at
    the end of a pass).

    A typical sg_pass_action object which clears the color attachment to black
    might look like this:

        const sg_pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            }
        };

    This omits the defaults for the color attachment store action, and
    the depth-stencil-attachments actions. The same pass action with the
    defaults explicitly filled in would look like this:

        const sg_pass_action pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_STORE,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            },
            .depth = = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = 1.0f,
            },
            .stencil = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = 0
            }
        };

    With the sg_pass object and sg_pass_action struct in place everything
    is ready now for the actual render pass:

    Using such this prepared sg_pass_action in a swapchain pass looks like
    this:

        sg_begin_pass(&(sg_pass){
            .action = pass_action,
            .swapchain = sglue_swapchain()
        });
        ...
        sg_end_pass();

    ...of alternatively in one offscreen pass:

        sg_begin_pass(&(sg_pass){
            .action = pass_action,
            .attachments = attachments,
        });
        ...
        sg_end_pass();

    Offscreen rendering can also go into a mipmap, or a slice/face of
    a cube-, array- or 3d-image (which some restrictions, for instance
    it's not possible to create a 3D image with a depth/stencil pixel format,
    these exceptions are generally caught by the sokol-gfx validation layer).

    The mipmap/slice selection happens at attachments creation time, for instance
    to render into mipmap 2 of slice 3 of an array texture:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0] = {
                .image = color_img,
                .mip_level = 2,
                .slice = 3,
            },
            .depth_stencil.image = depth_img,
        });

    If MSAA offscreen rendering is desired, the multi-sample rendering result
    must be 'resolved' into a separate 'resolve image', before that image can
    be used as texture.

    Creating a simple attachments object for multisampled rendering requires
    3 attachment images: the color attachment image which has a sample
    count > 1, a resolve attachment image of the same size and pixel format
    but a sample count == 1, and a depth/stencil attachment image with
    the same size and sample count as the color attachment image:

        const sg_image color_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 4,
        });
        const sg_image resolve_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_RGBA8,
            .sample_count = 1,
        });
        const sg_image depth_img = sg_make_image(&(sg_image_desc){
            .render_target = true,
            .width = 256,
            .height = 256,
            .pixel_format = SG_PIXELFORMAT_DEPTH,
            .sample_count = 4,
        });

    ...create the attachments object:

        const sg_attachments atts = sg_make_attachments(&(sg_attachments_desc){
            .colors[0].image = color_img,
            .resolves[0].image = resolve_img,
            .depth_stencil.image = depth_img,
        });

    If an attachments object defines a resolve image in a specific resolve attachment slot,
    an 'msaa resolve operation' will happen in sg_end_pass().

    In this scenario, the content of the MSAA color attachment doesn't need to be
    preserved (since it's only needed inside sg_end_pass for the msaa-resolve), so
    the .store_action should be set to "don't care":

        const sg_pass_action = {
            .colors[0] = {
                .load_action = SG_LOADACTION_CLEAR,
                .store_action = SG_STOREACTION_DONTCARE,
                .clear_value = { 0.0f, 0.0f, 0.0f, 1.0f }
            }
        };

    The actual render pass looks as usual:

        sg_begin_pass(&(sg_pass){ .action = pass_action, .attachments = atts });
        ...
        sg_end_pass();

    ...after sg_end_pass() the only difference to the non-msaa scenario is that the
    rendering result which is going to be used as texture in a followup pass is
    in 'resolve_img', not in 'color_img' (in fact, trying to bind color_img as a
    texture would result in a validation error).


    ON COMPUTE PASSES
    =================
    Compute passes are used to update the content of storage resources
    (currently only storage buffers) by running compute shader code on
    the GPU. This will almost always be more efficient than computing
    that same data on the CPU and uploading the data via `sg_update_buffer()`.

    NOTE: compute passes are only supported on the following platforms and
    backends:

        - macOS and iOS with Metal
        - Windows with D3D11 and OpenGL
        - Linux with OpenGL or GLES3.1+
        - Web with WebGPU
        - Android with GLES3.1+

    ...this means compute shaders can't be used on the following platform/backend
    combos (the same restrictions apply to using storage buffers without compute
    shaders):

        - macOS with GL
        - iOS with GLES3
        - Web with WebGL2

    A compute pass is started with:

        sg_begin_pass(&(sg_pass){ .compute = true });

    ...and finished with:

        sg_end_pass();

    Typically the following functions will be called inside a compute pass:

        sg_apply_pipeline
        sg_apply_bindings
        sg_apply_uniforms
        sg_dispatch

    The following functions are disallowed inside a compute pass
    and will cause validation layer errors:

        sg_apply_viewport[f]
        sg_apply_scissor_rect[f]
        sg_draw

    Only special 'compute shaders' and 'compute pipelines' can be used in
    compute passes. A compute shader only has a compute-function instead
    of a vertex- and fragment-function pair, and it doesn't accept vertex-
    and index-buffers as input, only storage-buffers, textures and non-filtering
    samplers (more details on compute shaders in the following section).

    A compute pipeline is created by providing a compute shader object,
    setting the .compute creation parameter to true and not defining any
    'render state':

        sg_pipeline pip = sg_make_pipeline(&(sg_pipeline_desc){
            .compute = true,
            .shader = compute_shader,
        });

    The sg_apply_bindings and sg_apply_uniforms calls are the same as in
    render passes, with the exception that no vertex- and index-buffers
    can be bound in the sg_apply_bindings call.

    Finally to kick off a compute workload, call sg_dispatch with the
    number of workgroups in the x, y and z-dimension:

        sg_dispatch(int num_groups_x, int num_groups_y, int num_groups_z)

    Also see the following compute-shader samples:

        - https://floooh.github.io/sokol-webgpu/instancing-compute-sapp.html
        - https://floooh.github.io/sokol-webgpu/computeboids-sapp.html


    ON SHADER CREATION
    ==================
    sokol-gfx doesn't come with an integrated shader cross-compiler, instead
    backend-specific shader sources or binary blobs need to be provided when
    creating a shader object, along with reflection information about the
    shader resource binding interface needed to bind sokol-gfx resources to the
    proper shader inputs.

    The easiest way to provide all this shader creation data is to use the
    sokol-shdc shader compiler tool to compile shaders from a common
    GLSL syntax into backend-specific sources or binary blobs, along with
    shader interface information and uniform blocks mapped to C structs.

    To create a shader using a C header which has been code-generated by sokol-shdc:

        // include the C header code-generated by sokol-shdc:
        #include "myshader.glsl.h"
        ...

        // create shader using a code-generated helper function from the C header:
        sg_shader shd = sg_make_shader(myshader_shader_desc(sg_query_backend()));

    The samples in the 'sapp' subdirectory of the sokol-samples project
    also use the sokol-shdc approach:

        https://github.com/floooh/sokol-samples/tree/master/sapp

    If you're planning to use sokol-shdc, you can stop reading here, instead
    continue with the sokol-shdc documentation:

        https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md

    To create shaders with backend-specific shader code or binary blobs,
    the sg_make_shader() function requires the following information:

    - Shader code or shader binary blobs for the vertex- and fragment-, or the
      compute-shader-stage:
        - for the desktop GL backend, source code can be provided in '#version 410' or
          '#version 430', version 430 is required when using storage buffers and
          compute shaders support, but note that this is not available on macOS
        - for the GLES3 backend, source code must be provided in '#version 300 es' syntax
        - for the D3D11 backend, shaders can be provided as source or binary
          blobs, the source code should be in HLSL4.0 (for compatibility with old
          low-end GPUs) or preferably in HLSL5.0 syntax, note that when
          shader source code is provided for the D3D11 backend, sokol-gfx will
          dynamically load 'd3dcompiler_47.dll'
        - for the Metal backends, shaders can be provided as source or binary blobs, the
          MSL version should be in 'metal-1.1' (other versions may work but are not tested)
        - for the WebGPU backend, shaders must be provided as WGSL source code
        - optionally the following shader-code related attributes can be provided:
            - an entry function name (only on D3D11 or Metal, but not OpenGL)
            - on D3D11 only, a compilation target (default is "vs_4_0" and "ps_4_0")

    - Information about the input vertex attributes used by the vertex shader,
      most of that backend-specific:
        - An optional 'base type' (float, signed-/unsigned-int) for each vertex
          attribute. When provided, this used by the validation layer to check
          that the CPU-side input vertex format is compatible with the input
          vertex declaration of the vertex shader.
        - Metal: no location information needed since vertex attributes are always bound
          by their attribute location defined in the shader via '[[attribute(N)]]'
        - WebGPU: no location information needed since vertex attributes are always
          bound by their attribute location defined in the shader via `@location(N)`
        - GLSL: vertex attribute names can be optionally provided, in that case their
          location will be looked up by name, otherwise, the vertex attribute location
          can be defined with 'layout(location = N)'
        - D3D11: a 'semantic name' and 'semantic index' must be provided for each vertex
          attribute, e.g. if the vertex attribute is defined as 'TEXCOORD1' in the shader,
          the semantic name would be 'TEXCOORD', and the semantic index would be '1'

      NOTE that vertex attributes currently must not have gaps. This requirement
      may be relaxed in the future.

    - Specifically for Metal compute shaders, the 'number of threads per threadgroup'
      must be provided. Normally this is extracted by sokol-shdc from the GLSL
      shader source code. For instance the following statement in the input
      GLSL:

        layout(local_size_x=64, local_size_y=1, local_size_z=1) in;

      ...will be communicated to the sokol-gfx Metal backend in the
      code-generated sg_shader_desc struct:

        (sg_shader_desc){
            .mtl_threads_per_threadgroup = { .x = 64, .y = 1, .z = 1 },
        }

    - Information about each uniform block used in the shader:
        - the shader stage of the uniform block (vertex, fragment or compute)
        - the size of the uniform block in number of bytes
        - a memory layout hint (currently 'native' or 'std140') where 'native' defines a
          backend-specific memory layout which shouldn't be used for cross-platform code.
          Only std140 guarantees a backend-agnostic memory layout.
        - a backend-specific bind slot:
            - D3D11/HLSL: the buffer register N (`register(bN)`) where N is 0..7
            - Metal/MSL: the buffer bind slot N (`[[buffer(N)]]`) where N is 0..7
            - WebGPU: the binding N in `@group(0) @binding(N)` where N is 0..15
        - For GLSL only: a description of the internal uniform block layout, which maps
          member types and their offsets on the CPU side to uniform variable names
          in the GLSL shader
        - please also NOTE the documentation sections about UNIFORM DATA LAYOUT
          and CROSS-BACKEND COMMON UNIFORM DATA LAYOUT below!

    - A description of each storage buffer used in the shader:
        - the shader stage of the storage buffer
        - a boolean 'readonly' flag, this is used for validation and hazard
          tracking in some 3D backends. Note that in render passes, only
          readonly storage buffer bindings are allowed. In compute passes, any
          read/write storage buffer binding is assumed to be written to by the
          compute shader.
        - a backend-specific bind slot:
            - D3D11/HLSL:
                - for readonly storage buffer bindings: the texture register N
                  (`register(tN)`) where N is 0..23 (in HLSL, readonly storage
                  buffers and textures share the same bind space for
                  'shader resource views')
                - for read/write storage buffer buffer bindings: the UAV register N
                  (`register(uN)`) where N is 0..7 (in HLSL, readwrite storage
                  buffers use their own bind space for 'unordered access views')
            - Metal/MSL: the buffer bind slot N (`[[buffer(N)]]`) where N is 8..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127
            - GL/GLSL: the buffer binding N in `layout(binding=N)` where N is 0..7
        - note that storage buffers are not supported on all backends
          and platforms

    - A description of each texture/image used in the shader:
        - the shader stage of the texture (vertex, fragment or compute)
        - the expected image type:
            - SG_IMAGETYPE_2D
            - SG_IMAGETYPE_CUBE
            - SG_IMAGETYPE_3D
            - SG_IMAGETYPE_ARRAY
        - the expected 'image sample type':
            - SG_IMAGESAMPLETYPE_FLOAT
            - SG_IMAGESAMPLETYPE_DEPTH
            - SG_IMAGESAMPLETYPE_SINT
            - SG_IMAGESAMPLETYPE_UINT
            - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT
        - a flag whether the texture is expected to be multisampled
        - a backend-specific bind slot:
            - D3D11/HLSL: the texture register N (`register(tN)`) where N is 0..23
              (in HLSL, readonly storage buffers and texture share the same bind space)
            - Metal/MSL: the texture bind slot N (`[[texture(N)]]`) where N is 0..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127

    - A description of each sampler used in the shader:
        - the shader stage of the sampler (vertex, fragment or compute)
        - the expected sampler type:
            - SG_SAMPLERTYPE_FILTERING,
            - SG_SAMPLERTYPE_NONFILTERING,
            - SG_SAMPLERTYPE_COMPARISON,
        - a backend-specific bind slot:
            - D3D11/HLSL: the sampler register N (`register(sN)`) where N is 0..15
            - Metal/MSL: the sampler bind slot N (`[[sampler(N)]]`) where N is 0..15
            - WebGPU/WGSL: the binding N in `@group(0) @binding(N)` where N is 0..127

    - An array of 'image-sampler-pairs' used by the shader to sample textures,
      for D3D11, Metal and WebGPU this is used for validation purposes to check
      whether the texture and sampler are compatible with each other (especially
      WebGPU is very picky about combining the correct
      texture-sample-type with the correct sampler-type). For GLSL an
      additional 'combined-image-sampler name' must be provided because 'OpenGL
      style GLSL' cannot handle separate texture and sampler objects, but still
      groups them into a traditional GLSL 'sampler object'.

    Compatibility rules for image-sample-type vs sampler-type are as follows:

        - SG_IMAGESAMPLETYPE_FLOAT => (SG_SAMPLERTYPE_FILTERING or SG_SAMPLERTYPE_NONFILTERING)
        - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_SINT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_UINT => SG_SAMPLERTYPE_NONFILTERING
        - SG_IMAGESAMPLETYPE_DEPTH => SG_SAMPLERTYPE_COMPARISON

    Backend-specific bindslot ranges (not relevant when using sokol-shdc):

        - D3D11/HLSL:
            - separate bindslot space per shader stage
            - uniform blocks (as cbuffer): `register(b0..b7)`
            - textures and readonly storage buffers: `register(t0..t23)`
            - read/write storage buffers: `register(u0..u7)`
            - samplers: `register(s0..s15)`
        - Metal/MSL:
            - separate bindslot space per shader stage
            - uniform blocks: `[[buffer(0..7)]]`
            - storage buffers: `[[buffer(8..15)]]`
            - textures: `[[texture(0..15)]]`
            - samplers: `[[sampler(0..15)]]`
        - WebGPU/WGSL:
            - common bindslot space across shader stages
            - uniform blocks: `@group(0) @binding(0..15)`
            - textures, samplers and storage buffers: `@group(1) @binding(0..127)`
        - GL/GLSL:
            - uniforms and image-samplers are bound by name
            - storage buffers: `layout(std430, binding=0..7)` (common
              bindslot space across shader stages)

    For example code of how to create backend-specific shader objects,
    please refer to the following samples:

        - for D3D11:    https://github.com/floooh/sokol-samples/tree/master/d3d11
        - for Metal:    https://github.com/floooh/sokol-samples/tree/master/metal
        - for OpenGL:   https://github.com/floooh/sokol-samples/tree/master/glfw
        - for GLES3:    https://github.com/floooh/sokol-samples/tree/master/html5
        - for WebGPU:   https://github.com/floooh/sokol-samples/tree/master/wgpu


    ON SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT AND SG_SAMPLERTYPE_NONFILTERING
    ========================================================================
    The WebGPU backend introduces the concept of 'unfilterable-float' textures,
    which can only be combined with 'nonfiltering' samplers (this is a restriction
    specific to WebGPU, but since the same sokol-gfx code should work across
    all backend, the sokol-gfx validation layer also enforces this restriction
    - the alternative would be undefined behaviour in some backend APIs on
    some devices).

    The background is that some mobile devices (most notably iOS devices) can
    not perform linear filtering when sampling textures with certain pixel
    formats, most notable the 32F formats:

        - SG_PIXELFORMAT_R32F
        - SG_PIXELFORMAT_RG32F
        - SG_PIXELFORMAT_RGBA32F

    The information of whether a shader is going to be used with such an
    unfilterable-float texture must already be provided in the sg_shader_desc
    struct when creating the shader (see the above section "ON SHADER CREATION").

    If you are using the sokol-shdc shader compiler, the information whether a
    texture/sampler binding expects an 'unfilterable-float/nonfiltering'
    texture/sampler combination cannot be inferred from the shader source
    alone, you'll need to provide this hint via annotation-tags. For instance
    here is an example from the ozz-skin-sapp.c sample shader which samples an
    RGBA32F texture with skinning matrices in the vertex shader:

    ```glsl
    @image_sample_type joint_tex unfilterable_float
    uniform texture2D joint_tex;
    @sampler_type smp nonfiltering
    uniform sampler smp;
    ```

    This will result in SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT and
    SG_SAMPLERTYPE_NONFILTERING being written to the code-generated
    sg_shader_desc struct.


    ON VERTEX FORMATS
    =================
    Sokol-gfx implements the same strict mapping rules from CPU-side
    vertex component formats to GPU-side vertex input data types:

    - float and packed normalized CPU-side formats must be used as
      floating point base type in the vertex shader
    - packed signed-integer CPU-side formats must be used as signed
      integer base type in the vertex shader
    - packed unsigned-integer CPU-side formats must be used as unsigned
      integer base type in the vertex shader

    These mapping rules are enforced by the sokol-gfx validation layer,
    but only when sufficient reflection information is provided in
    `sg_shader_desc.attrs[].base_type`. This is the case when sokol-shdc
    is used, otherwise the default base_type will be SG_SHADERATTRBASETYPE_UNDEFINED
    which causes the sokol-gfx validation check to be skipped (of course you
    can also provide the per-attribute base type information manually when
    not using sokol-shdc).

    The detailed mapping rules from SG_VERTEXFORMAT_* to GLSL data types
    are as follows:

    - FLOAT[*] => float, vec*
    - BYTE4N => vec* (scaled to -1.0 .. +1.0)
    - UBYTE4N => vec* (scaled to 0.0 .. +1.0)
    - SHORT[*]N => vec* (scaled to -1.0 .. +1.0)
    - USHORT[*]N => vec* (scaled to 0.0 .. +1.0)
    - INT[*] => int, ivec*
    - UINT[*] => uint, uvec*
    - BYTE4 => int*
    - UBYTE4 => uint*
    - SHORT[*] => int*
    - USHORT[*] => uint*

    NOTE that sokol-gfx only provides vertex formats with sizes of a multiple
    of 4 (e.g. BYTE4N but not BYTE2N). This is because vertex components must
    be 4-byte aligned anyway.


    UNIFORM DATA LAYOUT:
    ====================
    NOTE: if you use the sokol-shdc shader compiler tool, you don't need to worry
    about the following details.

    The data that's passed into the sg_apply_uniforms() function must adhere to
    specific layout rules so that the GPU shader finds the uniform block
    items at the right offset.

    For the D3D11 and Metal backends, sokol-gfx only cares about the size of uniform
    blocks, but not about the internal layout. The data will just be copied into
    a uniform/constant buffer in a single operation and it's up you to arrange the
    CPU-side layout so that it matches the GPU side layout. This also means that with
    the D3D11 and Metal backends you are not limited to a 'cross-platform' subset
    of uniform variable types.

    If you ever only use one of the D3D11, Metal *or* WebGPU backend, you can stop reading here.

    For the GL backends, the internal layout of uniform blocks matters though,
    and you are limited to a small number of uniform variable types. This is
    because sokol-gfx must be able to locate the uniform block members in order
    to upload them to the GPU with glUniformXXX() calls.

    To describe the uniform block layout to sokol-gfx, the following information
    must be passed to the sg_make_shader() call in the sg_shader_desc struct:

        - a hint about the used packing rule (either SG_UNIFORMLAYOUT_NATIVE or
          SG_UNIFORMLAYOUT_STD140)
        - a list of the uniform block members types in the correct order they
          appear on the CPU side

    For example if the GLSL shader has the following uniform declarations:

        uniform mat4 mvp;
        uniform vec2 offset0;
        uniform vec2 offset1;
        uniform vec2 offset2;

    ...and on the CPU side, there's a similar C struct:

        typedef struct {
            float mvp[16];
            float offset0[2];
            float offset1[2];
            float offset2[2];
        } params_t;

    ...the uniform block description in the sg_shader_desc must look like this:

        sg_shader_desc desc = {
            .vs.uniform_blocks[0] = {
                .size = sizeof(params_t),
                .layout = SG_UNIFORMLAYOUT_NATIVE,  // this is the default and can be omitted
                .uniforms = {
                    // order must be the same as in 'params_t':
                    [0] = { .name = "mvp", .type = SG_UNIFORMTYPE_MAT4 },
                    [1] = { .name = "offset0", .type = SG_UNIFORMTYPE_VEC2 },
                    [2] = { .name = "offset1", .type = SG_UNIFORMTYPE_VEC2 },
                    [3] = { .name = "offset2", .type = SG_UNIFORMTYPE_VEC2 },
                }
            }
        };

    With this information sokol-gfx can now compute the correct offsets of the data items
    within the uniform block struct.

    The SG_UNIFORMLAYOUT_NATIVE packing rule works fine if only the GL backends are used,
    but for proper D3D11/Metal/GL a subset of the std140 layout must be used which is
    described in the next section:


    CROSS-BACKEND COMMON UNIFORM DATA LAYOUT
    ========================================
    For cross-platform / cross-3D-backend code it is important that the same uniform block
    layout on the CPU side can be used for all sokol-gfx backends. To achieve this,
    a common subset of the std140 layout must be used:

    - The uniform block layout hint in sg_shader_desc must be explicitly set to
      SG_UNIFORMLAYOUT_STD140.
    - Only the following GLSL uniform types can be used (with their associated sokol-gfx enums):
        - float => SG_UNIFORMTYPE_FLOAT
        - vec2  => SG_UNIFORMTYPE_FLOAT2
        - vec3  => SG_UNIFORMTYPE_FLOAT3
        - vec4  => SG_UNIFORMTYPE_FLOAT4
        - int   => SG_UNIFORMTYPE_INT
        - ivec2 => SG_UNIFORMTYPE_INT2
        - ivec3 => SG_UNIFORMTYPE_INT3
        - ivec4 => SG_UNIFORMTYPE_INT4
        - mat4  => SG_UNIFORMTYPE_MAT4
    - Alignment for those types must be as follows (in bytes):
        - float => 4
        - vec2  => 8
        - vec3  => 16
        - vec4  => 16
        - int   => 4
        - ivec2 => 8
        - ivec3 => 16
        - ivec4 => 16
        - mat4  => 16
    - Arrays are only allowed for the following types: vec4, int4, mat4.

    Note that the HLSL cbuffer layout rules are slightly different from the
    std140 layout rules, this means that the cbuffer declarations in HLSL code
    must be tweaked so that the layout is compatible with std140.

    The by far easiest way to tackle the common uniform block layout problem is
    to use the sokol-shdc shader cross-compiler tool!


    ON STORAGE BUFFERS
    ==================
    The two main purpose of storage buffers are:

        - to be populated by compute shaders with dynamically generated data
        - for providing random-access data to all shader stages

    Storage buffers can be used to pass large amounts of random access structured
    data from the CPU side to the shaders. They are similar to data textures, but are
    more convenient to use both on the CPU and shader side since they can be accessed
    in shaders as as a 1-dimensional array of struct items.

    Storage buffers are *NOT* supported on the following platform/backend combos:

    - macOS+GL (because storage buffers require GL 4.3, while macOS only goes up to GL 4.1)
    - platforms which only support a GLES3.0 context (WebGL2 and iOS)

    To use storage buffers, the following steps are required:

        - write a shader which uses storage buffers (vertex- and fragment-shaders
          can only read from storage buffers, while compute-shaders can both read
          and write storage buffers)
        - create one or more storage buffers via sg_make_buffer() with the
          buffer type SG_BUFFERTYPE_STORAGEBUFFER
        - when creating a shader via sg_make_shader(), populate the sg_shader_desc
          struct with binding info (when using sokol-shdc, this step will be taken care
          of automatically)
            - which storage buffer bind slots on the vertex-, fragment- or compute-stage
              are occupied
            - whether the storage buffer on that bind slot is readonly (readonly
              bindings are required for vertex- and fragment-shaders, and in compute
              shaders the readonly flag is used to control hazard tracking in some
              3D backends)

        - when calling sg_apply_bindings(), apply the matching bind slots with the previously
          created storage buffers
        - ...and that's it.

    For more details, see the following backend-agnostic sokol samples:

    - simple vertex pulling from a storage buffer:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/vertexpull-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/vertexpull-sapp.glsl
    - instanced rendering via storage buffers (vertex- and instance-pulling):
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-pull-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-pull-sapp.glsl
    - storage buffers both on the vertex- and fragment-stage:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/sbuftex-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/sbuftex-sapp.glsl
    - the Ozz animation sample rewritten to pull all rendering data from storage buffers:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/ozz-storagebuffer-sapp.cc
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/ozz-storagebuffer-sapp.glsl
    - the instancing sample modified to use compute shaders:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-compute-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/instancing-compute-sapp.glsl
    - the Compute Boids sample ported to sokol-gfx:
        - C code: https://github.com/floooh/sokol-samples/blob/master/sapp/computeboids-sapp.c
        - shader: https://github.com/floooh/sokol-samples/blob/master/sapp/computeboids-sapp.glsl

    ...also see the following backend-specific vertex pulling samples (those also don't use sokol-shdc):

    - D3D11: https://github.com/floooh/sokol-samples/blob/master/d3d11/vertexpulling-d3d11.c
    - desktop GL: https://github.com/floooh/sokol-samples/blob/master/glfw/vertexpulling-glfw.c
    - Metal: https://github.com/floooh/sokol-samples/blob/master/metal/vertexpulling-metal.c
    - WebGPU: https://github.com/floooh/sokol-samples/blob/master/wgpu/vertexpulling-wgpu.c

    ...and the backend specific compute shader samples:

    - D3D11: https://github.com/floooh/sokol-samples/blob/master/d3d11/instancing-compute-d3d11.c
    - desktop GL: https://github.com/floooh/sokol-samples/blob/master/glfw/instancing-compute-glfw.c
    - Metal: https://github.com/floooh/sokol-samples/blob/master/metal/instancing-compute-metal.c
    - WebGPU: https://github.com/floooh/sokol-samples/blob/master/wgpu/instancing-compute-wgpu.c

    Storage buffer shader authoring caveats when using sokol-shdc:

        - declare a read-only storage buffer interface block with `layout(binding=N) readonly buffer [name] { ... }`
          (where 'N' is the index in `sg_bindings.storage_buffers[N]`)
        - ...or a read/write storage buffer interface block with `layout(binding=N) buffer [name] { ... }`
        - declare a struct which describes a single array item in the storage buffer interface block
        - only put a single flexible array member into the storage buffer interface block

    E.g. a complete example in 'sokol-shdc GLSL':

        ```glsl
        @vs
        // declare a struct:
        struct sb_vertex {
            vec3 pos;
            vec4 color;
        }
        // declare a buffer interface block with a single flexible struct array:
        layout(binding=0) readonly buffer vertices {
            sb_vertex vtx[];
        }
        // in the shader function, access the storage buffer like this:
        void main() {
            vec3 pos = vtx[gl_VertexIndex].pos;
            ...
        }
        @end
        ```

    In a compute shader you can read and write the same item in the same
    storage buffer (but you'll have to be careful for random access since
    many threads of the same compute function run in parallel):

        @cs
        struct sb_item {
            vec3 pos;
            vec3 vel;
        }
        layout(binding=0) buffer items_ssbo {
            sb_item items[];
        }
        layout(local_size_x=64, local_size_y=1, local_size_z=1) in;
        void main() {
            uint idx = gl_GlobalInvocationID.x;
            vec3 pos = items[idx].pos;
            ...
            items[idx].pos = pos;
        }
        @end

    Backend-specific storage-buffer caveats (not relevant when using sokol-shdc):

        D3D11:
            - storage buffers are created as 'raw' Byte Address Buffers
              (https://learn.microsoft.com/en-us/windows/win32/direct3d11/overviews-direct3d-11-resources-intro#raw-views-of-buffers)
            - in HLSL, use a ByteAddressBuffer for readonly access of the buffer content:
              (https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/sm5-object-byteaddressbuffer)
            - ...or RWByteAddressBuffer for read/write access:
              (https://learn.microsoft.com/en-us/windows/win32/direct3dhlsl/sm5-object-rwbyteaddressbuffer)
            - readonly-storage buffers and textures are both bound as 'shader-resource-view' and
              share the same bind slots (declared as `register(tN)` in HLSL), where N must be in the range 0..23)
            - read/write storage buffers are bound as 'unordered-access-view' (declared as `register(uN)` in HLSL
              where N is in the range 0..7)

        Metal:
            - in Metal there is no internal difference between vertex-, uniform- and
              storage-buffers, all are bound to the same 'buffer bind slots' with the
              following reserved ranges:
                - vertex shader stage:
                    - uniform buffers: slots 0..7
                    - storage buffers: slots 8..15
                    - vertex buffers: slots 15..23
                - fragment shader stage:
                    - uniform buffers: slots 0..7
                    - storage buffers: slots 8..15
            - this means in MSL, storage buffer bindings start at [[buffer(8)]] both in
              the vertex and fragment stage

        GL:
            - the GL backend doesn't use name-lookup to find storage buffer bindings, this
              means you must annotate buffers with `layout(std430, binding=N)` in GLSL
            - ...where N is 0..7 in the vertex shader, and 8..15 in the fragment shader

        WebGPU:
            - in WGSL, textures, samplers and storage buffers all use a shared
              bindspace across all shader stages on bindgroup 1:

              `@group(1) @binding(0..127)


    TRACE HOOKS:
    ============
    sokol_gfx.h optionally allows to install "trace hook" callbacks for
    each public API functions. When a public API function is called, and
    a trace hook callback has been installed for this function, the
    callback will be invoked with the parameters and result of the function.
    This is useful for things like debugging- and profiling-tools, or
    keeping track of resource creation and destruction.

    To use the trace hook feature:

    --- Define SOKOL_TRACE_HOOKS before including the implementation.

    --- Setup an sg_trace_hooks structure with your callback function
        pointers (keep all function pointers you're not interested
        in zero-initialized), optionally set the user_data member
        in the sg_trace_hooks struct.

    --- Install the trace hooks by calling sg_install_trace_hooks(),
        the return value of this function is another sg_trace_hooks
        struct which contains the previously set of trace hooks.
        You should keep this struct around, and call those previous
        functions pointers from your own trace callbacks for proper
        chaining.

    As an example of how trace hooks are used, have a look at the
    imgui/sokol_gfx_imgui.h header which implements a realtime
    debugging UI for sokol_gfx.h on top of Dear ImGui.


    MEMORY ALLOCATION OVERRIDE
    ==========================
    You can override the memory allocation functions at initialization time
    like this:

        void* my_alloc(size_t size, void* user_data) {
            return malloc(size);
        }

        void my_free(void* ptr, void* user_data) {
            free(ptr);
        }

        ...
            sg_setup(&(sg_desc){
                // ...
                .allocator = {
                    .alloc_fn = my_alloc,
                    .free_fn = my_free,
                    .user_data = ...,
                }
            });
        ...

    If no overrides are provided, malloc and free will be used.

    This only affects memory allocation calls done by sokol_gfx.h
    itself though, not any allocations in OS libraries.


    ERROR REPORTING AND LOGGING
    ===========================
    To get any logging information at all you need to provide a logging callback in the setup call
    the easiest way is to use sokol_log.h:

        #include "sokol_log.h"

        sg_setup(&(sg_desc){ .logger.func = slog_func });

    To override logging with your own callback, first write a logging function like this:

        void my_log(const char* tag,                // e.g. 'sg'
                    uint32_t log_level,             // 0=panic, 1=error, 2=warn, 3=info
                    uint32_t log_item_id,           // SG_LOGITEM_*
                    const char* message_or_null,    // a message string, may be nullptr in release mode
                    uint32_t line_nr,               // line number in sokol_gfx.h
                    const char* filename_or_null,   // source filename, may be nullptr in release mode
                    void* user_data)
        {
            ...
        }

    ...and then setup sokol-gfx like this:

        sg_setup(&(sg_desc){
            .logger = {
                .func = my_log,
                .user_data = my_user_data,
            }
        });

    The provided logging function must be reentrant (e.g. be callable from
    different threads).

    If you don't want to provide your own custom logger it is highly recommended to use
    the standard logger in sokol_log.h instead, otherwise you won't see any warnings or
    errors.


    COMMIT LISTENERS
    ================
    It's possible to hook callback functions into sokol-gfx which are called from
    inside sg_commit() in unspecified order. This is mainly useful for libraries
    that build on top of sokol_gfx.h to be notified about the end/start of a frame.

    To add a commit listener, call:

        static void my_commit_listener(void* user_data) {
            ...
        }

        bool success = sg_add_commit_listener((sg_commit_listener){
            .func = my_commit_listener,
            .user_data = ...,
        });

    The function returns false if the internal array of commit listeners is full,
    or the same commit listener had already been added.

    If the function returns true, my_commit_listener() will be called each frame
    from inside sg_commit().

    By default, 1024 distinct commit listeners can be added, but this number
    can be tweaked in the sg_setup() call:

        sg_setup(&(sg_desc){
            .max_commit_listeners = 2048,
        });

    An sg_commit_listener item is equal to another if both the function
    pointer and user_data field are equal.

    To remove a commit listener:

        bool success = sg_remove_commit_listener((sg_commit_listener){
            .func = my_commit_listener,
            .user_data = ...,
        });

    ...where the .func and .user_data field are equal to a previous
    sg_add_commit_listener() call. The function returns true if the commit
    listener item was found and removed, and false otherwise.


    RESOURCE CREATION AND DESTRUCTION IN DETAIL
    ===========================================
    The 'vanilla' way to create resource objects is with the 'make functions':

        sg_buffer sg_make_buffer(const sg_buffer_desc* desc)
        sg_image sg_make_image(const sg_image_desc* desc)
        sg_sampler sg_make_sampler(const sg_sampler_desc* desc)
        sg_shader sg_make_shader(const sg_shader_desc* desc)
        sg_pipeline sg_make_pipeline(const sg_pipeline_desc* desc)
        sg_attachments sg_make_attachments(const sg_attachments_desc* desc)

    This will result in one of three cases:

        1. The returned handle is invalid. This happens when there are no more
           free slots in the resource pool for this resource type. An invalid
           handle is associated with the INVALID resource state, for instance:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_INVALID) {
                    // buffer pool is exhausted
                }

        2. The returned handle is valid, but creating the underlying resource
           has failed for some reason. This results in a resource object in the
           FAILED state. The reason *why* resource creation has failed differ
           by resource type. Look for log messages with more details. A failed
           resource state can be checked with:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_FAILED) {
                    // creating the resource has failed
                }

        3. And finally, if everything goes right, the returned resource is
           in resource state VALID and ready to use. This can be checked
           with:

                sg_buffer buf = sg_make_buffer(...)
                if (sg_query_buffer_state(buf) == SG_RESOURCESTATE_VALID) {
                    // creating the resource has failed
                }

    When calling the 'make functions', the created resource goes through a number
    of states:

        - INITIAL: the resource slot associated with the new resource is currently
          free (technically, there is no resource yet, just an empty pool slot)
        - ALLOC: a handle for the new resource has been allocated, this just means
          a pool slot has been reserved.
        - VALID or FAILED: in VALID state any 3D API backend resource objects have
          been successfully created, otherwise if anything went wrong, the resource
          will be in FAILED state.

    Sometimes it makes sense to first grab a handle, but initialize the
    underlying resource at a later time. For instance when loading data
    asynchronously from a slow data source, you may know what buffers and
    textures are needed at an early stage of the loading process, but actually
    loading the buffer or texture content can only be completed at a later time.

    For such situations, sokol-gfx resource objects can be created in two steps.
    You can allocate a handle upfront with one of the 'alloc functions':

        sg_buffer sg_alloc_buffer(void)
        sg_image sg_alloc_image(void)
        sg_sampler sg_alloc_sampler(void)
        sg_shader sg_alloc_shader(void)
        sg_pipeline sg_alloc_pipeline(void)
        sg_attachments sg_alloc_attachments(void)

    This will return a handle with the underlying resource object in the
    ALLOC state:

        sg_image img = sg_alloc_image();
        if (sg_query_image_state(img) == SG_RESOURCESTATE_ALLOC) {
            // allocating an image handle has succeeded, otherwise
            // the image pool is full
        }

    Such an 'incomplete' handle can be used in most sokol-gfx rendering functions
    without doing any harm, sokol-gfx will simply skip any rendering operation
    that involve resources which are not in VALID state.

    At a later time (for instance once the texture has completed loading
    asynchronously), the resource creation can be completed by calling one of
    the 'init functions', those functions take an existing resource handle and
    'desc struct':

        void sg_init_buffer(sg_buffer buf, const sg_buffer_desc* desc)
        void sg_init_image(sg_image img, const sg_image_desc* desc)
        void sg_init_sampler(sg_sampler smp, const sg_sampler_desc* desc)
        void sg_init_shader(sg_shader shd, const sg_shader_desc* desc)
        void sg_init_pipeline(sg_pipeline pip, const sg_pipeline_desc* desc)
        void sg_init_attachments(sg_attachments atts, const sg_attachments_desc* desc)

    The init functions expect a resource in ALLOC state, and after the function
    returns, the resource will be either in VALID or FAILED state. Calling
    an 'alloc function' followed by the matching 'init function' is fully
    equivalent with calling the 'make function' alone.

    Destruction can also happen as a two-step process. The 'uninit functions'
    will put a resource object from the VALID or FAILED state back into the
    ALLOC state:

        void sg_uninit_buffer(sg_buffer buf)
        void sg_uninit_image(sg_image img)
        void sg_uninit_sampler(sg_sampler smp)
        void sg_uninit_shader(sg_shader shd)
        void sg_uninit_pipeline(sg_pipeline pip)
        void sg_uninit_attachments(sg_attachments pass)

    Calling the 'uninit functions' with a resource that is not in the VALID or
    FAILED state is a no-op.

    To finally free the pool slot for recycling call the 'dealloc functions':

        void sg_dealloc_buffer(sg_buffer buf)
        void sg_dealloc_image(sg_image img)
        void sg_dealloc_sampler(sg_sampler smp)
        void sg_dealloc_shader(sg_shader shd)
        void sg_dealloc_pipeline(sg_pipeline pip)
        void sg_dealloc_attachments(sg_attachments atts)

    Calling the 'dealloc functions' on a resource that's not in ALLOC state is
    a no-op, but will generate a warning log message.

    Calling an 'uninit function' and 'dealloc function' in sequence is equivalent
    with calling the associated 'destroy function':

        void sg_destroy_buffer(sg_buffer buf)
        void sg_destroy_image(sg_image img)
        void sg_destroy_sampler(sg_sampler smp)
        void sg_destroy_shader(sg_shader shd)
        void sg_destroy_pipeline(sg_pipeline pip)
        void sg_destroy_attachments(sg_attachments atts)

    The 'destroy functions' can be called on resources in any state and generally
    do the right thing (for instance if the resource is in ALLOC state, the destroy
    function will be equivalent to the 'dealloc function' and skip the 'uninit part').

    And finally to close the circle, the 'fail functions' can be called to manually
    put a resource in ALLOC state into the FAILED state:

        sg_fail_buffer(sg_buffer buf)
        sg_fail_image(sg_image img)
        sg_fail_sampler(sg_sampler smp)
        sg_fail_shader(sg_shader shd)
        sg_fail_pipeline(sg_pipeline pip)
        sg_fail_attachments(sg_attachments atts)

    This is recommended if anything went wrong outside of sokol-gfx during asynchronous
    resource setup (for instance a file loading operation failed). In this case,
    the 'fail function' should be called instead of the 'init function'.

    Calling a 'fail function' on a resource that's not in ALLOC state is a no-op,
    but will generate a warning log message.

    NOTE: that two-step resource creation usually only makes sense for buffers
    and images, but not for samplers, shaders, pipelines or attachments. Most notably, trying
    to create a pipeline object with a shader that's not in VALID state will
    trigger a validation layer error, or if the validation layer is disabled,
    result in a pipeline object in FAILED state. Same when trying to create
    an attachments object with invalid image objects.


    WEBGPU CAVEATS
    ==============
    For a general overview and design notes of the WebGPU backend see:

        https://floooh.github.io/2023/10/16/sokol-webgpu.html

    In general, don't expect an automatic speedup when switching from the WebGL2
    backend to the WebGPU backend. Some WebGPU functions currently actually
    have a higher CPU overhead than similar WebGL2 functions, leading to the
    paradoxical situation that some WebGPU code may be slower than similar WebGL2
    code.

    - when writing WGSL shader code by hand, a specific bind-slot convention
      must be used:

      All uniform block structs must use `@group(0)` and bindings in the
      range 0..15

        @group(0) @binding(0..15)

      All textures, samplers and storage buffers must use `@group(1)` and
      bindings must be in the range 0..127:

        @group(1) @binding(0..127)

      Note that the number of texture, sampler and storage buffer bindings
      is still limited despite the large bind range:

        - up to 16 textures and sampler across all shader stages
        - up to 8 storage buffers across all shader stages

      If you use sokol-shdc to generate WGSL shader code, you don't need to worry
      about the above binding conventions since sokol-shdc.

    - The sokol-gfx WebGPU backend uses the sg_desc.uniform_buffer_size item
      to allocate a single per-frame uniform buffer which must be big enough
      to hold all data written by sg_apply_uniforms() during a single frame,
      including a worst-case 256-byte alignment (e.g. each sg_apply_uniform
      call will cost at least 256 bytes of uniform buffer size). The default size
      is 4 MB, which is enough for 16384 sg_apply_uniform() calls per
      frame (assuming the uniform data 'payload' is less than 256 bytes
      per call). These rules are the same as for the Metal backend, so if
      you are already using the Metal backend you'll be fine.

    - sg_apply_bindings(): the sokol-gfx WebGPU backend implements a bindgroup
      cache to prevent excessive creation and destruction of BindGroup objects
      when calling sg_apply_bindings(). The number of slots in the bindgroups
      cache is defined in sg_desc.wgpu_bindgroups_cache_size when calling
      sg_setup. The cache size must be a power-of-2 number, with the default being
      1024. The bindgroups cache behaviour can be observed by calling the new
      function sg_query_frame_stats(), where the following struct items are
      of interest:

        .wgpu.num_bindgroup_cache_hits
        .wgpu.num_bindgroup_cache_misses
        .wgpu.num_bindgroup_cache_collisions
        .wgpu_num_bindgroup_cache_invalidates
        .wgpu.num_bindgroup_cache_vs_hash_key_mismatch

      The value to pay attention to is `.wgpu.num_bindgroup_cache_collisions`,
      if this number is consistently higher than a few percent of the
      .wgpu.num_set_bindgroup value, it might be a good idea to bump the
      bindgroups cache size to the next power-of-2.

    - sg_apply_viewport(): WebGPU currently has a unique restriction that viewport
      rectangles must be contained entirely within the framebuffer. As a shitty
      workaround sokol_gfx.h will clip incoming viewport rectangles against
      the framebuffer, but this will distort the clipspace-to-screenspace mapping.
      There's no proper way to handle this inside sokol_gfx.h, this must be fixed
      in a future WebGPU update (see: https://github.com/gpuweb/gpuweb/issues/373
      and https://github.com/gpuweb/gpuweb/pull/5025)

    - The sokol shader compiler generally adds `diagnostic(off, derivative_uniformity);`
      into the WGSL output. Currently only the Chrome WebGPU implementation seems
      to recognize this.

    - Likewise, the following sokol-gfx pixel formats are not supported in WebGPU:
      R16, R16SN, RG16, RG16SN, RGBA16, RGBA16SN.
      Unlike unsupported vertex formats, unsupported pixel formats can be queried
      in cross-backend code via sg_query_pixelformat() though.

    - The Emscripten WebGPU shim currently doesn't support the Closure minification
      post-link-step (e.g. currently the emcc argument '--closure 1' or '--closure 2'
      will generate broken Javascript code.

    - sokol-gfx requires the WebGPU device feature `depth32float-stencil8` to be enabled
      (this should be widely supported)

    - sokol-gfx expects that the WebGPU device feature `float32-filterable` to *not* be
      enabled (since this would exclude all iOS devices)


    LICENSE
    =======
    zlib/libpng license

    Copyright (c) 2018 Andre Weissflog

    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the
    use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not
        claim that you wrote the original software. If you use this software in a
        product, an acknowledgment in the product documentation would be
        appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must not
        be misrepresented as being the original software.

        3. This notice may not be removed or altered from any source
        distribution.

*/

#module_parameters(DEBUG := false, USE_GL := false, USE_DLL := false);

#scope_export;

#if OS == .WINDOWS {
    #if USE_DLL {
        #if USE_GL {
            #system_library,link_always "gdi32"; #system_library,link_always "dxguid"; #system_library,link_always "user32"; #system_library,link_always "shell32";
            #if  DEBUG { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_gl_debug";   }
            else       { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_gl_release"; }
        } else {
            #system_library,link_always "gdi32"; #system_library,link_always "dxguid"; #system_library,link_always "user32"; #system_library,link_always "shell32"; #system_library,link_always "d3d11";
            #if  DEBUG { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_d3d11_debug";   }
            else       { sokol_gfx_clib :: #library "sokol_gfx_windows_x64_d3d11_release"; }
        }
    } else {
        #if USE_GL {
            #system_library,link_always "gdi32"; #system_library,link_always "dxguid"; #system_library,link_always "user32"; #system_library,link_always "shell32";
            #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_gl_debug";   }
            else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_gl_release"; }
        } else {
            #system_library,link_always "gdi32"; #system_library,link_always "dxguid"; #system_library,link_always "user32"; #system_library,link_always "shell32"; #system_library,link_always "d3d11";
            #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_d3d11_debug";   }
            else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_windows_x64_d3d11_release"; }
        }
    }
}
else #if OS == .MACOS {
    #if USE_DLL {
             #if  USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_gl_release.dylib"; }
        else #if  USE_GL && CPU == .X64   &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_debug.dylib"; }
        else #if  USE_GL && CPU == .X64   && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_gl_release.dylib"; }
        else #if !USE_GL && CPU == .ARM64 &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .ARM64 && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_arm64_metal_release.dylib"; }
        else #if !USE_GL && CPU == .X64   &&  DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_debug.dylib"; }
        else #if !USE_GL && CPU == .X64   && !DEBUG { sokol_gfx_clib :: #library "../dylib/sokol_dylib_macos_x64_metal_release.dylib"; }
    } else {
        #if USE_GL {
            #system_library,link_always "Cocoa"; #system_library,link_always "QuartzCore"; #system_library,link_always "OpenGL";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_gl_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_gl_release"; }
            } else {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_gl_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_gl_release"; }
            }
        } else {
            #library,link_always "../../libclang_rt.osx"; #system_library,link_always "Cocoa"; #system_library,link_always "QuartzCore"; #system_library,link_always "Metal"; #system_library,link_always "MetalKit";
            #if CPU == .ARM64 {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_metal_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_arm64_metal_release"; }
            } else {
                #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_metal_debug";   }
                else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_macos_x64_metal_release"; }
            }
        }
    }
} else #if OS == .LINUX {
    #system_library,link_always "libXcursor"; #system_library,link_always "libX11"; #system_library,link_always "libXi"; #system_library,link_always "libGL";
    #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_linux_x64_gl_debug";   }
    else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_linux_x64_gl_release"; }
} else #if OS == .WASM {
    #if  DEBUG { sokol_gfx_clib :: #library,no_dll "sokol_gfx_wasm_gl_debug";   }
    else       { sokol_gfx_clib :: #library,no_dll "sokol_gfx_wasm_gl_release"; }
} else {
    log_error("This OS is currently not supported");
}

// setup and misc functions
sg_setup :: (desc: *sg_desc) -> void #foreign sokol_gfx_clib;
sg_shutdown :: () -> void #foreign sokol_gfx_clib;
sg_isvalid :: () -> bool #foreign sokol_gfx_clib;
sg_reset_state_cache :: () -> void #foreign sokol_gfx_clib;
sg_install_trace_hooks :: (trace_hooks: *sg_trace_hooks) -> sg_trace_hooks #foreign sokol_gfx_clib;
sg_push_debug_group :: (name: *u8) -> void #foreign sokol_gfx_clib;
sg_pop_debug_group :: () -> void #foreign sokol_gfx_clib;
sg_add_commit_listener :: (listener: sg_commit_listener) -> bool #foreign sokol_gfx_clib;
sg_remove_commit_listener :: (listener: sg_commit_listener) -> bool #foreign sokol_gfx_clib;
// resource creation, destruction and updating
sg_make_buffer :: (desc: *sg_buffer_desc) -> sg_buffer #foreign sokol_gfx_clib;
sg_make_image :: (desc: *sg_image_desc) -> sg_image #foreign sokol_gfx_clib;
sg_make_sampler :: (desc: *sg_sampler_desc) -> sg_sampler #foreign sokol_gfx_clib;
sg_make_shader :: (desc: *sg_shader_desc) -> sg_shader #foreign sokol_gfx_clib;
sg_make_pipeline :: (desc: *sg_pipeline_desc) -> sg_pipeline #foreign sokol_gfx_clib;
sg_make_attachments :: (desc: *sg_attachments_desc) -> sg_attachments #foreign sokol_gfx_clib;
sg_destroy_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_destroy_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_destroy_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_destroy_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_destroy_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_destroy_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_update_buffer :: (buf: sg_buffer, data: *sg_range) -> void #foreign sokol_gfx_clib;
sg_update_image :: (img: sg_image, data: *sg_image_data) -> void #foreign sokol_gfx_clib;
sg_append_buffer :: (buf: sg_buffer, data: *sg_range) -> s32 #foreign sokol_gfx_clib;
sg_query_buffer_overflow :: (buf: sg_buffer) -> bool #foreign sokol_gfx_clib;
sg_query_buffer_will_overflow :: (buf: sg_buffer, size: u64) -> bool #foreign sokol_gfx_clib;
// render and compute functions
sg_begin_pass :: (pass: *sg_pass) -> void #foreign sokol_gfx_clib;
sg_apply_viewport :: (x: s32, y: s32, width: s32, height: s32, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_viewportf :: (x: float, y: float, width: float, height: float, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_scissor_rect :: (x: s32, y: s32, width: s32, height: s32, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_scissor_rectf :: (x: float, y: float, width: float, height: float, origin_top_left: bool) -> void #foreign sokol_gfx_clib;
sg_apply_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_apply_bindings :: (bindings: *sg_bindings) -> void #foreign sokol_gfx_clib;
sg_apply_uniforms :: (ub_slot: s32, data: *sg_range) -> void #foreign sokol_gfx_clib;
sg_draw :: (base_element: s32, num_elements: s32, num_instances: s32) -> void #foreign sokol_gfx_clib;
sg_dispatch :: (num_groups_x: s32, num_groups_y: s32, num_groups_z: s32) -> void #foreign sokol_gfx_clib;
sg_end_pass :: () -> void #foreign sokol_gfx_clib;
sg_commit :: () -> void #foreign sokol_gfx_clib;
// getting information
sg_query_desc :: () -> sg_desc #foreign sokol_gfx_clib;
sg_query_backend :: () -> sg_backend #foreign sokol_gfx_clib;
sg_query_features :: () -> sg_features #foreign sokol_gfx_clib;
sg_query_limits :: () -> sg_limits #foreign sokol_gfx_clib;
sg_query_pixelformat :: (fmt: sg_pixel_format) -> sg_pixelformat_info #foreign sokol_gfx_clib;
sg_query_row_pitch :: (fmt: sg_pixel_format, width: s32, row_align_bytes: s32) -> s32 #foreign sokol_gfx_clib;
sg_query_surface_pitch :: (fmt: sg_pixel_format, width: s32, height: s32, row_align_bytes: s32) -> s32 #foreign sokol_gfx_clib;
// get current state of a resource (INITIAL, ALLOC, VALID, FAILED, INVALID)
sg_query_buffer_state :: (buf: sg_buffer) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_image_state :: (img: sg_image) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_sampler_state :: (smp: sg_sampler) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_shader_state :: (shd: sg_shader) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_pipeline_state :: (pip: sg_pipeline) -> sg_resource_state #foreign sokol_gfx_clib;
sg_query_attachments_state :: (atts: sg_attachments) -> sg_resource_state #foreign sokol_gfx_clib;
// get runtime information about a resource
sg_query_buffer_info :: (buf: sg_buffer) -> sg_buffer_info #foreign sokol_gfx_clib;
sg_query_image_info :: (img: sg_image) -> sg_image_info #foreign sokol_gfx_clib;
sg_query_sampler_info :: (smp: sg_sampler) -> sg_sampler_info #foreign sokol_gfx_clib;
sg_query_shader_info :: (shd: sg_shader) -> sg_shader_info #foreign sokol_gfx_clib;
sg_query_pipeline_info :: (pip: sg_pipeline) -> sg_pipeline_info #foreign sokol_gfx_clib;
sg_query_attachments_info :: (atts: sg_attachments) -> sg_attachments_info #foreign sokol_gfx_clib;
// get desc structs matching a specific resource (NOTE that not all creation attributes may be provided)
sg_query_buffer_desc :: (buf: sg_buffer) -> sg_buffer_desc #foreign sokol_gfx_clib;
sg_query_image_desc :: (img: sg_image) -> sg_image_desc #foreign sokol_gfx_clib;
sg_query_sampler_desc :: (smp: sg_sampler) -> sg_sampler_desc #foreign sokol_gfx_clib;
sg_query_shader_desc :: (shd: sg_shader) -> sg_shader_desc #foreign sokol_gfx_clib;
sg_query_pipeline_desc :: (pip: sg_pipeline) -> sg_pipeline_desc #foreign sokol_gfx_clib;
sg_query_attachments_desc :: (atts: sg_attachments) -> sg_attachments_desc #foreign sokol_gfx_clib;
// get resource creation desc struct with their default values replaced
sg_query_buffer_defaults :: (desc: *sg_buffer_desc) -> sg_buffer_desc #foreign sokol_gfx_clib;
sg_query_image_defaults :: (desc: *sg_image_desc) -> sg_image_desc #foreign sokol_gfx_clib;
sg_query_sampler_defaults :: (desc: *sg_sampler_desc) -> sg_sampler_desc #foreign sokol_gfx_clib;
sg_query_shader_defaults :: (desc: *sg_shader_desc) -> sg_shader_desc #foreign sokol_gfx_clib;
sg_query_pipeline_defaults :: (desc: *sg_pipeline_desc) -> sg_pipeline_desc #foreign sokol_gfx_clib;
sg_query_attachments_defaults :: (desc: *sg_attachments_desc) -> sg_attachments_desc #foreign sokol_gfx_clib;
// assorted query functions
sg_query_buffer_size :: (buf: sg_buffer) -> u64 #foreign sokol_gfx_clib;
sg_query_buffer_usage :: (buf: sg_buffer) -> sg_buffer_usage #foreign sokol_gfx_clib;
sg_query_image_type :: (img: sg_image) -> sg_image_type #foreign sokol_gfx_clib;
sg_query_image_width :: (img: sg_image) -> s32 #foreign sokol_gfx_clib;
sg_query_image_height :: (img: sg_image) -> s32 #foreign sokol_gfx_clib;
sg_query_image_num_slices :: (img: sg_image) -> s32 #foreign sokol_gfx_clib;
sg_query_image_num_mipmaps :: (img: sg_image) -> s32 #foreign sokol_gfx_clib;
sg_query_image_pixelformat :: (img: sg_image) -> sg_pixel_format #foreign sokol_gfx_clib;
sg_query_image_usage :: (img: sg_image) -> sg_image_usage #foreign sokol_gfx_clib;
sg_query_image_sample_count :: (img: sg_image) -> s32 #foreign sokol_gfx_clib;
// separate resource allocation and initialization (for async setup)
sg_alloc_buffer :: () -> sg_buffer #foreign sokol_gfx_clib;
sg_alloc_image :: () -> sg_image #foreign sokol_gfx_clib;
sg_alloc_sampler :: () -> sg_sampler #foreign sokol_gfx_clib;
sg_alloc_shader :: () -> sg_shader #foreign sokol_gfx_clib;
sg_alloc_pipeline :: () -> sg_pipeline #foreign sokol_gfx_clib;
sg_alloc_attachments :: () -> sg_attachments #foreign sokol_gfx_clib;
sg_dealloc_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_dealloc_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_dealloc_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_dealloc_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_dealloc_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_dealloc_attachments :: (attachments: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_init_buffer :: (buf: sg_buffer, desc: *sg_buffer_desc) -> void #foreign sokol_gfx_clib;
sg_init_image :: (img: sg_image, desc: *sg_image_desc) -> void #foreign sokol_gfx_clib;
sg_init_sampler :: (smg: sg_sampler, desc: *sg_sampler_desc) -> void #foreign sokol_gfx_clib;
sg_init_shader :: (shd: sg_shader, desc: *sg_shader_desc) -> void #foreign sokol_gfx_clib;
sg_init_pipeline :: (pip: sg_pipeline, desc: *sg_pipeline_desc) -> void #foreign sokol_gfx_clib;
sg_init_attachments :: (attachments: sg_attachments, desc: *sg_attachments_desc) -> void #foreign sokol_gfx_clib;
sg_uninit_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_uninit_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_uninit_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_uninit_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_uninit_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_uninit_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
sg_fail_buffer :: (buf: sg_buffer) -> void #foreign sokol_gfx_clib;
sg_fail_image :: (img: sg_image) -> void #foreign sokol_gfx_clib;
sg_fail_sampler :: (smp: sg_sampler) -> void #foreign sokol_gfx_clib;
sg_fail_shader :: (shd: sg_shader) -> void #foreign sokol_gfx_clib;
sg_fail_pipeline :: (pip: sg_pipeline) -> void #foreign sokol_gfx_clib;
sg_fail_attachments :: (atts: sg_attachments) -> void #foreign sokol_gfx_clib;
// frame stats
sg_enable_frame_stats :: () -> void #foreign sokol_gfx_clib;
sg_disable_frame_stats :: () -> void #foreign sokol_gfx_clib;
sg_frame_stats_enabled :: () -> bool #foreign sokol_gfx_clib;
sg_query_frame_stats :: () -> sg_frame_stats #foreign sokol_gfx_clib;
// D3D11: return ID3D11Device
sg_d3d11_device :: () -> *void #foreign sokol_gfx_clib;
// D3D11: return ID3D11DeviceContext
sg_d3d11_device_context :: () -> *void #foreign sokol_gfx_clib;
// D3D11: get internal buffer resource objects
sg_d3d11_query_buffer_info :: (buf: sg_buffer) -> sg_d3d11_buffer_info #foreign sokol_gfx_clib;
// D3D11: get internal image resource objects
sg_d3d11_query_image_info :: (img: sg_image) -> sg_d3d11_image_info #foreign sokol_gfx_clib;
// D3D11: get internal sampler resource objects
sg_d3d11_query_sampler_info :: (smp: sg_sampler) -> sg_d3d11_sampler_info #foreign sokol_gfx_clib;
// D3D11: get internal shader resource objects
sg_d3d11_query_shader_info :: (shd: sg_shader) -> sg_d3d11_shader_info #foreign sokol_gfx_clib;
// D3D11: get internal pipeline resource objects
sg_d3d11_query_pipeline_info :: (pip: sg_pipeline) -> sg_d3d11_pipeline_info #foreign sokol_gfx_clib;
// D3D11: get internal pass resource objects
sg_d3d11_query_attachments_info :: (atts: sg_attachments) -> sg_d3d11_attachments_info #foreign sokol_gfx_clib;
// Metal: return __bridge-casted MTLDevice
sg_mtl_device :: () -> *void #foreign sokol_gfx_clib;
// Metal: return __bridge-casted MTLRenderCommandEncoder when inside render pass (otherwise zero)
sg_mtl_render_command_encoder :: () -> *void #foreign sokol_gfx_clib;
// Metal: return __bridge-casted MTLComputeCommandEncoder when inside compute pass (otherwise zero)
sg_mtl_compute_command_encoder :: () -> *void #foreign sokol_gfx_clib;
// Metal: get internal __bridge-casted buffer resource objects
sg_mtl_query_buffer_info :: (buf: sg_buffer) -> sg_mtl_buffer_info #foreign sokol_gfx_clib;
// Metal: get internal __bridge-casted image resource objects
sg_mtl_query_image_info :: (img: sg_image) -> sg_mtl_image_info #foreign sokol_gfx_clib;
// Metal: get internal __bridge-casted sampler resource objects
sg_mtl_query_sampler_info :: (smp: sg_sampler) -> sg_mtl_sampler_info #foreign sokol_gfx_clib;
// Metal: get internal __bridge-casted shader resource objects
sg_mtl_query_shader_info :: (shd: sg_shader) -> sg_mtl_shader_info #foreign sokol_gfx_clib;
// Metal: get internal __bridge-casted pipeline resource objects
sg_mtl_query_pipeline_info :: (pip: sg_pipeline) -> sg_mtl_pipeline_info #foreign sokol_gfx_clib;
// WebGPU: return WGPUDevice object
sg_wgpu_device :: () -> *void #foreign sokol_gfx_clib;
// WebGPU: return WGPUQueue object
sg_wgpu_queue :: () -> *void #foreign sokol_gfx_clib;
// WebGPU: return this frame's WGPUCommandEncoder
sg_wgpu_command_encoder :: () -> *void #foreign sokol_gfx_clib;
// WebGPU: return WGPURenderPassEncoder of current pass (returns 0 when outside pass or in a compute pass)
sg_wgpu_render_pass_encoder :: () -> *void #foreign sokol_gfx_clib;
// WebGPU: return WGPUComputePassEncoder of current pass (returns 0 when outside pass or in a render pass)
sg_wgpu_compute_pass_encoder :: () -> *void #foreign sokol_gfx_clib;
// WebGPU: get internal buffer resource objects
sg_wgpu_query_buffer_info :: (buf: sg_buffer) -> sg_wgpu_buffer_info #foreign sokol_gfx_clib;
// WebGPU: get internal image resource objects
sg_wgpu_query_image_info :: (img: sg_image) -> sg_wgpu_image_info #foreign sokol_gfx_clib;
// WebGPU: get internal sampler resource objects
sg_wgpu_query_sampler_info :: (smp: sg_sampler) -> sg_wgpu_sampler_info #foreign sokol_gfx_clib;
// WebGPU: get internal shader resource objects
sg_wgpu_query_shader_info :: (shd: sg_shader) -> sg_wgpu_shader_info #foreign sokol_gfx_clib;
// WebGPU: get internal pipeline resource objects
sg_wgpu_query_pipeline_info :: (pip: sg_pipeline) -> sg_wgpu_pipeline_info #foreign sokol_gfx_clib;
// WebGPU: get internal pass resource objects
sg_wgpu_query_attachments_info :: (atts: sg_attachments) -> sg_wgpu_attachments_info #foreign sokol_gfx_clib;
// GL: get internal buffer resource objects
sg_gl_query_buffer_info :: (buf: sg_buffer) -> sg_gl_buffer_info #foreign sokol_gfx_clib;
// GL: get internal image resource objects
sg_gl_query_image_info :: (img: sg_image) -> sg_gl_image_info #foreign sokol_gfx_clib;
// GL: get internal sampler resource objects
sg_gl_query_sampler_info :: (smp: sg_sampler) -> sg_gl_sampler_info #foreign sokol_gfx_clib;
// GL: get internal shader resource objects
sg_gl_query_shader_info :: (shd: sg_shader) -> sg_gl_shader_info #foreign sokol_gfx_clib;
// GL: get internal pass resource objects
sg_gl_query_attachments_info :: (atts: sg_attachments) -> sg_gl_attachments_info #foreign sokol_gfx_clib;

sg_buffer :: struct {
    id : u32;
}

sg_image :: struct {
    id : u32;
}

sg_sampler :: struct {
    id : u32;
}

sg_shader :: struct {
    id : u32;
}

sg_pipeline :: struct {
    id : u32;
}

sg_attachments :: struct {
    id : u32;
}

sg_range :: struct {
    ptr : *void;
    size : u64;
}

INVALID_ID :: 0;
NUM_INFLIGHT_FRAMES :: 2;
MAX_COLOR_ATTACHMENTS :: 4;
MAX_STORAGE_ATTACHMENTS :: 4;
MAX_UNIFORMBLOCK_MEMBERS :: 16;
MAX_VERTEX_ATTRIBUTES :: 16;
MAX_MIPMAPS :: 16;
MAX_TEXTUREARRAY_LAYERS :: 128;
MAX_UNIFORMBLOCK_BINDSLOTS :: 8;
MAX_VERTEXBUFFER_BINDSLOTS :: 8;
MAX_IMAGE_BINDSLOTS :: 16;
MAX_SAMPLER_BINDSLOTS :: 16;
MAX_STORAGEBUFFER_BINDSLOTS :: 8;
MAX_IMAGE_SAMPLER_PAIRS :: 16;

sg_color :: struct {
    r : float;
    g : float;
    b : float;
    a : float;
}

/*
    sg_backend

    The active 3D-API backend, use the function sg_query_backend()
    to get the currently active backend.
*/
sg_backend :: enum u32 {
    GLCORE;
    GLES3;
    D3D11;
    METAL_IOS;
    METAL_MACOS;
    METAL_SIMULATOR;
    WGPU;
    DUMMY;
}

/*
    sg_pixel_format

    sokol_gfx.h basically uses the same pixel formats as WebGPU, since these
    are supported on most newer GPUs.

    A pixelformat name consist of three parts:

        - components (R, RG, RGB or RGBA)
        - bit width per component (8, 16 or 32)
        - component data type:
            - unsigned normalized (no postfix)
            - signed normalized (SN postfix)
            - unsigned integer (UI postfix)
            - signed integer (SI postfix)
            - float (F postfix)

    Not all pixel formats can be used for everything, call sg_query_pixelformat()
    to inspect the capabilities of a given pixelformat. The function returns
    an sg_pixelformat_info struct with the following members:

        - sample: the pixelformat can be sampled as texture at least with
                  nearest filtering
        - filter: the pixelformat can be sampled as texture with linear
                  filtering
        - render: the pixelformat can be used as render-pass attachment
        - blend:  blending is supported when used as render-pass attachment
        - msaa:   multisample-antialiasing is supported when used
                  as render-pass attachment
        - depth:  the pixelformat can be used for depth-stencil attachments
        - compressed: this is a block-compressed format
        - bytes_per_pixel: the numbers of bytes in a pixel (0 for compressed formats)

    The default pixel format for texture images is SG_PIXELFORMAT_RGBA8.

    The default pixel format for render target images is platform-dependent
    and taken from the sg_environment struct passed into sg_setup(). Typically
    the default formats are:

        - for the Metal, D3D11 and WebGPU backends: SG_PIXELFORMAT_BGRA8
        - for GL backends: SG_PIXELFORMAT_RGBA8
*/
sg_pixel_format :: enum u32 {
    DEFAULT;
    NONE;
    R8;
    R8SN;
    R8UI;
    R8SI;
    R16;
    R16SN;
    R16UI;
    R16SI;
    R16F;
    RG8;
    RG8SN;
    RG8UI;
    RG8SI;
    R32UI;
    R32SI;
    R32F;
    RG16;
    RG16SN;
    RG16UI;
    RG16SI;
    RG16F;
    RGBA8;
    SRGB8A8;
    RGBA8SN;
    RGBA8UI;
    RGBA8SI;
    BGRA8;
    RGB10A2;
    RG11B10F;
    RGB9E5;
    RG32UI;
    RG32SI;
    RG32F;
    RGBA16;
    RGBA16SN;
    RGBA16UI;
    RGBA16SI;
    RGBA16F;
    RGBA32UI;
    RGBA32SI;
    RGBA32F;
    DEPTH;
    DEPTH_STENCIL;
    BC1_RGBA;
    BC2_RGBA;
    BC3_RGBA;
    BC3_SRGBA;
    BC4_R;
    BC4_RSN;
    BC5_RG;
    BC5_RGSN;
    BC6H_RGBF;
    BC6H_RGBUF;
    BC7_RGBA;
    BC7_SRGBA;
    ETC2_RGB8;
    ETC2_SRGB8;
    ETC2_RGB8A1;
    ETC2_RGBA8;
    ETC2_SRGB8A8;
    EAC_R11;
    EAC_R11SN;
    EAC_RG11;
    EAC_RG11SN;
    ASTC_4x4_RGBA;
    ASTC_4x4_SRGBA;
}

sg_pixelformat_info :: struct {
    sample : bool;
    filter : bool;
    render : bool;
    blend : bool;
    msaa : bool;
    depth : bool;
    compressed : bool;
    read : bool;
    write : bool;
    bytes_per_pixel : s32;
}

sg_features :: struct {
    origin_top_left : bool;
    image_clamp_to_border : bool;
    mrt_independent_blend_state : bool;
    mrt_independent_write_mask : bool;
    compute : bool;
    msaa_image_bindings : bool;
    separate_buffer_types : bool;
}

sg_limits :: struct {
    max_image_size_2d : s32;
    max_image_size_cube : s32;
    max_image_size_3d : s32;
    max_image_size_array : s32;
    max_image_array_layers : s32;
    max_vertex_attrs : s32;
    gl_max_vertex_uniform_components : s32;
    gl_max_combined_texture_image_units : s32;
}

/*
    sg_resource_state

    The current state of a resource in its resource pool.
    Resources start in the INITIAL state, which means the
    pool slot is unoccupied and can be allocated. When a resource is
    created, first an id is allocated, and the resource pool slot
    is set to state ALLOC. After allocation, the resource is
    initialized, which may result in the VALID or FAILED state. The
    reason why allocation and initialization are separate is because
    some resource types (e.g. buffers and images) might be asynchronously
    initialized by the user application. If a resource which is not
    in the VALID state is attempted to be used for rendering, rendering
    operations will silently be dropped.

    The special INVALID state is returned in sg_query_xxx_state() if no
    resource object exists for the provided resource id.
*/
sg_resource_state :: enum u32 {
    INITIAL;
    ALLOC;
    VALID;
    FAILED;
    INVALID;
}

/*
    sg_index_type

    Indicates whether indexed rendering (fetching vertex-indices from an
    index buffer) is used, and if yes, the index data type (16- or 32-bits).

    This is used in the sg_pipeline_desc.index_type member when creating a
    pipeline object.

    The default index type is SG_INDEXTYPE_NONE.
*/
sg_index_type :: enum u32 {
    DEFAULT;
    NONE;
    UINT16;
    UINT32;
}

/*
    sg_image_type

    Indicates the basic type of an image object (2D-texture, cubemap,
    3D-texture or 2D-array-texture). Used in the sg_image_desc.type member when
    creating an image, and in sg_shader_image_desc to describe a sampled texture
    in the shader (both must match and will be checked in the validation layer
    when calling sg_apply_bindings).

    The default image type when creating an image is SG_IMAGETYPE_2D.
*/
sg_image_type :: enum u32 {
    DEFAULT;
    _2D;
    CUBE;
    _3D;
    ARRAY;
}

/*
    sg_image_sample_type

    The basic data type of a texture sample as expected by a shader.
    Must be provided in sg_shader_image and used by the validation
    layer in sg_apply_bindings() to check if the provided image object
    is compatible with what the shader expects. Apart from the sokol-gfx
    validation layer, WebGPU is the only backend API which actually requires
    matching texture and sampler type to be provided upfront for validation
    (other 3D APIs treat texture/sampler type mismatches as undefined behaviour).

    NOTE that the following texture pixel formats require the use
    of SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT, combined with a sampler
    of type SG_SAMPLERTYPE_NONFILTERING:

    - SG_PIXELFORMAT_R32F
    - SG_PIXELFORMAT_RG32F
    - SG_PIXELFORMAT_RGBA32F

    (when using sokol-shdc, also check out the meta tags `@image_sample_type`
    and `@sampler_type`)
*/
sg_image_sample_type :: enum u32 {
    DEFAULT;
    FLOAT;
    DEPTH;
    SINT;
    UINT;
    UNFILTERABLE_FLOAT;
}

/*
    sg_sampler_type

    The basic type of a texture sampler (sampling vs comparison) as
    defined in a shader. Must be provided in sg_shader_sampler_desc.

    sg_image_sample_type and sg_sampler_type for a texture/sampler
    pair must be compatible with each other, specifically only
    the following pairs are allowed:

    - SG_IMAGESAMPLETYPE_FLOAT => (SG_SAMPLERTYPE_FILTERING or SG_SAMPLERTYPE_NONFILTERING)
    - SG_IMAGESAMPLETYPE_UNFILTERABLE_FLOAT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_SINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_UINT => SG_SAMPLERTYPE_NONFILTERING
    - SG_IMAGESAMPLETYPE_DEPTH => SG_SAMPLERTYPE_COMPARISON
*/
sg_sampler_type :: enum u32 {
    DEFAULT;
    FILTERING;
    NONFILTERING;
    COMPARISON;
}

/*
    sg_cube_face

    The cubemap faces. Use these as indices in the sg_image_desc.content
    array.
*/
sg_cube_face :: enum u32 {
    POS_X;
    NEG_X;
    POS_Y;
    NEG_Y;
    POS_Z;
    NEG_Z;
}

/*
    sg_primitive_type

    This is the common subset of 3D primitive types supported across all 3D
    APIs. This is used in the sg_pipeline_desc.primitive_type member when
    creating a pipeline object.

    The default primitive type is SG_PRIMITIVETYPE_TRIANGLES.
*/
sg_primitive_type :: enum u32 {
    DEFAULT;
    POINTS;
    LINES;
    LINE_STRIP;
    TRIANGLES;
    TRIANGLE_STRIP;
}

/*
    sg_filter

    The filtering mode when sampling a texture image. This is
    used in the sg_sampler_desc.min_filter, sg_sampler_desc.mag_filter
    and sg_sampler_desc.mipmap_filter members when creating a sampler object.

    For the default is SG_FILTER_NEAREST.
*/
sg_filter :: enum u32 {
    DEFAULT;
    NEAREST;
    LINEAR;
}

/*
    sg_wrap

    The texture coordinates wrapping mode when sampling a texture
    image. This is used in the sg_image_desc.wrap_u, .wrap_v
    and .wrap_w members when creating an image.

    The default wrap mode is SG_WRAP_REPEAT.

    NOTE: SG_WRAP_CLAMP_TO_BORDER is not supported on all backends
    and platforms. To check for support, call sg_query_features()
    and check the "clamp_to_border" boolean in the returned
    sg_features struct.

    Platforms which don't support SG_WRAP_CLAMP_TO_BORDER will silently fall back
    to SG_WRAP_CLAMP_TO_EDGE without a validation error.
*/
sg_wrap :: enum u32 {
    DEFAULT;
    REPEAT;
    CLAMP_TO_EDGE;
    CLAMP_TO_BORDER;
    MIRRORED_REPEAT;
}

/*
    sg_border_color

    The border color to use when sampling a texture, and the UV wrap
    mode is SG_WRAP_CLAMP_TO_BORDER.

    The default border color is SG_BORDERCOLOR_OPAQUE_BLACK
*/
sg_border_color :: enum u32 {
    DEFAULT;
    TRANSPARENT_BLACK;
    OPAQUE_BLACK;
    OPAQUE_WHITE;
}

/*
    sg_vertex_format

    The data type of a vertex component. This is used to describe
    the layout of input vertex data when creating a pipeline object.

    NOTE that specific mapping rules exist from the CPU-side vertex
    formats to the vertex attribute base type in the vertex shader code
    (see doc header section 'ON VERTEX FORMATS').
*/
sg_vertex_format :: enum u32 {
    INVALID;
    FLOAT;
    FLOAT2;
    FLOAT3;
    FLOAT4;
    INT;
    INT2;
    INT3;
    INT4;
    UINT;
    UINT2;
    UINT3;
    UINT4;
    BYTE4;
    BYTE4N;
    UBYTE4;
    UBYTE4N;
    SHORT2;
    SHORT2N;
    USHORT2;
    USHORT2N;
    SHORT4;
    SHORT4N;
    USHORT4;
    USHORT4N;
    UINT10_N2;
    HALF2;
    HALF4;
}

/*
    sg_vertex_step

    Defines whether the input pointer of a vertex input stream is advanced
    'per vertex' or 'per instance'. The default step-func is
    SG_VERTEXSTEP_PER_VERTEX. SG_VERTEXSTEP_PER_INSTANCE is used with
    instanced-rendering.

    The vertex-step is part of the vertex-layout definition
    when creating pipeline objects.
*/
sg_vertex_step :: enum u32 {
    DEFAULT;
    PER_VERTEX;
    PER_INSTANCE;
}

/*
    sg_uniform_type

    The data type of a uniform block member. This is used to
    describe the internal layout of uniform blocks when creating
    a shader object. This is only required for the GL backend, all
    other backends will ignore the interior layout of uniform blocks.
*/
sg_uniform_type :: enum u32 {
    INVALID;
    FLOAT;
    FLOAT2;
    FLOAT3;
    FLOAT4;
    INT;
    INT2;
    INT3;
    INT4;
    MAT4;
}

/*
    sg_uniform_layout

    A hint for the interior memory layout of uniform blocks. This is
    only relevant for the GL backend where the internal layout
    of uniform blocks must be known to sokol-gfx. For all other backends the
    internal memory layout of uniform blocks doesn't matter, sokol-gfx
    will just pass uniform data as an opaque memory blob to the
    3D backend.

    SG_UNIFORMLAYOUT_NATIVE (default)
        Native layout means that a 'backend-native' memory layout
        is used. For the GL backend this means that uniforms
        are packed tightly in memory (e.g. there are no padding
        bytes).

    SG_UNIFORMLAYOUT_STD140
        The memory layout is a subset of std140. Arrays are only
        allowed for the FLOAT4, INT4 and MAT4. Alignment is as
        is as follows:

            FLOAT, INT:         4 byte alignment
            FLOAT2, INT2:       8 byte alignment
            FLOAT3, INT3:       16 byte alignment(!)
            FLOAT4, INT4:       16 byte alignment
            MAT4:               16 byte alignment
            FLOAT4[], INT4[]:   16 byte alignment

        The overall size of the uniform block must be a multiple
        of 16.

    For more information search for 'UNIFORM DATA LAYOUT' in the documentation block
    at the start of the header.
*/
sg_uniform_layout :: enum u32 {
    DEFAULT;
    NATIVE;
    STD140;
}

/*
    sg_cull_mode

    The face-culling mode, this is used in the
    sg_pipeline_desc.cull_mode member when creating a
    pipeline object.

    The default cull mode is SG_CULLMODE_NONE
*/
sg_cull_mode :: enum u32 {
    DEFAULT;
    NONE;
    FRONT;
    BACK;
}

/*
    sg_face_winding

    The vertex-winding rule that determines a front-facing primitive. This
    is used in the member sg_pipeline_desc.face_winding
    when creating a pipeline object.

    The default winding is SG_FACEWINDING_CW (clockwise)
*/
sg_face_winding :: enum u32 {
    DEFAULT;
    CCW;
    CW;
}

/*
    sg_compare_func

    The compare-function for configuring depth- and stencil-ref tests
    in pipeline objects, and for texture samplers which perform a comparison
    instead of regular sampling operation.

    Used in the following structs:

    sg_pipeline_desc
        .depth
            .compare
        .stencil
            .front.compare
            .back.compare

    sg_sampler_desc
        .compare

    The default compare func for depth- and stencil-tests is
    SG_COMPAREFUNC_ALWAYS.

    The default compare func for samplers is SG_COMPAREFUNC_NEVER.
*/
sg_compare_func :: enum u32 {
    DEFAULT;
    NEVER;
    LESS;
    EQUAL;
    LESS_EQUAL;
    GREATER;
    NOT_EQUAL;
    GREATER_EQUAL;
    ALWAYS;
}

/*
    sg_stencil_op

    The operation performed on a currently stored stencil-value when a
    comparison test passes or fails. This is used when creating a pipeline
    object in the following sg_pipeline_desc struct items:

    sg_pipeline_desc
        .stencil
            .front
                .fail_op
                .depth_fail_op
                .pass_op
            .back
                .fail_op
                .depth_fail_op
                .pass_op

    The default value is SG_STENCILOP_KEEP.
*/
sg_stencil_op :: enum u32 {
    DEFAULT;
    KEEP;
    ZERO;
    REPLACE;
    INCR_CLAMP;
    DECR_CLAMP;
    INVERT;
    INCR_WRAP;
    DECR_WRAP;
}

/*
    sg_blend_factor

    The source and destination factors in blending operations.
    This is used in the following members when creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .src_factor_rgb
                .dst_factor_rgb
                .src_factor_alpha
                .dst_factor_alpha

    The default value is SG_BLENDFACTOR_ONE for source
    factors, and for the destination SG_BLENDFACTOR_ZERO if the associated
    blend-op is ADD, SUBTRACT or REVERSE_SUBTRACT or SG_BLENDFACTOR_ONE
    if the associated blend-op is MIN or MAX.
*/
sg_blend_factor :: enum u32 {
    DEFAULT;
    ZERO;
    ONE;
    SRC_COLOR;
    ONE_MINUS_SRC_COLOR;
    SRC_ALPHA;
    ONE_MINUS_SRC_ALPHA;
    DST_COLOR;
    ONE_MINUS_DST_COLOR;
    DST_ALPHA;
    ONE_MINUS_DST_ALPHA;
    SRC_ALPHA_SATURATED;
    BLEND_COLOR;
    ONE_MINUS_BLEND_COLOR;
    BLEND_ALPHA;
    ONE_MINUS_BLEND_ALPHA;
}

/*
    sg_blend_op

    Describes how the source and destination values are combined in the
    fragment blending operation. It is used in the following struct items
    when creating a pipeline object:

    sg_pipeline_desc
        .colors[i]
            .blend
                .op_rgb
                .op_alpha

    The default value is SG_BLENDOP_ADD.
*/
sg_blend_op :: enum u32 {
    DEFAULT;
    ADD;
    SUBTRACT;
    REVERSE_SUBTRACT;
    MIN;
    MAX;
}

/*
    sg_color_mask

    Selects the active color channels when writing a fragment color to the
    framebuffer. This is used in the members
    sg_pipeline_desc.colors[i].write_mask when creating a pipeline object.

    The default colormask is SG_COLORMASK_RGBA (write all colors channels)

    NOTE: since the color mask value 0 is reserved for the default value
    (SG_COLORMASK_RGBA), use SG_COLORMASK_NONE if all color channels
    should be disabled.
*/
sg_color_mask :: enum u32 {
    DEFAULT :: 0;
    NONE :: 16;
    R :: 1;
    G :: 2;
    RG :: 3;
    B :: 4;
    RB :: 5;
    GB :: 6;
    RGB :: 7;
    A :: 8;
    RA :: 9;
    GA :: 10;
    RGA :: 11;
    BA :: 12;
    RBA :: 13;
    GBA :: 14;
    RGBA :: 15;
}

/*
    sg_load_action

    Defines the load action that should be performed at the start of a render pass:

    SG_LOADACTION_CLEAR:        clear the render target
    SG_LOADACTION_LOAD:         load the previous content of the render target
    SG_LOADACTION_DONTCARE:     leave the render target in an undefined state

    This is used in the sg_pass_action structure.

    The default load action for all pass attachments is SG_LOADACTION_CLEAR,
    with the values rgba = { 0.5f, 0.5f, 0.5f, 1.0f }, depth=1.0f and stencil=0.

    If you want to override the default behaviour, it is important to not
    only set the clear color, but the 'action' field as well (as long as this
    is _SG_LOADACTION_DEFAULT, the value fields will be ignored).
*/
sg_load_action :: enum u32 {
    DEFAULT;
    CLEAR;
    LOAD;
    DONTCARE;
}

/*
    sg_store_action

    Defines the store action that should be performed at the end of a render pass:

    SG_STOREACTION_STORE:       store the rendered content to the color attachment image
    SG_STOREACTION_DONTCARE:    allows the GPU to discard the rendered content
*/
sg_store_action :: enum u32 {
    DEFAULT;
    STORE;
    DONTCARE;
}

sg_color_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : sg_color;
}

sg_depth_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : float;
}

sg_stencil_attachment_action :: struct {
    load_action : sg_load_action;
    store_action : sg_store_action;
    clear_value : u8;
}

sg_pass_action :: struct {
    colors : [4]sg_color_attachment_action;
    depth : sg_depth_attachment_action;
    stencil : sg_stencil_attachment_action;
}

sg_metal_swapchain :: struct {
    current_drawable : *void;
    depth_stencil_texture : *void;
    msaa_color_texture : *void;
}

sg_d3d11_swapchain :: struct {
    render_view : *void;
    resolve_view : *void;
    depth_stencil_view : *void;
}

sg_wgpu_swapchain :: struct {
    render_view : *void;
    resolve_view : *void;
    depth_stencil_view : *void;
}

sg_gl_swapchain :: struct {
    framebuffer : u32;
}

sg_swapchain :: struct {
    width : s32;
    height : s32;
    sample_count : s32;
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    metal : sg_metal_swapchain;
    d3d11 : sg_d3d11_swapchain;
    wgpu : sg_wgpu_swapchain;
    gl : sg_gl_swapchain;
}

sg_pass :: struct {
    _ : u32;
    compute : bool;
    action : sg_pass_action;
    attachments : sg_attachments;
    swapchain : sg_swapchain;
    label : *u8;
    _ : u32;
}

sg_bindings :: struct {
    _ : u32;
    vertex_buffers : [8]sg_buffer;
    vertex_buffer_offsets : [8]s32;
    index_buffer : sg_buffer;
    index_buffer_offset : s32;
    images : [16]sg_image;
    samplers : [16]sg_sampler;
    storage_buffers : [8]sg_buffer;
    _ : u32;
}

sg_buffer_usage :: struct {
    vertex_buffer : bool;
    index_buffer : bool;
    storage_buffer : bool;
    immutable : bool;
    dynamic_update : bool;
    stream_update : bool;
}

sg_buffer_desc :: struct {
    _ : u32;
    size : u64;
    usage : sg_buffer_usage;
    data : sg_range;
    label : *u8;
    gl_buffers : [2]u32;
    mtl_buffers : [2]*void;
    d3d11_buffer : *void;
    wgpu_buffer : *void;
    _ : u32;
}

sg_image_usage :: struct {
    render_attachment : bool;
    storage_attachment : bool;
    immutable : bool;
    dynamic_update : bool;
    stream_update : bool;
}

sg_image_data :: struct {
    subimage : [6][16]sg_range;
}

sg_image_desc :: struct {
    _ : u32;
    type : sg_image_type;
    usage : sg_image_usage;
    width : s32;
    height : s32;
    num_slices : s32;
    num_mipmaps : s32;
    pixel_format : sg_pixel_format;
    sample_count : s32;
    data : sg_image_data;
    label : *u8;
    gl_textures : [2]u32;
    gl_texture_target : u32;
    mtl_textures : [2]*void;
    d3d11_texture : *void;
    d3d11_shader_resource_view : *void;
    wgpu_texture : *void;
    wgpu_texture_view : *void;
    _ : u32;
}

sg_sampler_desc :: struct {
    _ : u32;
    min_filter : sg_filter;
    mag_filter : sg_filter;
    mipmap_filter : sg_filter;
    wrap_u : sg_wrap;
    wrap_v : sg_wrap;
    wrap_w : sg_wrap;
    min_lod : float;
    max_lod : float;
    border_color : sg_border_color;
    compare : sg_compare_func;
    max_anisotropy : u32;
    label : *u8;
    gl_sampler : u32;
    mtl_sampler : *void;
    d3d11_sampler : *void;
    wgpu_sampler : *void;
    _ : u32;
}

/*
    sg_shader_desc

    Used as parameter of sg_make_shader() to create a shader object which
    communicates shader source or bytecode and shader interface
    reflection information to sokol-gfx.

    If you use sokol-shdc you can ignore the following information since
    the sg_shader_desc struct will be code generated.

    Otherwise you need to provide the following information to the
    sg_make_shader() call:

    - a vertex- and fragment-shader function:
        - the shader source or bytecode
        - an optional entry point name
        - for D3D11: an optional compile target when source code is provided
          (the defaults are "vs_4_0" and "ps_4_0")

    - ...or alternatively, a compute function:
        - the shader source or bytecode
        - an optional entry point name
        - for D3D11: an optional compile target when source code is provided
          (the default is "cs_5_0")

    - vertex attributes required by some backends (not for compute shaders):
        - the vertex attribute base type (undefined, float, signed int, unsigned int),
          this information is only used in the validation layer to check that the
          pipeline object vertex formats are compatible with the input vertex attribute
          type used in the vertex shader. NOTE that the default base type
          'undefined' skips the validation layer check.
        - for the GL backend: optional vertex attribute names used for name lookup
        - for the D3D11 backend: semantic names and indices

    - only for compute shaders on the Metal backend:
        - the workgroup size aka 'threads per thread-group'

          In other 3D APIs this is declared in the shader code:
            - GLSL: `layout(local_size_x=x, local_size_y=y, local_size_y=z) in;`
            - HLSL: `[numthreads(x, y, z)]`
            - WGSL: `@workgroup_size(x, y, z)`
          ...but in Metal the workgroup size is declared on the CPU side

    - reflection information for each uniform block used by the shader:
        - the shader stage the uniform block appears in (SG_SHADERSTAGE_*)
        - the size in bytes of the uniform block
        - backend-specific bindslots:
            - HLSL: the constant buffer register `register(b0..7)`
            - MSL: the buffer attribute `[[buffer(0..7)]]`
            - WGSL: the binding in `@group(0) @binding(0..15)`
        - GLSL only: a description of the uniform block interior
            - the memory layout standard (SG_UNIFORMLAYOUT_*)
            - for each member in the uniform block:
                - the member type (SG_UNIFORM_*)
                - if the member is an array, the array count
                - the member name

    - reflection information for each texture used by the shader:
        - the shader stage the texture appears in (SG_SHADERSTAGE_*)
        - the image type (SG_IMAGETYPE_*)
        - the image-sample type (SG_IMAGESAMPLETYPE_*)
        - whether the texture is multisampled
        - backend specific bindslots:
            - HLSL: the texture register `register(t0..23)`
            - MSL: the texture attribute `[[texture(0..15)]]`
            - WGSL: the binding in `@group(1) @binding(0..127)`

    - reflection information for each sampler used by the shader:
        - the shader stage the sampler appears in (SG_SHADERSTAGE_*)
        - the sampler type (SG_SAMPLERTYPE_*)
        - backend specific bindslots:
            - HLSL: the sampler register `register(s0..15)`
            - MSL: the sampler attribute `[[sampler(0..15)]]`
            - WGSL: the binding in `@group(0) @binding(0..127)`

    - reflection information for each storage buffer used by the shader:
        - the shader stage the storage buffer appears in (SG_SHADERSTAGE_*)
        - whether the storage buffer is readonly (currently this must
          always be true)
        - backend specific bindslots:
            - HLSL:
                - for readonly storage buffer bindings: `register(t0..23)`
                - for read/write storage buffer bindings: `register(u0..7)`
            - MSL: the buffer attribute `[[buffer(8..15)]]`
            - WGSL: the binding in `@group(1) @binding(0..127)`
            - GL: the binding in `layout(binding=0..7)`

    - reflection information for each combined image-sampler object
      used by the shader:
        - the shader stage (SG_SHADERSTAGE_*)
        - the texture's array index in the sg_shader_desc.images[] array
        - the sampler's array index in the sg_shader_desc.samplers[] array
        - GLSL only: the name of the combined image-sampler object

    The number and order of items in the sg_shader_desc.attrs[]
    array corresponds to the items in sg_pipeline_desc.layout.attrs.

        - sg_shader_desc.attrs[N] => sg_pipeline_desc.layout.attrs[N]

    NOTE that vertex attribute indices currently cannot have gaps.

    The items index in the sg_shader_desc.uniform_blocks[] array corresponds
    to the ub_slot arg in sg_apply_uniforms():

        - sg_shader_desc.uniform_blocks[N] => sg_apply_uniforms(N, ...)

    The items in the shader_desc images, samplers and storage_buffers
    arrays correspond to the same array items in the sg_bindings struct:

        - sg_shader_desc.images[N] => sg_bindings.images[N]
        - sg_shader_desc.samplers[N] => sg_bindings.samplers[N]
        - sg_shader_desc.storage_buffers[N] => sg_bindings.storage_buffers[N]

    For all GL backends, shader source-code must be provided. For D3D11 and Metal,
    either shader source-code or byte-code can be provided.

    NOTE that the uniform block, image, sampler and storage_buffer arrays
    can have gaps. This allows to use the same sg_bindings struct for
    different related shader variants.

    For D3D11, if source code is provided, the d3dcompiler_47.dll will be loaded
    on demand. If this fails, shader creation will fail. When compiling HLSL
    source code, you can provide an optional target string via
    sg_shader_stage_desc.d3d11_target, the default target is "vs_4_0" for the
    vertex shader stage and "ps_4_0" for the pixel shader stage.
*/
sg_shader_stage :: enum u32 {
    NONE;
    VERTEX;
    FRAGMENT;
    COMPUTE;
}

sg_shader_function :: struct {
    source : *u8;
    bytecode : sg_range;
    entry : *u8;
    d3d11_target : *u8;
}

sg_shader_attr_base_type :: enum u32 {
    UNDEFINED;
    FLOAT;
    SINT;
    UINT;
}

sg_shader_vertex_attr :: struct {
    base_type : sg_shader_attr_base_type;
    glsl_name : *u8;
    hlsl_sem_name : *u8;
    hlsl_sem_index : u8;
}

sg_glsl_shader_uniform :: struct {
    type : sg_uniform_type;
    array_count : u16;
    glsl_name : *u8;
}

sg_shader_uniform_block :: struct {
    stage : sg_shader_stage;
    size : u32;
    hlsl_register_b_n : u8;
    msl_buffer_n : u8;
    wgsl_group0_binding_n : u8;
    layout : sg_uniform_layout;
    glsl_uniforms : [16]sg_glsl_shader_uniform;
}

sg_shader_image :: struct {
    stage : sg_shader_stage;
    image_type : sg_image_type;
    sample_type : sg_image_sample_type;
    multisampled : bool;
    hlsl_register_t_n : u8;
    msl_texture_n : u8;
    wgsl_group1_binding_n : u8;
}

sg_shader_sampler :: struct {
    stage : sg_shader_stage;
    sampler_type : sg_sampler_type;
    hlsl_register_s_n : u8;
    msl_sampler_n : u8;
    wgsl_group1_binding_n : u8;
}

sg_shader_storage_buffer :: struct {
    stage : sg_shader_stage;
    readonly : bool;
    hlsl_register_t_n : u8;
    hlsl_register_u_n : u8;
    msl_buffer_n : u8;
    wgsl_group1_binding_n : u8;
    glsl_binding_n : u8;
}

sg_shader_storage_image :: struct {
    stage : sg_shader_stage;
    image_type : sg_image_type;
    access_format : sg_pixel_format;
    writeonly : bool;
    hlsl_register_u_n : u8;
    msl_texture_n : u8;
    wgsl_group2_binding_n : u8;
    glsl_binding_n : u8;
}

sg_shader_image_sampler_pair :: struct {
    stage : sg_shader_stage;
    image_slot : u8;
    sampler_slot : u8;
    glsl_name : *u8;
}

sg_mtl_shader_threads_per_threadgroup :: struct {
    x : s32;
    y : s32;
    z : s32;
}

sg_shader_desc :: struct {
    _ : u32;
    vertex_func : sg_shader_function;
    fragment_func : sg_shader_function;
    compute_func : sg_shader_function;
    attrs : [16]sg_shader_vertex_attr;
    uniform_blocks : [8]sg_shader_uniform_block;
    storage_buffers : [8]sg_shader_storage_buffer;
    images : [16]sg_shader_image;
    samplers : [16]sg_shader_sampler;
    image_sampler_pairs : [16]sg_shader_image_sampler_pair;
    storage_images : [4]sg_shader_storage_image;
    mtl_threads_per_threadgroup : sg_mtl_shader_threads_per_threadgroup;
    label : *u8;
    _ : u32;
}

sg_vertex_buffer_layout_state :: struct {
    stride : s32;
    step_func : sg_vertex_step;
    step_rate : s32;
}

sg_vertex_attr_state :: struct {
    buffer_index : s32;
    offset : s32;
    format : sg_vertex_format;
}

sg_vertex_layout_state :: struct {
    buffers : [8]sg_vertex_buffer_layout_state;
    attrs : [16]sg_vertex_attr_state;
}

sg_stencil_face_state :: struct {
    compare : sg_compare_func;
    fail_op : sg_stencil_op;
    depth_fail_op : sg_stencil_op;
    pass_op : sg_stencil_op;
}

sg_stencil_state :: struct {
    enabled : bool;
    front : sg_stencil_face_state;
    back : sg_stencil_face_state;
    read_mask : u8;
    write_mask : u8;
    ref : u8;
}

sg_depth_state :: struct {
    pixel_format : sg_pixel_format;
    compare : sg_compare_func;
    write_enabled : bool;
    bias : float;
    bias_slope_scale : float;
    bias_clamp : float;
}

sg_blend_state :: struct {
    enabled : bool;
    src_factor_rgb : sg_blend_factor;
    dst_factor_rgb : sg_blend_factor;
    op_rgb : sg_blend_op;
    src_factor_alpha : sg_blend_factor;
    dst_factor_alpha : sg_blend_factor;
    op_alpha : sg_blend_op;
}

sg_color_target_state :: struct {
    pixel_format : sg_pixel_format;
    write_mask : sg_color_mask;
    blend : sg_blend_state;
}

sg_pipeline_desc :: struct {
    _ : u32;
    compute : bool;
    shader : sg_shader;
    layout : sg_vertex_layout_state;
    depth : sg_depth_state;
    stencil : sg_stencil_state;
    color_count : s32;
    colors : [4]sg_color_target_state;
    primitive_type : sg_primitive_type;
    index_type : sg_index_type;
    cull_mode : sg_cull_mode;
    face_winding : sg_face_winding;
    sample_count : s32;
    blend_color : sg_color;
    alpha_to_coverage_enabled : bool;
    label : *u8;
    _ : u32;
}

sg_attachment_desc :: struct {
    image : sg_image;
    mip_level : s32;
    slice : s32;
}

sg_attachments_desc :: struct {
    _ : u32;
    colors : [4]sg_attachment_desc;
    resolves : [4]sg_attachment_desc;
    depth_stencil : sg_attachment_desc;
    storages : [4]sg_attachment_desc;
    label : *u8;
    _ : u32;
}

sg_trace_hooks :: struct {
    user_data : *void;
    reset_state_cache : (a0: *void) #c_call;
    make_buffer : (a0: *sg_buffer_desc, a1: sg_buffer, a2: *void) #c_call;
    make_image : (a0: *sg_image_desc, a1: sg_image, a2: *void) #c_call;
    make_sampler : (a0: *sg_sampler_desc, a1: sg_sampler, a2: *void) #c_call;
    make_shader : (a0: *sg_shader_desc, a1: sg_shader, a2: *void) #c_call;
    make_pipeline : (a0: *sg_pipeline_desc, a1: sg_pipeline, a2: *void) #c_call;
    make_attachments : (a0: *sg_attachments_desc, a1: sg_attachments, a2: *void) #c_call;
    destroy_buffer : (a0: sg_buffer, a1: *void) #c_call;
    destroy_image : (a0: sg_image, a1: *void) #c_call;
    destroy_sampler : (a0: sg_sampler, a1: *void) #c_call;
    destroy_shader : (a0: sg_shader, a1: *void) #c_call;
    destroy_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    destroy_attachments : (a0: sg_attachments, a1: *void) #c_call;
    update_buffer : (a0: sg_buffer, a1: *sg_range, a2: *void) #c_call;
    update_image : (a0: sg_image, a1: *sg_image_data, a2: *void) #c_call;
    append_buffer : (a0: sg_buffer, a1: *sg_range, a2: s32, a3: *void) #c_call;
    begin_pass : (a0: *sg_pass, a1: *void) #c_call;
    apply_viewport : (a0: s32, a1: s32, a2: s32, a3: s32, a4: bool, a5: *void) #c_call;
    apply_scissor_rect : (a0: s32, a1: s32, a2: s32, a3: s32, a4: bool, a5: *void) #c_call;
    apply_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    apply_bindings : (a0: *sg_bindings, a1: *void) #c_call;
    apply_uniforms : (a0: s32, a1: *sg_range, a2: *void) #c_call;
    draw : (a0: s32, a1: s32, a2: s32, a3: *void) #c_call;
    dispatch : (a0: s32, a1: s32, a2: s32, a3: *void) #c_call;
    end_pass : (a0: *void) #c_call;
    commit : (a0: *void) #c_call;
    alloc_buffer : (a0: sg_buffer, a1: *void) #c_call;
    alloc_image : (a0: sg_image, a1: *void) #c_call;
    alloc_sampler : (a0: sg_sampler, a1: *void) #c_call;
    alloc_shader : (a0: sg_shader, a1: *void) #c_call;
    alloc_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    alloc_attachments : (a0: sg_attachments, a1: *void) #c_call;
    dealloc_buffer : (a0: sg_buffer, a1: *void) #c_call;
    dealloc_image : (a0: sg_image, a1: *void) #c_call;
    dealloc_sampler : (a0: sg_sampler, a1: *void) #c_call;
    dealloc_shader : (a0: sg_shader, a1: *void) #c_call;
    dealloc_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    dealloc_attachments : (a0: sg_attachments, a1: *void) #c_call;
    init_buffer : (a0: sg_buffer, a1: *sg_buffer_desc, a2: *void) #c_call;
    init_image : (a0: sg_image, a1: *sg_image_desc, a2: *void) #c_call;
    init_sampler : (a0: sg_sampler, a1: *sg_sampler_desc, a2: *void) #c_call;
    init_shader : (a0: sg_shader, a1: *sg_shader_desc, a2: *void) #c_call;
    init_pipeline : (a0: sg_pipeline, a1: *sg_pipeline_desc, a2: *void) #c_call;
    init_attachments : (a0: sg_attachments, a1: *sg_attachments_desc, a2: *void) #c_call;
    uninit_buffer : (a0: sg_buffer, a1: *void) #c_call;
    uninit_image : (a0: sg_image, a1: *void) #c_call;
    uninit_sampler : (a0: sg_sampler, a1: *void) #c_call;
    uninit_shader : (a0: sg_shader, a1: *void) #c_call;
    uninit_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    uninit_attachments : (a0: sg_attachments, a1: *void) #c_call;
    fail_buffer : (a0: sg_buffer, a1: *void) #c_call;
    fail_image : (a0: sg_image, a1: *void) #c_call;
    fail_sampler : (a0: sg_sampler, a1: *void) #c_call;
    fail_shader : (a0: sg_shader, a1: *void) #c_call;
    fail_pipeline : (a0: sg_pipeline, a1: *void) #c_call;
    fail_attachments : (a0: sg_attachments, a1: *void) #c_call;
    push_debug_group : (a0: *u8, a1: *void) #c_call;
    pop_debug_group : (a0: *void) #c_call;
}

sg_slot_info :: struct {
    state : sg_resource_state;
    res_id : u32;
}

sg_buffer_info :: struct {
    slot : sg_slot_info;
    update_frame_index : u32;
    append_frame_index : u32;
    append_pos : s32;
    append_overflow : bool;
    num_slots : s32;
    active_slot : s32;
}

sg_image_info :: struct {
    slot : sg_slot_info;
    upd_frame_index : u32;
    num_slots : s32;
    active_slot : s32;
}

sg_sampler_info :: struct {
    slot : sg_slot_info;
}

sg_shader_info :: struct {
    slot : sg_slot_info;
}

sg_pipeline_info :: struct {
    slot : sg_slot_info;
}

sg_attachments_info :: struct {
    slot : sg_slot_info;
}

sg_frame_stats_gl :: struct {
    num_bind_buffer : u32;
    num_active_texture : u32;
    num_bind_texture : u32;
    num_bind_sampler : u32;
    num_use_program : u32;
    num_render_state : u32;
    num_vertex_attrib_pointer : u32;
    num_vertex_attrib_divisor : u32;
    num_enable_vertex_attrib_array : u32;
    num_disable_vertex_attrib_array : u32;
    num_uniform : u32;
    num_memory_barriers : u32;
}

sg_frame_stats_d3d11_pass :: struct {
    num_om_set_render_targets : u32;
    num_clear_render_target_view : u32;
    num_clear_depth_stencil_view : u32;
    num_resolve_subresource : u32;
}

sg_frame_stats_d3d11_pipeline :: struct {
    num_rs_set_state : u32;
    num_om_set_depth_stencil_state : u32;
    num_om_set_blend_state : u32;
    num_ia_set_primitive_topology : u32;
    num_ia_set_input_layout : u32;
    num_vs_set_shader : u32;
    num_vs_set_constant_buffers : u32;
    num_ps_set_shader : u32;
    num_ps_set_constant_buffers : u32;
    num_cs_set_shader : u32;
    num_cs_set_constant_buffers : u32;
}

sg_frame_stats_d3d11_bindings :: struct {
    num_ia_set_vertex_buffers : u32;
    num_ia_set_index_buffer : u32;
    num_vs_set_shader_resources : u32;
    num_vs_set_samplers : u32;
    num_ps_set_shader_resources : u32;
    num_ps_set_samplers : u32;
    num_cs_set_shader_resources : u32;
    num_cs_set_samplers : u32;
    num_cs_set_unordered_access_views : u32;
}

sg_frame_stats_d3d11_uniforms :: struct {
    num_update_subresource : u32;
}

sg_frame_stats_d3d11_draw :: struct {
    num_draw_indexed_instanced : u32;
    num_draw_indexed : u32;
    num_draw_instanced : u32;
    num_draw : u32;
}

sg_frame_stats_d3d11 :: struct {
    pass : sg_frame_stats_d3d11_pass;
    pipeline : sg_frame_stats_d3d11_pipeline;
    bindings : sg_frame_stats_d3d11_bindings;
    uniforms : sg_frame_stats_d3d11_uniforms;
    draw : sg_frame_stats_d3d11_draw;
    num_map : u32;
    num_unmap : u32;
}

sg_frame_stats_metal_idpool :: struct {
    num_added : u32;
    num_released : u32;
    num_garbage_collected : u32;
}

sg_frame_stats_metal_pipeline :: struct {
    num_set_blend_color : u32;
    num_set_cull_mode : u32;
    num_set_front_facing_winding : u32;
    num_set_stencil_reference_value : u32;
    num_set_depth_bias : u32;
    num_set_render_pipeline_state : u32;
    num_set_depth_stencil_state : u32;
}

sg_frame_stats_metal_bindings :: struct {
    num_set_vertex_buffer : u32;
    num_set_vertex_texture : u32;
    num_set_vertex_sampler_state : u32;
    num_set_fragment_buffer : u32;
    num_set_fragment_texture : u32;
    num_set_fragment_sampler_state : u32;
    num_set_compute_buffer : u32;
    num_set_compute_texture : u32;
    num_set_compute_sampler_state : u32;
}

sg_frame_stats_metal_uniforms :: struct {
    num_set_vertex_buffer_offset : u32;
    num_set_fragment_buffer_offset : u32;
    num_set_compute_buffer_offset : u32;
}

sg_frame_stats_metal :: struct {
    idpool : sg_frame_stats_metal_idpool;
    pipeline : sg_frame_stats_metal_pipeline;
    bindings : sg_frame_stats_metal_bindings;
    uniforms : sg_frame_stats_metal_uniforms;
}

sg_frame_stats_wgpu_uniforms :: struct {
    num_set_bindgroup : u32;
    size_write_buffer : u32;
}

sg_frame_stats_wgpu_bindings :: struct {
    num_set_vertex_buffer : u32;
    num_skip_redundant_vertex_buffer : u32;
    num_set_index_buffer : u32;
    num_skip_redundant_index_buffer : u32;
    num_create_bindgroup : u32;
    num_discard_bindgroup : u32;
    num_set_bindgroup : u32;
    num_skip_redundant_bindgroup : u32;
    num_bindgroup_cache_hits : u32;
    num_bindgroup_cache_misses : u32;
    num_bindgroup_cache_collisions : u32;
    num_bindgroup_cache_invalidates : u32;
    num_bindgroup_cache_hash_vs_key_mismatch : u32;
}

sg_frame_stats_wgpu :: struct {
    uniforms : sg_frame_stats_wgpu_uniforms;
    bindings : sg_frame_stats_wgpu_bindings;
}

sg_frame_stats :: struct {
    frame_index : u32;
    num_passes : u32;
    num_apply_viewport : u32;
    num_apply_scissor_rect : u32;
    num_apply_pipeline : u32;
    num_apply_bindings : u32;
    num_apply_uniforms : u32;
    num_draw : u32;
    num_dispatch : u32;
    num_update_buffer : u32;
    num_append_buffer : u32;
    num_update_image : u32;
    size_apply_uniforms : u32;
    size_update_buffer : u32;
    size_append_buffer : u32;
    size_update_image : u32;
    gl : sg_frame_stats_gl;
    d3d11 : sg_frame_stats_d3d11;
    metal : sg_frame_stats_metal;
    wgpu : sg_frame_stats_wgpu;
}

sg_log_item :: enum u32 {
    OK;
    MALLOC_FAILED;
    GL_TEXTURE_FORMAT_NOT_SUPPORTED;
    GL_3D_TEXTURES_NOT_SUPPORTED;
    GL_ARRAY_TEXTURES_NOT_SUPPORTED;
    GL_STORAGEBUFFER_GLSL_BINDING_OUT_OF_RANGE;
    GL_STORAGEIMAGE_GLSL_BINDING_OUT_OF_RANGE;
    GL_SHADER_COMPILATION_FAILED;
    GL_SHADER_LINKING_FAILED;
    GL_VERTEX_ATTRIBUTE_NOT_FOUND_IN_SHADER;
    GL_UNIFORMBLOCK_NAME_NOT_FOUND_IN_SHADER;
    GL_IMAGE_SAMPLER_NAME_NOT_FOUND_IN_SHADER;
    GL_FRAMEBUFFER_STATUS_UNDEFINED;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_ATTACHMENT;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MISSING_ATTACHMENT;
    GL_FRAMEBUFFER_STATUS_UNSUPPORTED;
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MULTISAMPLE;
    GL_FRAMEBUFFER_STATUS_UNKNOWN;
    D3D11_CREATE_BUFFER_FAILED;
    D3D11_CREATE_BUFFER_SRV_FAILED;
    D3D11_CREATE_BUFFER_UAV_FAILED;
    D3D11_CREATE_DEPTH_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_DEPTH_TEXTURE_FAILED;
    D3D11_CREATE_2D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_2D_TEXTURE_FAILED;
    D3D11_CREATE_2D_SRV_FAILED;
    D3D11_CREATE_3D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT;
    D3D11_CREATE_3D_TEXTURE_FAILED;
    D3D11_CREATE_3D_SRV_FAILED;
    D3D11_CREATE_MSAA_TEXTURE_FAILED;
    D3D11_CREATE_SAMPLER_STATE_FAILED;
    D3D11_UNIFORMBLOCK_HLSL_REGISTER_B_OUT_OF_RANGE;
    D3D11_STORAGEBUFFER_HLSL_REGISTER_T_OUT_OF_RANGE;
    D3D11_STORAGEBUFFER_HLSL_REGISTER_U_OUT_OF_RANGE;
    D3D11_IMAGE_HLSL_REGISTER_T_OUT_OF_RANGE;
    D3D11_SAMPLER_HLSL_REGISTER_S_OUT_OF_RANGE;
    D3D11_STORAGEIMAGE_HLSL_REGISTER_U_OUT_OF_RANGE;
    D3D11_LOAD_D3DCOMPILER_47_DLL_FAILED;
    D3D11_SHADER_COMPILATION_FAILED;
    D3D11_SHADER_COMPILATION_OUTPUT;
    D3D11_CREATE_CONSTANT_BUFFER_FAILED;
    D3D11_CREATE_INPUT_LAYOUT_FAILED;
    D3D11_CREATE_RASTERIZER_STATE_FAILED;
    D3D11_CREATE_DEPTH_STENCIL_STATE_FAILED;
    D3D11_CREATE_BLEND_STATE_FAILED;
    D3D11_CREATE_RTV_FAILED;
    D3D11_CREATE_DSV_FAILED;
    D3D11_CREATE_UAV_FAILED;
    D3D11_MAP_FOR_UPDATE_BUFFER_FAILED;
    D3D11_MAP_FOR_APPEND_BUFFER_FAILED;
    D3D11_MAP_FOR_UPDATE_IMAGE_FAILED;
    METAL_CREATE_BUFFER_FAILED;
    METAL_TEXTURE_FORMAT_NOT_SUPPORTED;
    METAL_CREATE_TEXTURE_FAILED;
    METAL_CREATE_SAMPLER_FAILED;
    METAL_SHADER_COMPILATION_FAILED;
    METAL_SHADER_CREATION_FAILED;
    METAL_SHADER_COMPILATION_OUTPUT;
    METAL_SHADER_ENTRY_NOT_FOUND;
    METAL_UNIFORMBLOCK_MSL_BUFFER_SLOT_OUT_OF_RANGE;
    METAL_STORAGEBUFFER_MSL_BUFFER_SLOT_OUT_OF_RANGE;
    METAL_STORAGEIMAGE_MSL_TEXTURE_SLOT_OUT_OF_RANGE;
    METAL_IMAGE_MSL_TEXTURE_SLOT_OUT_OF_RANGE;
    METAL_SAMPLER_MSL_SAMPLER_SLOT_OUT_OF_RANGE;
    METAL_CREATE_CPS_FAILED;
    METAL_CREATE_CPS_OUTPUT;
    METAL_CREATE_RPS_FAILED;
    METAL_CREATE_RPS_OUTPUT;
    METAL_CREATE_DSS_FAILED;
    WGPU_BINDGROUPS_POOL_EXHAUSTED;
    WGPU_BINDGROUPSCACHE_SIZE_GREATER_ONE;
    WGPU_BINDGROUPSCACHE_SIZE_POW2;
    WGPU_CREATEBINDGROUP_FAILED;
    WGPU_CREATE_BUFFER_FAILED;
    WGPU_CREATE_TEXTURE_FAILED;
    WGPU_CREATE_TEXTURE_VIEW_FAILED;
    WGPU_CREATE_SAMPLER_FAILED;
    WGPU_CREATE_SHADER_MODULE_FAILED;
    WGPU_SHADER_CREATE_BINDGROUP_LAYOUT_FAILED;
    WGPU_UNIFORMBLOCK_WGSL_GROUP0_BINDING_OUT_OF_RANGE;
    WGPU_STORAGEBUFFER_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    WGPU_IMAGE_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    WGPU_SAMPLER_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    WGPU_STORAGEIMAGE_WGSL_GROUP2_BINDING_OUT_OF_RANGE;
    WGPU_CREATE_PIPELINE_LAYOUT_FAILED;
    WGPU_CREATE_RENDER_PIPELINE_FAILED;
    WGPU_CREATE_COMPUTE_PIPELINE_FAILED;
    WGPU_ATTACHMENTS_CREATE_TEXTURE_VIEW_FAILED;
    IDENTICAL_COMMIT_LISTENER;
    COMMIT_LISTENER_ARRAY_FULL;
    TRACE_HOOKS_NOT_ENABLED;
    DEALLOC_BUFFER_INVALID_STATE;
    DEALLOC_IMAGE_INVALID_STATE;
    DEALLOC_SAMPLER_INVALID_STATE;
    DEALLOC_SHADER_INVALID_STATE;
    DEALLOC_PIPELINE_INVALID_STATE;
    DEALLOC_ATTACHMENTS_INVALID_STATE;
    INIT_BUFFER_INVALID_STATE;
    INIT_IMAGE_INVALID_STATE;
    INIT_SAMPLER_INVALID_STATE;
    INIT_SHADER_INVALID_STATE;
    INIT_PIPELINE_INVALID_STATE;
    INIT_ATTACHMENTS_INVALID_STATE;
    UNINIT_BUFFER_INVALID_STATE;
    UNINIT_IMAGE_INVALID_STATE;
    UNINIT_SAMPLER_INVALID_STATE;
    UNINIT_SHADER_INVALID_STATE;
    UNINIT_PIPELINE_INVALID_STATE;
    UNINIT_ATTACHMENTS_INVALID_STATE;
    FAIL_BUFFER_INVALID_STATE;
    FAIL_IMAGE_INVALID_STATE;
    FAIL_SAMPLER_INVALID_STATE;
    FAIL_SHADER_INVALID_STATE;
    FAIL_PIPELINE_INVALID_STATE;
    FAIL_ATTACHMENTS_INVALID_STATE;
    BUFFER_POOL_EXHAUSTED;
    IMAGE_POOL_EXHAUSTED;
    SAMPLER_POOL_EXHAUSTED;
    SHADER_POOL_EXHAUSTED;
    PIPELINE_POOL_EXHAUSTED;
    PASS_POOL_EXHAUSTED;
    BEGINPASS_ATTACHMENT_INVALID;
    APPLY_BINDINGS_STORAGE_BUFFER_TRACKER_EXHAUSTED;
    DRAW_WITHOUT_BINDINGS;
    VALIDATE_BUFFERDESC_CANARY;
    VALIDATE_BUFFERDESC_IMMUTABLE_DYNAMIC_STREAM;
    VALIDATE_BUFFERDESC_SEPARATE_BUFFER_TYPES;
    VALIDATE_BUFFERDESC_EXPECT_NONZERO_SIZE;
    VALIDATE_BUFFERDESC_EXPECT_MATCHING_DATA_SIZE;
    VALIDATE_BUFFERDESC_EXPECT_ZERO_DATA_SIZE;
    VALIATE_EXPECT_DATA;
    VALIDATE_BUFFERDESC_EXPECT_NO_DATA;
    VALIDATE_BUFFERDESC_EXPECT_DATA;
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SUPPORTED;
    VALIDATE_BUFFERDESC_STORAGEBUFFER_SIZE_MULTIPLE_4;
    VALIDATE_IMAGEDATA_NODATA;
    VALIDATE_IMAGEDATA_DATA_SIZE;
    VALIDATE_IMAGEDESC_CANARY;
    VALIDATE_IMAGEDESC_IMMUTABLE_DYNAMIC_STREAM;
    VALIDATE_IMAGEDESC_RENDER_VS_STORAGE_ATTACHMENT;
    VALIDATE_IMAGEDESC_WIDTH;
    VALIDATE_IMAGEDESC_HEIGHT;
    VALIDATE_IMAGEDESC_NONRT_PIXELFORMAT;
    VALIDATE_IMAGEDESC_MSAA_BUT_NO_ATTACHMENT;
    VALIDATE_IMAGEDESC_DEPTH_3D_IMAGE;
    VALIDATE_IMAGEDESC_ATTACHMENT_EXPECT_IMMUTABLE;
    VALIDATE_IMAGEDESC_ATTACHMENT_EXPECT_NO_DATA;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_NO_MSAA_SUPPORT;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_MSAA_NUM_MIPMAPS;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_MSAA_3D_IMAGE;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_MSAA_CUBE_IMAGE;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_MSAA_ARRAY_IMAGE;
    VALIDATE_IMAGEDESC_RENDERATTACHMENT_PIXELFORMAT;
    VALIDATE_IMAGEDESC_STORAGEATTACHMENT_PIXELFORMAT;
    VALIDATE_IMAGEDESC_STORAGEATTACHMENT_EXPECT_NO_MSAA;
    VALIDATE_IMAGEDESC_INJECTED_NO_DATA;
    VALIDATE_IMAGEDESC_DYNAMIC_NO_DATA;
    VALIDATE_IMAGEDESC_COMPRESSED_IMMUTABLE;
    VALIDATE_SAMPLERDESC_CANARY;
    VALIDATE_SAMPLERDESC_ANISTROPIC_REQUIRES_LINEAR_FILTERING;
    VALIDATE_SHADERDESC_CANARY;
    VALIDATE_SHADERDESC_VERTEX_SOURCE;
    VALIDATE_SHADERDESC_FRAGMENT_SOURCE;
    VALIDATE_SHADERDESC_COMPUTE_SOURCE;
    VALIDATE_SHADERDESC_VERTEX_SOURCE_OR_BYTECODE;
    VALIDATE_SHADERDESC_FRAGMENT_SOURCE_OR_BYTECODE;
    VALIDATE_SHADERDESC_COMPUTE_SOURCE_OR_BYTECODE;
    VALIDATE_SHADERDESC_INVALID_SHADER_COMBO;
    VALIDATE_SHADERDESC_NO_BYTECODE_SIZE;
    VALIDATE_SHADERDESC_METAL_THREADS_PER_THREADGROUP;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_NO_CONT_MEMBERS;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_SIZE_IS_ZERO;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_METAL_BUFFER_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_METAL_BUFFER_SLOT_COLLISION;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_HLSL_REGISTER_B_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_HLSL_REGISTER_B_COLLISION;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_WGSL_GROUP0_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_WGSL_GROUP0_BINDING_COLLISION;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_NO_MEMBERS;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_UNIFORM_GLSL_NAME;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_SIZE_MISMATCH;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_ARRAY_COUNT;
    VALIDATE_SHADERDESC_UNIFORMBLOCK_STD140_ARRAY_TYPE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_METAL_BUFFER_SLOT_COLLISION;
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_T_COLLISION;
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_U_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_HLSL_REGISTER_U_COLLISION;
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_GLSL_BINDING_COLLISION;
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEBUFFER_WGSL_GROUP1_BINDING_COLLISION;
    VALIDATE_SHADERDESC_STORAGEIMAGE_EXPECT_COMPUTE_STAGE;
    VALIDATE_SHADERDESC_STORAGEIMAGE_METAL_TEXTURE_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEIMAGE_METAL_TEXTURE_SLOT_COLLISION;
    VALIDATE_SHADERDESC_STORAGEIMAGE_HLSL_REGISTER_U_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEIMAGE_HLSL_REGISTER_U_COLLISION;
    VALIDATE_SHADERDESC_STORAGEIMAGE_GLSL_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEIMAGE_GLSL_BINDING_COLLISION;
    VALIDATE_SHADERDESC_STORAGEIMAGE_WGSL_GROUP2_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_STORAGEIMAGE_WGSL_GROUP2_BINDING_COLLISION;
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_METAL_TEXTURE_SLOT_COLLISION;
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_HLSL_REGISTER_T_COLLISION;
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_WGSL_GROUP1_BINDING_COLLISION;
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_SAMPLER_METAL_SAMPLER_SLOT_COLLISION;
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_SAMPLER_HLSL_REGISTER_S_COLLISION;
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_SAMPLER_WGSL_GROUP1_BINDING_COLLISION;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_SLOT_OUT_OF_RANGE;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_STAGE_MISMATCH;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_STAGE_MISMATCH;
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_GLSL_NAME;
    VALIDATE_SHADERDESC_NONFILTERING_SAMPLER_REQUIRED;
    VALIDATE_SHADERDESC_COMPARISON_SAMPLER_REQUIRED;
    VALIDATE_SHADERDESC_IMAGE_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS;
    VALIDATE_SHADERDESC_SAMPLER_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS;
    VALIDATE_SHADERDESC_ATTR_STRING_TOO_LONG;
    VALIDATE_PIPELINEDESC_CANARY;
    VALIDATE_PIPELINEDESC_SHADER;
    VALIDATE_PIPELINEDESC_COMPUTE_SHADER_EXPECTED;
    VALIDATE_PIPELINEDESC_NO_COMPUTE_SHADER_EXPECTED;
    VALIDATE_PIPELINEDESC_NO_CONT_ATTRS;
    VALIDATE_PIPELINEDESC_ATTR_BASETYPE_MISMATCH;
    VALIDATE_PIPELINEDESC_LAYOUT_STRIDE4;
    VALIDATE_PIPELINEDESC_ATTR_SEMANTICS;
    VALIDATE_PIPELINEDESC_SHADER_READONLY_STORAGEBUFFERS;
    VALIDATE_PIPELINEDESC_BLENDOP_MINMAX_REQUIRES_BLENDFACTOR_ONE;
    VALIDATE_ATTACHMENTSDESC_CANARY;
    VALIDATE_ATTACHMENTSDESC_NO_ATTACHMENTS;
    VALIDATE_ATTACHMENTSDESC_NO_CONT_COLOR_ATTS;
    VALIDATE_ATTACHMENTSDESC_COLOR_IMAGE;
    VALIDATE_ATTACHMENTSDESC_COLOR_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_COLOR_FACE;
    VALIDATE_ATTACHMENTSDESC_COLOR_LAYER;
    VALIDATE_ATTACHMENTSDESC_COLOR_SLICE;
    VALIDATE_ATTACHMENTSDESC_COLOR_IMAGE_NO_RENDERATTACHMENT;
    VALIDATE_ATTACHMENTSDESC_COLOR_INV_PIXELFORMAT;
    VALIDATE_ATTACHMENTSDESC_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_IMAGE_SAMPLE_COUNTS;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_COLOR_IMAGE_MSAA;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SAMPLE_COUNT;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_FACE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_LAYER;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_SLICE;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_NO_RT;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_RESOLVE_IMAGE_FORMAT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_INV_PIXELFORMAT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_DEPTH_FACE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_LAYER;
    VALIDATE_ATTACHMENTSDESC_DEPTH_SLICE;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_NO_RENDERATTACHMENT;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SIZES;
    VALIDATE_ATTACHMENTSDESC_DEPTH_IMAGE_SAMPLE_COUNT;
    VALIDATE_ATTACHMENTSDESC_STORAGE_IMAGE;
    VALIDATE_ATTACHMENTSDESC_STORAGE_MIPLEVEL;
    VALIDATE_ATTACHMENTSDESC_STORAGE_FACE;
    VALIDATE_ATTACHMENTSDESC_STORAGE_LAYER;
    VALIDATE_ATTACHMENTSDESC_STORAGE_SLICE;
    VALIDATE_ATTACHMENTSDESC_STORAGE_IMAGE_NO_STORAGEATTACHMENT;
    VALIDATE_ATTACHMENTSDESC_STORAGE_INV_PIXELFORMAT;
    VALIDATE_ATTACHMENTSDESC_RENDER_VS_STORAGE_ATTACHMENTS;
    VALIDATE_BEGINPASS_CANARY;
    VALIDATE_BEGINPASS_ATTACHMENTS_EXISTS;
    VALIDATE_BEGINPASS_ATTACHMENTS_VALID;
    VALIDATE_BEGINPASS_COMPUTEPASS_STORAGE_ATTACHMENTS_ONLY;
    VALIDATE_BEGINPASS_RENDERPASS_RENDER_ATTACHMENTS_ONLY;
    VALIDATE_BEGINPASS_COLOR_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_RESOLVE_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_DEPTHSTENCIL_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_STORAGE_ATTACHMENT_IMAGE;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_WIDTH_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_HEIGHT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_SAMPLECOUNT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_COLORFORMAT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_EXPECT_DEPTHFORMAT_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_CURRENTDRAWABLE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_DEPTHSTENCILTEXTURE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE;
    VALIDATE_BEGINPASS_SWAPCHAIN_METAL_EXPECT_MSAACOLORTEXTURE_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RENDERVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_RESOLVEVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_D3D11_EXPECT_DEPTHSTENCILVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RENDERVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_RESOLVEVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW;
    VALIDATE_BEGINPASS_SWAPCHAIN_WGPU_EXPECT_DEPTHSTENCILVIEW_NOTSET;
    VALIDATE_BEGINPASS_SWAPCHAIN_GL_EXPECT_FRAMEBUFFER_NOTSET;
    VALIDATE_AVP_RENDERPASS_EXPECTED;
    VALIDATE_ASR_RENDERPASS_EXPECTED;
    VALIDATE_APIP_PIPELINE_VALID_ID;
    VALIDATE_APIP_PIPELINE_EXISTS;
    VALIDATE_APIP_PIPELINE_VALID;
    VALIDATE_APIP_PASS_EXPECTED;
    VALIDATE_APIP_SHADER_EXISTS;
    VALIDATE_APIP_SHADER_VALID;
    VALIDATE_APIP_COMPUTEPASS_EXPECTED;
    VALIDATE_APIP_RENDERPASS_EXPECTED;
    VALIDATE_APIP_CURPASS_ATTACHMENTS_EXISTS;
    VALIDATE_APIP_CURPASS_ATTACHMENTS_VALID;
    VALIDATE_APIP_ATT_COUNT;
    VALIDATE_APIP_COLOR_FORMAT;
    VALIDATE_APIP_DEPTH_FORMAT;
    VALIDATE_APIP_SAMPLE_COUNT;
    VALIDATE_APIP_EXPECTED_STORAGE_ATTACHMENT_IMAGE;
    VALIDATE_APIP_STORAGE_ATTACHMENT_IMAGE_EXISTS;
    VALIDATE_APIP_STORAGE_ATTACHMENT_IMAGE_VALID;
    VALIDATE_APIP_STORAGE_ATTACHMENT_PIXELFORMAT;
    VALIDATE_APIP_STORAGE_ATTACHMENT_IMAGE_TYPE;
    VALIDATE_ABND_PASS_EXPECTED;
    VALIDATE_ABND_EMPTY_BINDINGS;
    VALIDATE_ABND_PIPELINE;
    VALIDATE_ABND_PIPELINE_EXISTS;
    VALIDATE_ABND_PIPELINE_VALID;
    VALIDATE_ABND_COMPUTE_EXPECTED_NO_VBS;
    VALIDATE_ABND_COMPUTE_EXPECTED_NO_IB;
    VALIDATE_ABND_EXPECTED_VB;
    VALIDATE_ABND_VB_EXISTS;
    VALIDATE_ABND_VB_TYPE;
    VALIDATE_ABND_VB_OVERFLOW;
    VALIDATE_ABND_NO_IB;
    VALIDATE_ABND_IB;
    VALIDATE_ABND_IB_EXISTS;
    VALIDATE_ABND_IB_TYPE;
    VALIDATE_ABND_IB_OVERFLOW;
    VALIDATE_ABND_EXPECTED_IMAGE_BINDING;
    VALIDATE_ABND_IMG_EXISTS;
    VALIDATE_ABND_IMAGE_TYPE_MISMATCH;
    VALIDATE_ABND_EXPECTED_MULTISAMPLED_IMAGE;
    VALIDATE_ABND_IMAGE_MSAA;
    VALIDATE_ABND_EXPECTED_FILTERABLE_IMAGE;
    VALIDATE_ABND_EXPECTED_DEPTH_IMAGE;
    VALIDATE_ABND_EXPECTED_SAMPLER_BINDING;
    VALIDATE_ABND_UNEXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_EXPECTED_SAMPLER_COMPARE_NEVER;
    VALIDATE_ABND_EXPECTED_NONFILTERING_SAMPLER;
    VALIDATE_ABND_SMP_EXISTS;
    VALIDATE_ABND_EXPECTED_STORAGEBUFFER_BINDING;
    VALIDATE_ABND_STORAGEBUFFER_EXISTS;
    VALIDATE_ABND_STORAGEBUFFER_BINDING_BUFFERTYPE;
    VALIDATE_ABND_STORAGEBUFFER_READWRITE_IMMUTABLE;
    VALIDATE_ABND_IMAGE_BINDING_VS_DEPTHSTENCIL_ATTACHMENT;
    VALIDATE_ABND_IMAGE_BINDING_VS_COLOR_ATTACHMENT;
    VALIDATE_ABND_IMAGE_BINDING_VS_RESOLVE_ATTACHMENT;
    VALIDATE_ABND_IMAGE_BINDING_VS_STORAGE_ATTACHMENT;
    VALIDATE_AU_PASS_EXPECTED;
    VALIDATE_AU_NO_PIPELINE;
    VALIDATE_AU_NO_UNIFORMBLOCK_AT_SLOT;
    VALIDATE_AU_SIZE;
    VALIDATE_DRAW_RENDERPASS_EXPECTED;
    VALIDATE_DRAW_BASEELEMENT;
    VALIDATE_DRAW_NUMELEMENTS;
    VALIDATE_DRAW_NUMINSTANCES;
    VALIDATE_DRAW_REQUIRED_BINDINGS_OR_UNIFORMS_MISSING;
    VALIDATE_DISPATCH_COMPUTEPASS_EXPECTED;
    VALIDATE_DISPATCH_NUMGROUPSX;
    VALIDATE_DISPATCH_NUMGROUPSY;
    VALIDATE_DISPATCH_NUMGROUPSZ;
    VALIDATE_DISPATCH_REQUIRED_BINDINGS_OR_UNIFORMS_MISSING;
    VALIDATE_UPDATEBUF_USAGE;
    VALIDATE_UPDATEBUF_SIZE;
    VALIDATE_UPDATEBUF_ONCE;
    VALIDATE_UPDATEBUF_APPEND;
    VALIDATE_APPENDBUF_USAGE;
    VALIDATE_APPENDBUF_SIZE;
    VALIDATE_APPENDBUF_UPDATE;
    VALIDATE_UPDIMG_USAGE;
    VALIDATE_UPDIMG_ONCE;
    VALIDATION_FAILED;
}

sg_environment_defaults :: struct {
    color_format : sg_pixel_format;
    depth_format : sg_pixel_format;
    sample_count : s32;
}

sg_metal_environment :: struct {
    device : *void;
}

sg_d3d11_environment :: struct {
    device : *void;
    device_context : *void;
}

sg_wgpu_environment :: struct {
    device : *void;
}

sg_environment :: struct {
    defaults : sg_environment_defaults;
    metal : sg_metal_environment;
    d3d11 : sg_d3d11_environment;
    wgpu : sg_wgpu_environment;
}

sg_commit_listener :: struct {
    func : (a0: *void) #c_call;
    user_data : *void;
}

sg_allocator :: struct {
    alloc_fn : (a0: u64, a1: *void) -> *void #c_call;
    free_fn : (a0: *void, a1: *void) #c_call;
    user_data : *void;
}

sg_logger :: struct {
    func : (a0: *u8, a1: u32, a2: u32, a3: *u8, a4: u32, a5: *u8, a6: *void) #c_call;
    user_data : *void;
}

sg_desc :: struct {
    _ : u32;
    buffer_pool_size : s32;
    image_pool_size : s32;
    sampler_pool_size : s32;
    shader_pool_size : s32;
    pipeline_pool_size : s32;
    attachments_pool_size : s32;
    uniform_buffer_size : s32;
    max_dispatch_calls_per_pass : s32;
    max_commit_listeners : s32;
    disable_validation : bool;
    d3d11_shader_debugging : bool;
    mtl_force_managed_storage_mode : bool;
    mtl_use_command_buffer_with_retained_references : bool;
    wgpu_disable_bindgroups_cache : bool;
    wgpu_bindgroups_cache_size : s32;
    allocator : sg_allocator;
    logger : sg_logger;
    environment : sg_environment;
    _ : u32;
}

sg_d3d11_buffer_info :: struct {
    buf : *void;
}

sg_d3d11_image_info :: struct {
    tex2d : *void;
    tex3d : *void;
    res : *void;
    srv : *void;
}

sg_d3d11_sampler_info :: struct {
    smp : *void;
}

sg_d3d11_shader_info :: struct {
    cbufs : [8]*void;
    vs : *void;
    fs : *void;
}

sg_d3d11_pipeline_info :: struct {
    il : *void;
    rs : *void;
    dss : *void;
    bs : *void;
}

sg_d3d11_attachments_info :: struct {
    color_rtv : [4]*void;
    resolve_rtv : [4]*void;
    dsv : *void;
}

sg_mtl_buffer_info :: struct {
    buf : [2]*void;
    active_slot : s32;
}

sg_mtl_image_info :: struct {
    tex : [2]*void;
    active_slot : s32;
}

sg_mtl_sampler_info :: struct {
    smp : *void;
}

sg_mtl_shader_info :: struct {
    vertex_lib : *void;
    fragment_lib : *void;
    vertex_func : *void;
    fragment_func : *void;
}

sg_mtl_pipeline_info :: struct {
    rps : *void;
    dss : *void;
}

sg_wgpu_buffer_info :: struct {
    buf : *void;
}

sg_wgpu_image_info :: struct {
    tex : *void;
    view : *void;
}

sg_wgpu_sampler_info :: struct {
    smp : *void;
}

sg_wgpu_shader_info :: struct {
    vs_mod : *void;
    fs_mod : *void;
    bgl : *void;
}

sg_wgpu_pipeline_info :: struct {
    render_pipeline : *void;
    compute_pipeline : *void;
}

sg_wgpu_attachments_info :: struct {
    color_view : [4]*void;
    resolve_view : [4]*void;
    ds_view : *void;
}

sg_gl_buffer_info :: struct {
    buf : [2]u32;
    active_slot : s32;
}

sg_gl_image_info :: struct {
    tex : [2]u32;
    tex_target : u32;
    msaa_render_buffer : u32;
    active_slot : s32;
}

sg_gl_sampler_info :: struct {
    smp : u32;
}

sg_gl_shader_info :: struct {
    prog : u32;
}

sg_gl_attachments_info :: struct {
    framebuffer : u32;
    msaa_resolve_framebuffer : [4]u32;
}

