{ config
, lib
, dream2nix
, ...
}: {
  imports = [
    dream2nix.modules.dream2nix.pip
  ];

  deps = { nixpkgs, ... }: {
    python = nixpkgs.python311;
    inherit
      (nixpkgs)
      # pkg-config
      # zlib
      # libjpeg
      gcc
      ;
  };

  name = "redun";
  version = "0.22.0";

  mkDerivation = {
    nativeBuildInputs = [
      config.deps.gcc
    ];
    #   # propagatedBuildInputs = [
    #   # ];
  };

  buildPythonPackage = {
    pythonImportsCheck = [
      "redun"
    ];
  };

  paths.lockFile = "lock.${config.deps.stdenv.system}.json";
  pip = {
    requirementsList = [ "${config.name}==${config.version}" ];
    pipFlags = [
      "--no-binary"
      ":all:"
    ];
  };
}
