
locals {
    vms_ssh_root_key = "${file("~/.ssh/id_ed25519.pub")}"
    vms_prefix = "netology-develop-platform"
    vm_web_name = "${local.vms_prefix}-${var.vm_web.name}"
    vm_db_name = "${local.vms_prefix}-${var.vm_db.name}"
}
