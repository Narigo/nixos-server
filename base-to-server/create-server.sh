#!/usr/bin/env bash

(

set -e

CHANNEL=18.03
USERNAME="$USER"
SSH_KEY_FILE="$HOME/.ssh/id_rsa"
SSH_KEY_FILE_PUBLIC="$SSH_KEY_FILE.pub"
SSH_AUTHORIZED_KEY=$(cat "$SSH_KEY_FILE_PUBLIC")
SERVER_IP="192.168.0.25"
SERVER_HOST="[$SERVER_IP]"

mkdir -p tmp-nix-files
cp *.nix tmp-nix-files/

# Copy .nix files and be sure the variables are replaced by actual values
mvstring="echo Starting"

sed -i '' 's#\$USERNAME\$#'"$USERNAME"'#g;' tmp-nix-files/*.nix
sed -i '' 's#\$SSH_AUTHORIZED_KEY\$#'"$SSH_AUTHORIZED_KEY"'#g;' tmp-nix-files/*.nix

for file in $(ls -1 tmp-nix-files/*.nix)
do
  filename=$(basename $file)
  mv tmp-nix-files/$filename tmp-nix-files/$filename.tmp
  mvstring="$mvstring && mv /etc/nixos/$filename.tmp /etc/nixos/$filename"
done

scp tmp-nix-files/*.nix.tmp "root@$SERVER_IP:/etc/nixos/"
ssh "root@$SERVER_IP" "$mvstring && nixos-rebuild switch && passwd -d root && echo done"
rm -rf tmp-nix-files

# TODO: Set password of user

)
