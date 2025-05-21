{
  description = "Example of consuming redun flake package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    redun = {
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

          flakePkgs = {
            redun = inputs.redun.packages.${system}.default;
          };

          python-with-packages = pkgs.python3.withPackages (ps: with ps;[
            flakePkgs.redun
            biopython
          ]);

        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs =
              [
                bashInteractive
                python-with-packages
              ];
          };

          packages.default = python-with-packages;
        }
      );
}
