{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    appimage-file-beta = {
      url = "https://github.com/zen-browser/desktop/releases/download/1.7.3b/zen-x86_64.AppImage";
      flake = false;
    };
    appimage-file-twilight = {
      url = "https://github.com/zen-browser/desktop/releases/download/twilight/zen-x86_64.AppImage";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {

          zen-beta-appimage = pkgs.callPackage (import ./zen-browser/appimage-default.nix) { src = inputs.appimage-file-beta; pname = "zen"; version = "beta"; };

          zen-twilight-appimage = pkgs.callPackage (import ./zen-browser/appimage-default.nix) { src = inputs.appimage-file-twilight; pname = "zen"; version = "twilight"; };

          default = zen-beta-appimage;
        };
      })[ "x86_64-linux" ]);
  };
}
