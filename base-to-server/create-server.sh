#!/usr/bin/env bash

(

set -e

ABS_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"

CHANNEL=18.03
USERNAME="$USER"
SSH_KEY_FILE="$HOME/.ssh/id_rsa"
SSH_KEY_FILE_PUBLIC="$SSH_KEY_FILE.pub"
SSH_AUTHORIZED_KEY=$(cat "$SSH_KEY_FILE_PUBLIC")
SERVER_IP="192.168.0.25"
SERVER_HOST="[$SERVER_IP]"

mkdir -p "$ABS_PATH/tmp-files"
cp "$ABS_PATH/"*.nix "$ABS_PATH/tmp-files/"

# Copy .nix files and be sure the variables are replaced by actual values
mvstring="echo Starting"

sed -i '' 's#\$USERNAME\$#'"$USERNAME"'#g;' "$ABS_PATH/tmp-files/"*.nix
sed -i '' 's#\$SSH_AUTHORIZED_KEY\$#'"$SSH_AUTHORIZED_KEY"'#g;' "$ABS_PATH/tmp-files/"*.nix

for file in $(ls -1 "$ABS_PATH/tmp-files/"*.nix)
do
  filename="$(basename $file)"
  mv "$ABS_PATH/tmp-files/$filename" "$ABS_PATH/tmp-files/$filename.tmp"
  mvstring="$mvstring && mv /etc/nixos/$filename.tmp /etc/nixos/$filename"
done

scp "$ABS_PATH/tmp-files/"* "root@$SERVER_IP:/etc/nixos/"
ssh "root@$SERVER_IP" "$mvstring && nixos-rebuild switch && passwd -d root && echo done"
rm -rf "$ABS_PATH/tmp-files"

# TODO: Set password of user

)
