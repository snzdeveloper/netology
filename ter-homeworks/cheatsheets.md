# Yandex cloud
## 
### yc  
```sh
yc resource-manager cloud list
yc resource-manager folder list

yc iam service-account create --name sa-terraform
yc iam key create  --service-account-name sa-terraform --folder-name default --output ~/.sa-terraform-key.json
yc iam key list --service-account-name=sa-terraform


yc config profile create sa-terraform
yc config set service-account-key ~/.sa-terraform-key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>

# export cloud_id=$(yc resource-manager cloud list | awk -F' ' '/cloud-/{ printf $2 }')
# export folder_id=$(yc resource-manager folder list | awk -F' ' '/default/{ printf $2 }')
# yc config profile activate sa-terraform 
# yc config set cloud-id $cloud_id
# yc config set folder-id $folder_id


yc resource-manager folder add-access-binding <folder-id> --role <editor> --subject serviceAccount:<account-id>

yc compute image list --folder-id standard-images  --limit 0  --jq '.[].family' | sort | uniq
yc compute image get-latest-from-family ubuntu-2204-lts --folder-id standard-images


yc container registry list
yc container registry configure-docker # для аутентификации докера
docker tag ubuntu cr.yandex/<идентификатор_реестра>/ubuntu:hello
```
### statelocking
```sh
#https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-state-lock
yc iam service-account list
yc iam service-account create --name sa-terraform

yc resource-manager folder add-access-binding b1g66aah472mb1u75kr7 --role ydb.admin --subject serviceAccount:ajegsep6pi9agjsf67uu
yc resource-manager folder add-access-binding b1g66aah472mb1u75kr7 --role storage.editor --subject serviceAccount:ajegsep6pi9agjsf67uu

# https://yandex.cloud/ru/docs/iam/concepts/authorization/#sa
# Как выбрать подходящий способ аутентификации в Yandex Cloud

# https://yandex.cloud/ru/docs/iam/operations/authentication/manage-authorized-keys#create-authorized-key
# Создать авторизованный ключ
yc iam key create  --service-account-name sa-terraform --folder-name default --output ~/.sa-terraform-key.json
yc iam key list --service-account-name=sa-terraform

# https://yandex.cloud/ru/docs/iam/operations/authentication/manage-access-keys#cli_1
# Статические ключи доступа, совместимые с AWS API
# https://yandex.cloud/ru/docs/iam/concepts/authorization/access-key
yc iam access-key create --service-account-name sa-terraform --description "this key is for my bucket"


# https://yandex.cloud/ru/docs/storage/operations/buckets/create#cli_1
yc storage bucket create --name snzdev

  name: snzdev
  folder_id: b1g66aah472mb1u75kr7
  anonymous_access_flags: {}
  default_storage_class: STANDARD
  versioning: VERSIONING_DISABLED
  created_at: "2025-09-16T11:34:56.289585Z"
  resource_id: e3e809r99ek57ag0uhb2

terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 -platform=windows_amd64 yandex-cloud/yandex


```
# Terraform  
##  
### for loop  
```hcl
# https://developer.hashicorp.com/terraform/language/expressions/for

```

https://yandex.cloud/ru/docs/tutorials/infrastructure-management/run-docker-on-vm/terraform
https://dev.to/z4ck404/all-you-need-to-know-about-terraform-provisioners-and-why-you-should-avoid-them-236a
https://dockerhosting.ru/blog/kak-razvernut-obraz-docker-s-pomoshhyu-terraform/
https://yandex.cloud/ru/docs/compute/operations/vm-connect/auth-inside-vm#tf_1


:)
https://stackoverflow.com/questions/45143567/can-a-dockerfile-push-itself-to-a-registry
https://www.snopes.com/fact-check/the-write-stuff/

