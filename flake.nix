{
  description = "LilleAila's nix flake templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    imports = [
      inputs.devshell.flakeModule
    ];

    devshells.default = {
      packages = with pkgs; [
        nil
        alejandra
      ];
    };

    templates = {
      flake-parts = {
        path = ./flake-parts;
        description = "A simple flake using flake-parts";
      };
    };
  };
}
