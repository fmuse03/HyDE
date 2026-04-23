{ lib, pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        _7zip-zstd
        bat
        dex
        dragon-drop
        duf
        eza
        fd
        fzf
        imagemagick
        jq
        lazygit
        ripgrep
        ripgrep-all
        tealdeer
        yazi
        zoxide
      ];
    };
  };
}
