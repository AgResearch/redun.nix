{
  description = "Flake for redun using dream2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , flake-utils
    , dream2nix
    , nixpkgs
    ,
    }:
    flake-utils.lib.eachDefaultSystem
      (system:

      let
        pkgs = import nixpkgs {
          inherit system;
        };

        redun-d2n = dream2nix.lib.evalModules {
          packageSets.nixpkgs = pkgs;
          modules = [
            ./default.nix
            ({ config, lib, ... }: {
              paths.projectRoot = ./.;
              paths.package = ./.;

              buildPythonPackage = {
                pyproject = lib.mkDefault true;
              };

              mkDerivation = {
                nativeBuildInputs = with config.deps.python3Packages; [ setuptools wheel ];

                # propagatedBuildInputs = with config.deps.python3Packages; [
                #   alembic
                #   sqlalchemy
                #   textual
                # ];
              };

              pip = {
                ignoredDependencies = [ "wheel" "setuptools" ];
              };
            })
          ];
        };

        # wrap the dream2nix package as a native Python package
        # so it may be installed using python3.withPackages
        redun-d2n-wrapped = pkgs.callPackage ./wrapDream2nix.nix {
          package = redun-d2n;
          # The approach of replacing propagatedBuildInputs after building the package doesn't work.
          # replacePropagatedBuildInputs = with pkgs.python3Packages; [
          #   alembic
          #   sqlalchemy
          #   textual
          # ];
        };

      in
      {
        packages.default = redun-d2n-wrapped;
      });
}
