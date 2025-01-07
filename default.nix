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
      python311Packages
      ;
  };

  name = "redun";
  version = "0.22.0";

  # mkDerivation = {
  #   nativeBuildInputs = [
  #     config.deps.python311Packages.setuptools
  #   ];
  #   # propagatedBuildInputs = [
  #   # ];
  # };

  buildPythonPackage = {
    pyproject = true;

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

    nativeBuildInputs = [
      config.deps.gcc
    ];

    overrides = {
      aiohappyeyeballs = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.poetry-core
        ];
      };
      aioitertools = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.flit
        ];
      };
      attrs = {
        buildPythonPackage.pyproject = true;
        mkDerivation = {
          patches = [ ./patches/attrs-24.3.0.license-files.patch ];

          nativeBuildInputs = [
            config.deps.python311Packages.hatchling
            config.deps.python311Packages.hatch-vcs
            config.deps.python311Packages.hatch-fancy-pypi-readme
          ];
        };
      };
      colorama = {
        buildPythonPackage.pyproject = true;
        mkDerivation = {
          nativeBuildInputs = [
            config.deps.python311Packages.hatchling
            # config.deps.python311Packages.hatch-vcs
            # config.deps.python311Packages.hatch-fancy-pypi-readme
          ];
        };
      };
      frozenlist = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.expandvars
          config.deps.python311Packages.cython
        ];
      };
      fsspec = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.hatchling
          config.deps.python311Packages.hatch-vcs
        ];
      };
      idna = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.flit
        ];
      };
      mdurl.buildPythonPackage.pyproject = true;
      platformdirs = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.hatchling
          config.deps.python311Packages.hatch-vcs
        ];
      };
      propcache = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.expandvars
          config.deps.python311Packages.cython
        ];
      };
      typing-extensions = {
        buildPythonPackage.pyproject = true;
        mkDerivation.nativeBuildInputs = [
          config.deps.python311Packages.flit
        ];
      };
    };
  };
}
