# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Предварительная настройка узлов
#### автозагрузка модулей ядра
```sh
# Настройка автозагрузки и запуск модулей ядра br_netfilter и overlay
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

#проверка
lsmod | grep br_netfilter
lsmod | grep overlay

## Ожидаемый результат должен быть следующим (цифры могут отличаться):
# br_netfilter           32768  0
# bridge                258048  1 br_netfilter
# overlay               147456  0

```

#### отключение swap
```sh

# Отключение файла подкачки
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab


# проверка
## Ожидаемый вывод команды – пустой. Она ничего не должна отобразить.
sudo swapon -s

```

#### Сетевые настройки
##### настроить статические адреса на свободном интерфейсе

```sh

#sudo nmcli con add con-name "enp0s9" ifname enp0s9 type ethernet ip4 172.30.120.201/24 gw4 172.30.120.1
sudo nmcli con mod enp0s9 ipv4.addresses "172.30.120.201/24" ipv4.method manual
#sudo nmcli con mod enp0s9 ipv4.dns "8.8.8.8"
sudo nmcli con up enp0s9

```
##### настройка имён/адресов хостов (вместо dns)
```sh

cat <<EOF | sudo tee /etc/hosts
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

# Cluster nodes
172.30.120.201 node1.internal
172.30.120.202 node2.internal
172.30.120.203 node3.internal
172.30.120.204 node4.internal
172.30.120.205 node5.internal
EOF

```
```sh

sudo hostnamectl set-hostname node1.internal

```
```sh

# Включаем forward пакетов:
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sed -i s/'^#net.ipv4.ip_forward=1'/'net.ipv4.ip_forward=1'/g /etc/sysctl.conf
sysctl -p
```
```sh
# Разрешение маршрутизации IP-трафика
echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/10-k8s.conf
sudo sysctl -f /etc/sysctl.d/10-k8s.conf

#проверка
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

## Ожидаемый результат:
# net.bridge.bridge-nf-call-iptables = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# net.ipv4.ip_forward = 1

```

#### Installing a container runtime
##### containerd из github
```sh

mkdir /tmp/containerd \
&& wget https://github.com/containerd/containerd/releases/download/v2.2.1/containerd-2.2.1-linux-amd64.tar.gz -O /tmp/containerd \
&& cd /tmp/containerd && tar xvf containerd-2.2.1-linux-amd64.tar.gz

systemctl stop containerd

cd bin
yes | sudo cp -rf * /usr/bin
sudo systemctl start containerd
containerd --version

```


##### containerd из репозитория
```sh

[user@localhost ~]$ sudo dnf install containerd -y --allowerasing 
Last metadata expiration check: 0:00:51 ago on Mon 26 Jan 2026 02:55:42 PM +05.
Dependencies resolved.
====================================================================================================================================================================================================================================
 Package                                                         Architecture                                 Version                                                 Repository                                               Size
====================================================================================================================================================================================================================================
Installing:
 containerd                                                      x86_64                                       2.2.0-3.el9                                             epel                                                     28 M
Installing dependencies:
 runc                                                            x86_64                                       4:1.4.0-1.el9_7                                         appstream                                               3.9 M
Removing dependent packages:
 containerd.io                                                   x86_64                                       1.7.28-1.el9                                            @docker-ce-stable                                       162 M
 docker-ce                                                       x86_64                                       3:28.5.1-1.el9                                          @docker-ce-stable                                        86 M
 docker-ce-rootless-extras                                       x86_64                                       28.5.1-1.el9                                            @docker-ce-stable                                        11 M

Transaction Summary
====================================================================================================================================================================================================================================
Install  2 Packages
Remove   3 Packages

Total download size: 32 M
Downloading Packages:
(1/2): runc-1.4.0-1.el9_7.x86_64.rpm                                                                                                                                                                6.3 MB/s | 3.9 MB     00:00    
(2/2): containerd-2.2.0-3.el9.x86_64.rpm                                                                                                                                                            1.6 MB/s |  28 MB     00:17    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                               1.7 MB/s |  32 MB     00:18     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                            1/1 
  Installing       : runc-4:1.4.0-1.el9_7.x86_64                                                                                                                                                                                1/5 
  Installing       : containerd-2.2.0-3.el9.x86_64                                                                                                                                                                              2/5 
  Running scriptlet: containerd-2.2.0-3.el9.x86_64                                                                                                                                                                              2/5 
  Running scriptlet: docker-ce-3:28.5.1-1.el9.x86_64                                                                                                                                                                            3/5 
Removed "/etc/systemd/system/multi-user.target.wants/docker.service".

  Erasing          : docker-ce-3:28.5.1-1.el9.x86_64                                                                                                                                                                            3/5 
  Running scriptlet: docker-ce-3:28.5.1-1.el9.x86_64                                                                                                                                                                            3/5 
  Running scriptlet: containerd.io-1.7.28-1.el9.x86_64                                                                                                                                                                          4/5 
Warning: The unit file, source configuration file or drop-ins of containerd.service changed on disk. Run 'systemctl daemon-reload' to reload units.

  Erasing          : containerd.io-1.7.28-1.el9.x86_64                                                                                                                                                                          4/5 
  Running scriptlet: containerd.io-1.7.28-1.el9.x86_64                                                                                                                                                                          4/5 
  Running scriptlet: docker-ce-rootless-extras-28.5.1-1.el9.x86_64                                                                                                                                                              5/5 
  Erasing          : docker-ce-rootless-extras-28.5.1-1.el9.x86_64                                                                                                                                                              5/5 
  Running scriptlet: docker-ce-rootless-extras-28.5.1-1.el9.x86_64                                                                                                                                                              5/5 
  Verifying        : containerd-2.2.0-3.el9.x86_64                                                                                                                                                                              1/5 
  Verifying        : runc-4:1.4.0-1.el9_7.x86_64                                                                                                                                                                                2/5 
  Verifying        : containerd.io-1.7.28-1.el9.x86_64                                                                                                                                                                          3/5 
  Verifying        : docker-ce-3:28.5.1-1.el9.x86_64                                                                                                                                                                            4/5 
  Verifying        : docker-ce-rootless-extras-28.5.1-1.el9.x86_64                                                                                                                                                              5/5 

Installed:
  containerd-2.2.0-3.el9.x86_64                                                                                     runc-4:1.4.0-1.el9_7.x86_64                                                                                    
Removed:
  containerd.io-1.7.28-1.el9.x86_64                                       docker-ce-3:28.5.1-1.el9.x86_64                                       docker-ce-rootless-extras-28.5.1-1.el9.x86_64                                      

Complete!

```
#####
```sh

# Создание конфигурации по умолчанию для containerd
sudo mkdir /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml

# Конфигурируем cgroup driver
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

```

```sh

# Установка systemd сервиса для containerd
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /etc/systemd/system/

```

```sh
# Установка компонента runc
wget https://github.com/opencontainers/runc/releases/download/v1.4.0/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
rm runc.amd64

```

```sh

# Установка сетевых плагинов:
wget https://github.com/containernetworking/plugins/releases/download/v1.9.0/cni-plugins-linux-amd64-v1.9.0.tgz
sudo mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.9.0.tgz
rm cni-plugins-linux-amd64-v1.9.0.tgz

```

```sh
# Запуск сервиса containerd
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

```

```sh
# Настройка конфигурации crictl
cat << _EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
_EOF
```

#####

```sh
#Проверка доступности сокета containerd
sudo crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock version
#  Version:  0.1.0
#  RuntimeName:  containerd
#  RuntimeVersion:  2.2.0
#  RuntimeApiVersion:  v1


```

#### Installing kubeadm, kubelet and kubectl
##### Set SELINUX permissive
```sh
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
##### Add the Kubernetes yum repository.
```sh

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

```


##### Install kubelet, kubeadm and kubectl
```sh
#[user@localhost ~]$ sudo yum install -y kubelet kubeadm kubectl --setopt=disable_excludes=kubernetes
sudo dnf install -y --disablerepo=* --enablerepo=kubernetes kubelet kubeadm kubectl --setopt=disable_excludes=kubernetes

Kubernetes                                                                                                                                                                                          4.9 kB/s | 5.6 kB     00:01    
Dependencies resolved.
====================================================================================================================================================================================================================================
 Package                                                  Architecture                                     Version                                                       Repository                                            Size
====================================================================================================================================================================================================================================
Installing:
 kubeadm                                                  x86_64                                           1.35.0-150500.1.1                                             kubernetes                                            12 M
 kubectl                                                  x86_64                                           1.35.0-150500.1.1                                             kubernetes                                            11 M
 kubelet                                                  x86_64                                           1.35.0-150500.1.1                                             kubernetes                                            12 M
Installing dependencies:
 cri-tools                                                x86_64                                           1.35.0-150500.1.1                                             kubernetes                                           7.5 M
 kubernetes-cni                                           x86_64                                           1.8.0-150500.1.1                                              kubernetes                                           8.8 M

Transaction Summary
====================================================================================================================================================================================================================================
Install  5 Packages

Total download size: 52 M
Installed size: 279 M
Downloading Packages:
(1/5): kubectl-1.35.0-150500.1.1.x86_64.rpm                                                                                                                                                         3.4 MB/s |  11 MB     00:03    
(2/5): cri-tools-1.35.0-150500.1.1.x86_64.rpm                                                                                                                                                       2.3 MB/s | 7.5 MB     00:03    
(3/5): kubeadm-1.35.0-150500.1.1.x86_64.rpm                                                                                                                                                         3.1 MB/s |  12 MB     00:03    
(4/5): kubernetes-cni-1.8.0-150500.1.1.x86_64.rpm                                                                                                                                                   3.2 MB/s | 8.8 MB     00:02    
(5/5): kubelet-1.35.0-150500.1.1.x86_64.rpm                                                                                                                                                         4.4 MB/s |  12 MB     00:02    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                               8.5 MB/s |  52 MB     00:06     
Kubernetes                                                                                                                                                                                          3.1 kB/s | 1.7 kB     00:00    
Importing GPG key 0x9A296436:
 Userid     : "isv:kubernetes OBS Project <isv:kubernetes@build.opensuse.org>"
 Fingerprint: DE15 B144 86CD 377B 9E87 6E1A 2346 54DA 9A29 6436
 From       : https://pkgs.k8s.io/core:/stable:/v1.35/rpm/repodata/repomd.xml.key
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                            1/1 
  Installing       : kubernetes-cni-1.8.0-150500.1.1.x86_64                                                                                                                                                                     1/5 
  Installing       : cri-tools-1.35.0-150500.1.1.x86_64                                                                                                                                                                         2/5 
  Installing       : kubeadm-1.35.0-150500.1.1.x86_64                                                                                                                                                                           3/5 
  Installing       : kubelet-1.35.0-150500.1.1.x86_64                                                                                                                                                                           4/5 
  Running scriptlet: kubelet-1.35.0-150500.1.1.x86_64                                                                                                                                                                           4/5 
  Installing       : kubectl-1.35.0-150500.1.1.x86_64                                                                                                                                                                           5/5 
  Running scriptlet: kubectl-1.35.0-150500.1.1.x86_64                                                                                                                                                                           5/5 
  Verifying        : cri-tools-1.35.0-150500.1.1.x86_64                                                                                                                                                                         1/5 
  Verifying        : kubeadm-1.35.0-150500.1.1.x86_64                                                                                                                                                                           2/5 
  Verifying        : kubectl-1.35.0-150500.1.1.x86_64                                                                                                                                                                           3/5 
  Verifying        : kubelet-1.35.0-150500.1.1.x86_64                                                                                                                                                                           4/5 
  Verifying        : kubernetes-cni-1.8.0-150500.1.1.x86_64                                                                                                                                                                     5/5 

Installed:
  cri-tools-1.35.0-150500.1.1.x86_64           kubeadm-1.35.0-150500.1.1.x86_64           kubectl-1.35.0-150500.1.1.x86_64           kubelet-1.35.0-150500.1.1.x86_64           kubernetes-cni-1.8.0-150500.1.1.x86_64          

Complete!

```

##### Enable the kubelet service before running kubeadm (Optional):
```sh

[user@localhost ~]$ sudo systemctl enable --now kubelet
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /usr/lib/systemd/system/kubelet.service

```

#### Creating a cluster with kubeadm
##### 
<!-- ```sh

cat <<EOF | tee kubeadm-config.yaml
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta4
kubernetesVersion: v1.35.0
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

``` -->
```sh
[user@localhost ~]$ sudo firewall-cmd --add-port=6443/tcp --add-port=10250/tcp
success
[user@localhost ~]$ sudo firewall-cmd --add-port=6443/udp --add-port=10250/udp
success


# [user@localhost ~]$ kubeadm init --config kubeadm-config.yaml


# #Конфигурирование утилиты управления kubectl
# echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | sudo tee -a /etc/environment





[user@node1 ~]$ sudo kubeadm init --pod-network-cidr=172.16.0.0/12 --control-plane-endpoint "172.30.120.201:6443" --upload-certs
[init] Using Kubernetes version: v1.35.0
[preflight] Running pre-flight checks
        [WARNING Firewalld]: firewalld is active, please ensure ports [6443 10250] are open or your cluster may not function correctly
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local node1.internal] and IPs [10.96.0.1 192.168.255.2 172.30.120.201]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost node1.internal] and IPs [192.168.255.2 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost node1.internal] and IPs [192.168.255.2 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/instance-config.yaml"
[patches] Applied patch of type "application/strategic-merge-patch+json" to target "kubeletconfiguration"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests"
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 507.136917ms
[control-plane-check] Waiting for healthy control plane components. This can take up to 4m0s
[control-plane-check] Checking kube-apiserver at https://192.168.255.2:6443/livez
[control-plane-check] Checking kube-controller-manager at https://127.0.0.1:10257/healthz
[control-plane-check] Checking kube-scheduler at https://127.0.0.1:10259/livez
[control-plane-check] kube-controller-manager is healthy after 1.019531245s
[control-plane-check] kube-scheduler is healthy after 1.959202383s
[control-plane-check] kube-apiserver is healthy after 4.004581443s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
7b70227e2c7efb0886a956f58a81f35610a984bcdb4fc81134c0c93611a6dc25
[mark-control-plane] Marking the node node1.internal as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node node1.internal as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: x08yt9.t6lbsagieminjtf3
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes running the following command on each as root:

  kubeadm join 172.30.120.201:6443 --token xu0z3u.ehdnqaqadczzdk2f \
        --discovery-token-ca-cert-hash sha256:b27d8bf7708b97481a56356fc6a4b8ad565ad8206129cca53109bcd9c8a2f19a \
        --control-plane --certificate-key b26bdaaf09c09ddc961752a19f95f455595056a7ed1a14ecc3d26b40851b98a1

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.30.120.201:6443 --token xu0z3u.ehdnqaqadczzdk2f \
        --discovery-token-ca-cert-hash sha256:b27d8bf7708b97481a56356fc6a4b8ad565ad8206129cca53109bcd9c8a2f19a 

```
### eviction
##### kubelet.config
#https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/
##### Set Kubelet Parameters Via A Configuration File
```yaml

apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
address: "192.168.0.8"
port: 20250
serializeImagePulls: false
evictionHard:
  memory.available:  "100Mi"
  nodefs.available:  "1%"
  nodefs.inodesFree: "1%"
  imagefs.available: "11%"
  imagefs.inodesFree: "1%"

```

##### get tokens
```sh
sudo kubeadm token list
```


```sh

[user@node1 ~]$ kubectl get nodes -o wide; kubectl get pods --all-namespaces -o wide
NAME             STATUS   ROLES           AGE    VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                      KERNEL-VERSION                CONTAINER-RUNTIME
node1.internal   Ready    control-plane   100s   v1.35.0   172.30.120.201   <none>        Rocky Linux 9.7 (Blue Onyx)   6.1.161-1.el9.elrepo.x86_64   containerd://2.2.1
NAMESPACE     NAME                                     READY   STATUS    RESTARTS   AGE   IP               NODE             NOMINATED NODE   READINESS GATES
kube-system   coredns-7d764666f9-dp8g6                 0/1     Pending   0          90s   <none>           <none>           <none>           <none>
kube-system   coredns-7d764666f9-qqt8g                 0/1     Pending   0          90s   <none>           <none>           <none>           <none>
kube-system   etcd-node1.internal                      1/1     Running   8          99s   172.30.120.201   node1.internal   <none>           <none>
kube-system   kube-apiserver-node1.internal            1/1     Running   0          99s   172.30.120.201   node1.internal   <none>           <none>
kube-system   kube-controller-manager-node1.internal   1/1     Running   0          97s   172.30.120.201   node1.internal   <none>           <none>
kube-system   kube-proxy-h29sb                         1/1     Running   0          90s   172.30.120.201   node1.internal   <none>           <none>
kube-system   kube-scheduler-node1.internal            1/1     Running   0          99s   172.30.120.201   node1.internal   <none>           <none>

```




## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.






###https://habr.com/ru/articles/725640/
###https://habr.com/ru/companies/domclick/articles/682364/
###https://timeweb.cloud/tutorials/kubernetes/kak-ustanovit-i-nastroit-kubernetes-ubuntu

### Сетевые политики и calico-cni
###https://habr.com/ru/companies/flant/articles/485716/
###https://ezyforanykey.blogspot.com/2019/08/kubernetes-calico-cni.html
###https://it-interv.ru/k8s-install-calico

### containerd+++
###https://habr.com/ru/articles/760806/
###https://redos.red-soft.ru/base/redos-7_3/7_3-administation/7_3-containers/7_3-kubernetes/7_3-kubernetes-1-24-containerd/

### cubespray
#https://core247.kz/blog/kubernetes-kupespray

### ansible
#https://github.com/kairen/kubeadm-ansible




### ???
#https://serverfault.com/questions/1185045/kubernetes-node-wont-join-using-calico