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
            gquery-api = inputs.gquery.packages.${system}.api;

          };

          redun = inputs.redun.lib.${system}.redun {
            python = python-with-gquery;
          };

          python-with-gquery = pkgs.python3.withPackages
            (python-pkgs: [
              # add any other required packages here, either from nixpkgs or other flakes
              flakePkgs.gquery-api
            ]);

        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs =
              [
                bashInteractive
                # python-with-gquery
                redun
              ];
          };

          packages = {
            inherit redun;
            gquery-api = flakePkgs.gquery-api;
            python = python-with-gquery;
          };
        }
      );
}
