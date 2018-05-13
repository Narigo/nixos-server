{ config, pkgs, ... }:

{
  # imports = [ ./docker.nix ];
  services.sshd.enable = true;
  services.openssh.permitRootLogin = pkgs.lib.mkForce "no";

  systemd.services.sshd.wantedBy = [ "multi-user.target" ];

  security.sudo.enable = pkgs.lib.mkForce true;
  security.sudo.configFile = ''
root		ALL = (ALL) ALL
%wheel		ALL = (ALL) ALL
'';

  virtualisation.docker.enable = true;

  users = {
    mutableUsers = false;

    users.$USERNAME$ = {
      isNormalUser = true;
      home = "/home/$USERNAME$";
      description = "$USERNAME$";
      extraGroups = [ "sudoers" "wheel" "docker" ];
      openssh.authorizedKeys.keys = [ "$SSH_AUTHORIZED_KEY$" ];
    };
  };

}