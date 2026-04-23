{ lib, nixosModulesPath, ... }:
{
  options = with lib; {
  };
  
  imports = [
    "${nixosModulesPath}/config/nsswitch.nix"
    "${nixosModulesPath}/config/resolvconf.nix"
    "${nixosModulesPath}/services/networking/mullvad-vpn.nix"
    "${nixosModulesPath}/services/system/nscd.nix"
  ];
}
