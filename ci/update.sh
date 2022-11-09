aws s3 rm --recursive s3://haryel-ifsp-angular
npm install
npm run build
aws s3 sync ./dist/ s3://haryel-ifsp-angular