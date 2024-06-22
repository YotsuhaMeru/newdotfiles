{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.locale;
in {
  options = {
    modules.locale = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
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
  };
}
