# npm is the most widely used package manager for javascript projects
# and includes node.js by default
# node.js is a tool for building using javascript
# nginx is a web server

https://catalog.us-east-1.prod.workshops.aws/workshops/85cd2bb2-7f79-4e96-bdee-8078e469752a/en-US/introduction

# web
sudo service nginx restart | status
npm install
cd ~/web-tier
npm run build

# app 
cd ~/app-tier
npm install
pm2 stop
pm2 start

curl http://localhost:4000/health
curl http://localhost:4000/transaction

