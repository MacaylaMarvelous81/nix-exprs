args@{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs args,
  lib ? pkgs.lib,
  erosanix ? import (fetchTarball "https://github.com/rhinofi/flake-compat/archive/55cdfe245f739b2b33d2037589fa7e0a0376efa4.tar.gz") { src = sources.erosanix; impureOverrides = { nixpkgs = sources.nixpkgs; }; },
  # erosanix ? import sources.erosanix { inherit pkgs; },
  mkWindowsApp ? erosanix.defaultNix.lib."${ builtins.currentSystem }".mkWindowsApp,
  ...
}:
lib.filesystem.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  newScope = extra: lib.callPackageWith (pkgs // extra // {
    inherit mkWindowsApp;
  });
  directory = ./pkgs;
}
