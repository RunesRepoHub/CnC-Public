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

docker stop $SCRIPT > /dev/null 2>&1
docker rm $SCRIPT > /dev/null 2>&1
docker volume prune -y > /dev/null 2>&1

docker run -i -d --name="$SCRIPT" debian:10 > /dev/null 2>&1
docker exec -i $SCRIPT /bin/bash > /dev/null 2>&1
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get install curl -y > /dev/null 2>&1
apt-get install git -y > /dev/null 2>&1
apt-get install sudo -y > /dev/null 2>&1
apt-get install dialog > /dev/null 2>&1
cd root > /dev/null 2>&1
git clone https://github.com/rune004/CnC-Public.git > /dev/null 2>&1