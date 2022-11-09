echo 'Verificando zip da função lambda'
sleep 2
FILE="./server/index.zip"
if test -f "$FILE"; then
    echo 'Deletando zip da função lambda'
    sleep 2
    rm -rf "$FILE"
fi
cd server
echo 'Criando zip da função lambda'
sleep 2
zip -r index.zip ./index.js
cd ..
cd infra
echo 'Inicializando terraform'
sleep 2
terraform init
echo 'Iniciando deploy da infra'
sleep 2
terraform plan && terraform apply -auto-approve
LAMBDA_URL="$(terraform output -raw lambda_url)"
cd ..

CAMINHO_RAIZ="$(pwd)"

cd src/environments/
sed -i '' -e "s#_url_#$LAMBDA_URL#g" environment.ts
sed -i '' -e "s#_url_#$LAMBDA_URL#g" environment.prod.ts

cd $CAMINHO_RAIZ
echo 'Compilando a aplicação'
sleep 2
npm install
npm run build
echo 'Enviando a aplicação para o S3'
sleep 2
aws s3 sync ./dist/ s3://haryel-ifsp-angular
echo 'Removendo url'
sleep 2
git restore ./src/environments/environment.ts
git restore ./src/environments/environment.prod.ts
echo ''
echo ''
echo $LAMBDA_URL