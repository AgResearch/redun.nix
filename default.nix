{ config
, lib
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
  version = "0.26.0";

  mkDerivation = {
    patches = [ ./patches/0002-Remove-console-debug-logger-115.patch ];
  };

  buildPythonPackage = {
    pyproject = true;

    pythonImportsCheck = [
      "redun"
    ];

    # mitigate duplicated packages error, where this conflicts with the nixpkgs package:
    catchConflicts = false;
  };

  paths.lockFile = "lock.${config.deps.stdenv.system}.json";
  pip = rec {
    requirementsList = [ "${config.name}==${config.version}" ] ++
      # incorporate each version specified below in `overrides` into `requirementsList`
      lib.mapAttrsToList (name: version: "${name}==${version}") (
        lib.attrsets.concatMapAttrs
          (name: spec:
            if (lib.attrsets.hasAttr "version" spec) then
              { ${name} = spec.version; }
            else
              { }
          )
          overrides
      );

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
            nativeBuildInputs = [
              config.deps.python3Packages.hatchling
              config.deps.python3Packages.setuptools-scm
            ];
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
        pyrepl = {
          buildPythonPackage.pyproject = true;
          mkDerivation = {
            nativeBuildInputs = [
              config.deps.python3Packages.hatchling
              config.deps.python3Packages.setuptools-scm
            ];
          };
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
          # match version with nixpkgs/nixos-24.05
          version = "4.11.0";

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
