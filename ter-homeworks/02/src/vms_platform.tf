

variable "vm_web" {
    type = object({
      name =     string
      platform = string
      cores    = number
      memory   = number
      core_fraction = number
      preemptible = bool
      zone = string
    })
    
    default = { 
      name = "web"
      platform = "standard-v3" #Intel Ice Lake
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      zone          = "ru-central1-a"
    }

  description = "yandex compute cloud web instance properties"
}


### vm_dbs_***
variable "vm_db" {
    type = object({
      name =     string
      platform = string
      cores    = number
      memory   = number
      core_fraction = number
      preemptible = bool
      zone        = string
    })
    
    default = { 
      name = "db"
      platform = "standard-v3" #Intel Ice Lake
      cores         = 2
      memory        = 2
      core_fraction = 20
      preemptible = true
      zone          = "ru-central1-a"
    }

  description = "yandex compute cloud db instance properties"
}

