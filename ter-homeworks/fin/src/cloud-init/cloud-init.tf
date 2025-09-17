resource "local_file" "cloudinit" {
  content = templatefile("${path.module}/cloud-init.yml.tftpl",  { 
    ssh_keys = [ for k in var.ssh-authorized-keys: file(k) ]
    packages = flatten([ for i in var.modules-to-install: [ for k,v in local.modules: v.packages if k == i ]])
    #runcmds = toset(flatten([for i in var.modules-to-install: [ for k,v in local.modules: v.runcmd if k == i ]]))
    runcmds = flatten([ for i in var.modules-to-install: [ for k,v in local.modules: v.runcmd if k == i ]])
  })
  filename = "${abspath(path.module)}/cloud-init.yml"
}

output "content" {
  value = local_file.cloudinit.content
}
output "modules" {
  value = local.modules
}
