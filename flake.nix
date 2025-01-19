{
  description = "Flake for redun using dream2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
        redun = dream2nix.lib.evalModules {
          packageSets.nixpkgs = pkgs;
          modules = [
            ./default.nix
            ({ config, lib, ... }: {
              paths.projectRoot = ./.;
              paths.package = ./.;

              buildPythonPackage.pyproject = lib.mkDefault true;
              mkDerivation.nativeBuildInputs = with config.deps.python311Packages; [ setuptools wheel ];
              pip = {
                ignoredDependencies = [ "wheel" "setuptools" ];
              };
            })
          ];
        };
      in
      {
        packages.default = redun;
      });
}
