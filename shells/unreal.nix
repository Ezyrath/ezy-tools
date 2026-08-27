{pkgs}: let
  dep = with pkgs; [
    # interactive shell
    bashInteractive

    pkg-config
    openssl
    gnumake
    glib
    gcc
    gdb
    cmake
    scons
    linuxHeaders

    vulkan-loader
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    libxkbcommon
    alsa-lib
    libpulseaudio
    dbus
    dbus.lib
    speechd
    fontconfig
    fontconfig.lib
    udev
    icu

    # fix install git-dependancy (test for the next build what is useless)
    zlib
    lldb
    dotnet-sdk
    maven
    expat
    libxcrypt
    libxcrypt-legacy
    libxml2
    libgcc
    lttng-ust_2_12
    xz

    # fix unreal-engine startup
    nss
    nspr
    at-spi2-atk
    mesa
    pango
    cairo

    # fix libcef dep
    xorg.libxcb
    libdrm

    # --- optionnal ----
    cmakeWithGui # ui for cmake (cmake-gui)

    cudatoolkit # cuda
    # ------------------
  ];
in
  pkgs.buildFHSEnv {
    name = "unreal-engine";
    targetPkgs = _pkgs: dep;
    multiPkgs = _pkgs: dep;
    runScript = "bash";
    profile = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
      export SDL_VIDEODRIVER=wayland,x11
      export PATH="/home/ezyrath/.local/bin:$PATH"
      . "$HOME/.cargo/env"
    '';
  }
