###cloud vars
variable "ssh-authorized-keys" {
  type        = list(string)
  description = "ssh public keys"
}


variable "modules-to-install" {
    type        = list(string)
    default = [ "nginx" ]
    description = "modules list"
}

