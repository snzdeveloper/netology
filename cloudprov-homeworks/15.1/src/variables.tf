### cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vpc_public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "vpc_private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "VPC network & subnet name"
}

variable "ssh_key_file" {
  type        = string
  default     = "ubuntu: "
  description = "ssh key file"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "ubuntu: "
  description = "ssh key file"
}

variable "nat_instance_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "nat instance boot disk id"
}
variable "nat_ip_address" {
  type        = string
  default     = "192.168.10.254"
  description = "nat instance internal ip address"
}

variable "each_vm" {
  type = list(object({  
    name=string
    cpu=number
    ram=number
    # subnet_id=string
    core_fraction=number
    disk_volume=optional(number)
    hdd_size=number
    hdd_type=string
  }))

  default = []
}

variable "net_subnets" {
  type = list(object({  
    name=string
    type=string
    cidr=list(string)
  }))

  default = []
}
