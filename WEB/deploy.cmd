# npm is the most widely used package manager for javascript projects
# and includes node.js by default
# node.js is a tool for building using javascript
# nginx is a web server

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

