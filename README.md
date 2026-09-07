<!-- [![Jai](https://github.com/colinbellino/sokol-jai/actions/workflows/main.yml/badge.svg)](https://github.com/colinbellino/sokol-jai/actions/workflows/main.yml) -->

Auto-generated Jai bindings for the [sokol headers](https://github.com/floooh/sokol).

To include sokol in your project you can copy the [sokol](sokol/) directory.

## BUILD

Supported platforms are: Windows, macOS, Linux (with X11)

On Linux install the following packages: libglu1-mesa-dev, mesa-common-dev, xorg-dev, libasound-dev
(or generally: the dev packages required for X11, GL and ALSA development)

1. First build the required static link libraries:

    ```bash
    cd sokol
    # on macOS:
    ./build_clibs_macos.sh
    # on Linux:
    ./build_clibs_linux.sh
    # on Windows with MSVC (from a 'Visual Studio Developer Command Prompt')
    build_clibs_windows.cmd
    cd ..
    ```

2. Create a build directory and cd into it:
    ```bash
    mkdir build
    cd build
    ```

3. Build and run the samples:
    ```bash
    jai ../examples/first.jai - clear
    jai ../examples/first.jai - triangle
    jai ../examples/first.jai - offscreen
    jai ../examples/first.jai - blend
    jai ../examples/first.jai - debugtext-print
    jai ../examples/first.jai - saudio
    jai ../examples/first.jai - fontstash-sapp
    jai ../examples/first.jai - sgl-context-sapp
    jai ../examples/first.jai - cube-sapp
    ```

    By default, the backend 3D API will be selected based on the target platform:

    - macOS: Metal
    - Windows: D3D11
    - Linux: GL

    To force the GL backend on macOS or Windows, build with ```-GL```:

    ```
    jai ../examples/first.jai - clear -GL
    ```

    The ```clear``` sample prints the selected backend to the terminal:

    ```
    jai ../examples/first.jai - clear -GL
    >> using GL backend
    ```

## Dear ImGui integration

> _The section below is LLM-generated._

The `sokol/imgui`, `sokol/gfx_imgui` and `sokol/app_imgui` Jai modules ship,
but their pre-built C archives under `sokol/imgui/`, `sokol/gfx_imgui/` and
`sokol/app_imgui/` are **not** produced by `build_clibs_*.sh` — those scripts
intentionally skip these headers because they need Dear ImGui (C++), which
you must supply.

To use them:

1. Clone [dcimgui](https://github.com/floooh/dcimgui) (an all-in-one Dear
   ImGui + `cimgui.h` C-API drop) and build it into a static library —
   regular flavour:

    ```bash
    cd path/to/dcimgui
    c++ -c -O2 -std=c++17 src/*.cpp
    ar rcs libimgui.a *.o
    ```

    Use `src-docking/` instead for the docking flavour.

2. Compile the sokol stub yourself for each config you need. Example for
   macOS arm64 Metal debug:

    ```bash
    MACOSX_DEPLOYMENT_TARGET=14.0 cc -c -g -x objective-c -arch arm64 \
        -std=c11 -DIMPL -DSOKOL_METAL \
        -I path/to/dcimgui/src \
        sokol/c/sokol_imgui.c
    ar rcs sokol/imgui/sokol_imgui_macos_arm64_metal_debug.a sokol_imgui.o
    ```

    Repeat per (arch × config × backend) combination you target — mirroring
    the naming used by the other `sokol/<module>/*.a` archives.

3. Import the module and use it normally:

    ```jai
    #import "sokol/imgui";
    ```

    Also add `libimgui.a` and the C++ runtime (`-lc++` on macOS, `-lstdc++`
    on Linux) to your Jai program's link options.

The same flow applies to `sokol/gfx_imgui` and `sokol/app_imgui`.
