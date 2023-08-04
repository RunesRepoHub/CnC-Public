# Set Version 
version="v0.0.5"
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

# Dialog input to get the user's passwordz
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
userdb=$(curl -s --user $user_and_pass PGSj7EDLrESqn3Rbn:GgJkVVkP8H8TyDmxBiybM3gDzuCpkAuJgrhiFeicwkdvfAmLx9MzYGVWjLDfD "https://n8n-b.rp-helpdesk.com/webhook/login-user?user=$username")
#-------------------------------------------------------------------------------------------------------------------------
# Get the password from the database
passdb=$(curl -s --user $user_and_pass PGSj7EDLrESqn3Rbn:GgJkVVkP8H8TyDmxBiybM3gDzuCpkAuJgrhiFeicwkdvfAmLx9MzYGVWjLDfD "https://n8n-b.rp-helpdesk.com/webhook/login-pass?pass=$password")
#-------------------------------------------------------------------------------------------------------------------------
# Pull down a fresh session ID
sessionid=$(curl -s --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/sessionid")
#-------------------------------------------------------------------------------------------------------------------------
# Save session ID locally
sudo rm ~/Documents/.sessionid
echo "$sessionid" >> ~/Documents/.sessionid
#-------------------------------------------------------------------------------------------------------------------------
# Pull down the token for the downloader
token=$(curl -s --user $user_and_pass "https://n8n-b.rp-helpdesk.com/webhook/token?sessionid=$sessionid")
#-------------------------------------------------------------------------------------------------------------------------
# Export token, user_and_pass and sessionid for later use
export user_and_pass="$user_and_pass"
export token="$token"
export sessionid="$sessionid"
#-------------------------------------------------------------------------------------------------------------------------
# Check the username and password are valid or not
if (( $user == "$userdb" && $pass == "$passdb" && $sessionid == "$sessionid" ))
then
    clear
    dialog --title "Login" --backtitle "$scriptname - Version $version" --infobox "Successful login" 10 60 ; sleep 5
else 
    clear
    dialog --title "Login" --backtitle "$scriptname - Version $version" --infobox "Unsuccessful login" 10 60 ; sleep 5
fi