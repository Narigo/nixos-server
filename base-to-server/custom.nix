{ config, pkgs, ... }:

{
  imports = [ nextcloud.nix ];
  services.sshd.enable = true;
  services.sshd.permitRootLogin = pkgs.lib.mkOverride 40 "no";

  systemd.services.sshd.wantedBy = pkgs.lib.mkOverride 40 [ "multi-user.target" ];

  users.users.joern = {
    isNormalUser = true;
    home = "/home/$USERNAME$";
    description = "$USERNAME$";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "$SSH_KEY$" ];
  };

}