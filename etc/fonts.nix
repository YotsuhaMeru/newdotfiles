{ config, pkgs, ... }:

{
  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [
          "DejaVu Sans Mono"
          "IPAGothic"
        ];
        sansSerif = [
          "DejaVu Sans"
          "IPAPGothic"
        ];
        serif = [
          "DejaVu Serif"
          "IPAPMincho"
        ];
      };
    };
    packages = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
      nerdfonts
    ];
  };

}
