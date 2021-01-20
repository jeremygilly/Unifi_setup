# How to connect to Unifi at the UWA

This will hopefully assist anyone looking to connect to Unifi at University of Western Australia.

For further information, please check out: https://www.raspberrypi.org/forums/viewtopic.php?f=36&t=111100&p=1272692#p1272692

Remember to place the files in this repo in their correct locations on your RPi (or edit the appropriate files to match these ones). The correct file locations are listed as a comment at the head of each file.

Easy implementation: Use your phone as a wireless hotspot and connect to the internet, then:
```
git clone git://github.com/jeremygilly/Unifi_setup.git
sudo bash unifi.sh
```

## Details
This script leaves the /etc/network/interfaces file untouched. You can check that your version of the file is the correct one by looking at the interfaces file in this repo.

This script copies the dhcpch.conf file from this repo to your Raspberry Pi. Beware this will overwrite changes you have made.
You may choose to only copy the last three lines of the dhcpcd.conf file from this repo to your file if you have implemented custom networking (e.g. static IPs, custom ethernet settings, etc)

This script adds the network={...} items to the /etc/wpa_supplicant/wpa_supplicant.conf file and attempts to keep the user's previous settings. This may not always work, so you should check the repo's version and your version manually.

Good luck.
