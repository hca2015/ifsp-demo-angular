aws s3 rm --recursive s3://haryel-ifsp-angular
cd infra
terraform destroy -auto-approve
cd ..
FILE="./server/index.zip"
if test -f "$FILE"; then
    rm -rf "$FILE"
fi