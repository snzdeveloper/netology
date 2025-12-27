#https://cloud.theodo.com/en/blog/prometheus-monitoring-ansible
#https://github.com/prometheus-community/ansible/tree/main
#https://adminvps.ru/blog/ustanovka-node-exporter-i-integracziya-s-prometheus-dlya-monitoringa-servera/
#https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/prometheus-config-examples/docker-compose-linux/
#https://www.metalnikovg.ru/blog/monitoring-linux-hostov-s-prometheus-node-exporter
#https://galaxy.semaphoreui.com/ru/views/geerlingguy/ansible-role-node_exporter/overview
### открыть порты в firewall для node exporter и prometheus (если нужно)
#https://habr.com/ru/companies/otus/articles/947750/
firewalld:
    sudo firewall-cmd --add-port=9100/tcp
    sudo firewall-cmd --add-port=9090/tcp
    sudo firewall-cmd --list-all-zones
iptables:
    sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
    sudo iptables -L -n -v
nft:
    #https://wiki.archlinux.org/title/Nftables
#https://www.digitalocean.com/community/tutorials/how-to-use-netcat-to-establish-and-test-tcp-and-udp-connections

CPU: 100 - (avg by (instance) (irate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[30s])) * 100)
NET: sum by (instance) (rate(node_network_receive_bytes_total{device=~"(eth(0|1)*)"}[1m]))

#https://1cloud.ru/blog/big_digest_2022
#https://www.redhat.com/en/blog/exposing-custom-metrics-from-virtual-machines

#https://stackoverflow.com/questions/75974201/is-it-possible-to-loop-through-array-of-specific-host-and-configuration
#https://stackoverflow.com/questions/77106000/how-to-extract-multiple-hostvars-from-all-hosts-in-a-group
#https://serverfault.com/questions/1097743/ansible-get-list-of-all-hostnames-and-corresponding-ansible-host-values-from-i
#https://labex.io/ru/tutorials/ansible-ansible-hostvars-391846
#https://git.digitalstudium.com/digitalstudium/ha-prometheus

#https://www.dmosk.ru/miniinstruktions.php?mini=ansible-roles-example#prometheus
#https://stackoverflow.com/questions/65139989/ansible-how-to-fix-to-nice-yaml-output-quotation-and-line-breaks
#https://my.adminvps.ru/knowledgebase/83/chto-takoe-la-load-average-i-kak-pravilno-ego-rasschityvat.html