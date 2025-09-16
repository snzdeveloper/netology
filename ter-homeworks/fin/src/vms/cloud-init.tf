resource "local_file" "cloudinit" {
#  content = templatefile("${path.module}/hosts.tftpl",  { servers = flatten(yandex_compute_instance.web[*],yandex_compute_instance.db[*],yandex_compute_instance.storage) })
  content = templatefile("${path.module}/cloud-init.yml.tftpl",  { 
    ssh_keys = [ for k in var.ssh-authorized-keys: file(k) ]
  })
  filename = "${abspath(path.module)}/cloud-init.yml"
}
