{ config, pkgs, ...}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes"; 

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
  programs.fish.enable = true;

  # default syspkg
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

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
