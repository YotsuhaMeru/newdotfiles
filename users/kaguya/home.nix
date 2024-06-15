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
    python3
    ripgrep
  ];
  programs = {
    fish.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: [
        epkgs.vterm
      ];
    };

    direnv = {
      enable = true;
      nix-direnv = {enable = true;};
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    home-manager.enable = true;
  };

  home.stateVersion = "23.05";
}
