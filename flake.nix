{
  description = "Trino - Distributed SQL query engine for big data";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        trino = pkgs.callPackage ./trino.nix { };
      in
      {
        packages = {
          trino = trino;
          default = trino;
        };

        apps.trino = flake-utils.lib.mkApp {
          drv = trino;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ trino ];
        };
      }
    );
}