{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # set default shell
  users.defaultUserShell = pkgs.fish;

  environment.variables.EDITOR = "vim";

  # default syspkg
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

  programs = {
    fish.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
