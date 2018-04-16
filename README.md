# nixos-server

Setting up my NixOS home server.

This will be split into two parts. The first one is getting an SSH daemon running as quick as possible. The second part
means setting up the complete system through SSH.

## Set up the base installation for a server

1. Install NixOS on an SD card
  a. Download the RaspberryPi image
  b. Use `dd` to write it on the SD card
2. Boot up the RaspberryPi with a monitor and keyboard connected.
3. curl and run the intialization file. For example `sh <(curl -s 192.168.0.10:5500/init-to-base/init.sh)` when running
   the VS-Code live reload server.
4. Set a password during the installation and use it to access the RaspberryPi for the second part.

## Set up the server through SSH

Run the `create-server.sh` script to set up the user and add the users SSH key.
