{lib, ...}: let
  folder = ./.;
  toImport = name: _value: folder + ("/" + name);
  filterServiceFiles = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterServiceFiles (builtins.readDir folder));
in {
  inherit imports;
}
