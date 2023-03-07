#!/bin/bash

### Raspberry Pi static IP configuration ###

## (Not needed) Add the following line in /etc/network/interfaces
##    iface wlan0 inet manual

# Add the following on top of /etc/dhcpcd.conf
    interface wlan0
    static ip_address=10.194.65.164/24
    static routers=10.194.64.1
    static domain_name_servers=10.10.1.2 10.10.2.2

# Add the following to /etc/wpa_supplicant/wpa_supplicant.conf
    network={
        ssid="IITD_IOT"
        scan_ssid=1
        psk="`cat /sys/class/net/wlp59s0/address`"
        key_mgmt=WPA-PSK
    }

# Run the following
    sudo wpa_cli -i wlan0 reconfigure
    sudo service dhcpcd restart

# For autostart, add the following to /etc/xdg/autostart/LinuxDLMSServer.desktop
    [Desktop Entry]
    Type=Application
    Name=DLMS Server
    Exec=lxterminal -l
    TryExex=cd /home/pi/Desktop/DLMS-COSEM-master/build/src/Linux && ./Linux -S
    Hidden=false

# Try rebooting.
