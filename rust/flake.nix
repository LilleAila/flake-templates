{
  description = "A flake using texlive for LaTeX";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    # Basically cargo but nix:
    naersk.url = "github:nix-community/naersk";
  };

  outputs = {...} @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.devshell.flakeModule
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        dependencies = with pkgs; [
          cargo
          rustc
          rustfmt
          rustPackages.clippy
          rust-analyzer
        ];
        naersk-lib = pkgs.callPackage inputs.naersk {};
      in {
        devshells.default = {
          packages = dependencies;
        };

        packages = {
          default = naersk-lib.buildPackage ./.;
        };
      };
    };
}
