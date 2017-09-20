cat /var/lib/misc/dnsmasq.leases

# echo "log-queries" > /etc/dnsmasq.d/log-queries
# DNS logging in /var/log/daemon.log


#$ cat /etc/rsyslog.d/00-dnsmasq-splunk.conf
#if $programname == 'dnsmasq' and ($msg contains ' query[' or $msg contains ' reply ') then @splunkserver:5141
