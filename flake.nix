{
  description = "Flake for gbs_prism";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
          };

          pyrepl = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "pyrepl";
              version = "0.11.3";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-qYGnkogRvaV8o76wxnTUFM8Kcfy5o3tnbtQV/QCBdK0=";
              };
              pyproject = true;

              nativeBuildInputs = with python3Packages;
                [
                  setuptools
                  setuptools_scm
                ];
            };

          fancycompleter = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "fancycompleter";
              version = "0.11.1";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-W0rWXXazKxJZJRUW0PHLLYKDKx/4UGaXpwcoR4B1f2k=";
              };
              pyproject = true;

              nativeBuildInputs = with python3Packages;
                [
                  setuptools
                  setuptools_scm
                ];

              propagatedBuildInputs = [
                pyrepl
              ];
            };

          # redun tends to crash when using recent textual, so fix this at an older version for now
          older-version-of-textual = pkgs.python3Packages.textual.overridePythonAttrs (_: rec {
            version = "1.0.0";
            src = pkgs.fetchPypi {
              pname = "textual";
              inherit version;
              sha256 = "sha256-vsn+Y1R8HFUladG3XTCQOLfUVsA/ht+jcG3bCZsVE5k=";
            };
            doCheck = false;
          });

          redun = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "redun";
              version = "0.28.0";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-QBlxwQssR3cpansriKMN6bqcAWlcXhHyTjt3dtJxw4U=";
              };

              format = "setuptools";

              doCheck = false;

              nativeBuildInputs = with python3Packages;
                [
                  setuptools
                ];

              buildInputs = with python3Packages;
                [
                  packaging
                ];

              propagatedBuildInputs = with python3Packages;
                [
                  aiobotocore
                  aiohappyeyeballs
                  aiohttp
                  aioitertools
                  aiosignal
                  alembic
                  attrs
                  awscli
                  boto3
                  botocore
                  certifi
                  charset-normalizer
                  colorama
                  docutils
                  fancycompleter
                  frozenlist
                  fsspec
                  greenlet
                  idna
                  jmespath
                  linkify-it-py
                  mako
                  markdown-it-py
                  markupsafe
                  mdit-py-plugins
                  mdurl
                  multidict
                  platformdirs
                  propcache
                  pyasn1
                  pygments
                  pyrepl
                  python-dateutil
                  pyyaml
                  requests
                  rich
                  rsa
                  s3fs
                  s3transfer
                  six
                  sqlalchemy

                  # awaiting https://github.com/insitro/redun/issues/122 before using textual from nixpkgs:
                  # textual
                  older-version-of-textual

                  typing-extensions
                  uc-micro-py
                  urllib3
                  wrapt
                  yarl
                ];
            };

        in
        {
          packages = {
            default = redun;

            inherit fancycompleter pyrepl;
          };
        });
}
