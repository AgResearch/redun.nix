{
  description = "Example of consuming redun flake package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    redun = {
      # url = "github:AgResearch/redun.nix?ref=refs/tags/24.05";
      url = "github:AgResearch/redun.nix/dev";
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

          python-with-redun = pkgs.python3.withPackages (python-pkgs: [
            flakePkgs.redun
            # add any other required packages here, either from nixpkgs or other flakes
          ]);

        in
        with pkgs;
        {
          devShells = {
            default = mkShell {
              buildInputs =
                [
                  bashInteractive
                  python-with-redun
                ];
            };
          };

          packages = {
            default = python-with-redun;
          };
        }
      );
}

