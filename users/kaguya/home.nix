{pkgs, ...}: {
  home = {
    username = "kaguya";
    homeDirectory = "/home/kaguya";
    stateVersion = "23.05";
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
}
