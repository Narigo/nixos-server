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

On the RaspberryPi, you might want to run a server. The easiest way to do so is to dockerize everything and run docker.

1. Run the `create-server.sh` script to set up the user and add the users SSH key.
2. `cd nextcloud-docker`
3. Run the necessary docker commands.

### Setting up nginx server + NextCloud

```
# create a volume for NextClouds App / Config
docker volume create --name nextcloud -o type=none -o device=/my/path/nextcloud -o o=bind
# create a volume for PostgreSQL databases
docker volume create --name db -o type=none -o device=/my/path/db -o o=bind

# Start PostgreSQL
POSTGRES_DB="" POSTGRES_USER="" POSTGRES_PASSWORD="" POSTGRES_HOST="" docker run -d --name db --hostname db -v db:/var/lib/postgresql/data postgres

# Start NextCloud with the volume mounted
docker run -d --name nextcloud --hostname nextcloud --link db -v nextcloud:/var/www/html nextcloud:fpm

# Build nginx
docker build -t nginx ./web

# Start nginx with NextCloud linked
docker run -d --name nginx --hostname nginx --link nextcloud -v nextcloud:/var/www/html nginx
```

# TODO document commands to start nextcloud, postgresql, letsencrypt and nginx server
```

### Setting up automatic backups

TBD
