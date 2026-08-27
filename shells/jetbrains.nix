{ pkgs, name ? "jetbrains-env" }:

pkgs.mkShell {
  inherit name;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = with pkgs; [];

  runtimeDependencies = with pkgs; [
    stdenv
    callPackage
    fetchurl

    jdk
    zlib
    python3
    lldb
    dotnet-sdk_7
    maven
    openssl
    expat
    libxcrypt
    libxcrypt-legacy
    fontconfig
    libxml2
    runCommand
    musl
    R
    libgcc
    lttng-ust_2_12
    xz
    libGL
  ];

  shellHook = ''
    PS1="\[\e[92m\]┌───(\u@${name}) \[\e[37m\]\w\n\[\e[92m\]└─§> \[\e[0m\]"
  '';
}
