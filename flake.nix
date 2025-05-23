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
              };

              pip = {
                ignoredDependencies = [ "wheel" "setuptools" ];
              };
            })
          ];
        };

        # wrap the dream2nix package as a native Python package
        # so it may be installed using python3.withPackages
        redun-d2n-wrapped =
          let
            inherit (pkgs.python3) sitePackages;
            inherit (pkgs.python3Packages) buildPythonPackage;
          in
          buildPythonPackage
            {
              pname = redun-d2n.name;
              version = redun-d2n.version;
              src = redun-d2n;
              propagatedBuildInputs = redun-d2n.config.mkDerivation.propagatedBuildInputs;
              format = "other";
              dontBuild = true;
              installPhase = ''
                mkdir -p $out/bin $out/${sitePackages}
                cp -r ${redun-d2n.config.public}/${sitePackages}/* $out/${sitePackages}/
                cp -r ${redun-d2n.config.public}/bin/* $out/bin/
              '';
            };

      in
      {
        packages.default = redun-d2n-wrapped;
      });
}
