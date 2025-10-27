cd cloud-init

terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -target yandex_compute_instance.teamcity-agent

docker run --rm -d --name teamcity-server-instance  \
    -v ~/tcdata:/data/teamcity_server/datadir \
    -v ~/tclogs:/opt/teamcity/logs \
    -p 8111:8111  \
    jetbrains/teamcity-server


https://github.com/dcjulian29/ansible-role-teamcity/tree/main
