## |================================|
## |       Made By Rune004          |
## |    Need Support or Help?       |
## |    It can be found below.      |
## |================================|
## |            Discord:            |
## | https://discord.gg/UHd4tJg9Vm  |
## |================================|
## |            Github:             |
## |  https://github.com/rune004    |
## |================================|
# Get update and packages needed 
set -e

DEB_PACKAGE_NAME="python2.7 python2-dev libssl-dev"

 if cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Ubuntu"
    echo "==============================================="
    sudo apt-get update
    sudo apt-get install -y $DEB_PACKAGE_NAME
    sudo apt-get install curl -y
    sudo apt-get install nano -y
    sudo apt-get install sudo -y
    sudo apt-get install wget -y 
    sudo apt-get install cron -y
    sudo apt-get install dialog
    sudo dialog --create-rc ~/.dialogrc
    sudo cat ~/CnC-Public/dialog.txt > ~/.dialogrc
 elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Debian"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
    apt-get install curl -y
    apt-get install nano -y
    apt-get install wget -y 
    apt-get install sudo -y
    apt-get install cron -y
    apt-get install dialog
    dialog --create-rc ~/.dialogrc
    cat ~/CnC-Public/dialog.txt > ~/.dialogrc
 else
    echo "OS NOT DETECTED, couldn't install package $PACKAGE"
    exit 1;
 fi
#-------------------------------------------------------------------------------------------------------------------------
# Set Version 
version="v0.0.1"
export version="$version"
#-------------------------------------------------------------------------------------------------------------------------
# Set the overall script name
scriptname="RPH CnC BASH Menu"
export scriptname="$scriptname"
#-------------------------------------------------------------------------------------------------------------------------
# Get the filename for display
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
#-------------------------------------------------------------------------------------------------------------------------

# Dialog input to get username
username=$(\
  dialog --title "Login" \
         --backtitle "$scriptname - Version $version" \
         --inputbox "User:" 10 60 \
  3>&1 1>&2 2>&3 3>&- \
) ||exit
#-------------------------------------------------------------------------------------------------------------------------

# Dialog input to get the user's password
password=$(\
  dialog --title "Login" \
         --backtitle "$scriptname - Version $version" \
         --passwordbox "Password:" 10 60 \
  3>&1 1>&2 2>&3 3>&- \
) ||exit
#-------------------------------------------------------------------------------------------------------------------------
# Check user and pass against my database
user_and_pass=$(curl -sS --user  PGSj7EDLrESqn3Rbn:GgJkVVkP8H8TyDmxBiybM3gDzuCpkAuJgrhiFeicwkdvfAmLx9MzYGVWjLDfD "https://n8n-b.rp-helpdesk.com/webhook/login?user=$username&pass=$password")
#-------------------------------------------------------------------------------------------------------------------------
# Get the username from the database
userdb=$(curl -sS --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/login-user?user=$username")
#-------------------------------------------------------------------------------------------------------------------------
# Get the password from the database
passdb=$(curl -sS --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/login-pass?pass=$password")
#-------------------------------------------------------------------------------------------------------------------------
# Pull down a fresh session ID
sessionid=$(curl -sS --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/sessionid?user=$username&pass=$password")
#-------------------------------------------------------------------------------------------------------------------------
# Save session ID locally
sudo rm ~/Documents/.sessionid
echo "$sessionid" > ~/Documents/.sessionid
# Save username and password locally
sudo rm ~/Documents/.username
echo "$username" > ~/Documents/.username
sudo rm ~/Documents/.password
echo "$password" > ~/Documents/.password
#-------------------------------------------------------------------------------------------------------------------------
# Pull down the token for the downloader
token1=$(curl -sS --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/token1?sessionid=$sessionid&user=$username&pass=$password")
token2=$(curl -sS --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/token2?sessionid=$sessionid&user=$username&pass=$password")
token="$token1$token2"
#-------------------------------------------------------------------------------------------------------------------------
# Export token, user_and_pass and sessionid for later use
export username="$username"
export password="$password"
export userdb="$userdb"
export passdb="$passdb"
export user_and_pass="$user_and_pass"
export token="$token"
export sessionid="$sessionid"
#-------------------------------------------------------------------------------------------------------------------------
# Check the username and password are valid or not
if (( $username == "$userdb" && $password == "$passdb" ))
then
    clear
    dialog --title "$me" --backtitle "$scriptname - Version $version"        --msgbox "Successful login" 10 60 ;
    
    cd ~
    
    if [ -d ~/CnC ]; then
      sudo rm -r ~/CnC
      dialog --title "$me" --clear \
             --backtitle "$scriptname - Version $version" \
             --prgbox "Git Clone CnC" "git clone https://rune004:$token@github.com/rune004/CnC.git" 30 60 ;
      
      bash ~/CnC/CnC.sh
    else
      dialog --title "$me" --clear \
             --backtitle "$scriptname - Version $version" \
             --prgbox "Git Clone CnC" "git clone https://rune004:$token@github.com/rune004/CnC.git" 30 60 ;
      
      bash ~/CnC/CnC.sh
    fi

    

else 
    clear
    dialog --title "Login" --backtitle "$scriptname - Version $version" --infobox "Unsuccessful login" 10 60 ; sleep 5
fi