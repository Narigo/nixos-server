{ config, pkgs, ... }:

{
  imports = [ "./nextcloud.nix" ];
  services.sshd.enable = true;
  services.sshd.permitRootLogin = pkgs.lib.mkOverride 40 "no";

  systemd.services.sshd.wantedBy = pkgs.lib.mkOverride 40 [ "multi-user.target" ];

  security.sudo.enable = true;
  security.sudo.configFile = ''
root		ALL = (ALL) ALL
%wheel		ALL = (ALL) ALL
'';

  users.users.$USERNAME$ = {
    isNormalUser = true;
    home = "/home/$USERNAME$";
    description = "$USERNAME$";
    extraGroups = [ "sudoers" "wheel" ];
    openssh.authorizedKeys.keys = [ "$SSH_KEY$" ];
  };

}