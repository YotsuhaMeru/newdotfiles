{lib, ...}:
with lib; {
  options.var.username = mkOption {
    default = null;
    type = types.nullOr types.str;
  };
  options.var.tempusername = mkOption {type = types.str;};
}
