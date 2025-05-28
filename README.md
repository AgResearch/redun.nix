# redun.nix

Provides the Python [redun](https://insitro.github.io/redun/) package as a Nix package.

## Usage

Consuming the flake package is the same as with any Nix flake package.  See the [example flake](examples/flake.nix), which combines `redun` and `BioPython`, and which may be used like this:

```
$ cd examples
$ nix develop
$ redun run seq.py main
```
