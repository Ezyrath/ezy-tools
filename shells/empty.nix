{
  pkgs,
  name ? "empty-env",
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

  runtimeDependencies = with pkgs; [];

  shellHook = ''
    export SHELL=${pkgs.bashInteractive}/bin/bash
    PS1="\[\e[92m\]┌───(\u@${name}) \[\e[37m\]\w\n\[\e[92m\]└─§> \[\e[0m\]"
  '';
}
