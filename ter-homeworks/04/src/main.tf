
module "vpc_develop" {
  source = "./vpc"
  #name = "develop"
  name           = "develop-ru"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
}



module "vms_develop" {
  source = "./vms"
  #name = "develop"
  public_key    = local.metadata.ssh-keys
  cloud_id      = var.cloud_id
  folder_id     = var.folder_id
  default_zone  = var.default_zone
  ssh-authorized-keys = ["~/.ssh/id_ed25519.pub"]
}
