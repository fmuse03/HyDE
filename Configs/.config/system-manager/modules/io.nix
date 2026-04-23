{ lib, pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        kdePackages.dolphin
      ];
    };
  };
}
