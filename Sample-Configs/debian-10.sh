## |--------------------------------|
## |       Made By Rune004          |
## |    Need Support or Help?       |
## |    It can be found below.      |
## |                                |
## |            Discord:            |
## | https://discord.gg/UHd4tJg9Vm  |
## |                                |
## |            Github:             |
## |  https://github.com/rune004    |
## |--------------------------------|
SCRIPT="Debian-10"

docker stop $SCRIPT
docker rm $SCRIPT
docker volume prune -y

docker run -i -d --name="$SCRIPT" debian:10
docker exec -i $SCRIPT /bin/bash
apt-get update
apt-get upgrade -y
apt-get install curl -y
apt-get install git -y
apt-get install sudo -y
apt-get install dialog
cd root