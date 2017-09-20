# Hostapd inclusief dhcp server / dns server

eerlijk gejat:

https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/

## Install software

Voor de setup hebben we dnsmas en hostapd nodig.
```
	$ sudo apt-get install dnsmasq hostapd	
```
## DHCP uitschakelen voor de wlan0
Tegen de dhcp client zeggen dat hij van de wlan0 af moet blijven.

```
	vi /etc/dhcpcd.conf

	....
	denyinterfaces wlan0
```

## statisch ip address op wlan0
IP adres vast zetten

```
	$ sudo vi /etc/network/interfaces

	allow-hotplug wlan0  
	iface wlan0 inet static  
	    address 172.24.1.1
	    netmask 255.255.255.0
	    network 172.24.1.0
	    broadcast 172.24.1.255
	#    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

En natuurlijk even droog oefenen.

```
	$ sudo service dhcpcd restart
```

## Configure hostapd
Nieuwe config voor hostapd
Hier configureren we de access point.

```
	vi /etc/hostapd/hostapd.conf

	# This is the name of the WiFi interface we configured above
	interface=wlan0

	# Use the nl80211 driver with the brcmfmac driver
	driver=nl80211

	# This is the name of the network
	ssid=rpib3-AP

	# Use the 2.4GHz band
	hw_mode=g

	# Use channel 6
	channel=6

	# Enable 802.11n
	ieee80211n=1

	# Enable WMM
	wmm_enabled=1

	# Enable 40MHz channels with 20ns guard interval
	ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

	# Accept all MAC addresses
	macaddr_acl=0

	# Use WPA authentication
	auth_algs=1

	# Require clients to know the network name
	ignore_broadcast_ssid=0

	# Use WPA2
	wpa=2

	# Use a pre-shared key
	wpa_key_mgmt=WPA-PSK

	# The network passphrase
	wpa_passphrase=raspberry

	# Use AES, instead of TKIP
	rsn_pairwise=CCMP
```


## Configure dnsmasq
dnsmasq configudingesen

```
	$ sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.org
	$ sudo vi /etc/dnsmasq.conf

	interface=wlan0      # Use interface wlan0
	listen-address=172.24.1.1 # Explicitly specify the address to listen on
	bind-interfaces      # Bind to the interface to make sure we aren't sending things elsewhere
	server=8.8.8.8       # Forward DNS requests to Google DNS
	domain-needed        # Don't forward short names
	bogus-priv           # Never forward addresses in the non-routed address spaces.
	dhcp-range=172.24.1.50,172.24.1.150,12h # Assign IP addresses between 172.24.1.50 and 172.24.1.150 with a 12 hour lease time
```

## De routering aanzetten
Dus het verkeer op wlan0 oppakken en doorzetten naar eth0

```
	sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
```
En dit willen we natuurlijk permanent maken:
(even het # weghalen bij #net.ipv4.ip_forward=1)


```
	sudo nano /etc/sysctl.conf

	# Uncomment the next line to enable packet forwarding for IPv4
	net.ipv4.ip_forward=1
```

## Firewall configureren voor masqurading aan te zetten

```
	sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
	sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
	sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
```

Opslaan
```
	iptables-restore < /etc/iptables.ipv4.nat
```




## Gebruikte commando's

$ vi /etc/dhcpcd.conf
$ ifconfig
$ sudo apt-get update
$ sudo apt-get install dnsmasq hostapd
$ 
$ sudo apt-get install dnsmasq hostapd
$ vi /etc/hostapd/hostapd.conf
$ sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf
$ vi /etc/hostapd/hostapd.conf
$ vi /etc/hostapd/hostapd.conf
$ sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf
$ vi /etc/hostapd/hostapd.conf
$ sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf
$ cd .
$ cd ..
$ mv dnsmasq.conf dnsmasq.conf.org
$vi dnsmasq.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
vi /etc/rc.local
sudo service hostapd start
sudo service dnsmasq start
/etc/sysctl.conf
vi /etc/sysctl.conf
sudo reboot
sudo service hostapd status
vi /etc/hostapd/hostapd.conf
cd /etc/init.d/
ls
vi hostapd
vi /etc/default/hostapd
sudo reboot
vi /etc/ssh/sshd_config
dnsmasq  --help
dnsmasq  --help | grep dhcp
:q
ls -l /var/lib/misc/dnsmasq.leases
vi /var/lib/misc/dnsmasq.leases
cat /var/lib/misc/dnsmasq.leases
cd /home/gej/
ls
cd hostapd/

vi logging.sh
vi /var/log/syslog
chmod a+x logging.sh
./logging.sh
cd /etc/dnsmasq.d/
ls
vi README
ls
echo "log-queries" > /etc/dnsmasq.d/log-queries
vi log-queries
systemctl dnsmasq.service restart
service dnsmasq restart
vi /var/log/daemon.log
tail -f /var/log/daemon.log
cd /home/gej/hostapd/
vi logging.sh
tail -f /var/log/daemon.log
nmtui

