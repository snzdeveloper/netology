#https://cloud.theodo.com/en/blog/prometheus-monitoring-ansible
#https://github.com/prometheus-community/ansible/tree/main
#https://adminvps.ru/blog/ustanovka-node-exporter-i-integracziya-s-prometheus-dlya-monitoringa-servera/
#https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/prometheus-config-examples/docker-compose-linux/
#https://www.metalnikovg.ru/blog/monitoring-linux-hostov-s-prometheus-node-exporter
### открыть порты в firewall для node exporter и prometheus (если нужно)
#https://habr.com/ru/companies/otus/articles/947750/
firewalld:
    sudo firewall-cmd --add-port=9100/tcp
    sudo firewall-cmd --add-port=9090/tcp
    sudo firewall-cmd --list-all-zones
iptables:
    sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
    sudo iptables -L -n -v
nft:
    #https://wiki.archlinux.org/title/Nftables
#https://www.digitalocean.com/community/tutorials/how-to-use-netcat-to-establish-and-test-tcp-and-udp-connections

CPU: 100 - (avg by (instance) (irate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[30s])) * 100)


https://1cloud.ru/blog/big_digest_2022
https://www.redhat.com/en/blog/exposing-custom-metrics-from-virtual-machines
https://stackoverflow.com/questions/75974201/is-it-possible-to-loop-through-array-of-specific-host-and-configuration
