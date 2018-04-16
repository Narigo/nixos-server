{ config, pkgs, ... }:

{
  users.users.nextcloud = {
    isNormalUser = false;
    home = "/home/nextcloud";
    description = "NextCloud user";
    extraGroups = [ "nextcloud" ];
  };
}
