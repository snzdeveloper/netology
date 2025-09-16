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

# variable "default_zone" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
# }

variable "ssh-authorized-keys" {
  type        = list(string)
  description = "ssh public keys"
}

# variable "modules-to-install" {
#   type        = map({
#     packages = list(string)
#     runcmd = list(string)
#   })
#   description = "modules"
# }
# variable "modulesx" {
#     type = map(object({
#       packages = list(string)
#       runcmd = list(string)
#     }))
#     default = {
#       "nginx" = {
#         packages = []
#         runcmd = []
#       }
#     }
#     description = "modules list"
# }

variable "modules-to-install" {
    type        = list(string)
    default = [ "nginx" ]
    description = "modules list"
}

