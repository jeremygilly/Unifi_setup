# Connect to Unifi at the University of Western Australia
# To download: 
# Usage: sudo bash unifi.sh
# For more information, please visit: https://www.raspberrypi.org/forums/viewtopic.php?f=36&t=111100&p=1272692#p1272692
# For example files, please visit: https://github.com/jeremygilly/Unifi_setup

printf "This program will overwrite your /etc/dhcpcd.conf file. In most cases, this is fine."
printf "However, just in case, this program will copy your file to /etc/dhcpcd_old.conf so you'll still have it."
printf "Quit the program now (Ctrl+c) if you don't want this to happen and update the files manually.\n"

read -p "UWA ID number: " UWAID
read -s -p "UWA Password: " UWAPASSWORD
hash=$(echo -n $UWAPASSWORD | iconv -t utf16le | openssl md4)
hash=${hash#*= }
printf "Received successfully. Thank you.\n"

wpa_supplicant_location="/etc/wpa_supplicant/wpa_supplicant.conf"
supp_txt="network={\n\tssid="'"'Unifi'"'"\n\tpriority=1\n\tproto=RSN\n\tkey_mgmt=WPA-EAP\n\tpairwise=CCMP\n\tauth_alg=OPEN\n\teap=PEAP\n\tidentity="'"'${UWAID}'"'"\n\tpassword=hash:${hash}\n\tphase1="'"'peaplevel=0'"'"\n\tphase2="'"'auth=MSCHAPV2'"'"\n}"      

if grep -Fqrn $wpa_supplicant_location -e 'Unifi'
then 
	sudo sed -i "s/.*identity.*/	identity="'"'${UWAID}'"'"/g" $wpa_supplicant_location
	sudo sed -i "s/.*password.*/	password=hash:${hash}/g" $wpa_supplicant_location
else 
	sudo sed -i "s/.*priority=1.*/''/g" $wpa_supplicant_location
	sudo sed -i "$ a #The following are the Unifi settings." $wpa_supplicant_location
	sudo sed -i "$ a $supp_txt" $wpa_supplicant_location
fi

dir=$(dirname $(readlink -f $0))
sudo mv /etc/dhcpcd.conf /etc/dhcpcd_old.conf
sudo cp $dir/dhcpcd.conf /etc/dhcpcd.conf

printf "Restarting networking service.\n"
sudo service networking restart

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then 
	printf "Internet connected! Congratulations.\n"
else
	printf "\nUnifi connection failed. :(\n"
	printf "\nPlease check your password. If you're sure it's correct, please keep reading.\n"
	printf "\nCheck that the /etc/network/interfaces file matches https://github.com/jeremygilly/Unifi_setup/blob/master/interfaces"
	printf "\nAnd, please check that the /etc/wpa_supplicant/wpa_supplicant.conf file matches https://github.com/jeremygilly/Unifi_setup/blob/master/wpa_supplicant.conf"
	printf "\n\nAlso check the readme on https://github.com/jeremygilly/Unifi_setup/"
	printf "\nBe sure to remove anything that doesn't fit."
	printf "\n\nYour ID was $UWAID"
	printf "\nYour password hash was $hash"
	printf "\n\nFor more information, please google wpa_supplicant and enterprise networks or go to https://www.raspberrypi.org/forums/viewtopic.php?f=36&t=111100&p=1272692#p1272692\n"
fi
