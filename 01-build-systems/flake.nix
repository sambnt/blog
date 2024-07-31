{
  description = "01-build-systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      defaultSystem = lib.head supportedSystems;
      forAllSystems = lib.genAttrs supportedSystems;

      pkgsFor = system: import nixpkgs {
        inherit system;
      };

    in {
      legacyPackages = forAllSystems pkgsFor;

      devShells = forAllSystems (system: let
        pkgs = pkgsFor system;
      in {
        default = pkgs.mkShell {
          SDL_INCLUDE_DIR = "${pkgs.SDL2.dev}/include";
          SDL_LIB_DIR = "${pkgs.SDL2}/lib";
          buildInputs = [ pkgs.gcc pkgs.mermaid-cli ];
        };
      });
    };
}
