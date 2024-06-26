_: {
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "ririko";
    homeDirectory = "/home/ririko";
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };

  programs.fish.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
