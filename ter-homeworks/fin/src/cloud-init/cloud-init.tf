resource "local_file" "cloudinit" {
#  content = templatefile("${path.module}/hosts.tftpl",  { servers = flatten(yandex_compute_instance.web[*],yandex_compute_instance.db[*],yandex_compute_instance.storage) })
  content = templatefile("${path.module}/cloud-init.yml.tftpl",  { 
    ssh_keys = [ for k in var.ssh-authorized-keys: file(k) ]
    packages = flatten([ for i in var.modules-to-install: [ for k,v in local.modules: v.packages if k == i ]])
    #runcmds = toset(flatten([for i in var.modules-to-install: [ for k,v in local.modules: v.runcmd if k == i ]]))
    runcmds = flatten([ for i in var.modules-to-install: [ for k,v in local.modules: v.runcmd if k == i ]])
  })
  filename = "${abspath(path.module)}/cloud-init.yml"
}


#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  depends_on = [ local_file.cloudinit ]

  #template = file("${abspath(path.module)}/cloud-init.yml")
  template = local_file.cloudinit.content
}

# metadata = {
#   user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
#   serial-port-enable = 1
# }
output "rendered" {
  value = data.template_file.cloudinit.rendered
}
output "modules" {
  value = local.modules
}
