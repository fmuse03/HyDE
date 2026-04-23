{ lib, pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        llama-cpp-vulkan
      ];
    };
  };
}
