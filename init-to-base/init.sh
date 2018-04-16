#!/usr/bin/env bash

set -e

cat <<END
Hi there!

This script will set up an OpenSSH server on your RaspberryPi and open it for
remote connections. It will be ready for incoming connections so you do not
have to do the next steps with a monitor and keyboard connected to your 
RaspberryPi.

You will be asked for a password to secure the OpenSSH server. When you can
connect via SSH and run the installation script, it will be changed to a more
secure connection with ssh keys.

END

echo -n "Please enter a password for the OpenSSH server: "
read -s sshpass; echo;

# setting the root password to the given password!
echo "root:$sshpass" | chpasswd

ipaddr=$(hostname -i | awk '{ print $1 }')

echo "Run the following command as soon as the OpenSSH service is up:"
echo
echo "    ssh root@$ipaddr"
echo
echo -n "Starting OpenSSH server ..."
systemctl start sshd
echo " done!"

# nixos switch configuration and enable the SSH server
CONFIGURATION_NIX=$(cat <<END_OF_FILE
{ config, pkgs, ... }:

{
  imports = [ ./base-installation.nix ./custom.nix ];
}
END_OF_FILE
)

# nixos switch configuration and enable the SSH server
CUSTOM_CONFIGURATION_NIX=$(cat <<END_OF_FILE
{ config, pkgs, ... }:

{ services.openssh.enable = true;
  services.openssh.permitRootLogin = pkgs.lib.mkForce "yes";

  systemd.services.sshd.wantedBy = pkgs.lib.mkOverride 40 [ "multi-user.target" ];
}
END_OF_FILE
)

if [ ! -e /etc/nixos/base-installation.nix ]; then
  mv -n /etc/nixos/configuration.nix /etc/nixos/base-installation.nix
  echo "$CONFIGURATION_NIX" > /etc/nixos/configuration.nix
  echo "Configuration changed."
else
  echo "Not touching base configuration."
fi

echo "$CUSTOM_CONFIGURATION_NIX" > /etc/nixos/custom.nix

nixos-rebuild switch
