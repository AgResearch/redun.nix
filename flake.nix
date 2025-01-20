{
  description = "Flake for redun using dream2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
              mkDerivation.nativeBuildInputs = with config.deps.python3Packages; [ setuptools wheel ];
              pip = {
                ignoredDependencies = [ "wheel" "setuptools" ];
              };
            })
          ];
        };
        redun-wrapped = { python }:
          pkgs.symlinkJoin {
            name = "redun-wrapped";
            paths = [ redun ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              # edit out redun's own python for our parameterized python
              for editpath in bin/redun bin/.redun-wrapped nix-support/propagated-build-inputs; do
                sed -i -e "s,/nix/store/[a-z0-9]*-python3-[.0-9]*,${python},g" $out/$editpath
              done
            '';
          }
        ;
      in
      {
        lib.redun = redun-wrapped;
      });
}
