{ lib, pkgs, ... }:
let vars = rec {
  mkCountryList = id: countries: name: {
    inherit id name;
    locations = map (country: { inherit country; }) countries;
  };
  countries = rec {
    north_america = [ "ca" "mx" "us" ];
    south_america = [ "br" "cl" "co" "pe" ];
    europe = [ "al" "at" "be" "bg" "ch" "cy" "cz" "de" "dk" "ee" "es" "fi" "fr" "gb" "gr" "hr" "hu" "ie" "it" "lv" "nl" "no" "pl" "pt" "ro" "rs" "se" "si" "sk" "tr" "ua" ];
    africa = [ "ng" "za" ];
    asia = [ "hk" "id" "il" "jp" "my" "ph" "sg" "th" ];
    oceania = [ "au" "nz" ];
    all = north_america ++ south_america ++ europe ++ africa ++ asia ++ oceania;
  };
  settings_label = "10-mullvad-settings";
  settings = pkgs.writeText settings_label (builtins.toJSON {
    auto_connect = true;
    lockdown_mode = true;

    custom_lists.custom_lists = [
      (mkCountryList "00000000-0000-0000-0000-000000000000" countries.all "All Countries")
      (mkCountryList "00000000-0000-0000-0000-000000000002" countries.north_america "North America")
      (mkCountryList "00000000-0000-0000-0000-000000000003" countries.south_america "South America")
      (mkCountryList "00000000-0000-0000-0000-000000000004" countries.europe "Europe")
      (mkCountryList "00000000-0000-0000-0000-000000000005" countries.africa "Africa")
      (mkCountryList "00000000-0000-0000-0000-000000000006" countries.asia "Asia")
      (mkCountryList "00000000-0000-0000-0000-000000000007" countries.oceania "Oceania")
    ];
    relay_settings.normal = {
      location.only.location.country = "sg";
      wireguard_constraints = {
        entry_location.only.location.country = "sg";
        use_multihop = true;
      };
    };

    obfuscation_settings = {
      selected_obfuscation = "lwo";
    };

    tunnel_options = {
      generic.enable_ipv6 = true;
      wireguard = {
        quantum_resistant = "on";
        daita = {
          use_multihop_if_necessary = true;
        };
      };
    };
  });

  tailscale_nft_label = "10-mullvad-tailscale-nftable";
  tailscale_nft = pkgs.writeText tailscale_nft_label ''
    table inet mullvad_tailscale {
      chain output {
        type route hook output priority -100; policy accept;
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      chain input {
        type filter hook input priority -100; policy accept;
        ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    }
    '';
};
in {
  config = {
    environment.etc = {
      "${vars.settings_label}" = {
        mode = "600";
        source = "${vars.settings}";
      };
      "${vars.tailscale_nft_label}" = {
        mode = "644";
        source = "${vars.tailscale_nft}";
      };
    };
    environment.systemPackages = with pkgs; [
      mullvad-vpn
    ];
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
