{
  description = "Flake for redun using dream2nix";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
  };

  outputs =
    { self
    , dream2nix
    , nixpkgs
    ,
    }:
    let
      # A helper that helps us define the attributes below for
      # all systems we care about.
      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      packages = eachSystem (system: {
        # For each system, we define our default package
        # by passing in our desired nixpkgs revision plus
        # any dream2nix modules needed by it.
        default = dream2nix.lib.evalModules {
          packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
          modules = [
            # Import our actual package definiton as a dream2nix module from ./default.nix
            ./default.nix
            {
              # Aid dream2nix to find the project root. This setup should also works for mono
              # repos. If you only have a single project, the defaults should be good enough.
              paths.projectRoot = ./.;
              # can be changed to ".git" or "flake.nix" to get rid of .project-root
              paths.projectRootFile = "flake.nix";
              paths.package = ./.;
            }
          ];
        };
      });
    };
}
