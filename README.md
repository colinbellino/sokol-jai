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
    Warning: examples that are commented out aren't implemented yet (the modules are still working, i just haven't taking the time to port the examples).
    ```bash
    jai ../examples/first.jai - clear
    jai ../examples/first.jai - triangle
    # jai ../examples/first.jai - quad
    # jai ../examples/first.jai - bufferoffsets
    # jai ../examples/first.jai - cube
    # jai ../examples/first.jai - noninterleaved
    # jai ../examples/first.jai - texcube
    # jai ../examples/first.jai - shapes
    jai ../examples/first.jai - offscreen
    # jai ../examples/first.jai - instancing
    # jai ../examples/first.jai - mrt
    jai ../examples/first.jai - blend
    # jai ../examples/first.jai - debugtext
    jai ../examples/first.jai - debugtext-print
    # jai ../examples/first.jai - debugtext-userfont
    jai ../examples/first.jai - saudio
    # jai ../examples/first.jai - sgl
    # jai ../examples/first.jai - sgl-points
    # jai ../examples/first.jai - sgl-context
    # jai ../examples/first.jai - vertexpull
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
