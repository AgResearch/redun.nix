{
  description = "Example of consuming redun flake package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    redun = {
      # url = "github:AgResearch/redun.nix?ref=refs/tags/24.05";
      url = "..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
          };

          redun = inputs.redun.lib.${system}.default {
            buildInputs = [
              # add any other required packages here, either from nixpkgs or other flakes
              pkgs.python3Packages.pytest
            ];
          };

        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs =
              [
                bashInteractive
                redun
              ];
          };

          packages.default = redun;
        }
      );
}
