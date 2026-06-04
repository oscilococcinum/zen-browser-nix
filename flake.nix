{
  inputs = {
    zen-appimage = {
      url = "https://github.com/zen-browser/desktop/releases/download/1.19.8b/zen-x86_64.AppImage";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      packages = builtins.listToAttrs (
        map (system: {
          name = system;
          value =
            with import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }; rec {

              zen-appimage = pkgs.callPackage (import ./pkg/appimage-default.nix) {
                src = inputs.zen-appimage;
                pname = "zen";
                version = "1.19.8b";
              };

              default = zen-appimage;
            };
        }) [ "x86_64-linux" ]
      );
    };
}
