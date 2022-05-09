#!/bin/sh

#Create Folder App
mkdir app

#Create Folder App/src
mkdir app/src

#Install NPM INT
npm app/init -y

#Install express
npm app/ i express --save

#Install cors
npm i cors --save

#Install body-parser
npm i body-parser --save

#Install Nodemon
npm i --save-dev nodemon

#Install Consign
npm i consign --save

#Start Project
nodemon