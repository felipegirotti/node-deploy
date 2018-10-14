SERVERS=''
HOSTS={{ groups.apps }}
for host in HOSTS; do
    IP={{ hostvars[host]['ansible_host'] }}
    SERVERS="$SERVERS \n server $host  $IP:5001"
done

sed -i "s/%servers%/$SERVERS" /etc/haproxy/haproxy.cfg
        