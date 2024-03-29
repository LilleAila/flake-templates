{
  description = "A flake using texlive for LaTeX";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
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
          texliveFull
          pandoc
          (python311.withPackages (python-pkgs:
            with python-pkgs; [
              pygments # For minted
            ]))
        ];
      in {
        devshells.default = {
          packages = dependencies;
        };

        packages = let
          document = pkgs.stdenv.mkDerivation {
            name = "LaTeX Document";
            src = ./.;
            buildInputs = dependencies;
            phases = ["unpackPhase" "buildPhase"];
            buildPhase = ''
              mkdir -p $out
              latexmk -pdf -shell-escape ./document.tex
              mv document.pdf $out/document.pdf
            '';
          };
        in {
          default = document;
        };
      };
    };
}
