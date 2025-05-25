# compatability wrapper for dream2nix Python packages
{ lib
, python3
, python3Packages
  # dream2nix package to be wrapped:
, package
  # packages from nixpkgs to replace in the wrapped package, to avoid collisions downstream
, replacePropagatedBuildInputs ? [ ]
}:
let
  inherit (python3) sitePackages;
  inherit (python3Packages) buildPythonPackage;

  # get the name, e.g. alembic from python3.12-alembic-1.15.2
  pythonPackageName = pkg: builtins.elemAt (lib.strings.splitString "-" pkg.name) 1;

  replacePackageNames = builtins.map pythonPackageName replacePropagatedBuildInputs;
  filteredPropagatedBuildInputs = builtins.filter (pkg: ! builtins.elem (pythonPackageName pkg) replacePackageNames) package.config.mkDerivation.propagatedBuildInputs;
  propagatedBuildInputs = filteredPropagatedBuildInputs ++ replacePropagatedBuildInputs;

in
buildPythonPackage
{
  pname = package.name;
  version = package.version;
  src = package;
  inherit propagatedBuildInputs;

  format = "other";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/${sitePackages}
    cp -r ${package.config.public}/${sitePackages}/* $out/${sitePackages}/
    cp -r ${package.config.public}/bin/* $out/bin/
  '';
}
