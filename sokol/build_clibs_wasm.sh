set -e

build_lib_wasm_release() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    emcc -c -O2 -DNDEBUG -sMEMORY64 -sSHARED_MEMORY -DIMPL -D$backend c/$src.c
    emar rcs $dst.a $src.o
}

build_lib_wasm_debug() {
    src=$1
    dst=$2
    backend=$3
    echo $dst
    emcc -c -g -DIMPL -sMEMORY64 -sSHARED_MEMORY -D$backend c/$src.c
    emar rcs $dst.a $src.o
}

# wasm + GL + Release
build_lib_wasm_release sokol_log         log/sokol_log_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_gfx         gfx/sokol_gfx_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_app         app/sokol_app_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_glue        glue/sokol_glue_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_time        time/sokol_time_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_audio       audio/sokol_audio_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_debugtext   debugtext/sokol_debugtext_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_shape       shape/sokol_shape_wasm_wgpu_release SOKOL_WGPU
build_lib_wasm_release sokol_gl          gl/sokol_gl_wasm_wgpu_release SOKOL_WGPU

# wasm + GL + Debug
build_lib_wasm_debug sokol_log           log/sokol_log_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_gfx           gfx/sokol_gfx_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_app           app/sokol_app_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_glue          glue/sokol_glue_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_time          time/sokol_time_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_audio         audio/sokol_audio_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_debugtext     debugtext/sokol_debugtext_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_shape         shape/sokol_shape_wasm_wgpu_debug SOKOL_WGPU
build_lib_wasm_debug sokol_gl            gl/sokol_gl_wasm_wgpu_debug SOKOL_WGPU

rm *.o
