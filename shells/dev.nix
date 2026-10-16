{
  pkgs,
  wl-inject ? null,
  ue-linux-win64 ? null,
}: let
  wlInjectPkg =
    if wl-inject != null
    then wl-inject
    else (builtins.getFlake "github:Ezyrath/wl-inject").packages.${pkgs.stdenv.hostPlatform.system}.default;

  ueLinuxWin64Pkg =
    if ue-linux-win64 != null
    then ue-linux-win64
    else if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
    then (builtins.getFlake "github:Ezyrath/ue-linux-win64").packages.x86_64-linux.default
    else null;

  deps =
    (with pkgs; [
      # interactive shell
      bashInteractive

      # builder + builder-helper
      pkg-config
      cfssl # for kubernetes
      openssl
      openssl.dev
      gnumake
      glib
      gcc
      gdb
      clang-tools
      cmake
      ninja
      maven
      gradle
      scons
      linuxHeaders

      # graphics dep
      vulkan-validation-layers
      vulkan-loader
      vulkan-tools
      libGL
      libgbm
      libX11
      libXcursor
      libXinerama
      libXext
      libXrandr
      libXrender
      libXi
      libXfixes
      libXcomposite # for bridge ?
      libXdamage # for bridge ?
      libxkbcommon
      wayland
      wayland.dev
      wayland-protocols
      alsa-lib
      libpulseaudio
      dbus
      dbus.lib
      speechd
      fontconfig
      fontconfig.lib
      fontconfig.dev
      freetype
      freetype.dev
      udev
      udev.dev
      icu

      # fix install git-dependancy (test for the next build what is useless)
      zlib
      lldb
      dotnet-sdk
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
      libxcb
      libdrm

      # ----- cypress ------
      cups
      gtk3
      # --------------------

      # --- webview & audio ----
      webkitgtk_4_1
      alsa-utils
      alsa-lib.dev

      # GTK Deps
      cairo
      pango
      gdk-pixbuf
      atk
      libsoup_3

      # proton-drive
      libsecret

      # agent ui test x11/wayland app
      sway
      grim
      wlInjectPkg

      # ------------------------

      # --- optionnal ----
      cmakeWithGui # ui for cmake (cmake-gui)
      binaryen # wasm optimizer (used by spacetimedb)
      temurin-bin-25 # java optimized
      cloudflared # cloudflare cli
      # ------------------

      # --- kubernetes & ops ----
      ansible
      sshpass
      kubectl
      kubernetes-helm
      kubelogin-oidc
      # -------------------------

      # --- mobile / android ----
      android-tools
      # -------------------------

      # --- unreal linux->win64 cross-compilation ---
      xwin
      llvmPackages_20.clang-unwrapped
      llvmPackages_20.lld
      llvmPackages_20.bintools-unwrapped
      wine64Packages.stable
      # ---------------------------------------------
    ])
    ++ pkgs.lib.optional (ueLinuxWin64Pkg != null) ueLinuxWin64Pkg;
in
  pkgs.buildFHSEnv {
    name = "dev";
    targetPkgs = _pkgs: deps;
    multiPkgs = _pkgs: deps;

    # add xdg-open to the environment for unreal engine
    extraBuildCommands = ''
      mkdir -p $out/usr/bin
      ln -s ${pkgs.xdg-utils}/bin/xdg-open $out/usr/bin/xdg-open
    '';

    profile = ''
      export SHELL=/bin/bash
      export name="dev"

      # spacetime + rust
      export PATH="$HOME/.local/bin:$PATH"
      if [ -d "$HOME/Documents/ue-linux-win64/bin" ]; then
        export PATH="$HOME/Documents/ue-linux-win64/bin:$PATH"
      fi
      . "$HOME/.cargo/env"
      export JAVA_HOME=${pkgs.temurin-bin-25}

      # unused for new
      # # JetBrains IDEs — symlink only .sh launchers to avoid polluting PATH with internal binaries
      # _jb_bin="$HOME/.local/share/JetBrains/launchers"
      # mkdir -p "$_jb_bin"
      # for _sh in "$HOME/.local/share/JetBrains/Toolbox/apps"/*/bin/*.sh; do
      #   [ -f "$_sh" ] && ln -sf "$_sh" "$_jb_bin/$(basename "$_sh" .sh)"
      # done
      # export PATH="$_jb_bin:$PATH"
      # unset _jb_bin _sh
    '';
  }
