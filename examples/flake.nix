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
    gquery = {
      # TODO switch back to main branch
      url = "git+ssh://k-devops-pv01.agresearch.co.nz/tfs/Scientific/Bioinformatics/_git/gquery?ref=refs/heads/gbs_prism";
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
            gquery-api = inputs.gquery.packages.${system}.api;

          };

          python-with-redun = pkgs.symlinkJoin
            {
              name = "python-with-redun";
              paths = [
                flakePkgs.redun
                (
                  pkgs.python3.withPackages (python-pkgs: [
                    # add any other required packages here, either from nixpkgs or other flakes
                    python-pkgs.pytest
                  ])
                )
              ];
            };

        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs =
              [
                bashInteractive
                python-with-redun
              ];
          };

          packages = {
            redun = flakePkgs.redun;
            gquery-api = flakePkgs.gquery-api;
            python = pkgs.python3.withPackages
              (python-pkgs: [
                flakePkgs.redun
                flakePkgs.gquery-api
              ]);
          };
        }
      );
}

