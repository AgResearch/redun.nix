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

    overrides =
      {
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
            ];
          };
        };
        fancycompleter = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            patches = [ ./patches/fancycompleter-0.9.1.pyproject.patch ];

            nativeBuildInputs = [
              config.deps.python311Packages.distutils
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
        markdown-it-py = {
          buildPythonPackage.pyproject = true;
        };
        mdit-py-plugins = {
          buildPythonPackage = {
            pyproject = true;
          };
          mkDerivation = {
            nativeBuildInputs = [
              config.deps.python311Packages.flit
            ];

            preInstallPhases = [ ]; # inhibit pythonRuntimeDepsCheck because markdown-it-py is not available yet
          };
        };
        mdurl = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python311Packages.flit
          ];
        };
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
        pygments = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python311Packages.hatchling
          ];
        };
        typing-extensions = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python311Packages.flit
          ];
        };
        urllib3 = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python311Packages.hatchling
            config.deps.python311Packages.hatch-vcs
          ];
        };
      };
  };
}
