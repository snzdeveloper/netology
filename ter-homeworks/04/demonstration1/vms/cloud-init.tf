resource "local_file" "cloudinit" {
#  content = templatefile("${path.module}/hosts.tftpl",  { servers = flatten(yandex_compute_instance.web[*],yandex_compute_instance.db[*],yandex_compute_instance.storage) })
  content = templatefile("${path.module}/cloud-init.yml.tftpl",  { 
    ssh_keys = tolist([file("~/.ssh/id_ed25519.pub")]) 
  })
  filename = "${abspath(path.module)}/cloud-init.yml"
}
