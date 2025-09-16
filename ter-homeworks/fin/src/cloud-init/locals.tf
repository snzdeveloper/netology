
locals {
    modules = {
        "nginx" = {
            packages = [
                "nginx"
            ]
            runcmd = [
                "[systemctl, enable, nginx]",
                "[systemctl, start, nginx]",
                "[systemctl, restart, nginx]"
            ]
        }
        "docker:ubuntu" = {
            packages = []
            runcmd = [
                "mkdir -p /etc/apt/keyrings",
                "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
                "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
                "apt-get update",
                "apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
                "systemctl enable docker",
                "systemctl start docker"
            ]
        }

    }

  environment_configs = {
    development = {
      location    = "East US"
      instance_type = "t2.micro"
      min_instances = 1
    }
    staging = {
      location    = "West US"
      instance_type = "t2.small"
      min_instances = 2
    }
    production = {
      location    = "Central US"
      instance_type = "m5.large"
      min_instances = 3
    }
  }


}

