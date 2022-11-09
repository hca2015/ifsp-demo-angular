terraform plan && terraform apply -auto-approve
lambda_url=$(terraform output -raw lambda_url)
echo $(lambda_url)