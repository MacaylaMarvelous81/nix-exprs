{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}:
lib.filesystem.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./pkgs;
}
