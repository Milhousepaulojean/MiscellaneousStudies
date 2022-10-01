#!/bin/sh

#Install NPM INT
npm init -y

#Install express
npm i express --save

#Install cors
npm i cors --save

#Install body-parser
npm i body-parser --save

#Install Nodemon
npm i --save-dev nodemon

#Install Consign
npm i consign --save

#Install swagger
npm i --save-dev swagger-autogen
npm i --save-dev swagger-ui-express

# Create Folders and Files
mkdir config
touch config/server.js

mkdir routes
touch routes/routes.js

touch swagger_output.json
mkdir services
touch services/servicesSample.js
touch services/IservicesSample.js

mkdir repository
touch repository/repositorySample.js
touch services/IrepositorySample.js

mkdir middleware
touch middleware/middlewareSample.js

touch Task.todo
touch index.js


#Start Project
#nodemon