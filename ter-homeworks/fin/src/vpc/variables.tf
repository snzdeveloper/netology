###cloud vars

# variable "public_key" {
#   type    = string
#   default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiVcfW8Wa/DxbBNzmQcwn7hJOj7ji9eoTpFakVnY/AI webinar"
# }

# variable "cloud_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
# }

# variable "folder_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
# }

variable "name" {
  type        = string
  default     = "develop-ru"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "v4_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

# variable "counts" {
#   type        = number
#   default     = 1
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }
