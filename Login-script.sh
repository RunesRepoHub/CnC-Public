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
# Pull down a fresh session ID
sessionid=$(curl -s --user $user_and_pass https://n8n-b.rp-helpdesk.com/webhook/sessionid)
#-------------------------------------------------------------------------------------------------------------------------
# Save session ID locally
echo "$sessionid" >> ~/Documents/.sessionid
#-------------------------------------------------------------------------------------------------------------------------
# Pull down the token for the downloader
token=$(curl -s --user $user_and_pass https://n8n-b.rp-helpdesk.com/webhook/token?sessionid=$sessionid)
#-------------------------------------------------------------------------------------------------------------------------
# Export token, user_and_pass and sessionid for later use
export user_and_pass="$user_and_pass"
export token="$token"
export sessionid="$sessionid"
#-------------------------------------------------------------------------------------------------------------------------