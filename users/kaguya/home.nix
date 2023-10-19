{ config, pkgs, ... }:

{
  home = {
    username = "kaguya";
    homeDirectory = "/home/kaguya";
  };

  programs.fish.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".doom.d/themes/catppuccin-theme.el".source = pkgs.fetchFromGitHub
    {
      owner = "catppuccin";
      repo = "emacs";
      rev = "fa9e421b5e041217d4841bea27384faa194deff6";
      sha256 = "rUvY6yautK+5wvHy8oteGo4Lftip1h5He9ejADso0Ag=";
    } + "/catppuccin-theme.el";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
