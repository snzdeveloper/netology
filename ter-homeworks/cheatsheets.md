```sh
yc resource-manager cloud list
yc resource-manager folder list

yc iam service-account create --name sa-terraform
yc iam key create  --service-account-name sa-terraform   --folder-name default   --output ~/.sa-terraform-key.json
yc iam key list --service-account-name=sa-terraform

yc resource-manager folder add-access-binding <folder-id> --role <editor> --subject serviceAccount:<account-id>

yc compute image list --folder-id standard-images  --limit 0  --jq '.[].family' | sort | uniq


```