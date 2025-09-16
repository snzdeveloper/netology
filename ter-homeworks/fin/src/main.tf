# создаем облачную сеть
# создаем подсеть
module "vpc_develop" {
  source = "./vpc"
  #name = "develop"
  name           = "develop"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
}

module "vpc_sg" {
  source = "./sg"
  #name = "develop"
  cloud_id      = var.cloud_id
  folder_id     = var.folder_id
  vpc_network = {
    id = module.vpc_develop.vpc_network.id
  }

  security_group_ingress = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий ssh"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий  http"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий mariadb"
      v4_cidr_blocks = ["10.0.0.0/8"]
      port           = 3306
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий http(s):8080-8090"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 8080
      to_port        = 8090
    },
  ]
}

# module "vms_develop" {
#   source = "./vms"
#   #name = "develop"
#   public_key    = local.metadata.ssh-keys
#   cloud_id      = var.cloud_id
#   folder_id     = var.folder_id
#   default_zone  = var.default_zone
#   ssh-authorized-keys = ["~/.ssh/id_ed25519.pub"]

#   vpc_network = module.vpc_develop.vpc_network
#   vpc_subnet = module.vpc_develop.vpc_subnet
# }

module "cloudinit" {
  source = "./cloud-init"
  ssh-authorized-keys = ["~/.ssh/id_ed25519.pub","~/.ssh/id_ed25519-wsl.pub"]
  modules-to-install = [ "docker:ubuntu" ]
}


resource "yandex_compute_instance" "db" {
  #depends_on = [yandex_compute_instance.db]

  count = 1

  name        = "db-${count.index+1}" #Имя ВМ в облачной консоли
  hostname    = "db-${count.index+1}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  //metadata = local.metadata
  metadata = {
    user-data          = module.cloudinit.rendered
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = module.vpc_develop.vpc_subnet.id
    nat       = true
    security_group_ids = [ module.vpc_sg.sg.id ]
  }

  allow_stopping_for_update = true
  connection {
    type = "ssh"
    host = self.network_interface[0].nat_ip_address
    user = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
  }
  provisioner "file" {
    source = "./web.env"
    destination = "/home/ubuntu/web.env"
  }
  provisioner "remote-exec" {
    inline = [ 
      "sleep 100", # wait for docker to install from cloud-init
      "docker run -d --env-file /home/ubuntu/web.env -p 3306:3306 --name mysql1 mariadb:10.6.4-focal"
     ]
  }  
  #docker run -d -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" -e MYSQL_ROOT_HOST="%" -p 3306:3306 -v mariadb_data:/var/lib/mysql --name mysql cr.yandex/crp6lq6m05qvpikv5fuc/mariadb:webdb
}

resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]

  count = 1

  name        = "web-${count.index+1}" #Имя ВМ в облачной консоли
  hostname    = "web-${count.index+1}" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  //metadata = local.metadata
  metadata = {
    user-data          = module.cloudinit.rendered
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = module.vpc_develop.vpc_subnet.id
    nat       = true
    security_group_ids = [ module.vpc_sg.sg.id ]
  }

  allow_stopping_for_update = true
  connection {
    type = "ssh"
    host = self.network_interface[0].nat_ip_address
    user = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
  }  
  
  provisioner "file" {
    source = "./web.env"
    destination = "/home/ubuntu/web.env"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sleep 100", # wait for docker to install from cloud-init
      "mkdir -p /home/ubuntu/webapp",
      "cd /home/ubuntu/webapp",
      "git clone https://github.com/snzdeveloper/shvirtd-example-python.git",
      "cd shvirtd-example-python",
      "cp /home/ubuntu/web.env .",
      "MYSQL_HOST=${yandex_compute_instance.db[0].network_interface[0].ip_address} docker compose -f proxy.yaml -f webapp.yaml up -d",
      "docker compose stop",  # не знаю почему то при первом запуске выдаётся ошибка, что таблица не существует (Table 'virtd.requests' doesn't exist)
      "docker compose start", # поэтому перезапуск
     ]
  }
}
# docker run -d -e MYSQL_ROOT_PASSWORD="psswrd" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="dbuser" -e MYSQL_PASSWORD="pass" -p 3306:3306 --name mysql cr.yandex/crp6lq6m05qvpikv5fuc/webapp:python
