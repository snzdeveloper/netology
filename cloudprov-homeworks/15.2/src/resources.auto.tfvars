ssh_key_file = "~/.ssh/id_ed25519.pub"

each_vm = [
   {
      name="public"
      cpu=2
      ram=1
      # subnet_id=yandex_vpc_subnet.vpc_public_subnet.id
      core_fraction=20
      hdd_size=10
      hdd_type="network-hdd"
   },
   {
      name="private"
      cpu=2
      ram=2
      # subnet_id="{{ yandex_vpc_subnet.vpc_private_subnet.id }}"
      core_fraction=20
      hdd_size=10
      hdd_type="network-hdd"
   }   
]

### bucket
bucket_name = "sbaucket"
anonymous_access_flags = {
   list = true
   read = true
   config_read = false
}
boot_image_id = "fd827b91d99psvq5fjit"