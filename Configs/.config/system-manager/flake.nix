{
  description = "Standalone System Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-system-graphics,
      system-manager,
      ...
    }:
    let
      pathDir = "/run/system-manager/sw";
    in {
      systemConfigs.default = system-manager.lib.makeSystemConfig {
        modules = [
          nix-system-graphics.systemModules.default
          {
            environment.extraInit = ''
              export TERMINFO_DIRS="${pathDir}/share/terminfo:''${TERMINFO_DIRS}"
              export XDG_DATA_DIRS="${pathDir}/share/:''${XDG_DATA_DIRS}"
              '';
            environment.pathsToLink = [ "/bin" "/share" ];
            nixpkgs.hostPlatform = "x86_64-linux";
            system-graphics.enable = true;
            system-manager.allowAnyDistro = true;
          }
          ./modules/ai.nix
          ./modules/cli.nix
          ./modules/deco.nix
          ./modules/ide.nix
          ./modules/io.nix
          ./modules/net.nix
          ./modules/syncthing.nix
        ];

        overlays = [
          (self: super:
            let
              optimizePkg = pkg: {
                "${pkg}" = super."${pkg}".override { stdenv = super.impureUseNativeOptimizations super.stdenv; };
              };
            in {}
          )
        ];
      };
    };
}
