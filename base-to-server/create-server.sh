
CHANNEL=18.03
USERNAME=joern
SSH_KEY=$(cat "$HOME/.ssh/id_rsa.pub")
SERVER_IP=2a02:810d:200:1f84::3

cat custom.nix | sed 's/\$USERNAME\$/'"$USERNAME"'/;' | sed 's#\$SSH_KEY\$#'"$SSH_KEY"'#;' > .custom.nix.tmp
ssh root@$SERVER_IP "cat - > /etc/nixos/custom.nix && nixos-rebuild switch" < .custom.nix.tmp
rm .custom.nix.tmp

# Install more .nix files, this time use the user with their ssh key instead of relying on a password
ssh $USERNAME@$SERVER_IP "cat - > /etc/nixos/nextcloud.nix && nixos-rebuild switch" < nextcloud.nix

# TODO: Set password of user
# TODO: Remove password of root
