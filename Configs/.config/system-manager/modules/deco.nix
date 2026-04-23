{ lib, pkgs, ... }:
{
  config = {
    environment = {
      systemPackages = with pkgs; [
        # Fonts
        cozette
        noto-fonts
        texlivePackages.gnu-freefont
        ttf-indic
        ## Code
        nerd-fonts.caskaydia-mono
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.fira-code
        ## Languages
        koruri
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        ## Symbol
        arphic-uming # Kaomoji
        material-symbols
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji
        texlivePackages.fontawesome7
      ];
    };
  };
}
