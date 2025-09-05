
locals {

    metadata = {
        ssh-keys = "ubuntu:${file(var.ssh_key_file)}"
    }
}
