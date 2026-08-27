{
  pkgs,
  name ? "godot-env",
}:
pkgs.mkShell {
  inherit name;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = with pkgs; [
    pkg-config
    openssl
    gnumake
    glib
    gcc
    cmake
    scons
  ];

  runtimeDependencies = with pkgs; [
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
  ];

  shellHook = ''
    PS1="\[\e[92m\]┌───(\u@${name}) \[\e[37m\]\w\n\[\e[92m\]└─§> \[\e[0m\]"
  '';
}
