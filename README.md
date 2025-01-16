# redun.nix

Provides the Python [redun](https://insitro.github.io/redun/) package as a Nix Python package.

## Usage

Consuming the flake package is the same as with any Nix Python flake package, except that care must be taken to match the version of nixpkgs being used with the corresponding tag in this repo.  Otherwise Python package version conflicts may occur.

To install redun from a branch in the repo, e.g. main:

```
$ nix build github:AgResearch/redun.nix/main
```

Or having cloned the repo locally, build the flake from the current repo:

```
$ nix build
```

When building the consuming flake for the first time, or after changing to a different version, you will be prompted to create or update the lock file, so simply run `bash` with the given arguments (not exactly as this example):

```
error: The lock file ./lock.x86_64-linux.json
  for drv-parts module 'redun' is outdated.

To create or update the lock file, run:
  bash -c $(nix-build /nix/store/99mkr6pbx2f3z8xwv1fb5gxp85z66cj5-refresh.drv --no-link)/bin/refresh
```



## Local Build



## Version Update

To update for a new version, set the version of redun and nixpkgs required in the flake, then:

```
nix run '.#default.lock'
```

