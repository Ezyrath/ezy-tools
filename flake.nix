{
  description = "Ezyrath personal tools & development shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wl-inject = {
      url = "github:Ezyrath/wl-inject";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    wl-inject,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        wlInjectPkg = wl-inject.packages.${system}.default;
      in {
        default = pkgs.stdenv.mkDerivation {
          pname = "ezy-tools";
          version = "1.0.0";
          src = ./.;

          buildInputs = with pkgs; [bash coreutils];

          installPhase = ''
            mkdir -p $out/bin $out/share/bash-completion/completions

            if [ -d bin ]; then
              cp -r bin/* $out/bin/
            fi
            chmod +x $out/bin/*

            if [ -d bash_completion ]; then
              cp -r bash_completion/* $out/share/bash-completion/completions/
            fi
          '';
        };

        dev = import ./shells/dev.nix {
          inherit pkgs;
          wl-inject = wlInjectPkg;
        };
        unreal = import ./shells/unreal.nix {inherit pkgs;};
      }
    );

    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        default = self.devShells.${system}.dev;
        dev = self.packages.${system}.dev.env;
        unreal = self.packages.${system}.unreal.env;
        godot = import ./shells/godot.nix {inherit pkgs;};
        jetbrains = import ./shells/jetbrains.nix {inherit pkgs;};
        empty = import ./shells/empty.nix {inherit pkgs;};
      }
    );
  };
}
