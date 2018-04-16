#!/usr/bin/env bash

set -e

CHANNEL=18.03
USERNAME="$USER"
SSH_KEY=$(cat "$HOME/.ssh/id_rsa.pub")
SERVER_IP=2a02:810d:200:1f84::3

# Set up initial root stuff and remove root password again
cat custom.nix | sed 's/\$USERNAME\$/'"$USERNAME"'/g;' | sed 's#\$SSH_KEY\$#'"$SSH_KEY"'#g;' > .custom.nix.tmp
scp nextcloud.nix .custom.nix.tmp "root@$SERVER_IP:/etc/nixos/"
ssh "root@$SERVER_IP" "mv /etc/nixos/.custom.nix.tmp /etc/nixos/custom.nix && nixos-rebuild switch && passwd -d root"
rm .custom.nix.tmp

# Install more .nix files, this time use the user with their ssh key instead of relying on a password
ssh "$USERNAME@$SERVER_IP" "sudo cat - > /etc/nixos/nextcloud.nix && nixos-rebuild switch" < nextcloud.nix

# TODO: Set password of user
