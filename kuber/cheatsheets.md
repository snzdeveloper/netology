### указать адрес ip по которому подключеться при запуске exec
```sh

kubectl exec -ti pods/netology-multitool -- bash

#https://canonical.com/microk8s/docs/configure-host-interfaces
#/var/snap/microk8s/current/args/kube-apiserver
--advertise-address=192.168.56.102
--bind-address=0.0.0.0
--secure-port=16443

```


### Установка и настройка kubectl
#https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/

###
curl -LO https://dl.k8s.io/release/`curl -LS https://dl.k8s.io/release/stable.txt`/bin/linux/amd64/kubectl

###
```sh

sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

```

### Проверка конфигурации kubectl
```sh

kubectl cluster-info

```

###
```sh

microk8s config > $HOME/.kube/config

```

###
```sh

apt-get install bash-completion

```

###
```sh

# Включение автодополнения ввода kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
# или
kubectl completion bash >/etc/bash_completion.d/kubectl

#если у вас определён псевдоним для kubectl
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

```

### k9s
```sh

#https://github.com/derailed/k9s
echo "alias k9s='docker run --rm -it -v ~/.kube/config:/root/.kube/config quay.io/derailed/k9s'">>~/.bashrc

```

### scale deployment
```sh

kubectl scale deployment/<deployment-name> --replicas=<count>
kubectl scale deployment/nginx-multitool-deployment --replicas 3

```

### node name
```sh
kubectl get node -o yaml | grep 'kubernetes.io/hostname'
```

### enable community repository
```sh
microk8s enable community
```

### install nfs https://canonical.com/microk8s/docs/how-to-nfs#p-32464-install-the-csi-driver-for-nfs
#### Install NFS
```sh
sudo apt-get install nfs-kernel-server

sudo mkdir -p /srv/nfs
sudo chown nobody:nogroup /srv/nfs
sudo chmod 0777 /srv/nfs


sudo mv /etc/exports /etc/exports.bak
echo '/srv/nfs *(rw,sync,no_subtree_check)' | sudo tee /etc/exports


sudo systemctl restart nfs-kernel-server
```

#### Install the CSI driver for NFS
```sh
microk8s enable helm3
microk8s helm3 repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
microk8s helm3 repo update
```

#### install the Helm chart under the kube-system namespace
```sh
microk8s helm3 install csi-driver-nfs csi-driver-nfs/csi-driver-nfs \
    --namespace kube-system \
    --set kubeletDir=/var/snap/microk8s/common/var/lib/kubelet
```

#### wait for the CSI controller and node pods
```sh
microk8s kubectl wait pod --selector app.kubernetes.io/name=csi-driver-nfs --for condition=ready --namespace kube-system
```


### ingress
####https://cloud.vk.com/docs/on-premises/private-cloud/4_2/user-guide/k8s_main/k8s_network/k8s_network_ingress
####https://wiki.merionet.ru/articles/rukovodstvo-po-kubernetes-ingress

### tls
```sh  
 openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=*.example.com/O=Example Org"

 openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=example.com/O=Example Org" -addext "subjectAltName = DNS:example.com, DNS:*.example.com"

```

```sh
kubectl create secret tls testsecret-tls --cert=tls.crt --key=tls.key
```