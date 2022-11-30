#!/bin/bash

# Installing dhcpcd5
apt install dhcpcd5 -y

# Installing rfkill
apt install rfkill -y

# Installing hostapd
apt install hostapd -y 
systemctl unmask hostapd
systemctl enable hostapd

# Installing dnsmasq
apt install dnsmasq -y

# Installing netfilter-persistent & iptables-persistent
DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

# Configuring dhcpcd.conf
sed -i '$a interface wlann0 \n    static ip_address=192.168.4.1/24 \n    nohook wpa_supplicant' /etc/dhcpcd.conf

# Configuring routed-ap.conf
sed -i 'net.ipv4.ipforeard=1' /etc/sysctl.d/routed-ap.conf

# Configuring firewall rules
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
netfilter-persistent save

# Configuring dnsmasq.conf.orig
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
echo 'interface=wlan0' > /etc/dnsmasq.conf 
sed -i '$a hcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h\ndomain=wlan\naddress=/gw.wlan/192.168.4.1' /etc/dnsmasq.conf

# Configuring rfkill
rfkill unblock wlan

# Configuring hostapd.conf
echo 'country_code=AR' > /etc/hostapd/hostapd.conf
sed -i '$a interface=wlan0\nssid=CosmicLAN 2.4Ghz\nhw_mode=g\nchannel=7\nmacaddr_acl=0\nauth_algs=1\nignore_broadcast_ssid=0\nwpa=2\nwpa_passphrase=C0n7r4s3ñ4\nwpa_key_mgmt=WPA-PSK\nwpa_pairwise=TKIP\nrsn_pairwise=CCMP' /etc/hostapd/hostapd.conf