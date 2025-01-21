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
        redun = mkDerivationExtraArgs: dream2nix.lib.evalModules {
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
              } // mkDerivationExtraArgs;

              pip = {
                ignoredDependencies = [ "wheel" "setuptools" ];
              };
            })
          ];
        };
      in
      {
        # if you want redun to have access to your own python packages use this attribute
        # e.g. lib.${system}.default { propagatedBuildInputs = [ ... ]; }
        lib.default = redun;

        # otherwise this one is the same, but with no extra packages
        packages.default = redun { };
      });
}
