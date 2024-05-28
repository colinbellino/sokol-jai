<!-- [![Jai](https://github.com/colinbellino/sokol-jai/actions/workflows/main.yml/badge.svg)](https://github.com/colinbellino/sokol-jai/actions/workflows/main.yml) -->

Auto-generated Jai bindings for the [sokol headers](https://github.com/floooh/sokol).

To include sokol in your project you can copy the [sokol](sokol/) directory.

## TODO:
- Pass SOKOL_DEBUG when building or importing
- Pass SOKOL_USE_GL when building or importing
- Compile shaders
- Windows support
- Linux support

## BUILD

Supported platforms are: Windows, macOS, Linux (with X11)

On Linux install the following packages: libglu1-mesa-dev, mesa-common-dev, xorg-dev, libasound-dev
(or generally: the dev packages required for X11, GL and ALSA development)

1. First build the required static link libraries:

    ```
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
    ```
    mkdir build
    cd build
    ```

3. Build and run the samples:
    ```
    jai ../examples/clear.jai && ../examples/clear
    jai ../examples/triangle.jai && ../examples/triangle
    jai ../examples/quad.jai && ../examples/quad
    jai ../examples/bufferoffsets.jai && ../examples/bufferoffsets
    jai ../examples/cube.jai && ../examples/cube
    jai ../examples/noninterleaved.jai && ../examples/noninterleaved
    jai ../examples/texcube.jai && ../examples/texcube
    jai ../examples/shapes.jai && ../examples/shapes
    jai ../examples/offscreen.jai && ../examples/offscreen
    jai ../examples/instancing.jai && ../examples/instancing
    jai ../examples/mrt.jai && ../examples/mrt
    jai ../examples/blend.jai && ../examples/blend
    jai ../examples/debugtext.jai && ../examples/debugtext
    jai ../examples/debugtext.jaiprint/ && ../examples/debugtext-print
    jai ../examples/debugtext.jaiuserfont/ && ../examples/debugtext-userfont
    jai ../examples/saudio.jai && ../examples/saudio
    jai ../examples/sgl.jai && ../examples/sgl
    jai ../examples/sgl.jaipoints/ && ../examples/sgl-points
    jai ../examples/sgl.jaicontext/ && ../examples/sgl-context
    jai ../examples/vertexpull.jai && ../examples/vertexpull
    ```

    By default, the backend 3D API will be selected based on the target platform:

    - macOS: Metal
    - Windows: D3D11
    - Linux: GL

    (TODO: support this)
    To force the GL backend on macOS or Windows, build with ```-define:SOKOL_USE_GL=true```:

    ```
    jai ../examples/clear.jai - -define:SOKOL_USE_GL=true
    ```

    The ```clear``` sample prints the selected backend to the terminal:

    ```
    jai ../examples/clear.jai - -define:SOKOL_USE_GL=true
    >> using GL backend
    ```
