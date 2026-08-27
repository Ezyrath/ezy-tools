{
  pkgs,
  name ? "jetbrains-env",
}:
pkgs.mkShell {
  inherit name;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = with pkgs; [
    bashInteractive
  ];

  runtimeDependencies = with pkgs; [
    jdk
    zlib
    python3
    lldb
    dotnet-sdk_8
    maven
    openssl
    expat
    libxcrypt
    libxcrypt-legacy
    fontconfig
    libxml2
    musl
    R
    libgcc
    lttng-ust_2_12
    xz
    libGL
  ];

  shellHook = ''
    export SHELL=${pkgs.bashInteractive}/bin/bash
    PS1="\[\e[92m\]┌───(\u@${name}) \[\e[37m\]\w\n\[\e[92m\]└─§> \[\e[0m\]"
  '';
}
