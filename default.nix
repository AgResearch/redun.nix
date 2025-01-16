{ config
, dream2nix
, ...
}: {
  imports = [
    dream2nix.modules.dream2nix.pip
  ];

  deps = { nixpkgs, ... }: {
    python = nixpkgs.python3;
    inherit
      (nixpkgs)
      gcc
      python3Packages
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
        aiobotocore = {
          buildPythonPackage.pyproject = true;
        };
        aiohappyeyeballs = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.poetry-core
          ];
        };
        aioitertools = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.flit
          ];
        };
        attrs = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            patches = [ ./patches/attrs-24.3.0.license-files.patch ];

            nativeBuildInputs = [
              config.deps.python3Packages.hatchling
              config.deps.python3Packages.hatch-vcs
              config.deps.python3Packages.hatch-fancy-pypi-readme
            ];
          };
        };
        colorama = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            nativeBuildInputs = [
              config.deps.python3Packages.hatchling
            ];
          };
        };
        fancycompleter = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            patches = [ ./patches/fancycompleter-0.9.1.pyproject.patch ];
          };
        };
        frozenlist = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.cython
            config.deps.python3Packages.expandvars
          ];
        };
        fsspec = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.hatchling
            config.deps.python3Packages.hatch-vcs
          ];
        };
        idna = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.flit
          ];
        };
        markdown-it-py = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.flit
          ];
        };
        linkify-it-py = {
          buildPythonPackage.pyproject = true;
        };
        mdit-py-plugins = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            nativeBuildInputs = [
              config.deps.python3Packages.flit
              config.deps.python3Packages.markdown-it-py
            ];
          };
        };
        mdurl = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.flit
          ];
        };
        platformdirs = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            patches = [ ./patches/platformdirs-4.3.6.hatchling-version.patch ];

            nativeBuildInputs = [
              config.deps.python3Packages.hatchling
              config.deps.python3Packages.hatch-vcs
            ];
          };
        };
        propcache = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.cython
            config.deps.python3Packages.expandvars
          ];
        };
        pygments = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.hatchling
          ];
        };
        python-dateutil = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            patches = [ ./patches/python-dateutil-2.9.0.post0.setuptools-scm-version.patch ];

            nativeBuildInputs = [
              config.deps.python3Packages.setuptools-scm
            ];
          };
        };
        rich = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.poetry-core
          ];
        };
        textual = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.poetry-core
          ];
        };
        typing-extensions = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.flit
          ];
        };
        uc-micro-py = {
          buildPythonPackage.pyproject = true;
        };
        urllib3 = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.hatchling
            config.deps.python3Packages.hatch-vcs
          ];
        };
        yarl = {
          buildPythonPackage.pyproject = true;
          mkDerivation.nativeBuildInputs = [
            config.deps.python3Packages.cython
            config.deps.python3Packages.expandvars
          ];
        };
      };
  };
}
