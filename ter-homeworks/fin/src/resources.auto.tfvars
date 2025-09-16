ssh_key_file = "~/.ssh/id_ed25519.pub"

each_db = [
   {
      name="main"
      cpu=2
      ram=1
      core_fraction=20
      hdd_size=10
      hdd_type="network-hdd"
   },
   {
      name="replica"
      cpu=2
      ram=2
      core_fraction=20
      hdd_size=10
      hdd_type="network-hdd"
   }   
]

