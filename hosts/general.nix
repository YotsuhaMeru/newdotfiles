{pkgs, ...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # mdns service
  services.avahi = {
    enable = true;
    nssmdns = true;
    # publish/announce machine
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
      hinfo = true;
      workstation = true;
    };
  };

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

    # GTK2 fallback to ncurses when gui isn't available
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "gtk2";
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.utf8";
    LC_IDENTIFICATION = "ja_JP.utf8";
    LC_MEASUREMENT = "ja_JP.utf8";
    LC_MONETARY = "ja_JP.utf8";
    LC_NAME = "ja_JP.utf8";
    LC_NUMERIC = "ja_JP.utf8";
    LC_PAPER = "ja_JP.utf8";
    LC_TELEPHONE = "ja_JP.utf8";
    LC_TIME = "ja_JP.utf8";
  };
}
