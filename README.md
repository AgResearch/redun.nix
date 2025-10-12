# redun.nix

Provides the Python [redun](https://insitro.github.io/redun/) package as a Nix package.

## Usage

Consuming the flake package is the same as with any Nix flake package.  See the [example flake](examples/flake.nix), which combines `redun` and `BioPython`, and which may be used like this:

```
$ cd examples
$ nix develop
$ redun run seq.py main
```

## Upgrading to a new version of redun

Historically the Nix package for redun was build by fetching the source from GitHub.  However, the redun
developers seem not be be tagging releases on GitHub.  Their release channel is PyPI, so fetching from PyPI
is a more robust approach.

To update, find the definition of `redun` in [flake.nix](flake.nix), like this:

```
          redun = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "redun";
              version = "0.28.0";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-QBlxwQssR3cpansriKMN6bqcAWlcXhHyTjt3dtJxw4U=";
              };

             ...

            };
```

Unless dependencies have changed, it should be enough to bump the version and determine a new hash by first setting it to empty, like this:

```
          redun = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "redun";
              version = "0.32.0";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "";
              };

             ...

            };
```

Now `nix build` will fail like this:
```
> nix build
warning: Git tree '/home/guestsi/vc/agr-github/redun.nix' is dirty
warning: found empty hash, assuming 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
error: hash mismatch in fixed-output derivation '/nix/store/q650bk4s9vgmapshvwbbb0p2v6lv4h4y-redun-0.32.0.tar.gz.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-b+ihqRj8DT95dmm3uT2IqauHfrxjZiIZDjxHQH+N37c=
error: 1 dependencies of derivation '/nix/store/21rj0v8j37gv0sj9dn7hy5ypxl9px2s6-python3.12-redun-0.32.0.drv' failed to build
```

This hash should be pasted in to the `flake.nix`, like this:

```
          redun = with pkgs;
            python3Packages.buildPythonPackage rec {
              pname = "redun";
              version = "0.32.0";
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-b+ihqRj8DT95dmm3uT2IqauHfrxjZiIZDjxHQH+N37c=";
              };

             ...

            };
```

And now `nix build` should work.

If dependencies have changed, they will need to be updated in the flake.  This is straightforward for packages which exist in nixpkgs, but for those that don't, such as `pyrepl` and `fancycompleter`, it will be necessary to build them explicitly, as per those two packages.
