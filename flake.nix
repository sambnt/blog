{
  description = "blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
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
          buildInputs = [ pkgs.mermaid-cli pkgs.direnv pkgs.emacs ];
        };
      });
    };
}
