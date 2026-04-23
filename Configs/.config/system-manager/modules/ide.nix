{ lib, pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        # Editors
        helix
        neovim
        vim

        # Languages
        asdf-vm
        rustup

        # Language Servers
        hyprls
        nixd
        svelte-language-server
        tombi
        typescript-language-server
        yaml-language-server

        # Terminals
        alacritty
        kitty
      ];
    };
  };
}
