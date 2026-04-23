{ lib, nixosModulesPath, pkgs, ... }:
{
  config = {
    services.syncthing = {
      enable = true;
    };
    networking.hostName = "floer-star";
  };

  imports = [
    "${nixosModulesPath}/config/networking.nix"
    "${nixosModulesPath}/config/system-environment.nix"
    "${nixosModulesPath}/services/networking/mstpd.nix"
    "${nixosModulesPath}/services/networking/syncthing.nix"
    "${nixosModulesPath}/tasks/network-interfaces.nix"
  ];
}
