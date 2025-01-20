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
                sed -i -e "s:/nix/store/[a-z0-9]*-python3-[.0-9]*:${python}:g" $out/$editpath
              done

              # and add parameterized python site-packages  to addsitedir
              for editpath in bin/.redun-wrapped; do
                sed -i -e "s:/site-packages']:XYZ/site-packages','${python}/lib/${python.libPrefix}/site-packages']:" $out/$editpath
              done
            '';
          }
        ;
      in
      {
        # if you want redun to use your own python which has particular packages installed,
        # use this attribute, like lib.${system}.default { python = python-with-my-packages; }
        lib.default = redun-wrapped;

        # otherwise this one is the same, but with the default python with no extra packages
        packages.default = redun-wrapped { python = pkgs.python3; };
      });
}
