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
      fetchFromGitHub
      gcc
      python3Packages
      ;
  };

  name = "redun";
  version = "0.25.0";

  mkDerivation = {
    src = config.deps.fetchFromGitHub {
      # use own fork until this is fixed:
      # https://github.com/insitro/redun/issues/109
      owner = "tesujimath";
      repo = "redun";
      rev = "75b1dcb3f2ee3174a36afa60182c84ce00777e90";
      hash = "sha256-lAqRkdio14kabms0OLFHFBE+VWXcWfVIRK6tCIcbRv0=";
    };
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
