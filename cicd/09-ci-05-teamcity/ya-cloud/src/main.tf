
# формируем cloud-init
module "cloudinit" {
  source = "../cloud-init"
  ssh-authorized-keys = ["~/.ssh/id_ed25519.pub"]
  modules-to-install = [ "docker:ubuntu" ]
}

resource "null_resource" "teamcity_server_provision" {
  depends_on = [ local_file.hosts_yaml ]

  connection {
    type = "ssh"
    host = yandex_compute_instance.teamcity-server[0].network_interface[0].nat_ip_address
    user = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
  }  
  
  # provisioner "file" {
  #   source = "./web.env"
  #   destination = "/home/ubuntu/web.env"
  # }

  # provisioner "remote-exec" {
  #   inline = [ 
  #     "sleep 100", # wait for docker to install from cloud-init
  #     "mkdir -p /home/ubuntu/app",
  #     "cd /home/ubuntu/app",
  #     "docker pull jetbrains/teamcity-server"
  #     # "git clone https://github.com/snzdeveloper/shvirtd-example-python.git",
  #     # "cd shvirtd-example-python",
  #     # "cp /home/ubuntu/web.env .",
  #     # "MYSQL_HOST=${self.network_interface[0].ip_address} docker compose -f proxy.yaml -f webapp.yaml up -d",
  #     # "docker compose stop",  # не знаю почему то при первом запуске выдаётся ошибка, что таблица не существует (Table 'virtd.requests' doesn't exist)
  #     # "docker compose start", # поэтому перезапуск
  #    ]
  # }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/hosts.yml ${abspath(path.module)}/ansible.yaml"
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
}

resource "null_resource" "teamcity_agent_provision" {
  depends_on = [ local_file.hosts_yaml ]

  count = length(yandex_compute_instance.teamcity-agent)

  connection {
    type = "ssh"
    host = yandex_compute_instance.teamcity-agent[count.index].network_interface[0].nat_ip_address
    user = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
  }  
  
  # provisioner "file" {
  #   source = "./web.env"
  #   destination = "/home/ubuntu/web.env"
  # }

  # provisioner "remote-exec" {
  #   inline = [ 
  #     "sleep 100", # wait for docker to install from cloud-init
  #     "mkdir -p /home/ubuntu/app",
  #     "cd /home/ubuntu/app",
  #     "docker pull jetbrains/teamcity-agent"
  #     # "git clone https://github.com/snzdeveloper/shvirtd-example-python.git",
  #     # "cd shvirtd-example-python",
  #     # "cp /home/ubuntu/web.env .",
  #     # "MYSQL_HOST=${self.network_interface[0].ip_address} docker compose -f proxy.yaml -f webapp.yaml up -d",
  #     # "docker compose stop",  # не знаю почему то при первом запуске выдаётся ошибка, что таблица не существует (Table 'virtd.requests' doesn't exist)
  #     # "docker compose start", # поэтому перезапуск
  #    ]
  # }

}
