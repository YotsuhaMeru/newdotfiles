{
  config,
  pkgs,
  ...
}: {
  users.users."${config.var.username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUjt8Q4FYx79MfBQpN533bK2UTYk/H2TXAuM06bMyvP yotsuhameru@yotsuhameru.key"
  ];
  
}
