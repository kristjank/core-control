#!/usr/bin/env bash
#Initialize filter
start_ark() {

table=$(sudo iptables -nL ARK 2> /dev/null)
myip=$(ifconfig `ip route | grep default | head -1 | sed 's/\(.*dev \)\([a-z0-9]*\)\(.*\)/\2/g'` | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)

if [[ $table ]]; then
        sudo iptables -F ARK
        sudo iptables -A ARK -s 127.0.0.1 -j ACCEPT
        sudo iptables -A ARK -d 127.0.0.1 -j ACCEPT
        sudo iptables -A ARK -j DROP
        echo "ARK filter exists, resetting rules"

else
        echo "ARK filter does not exist, creating it"
        sudo iptables -N ARK
        sudo iptables -I INPUT -p tcp -m multiport --dports 4000:4003 -j ARK
        sudo iptables -I OUTPUT -p tcp -m multiport --dports 4000:4003 -j ARK
        sudo iptables -I INPUT -p tcp --dport 4040 -j ARK
        sudo iptables -I OUTPUT -p tcp --dport 4040 -j ARK
        sudo iptables -A ARK -s 127.0.0.1 -j ACCEPT
        sudo iptables -A ARK -d 127.0.0.1 -j ACCEPT
        sudo iptables -A ARK -j DROP
fi
#Insert allowed IPs
declare -a IPS=(49.12.15.12
		49.12.0.201
		49.12.14.246
		49.12.14.245
		49.12.14.247
		91.246.224.211
		52.143.133.186
		134.122.25.93
                20.188.47.95
                86.58.78.190
               )

for ip in "${IPS[@]}"
do
        sudo iptables -I ARK -s $myip -d $ip -j ACCEPT
        sudo iptables -I ARK -d $myip -s $ip -j ACCEPT
done
}

#Stop filter function
stop_ark() {

table=$(sudo iptables -nL ARK 2> /dev/null)

if [[ $table ]]; then
        sudo iptables -F ARK
        sudo iptables -D INPUT -p tcp -m multiport --dports 4000:4003 -j ARK > /dev/null 2>&1
        sudo iptables -D OUTPUT -p tcp -m multiport --dports 4000:4003 -j ARK > /dev/null 2>&1 
        sudo iptables -D INPUT -p tcp --dport 4040 -j ARK > /dev/null 2>&1
        sudo iptables -D OUTPUT -p tcp --dport 4040 -j ARK > /dev/null 2>&1
        sudo iptables -X ARK
        echo "Removed ARK filter!"
fi
}

case "$1" in
    start)   start_ark ;;
    stop)    stop_ark ;;
    restart) stop_ark; start_ark ;;
    *) echo "usage: $0 start|stop|restart" >&2
       exit 1
       ;;
esac
