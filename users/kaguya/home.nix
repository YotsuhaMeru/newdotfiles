{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "kaguya";
    homeDirectory = "/home/kaguya";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    lutris
  ];
  programs.fish.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {enable = true;};
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
