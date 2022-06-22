const { Given, When, Then } = require('cucumber');
const request = require('supertest');
const app = require('../../../config/server')
const assert = require('assert')
const jest = require('jest')

let ret;
let urlget;

Given('chamar a url {string}', function (string) {
           // Write code here that turns the phrase above into concrete actions
           urlget = string;
         });

When('verificar qual foi o retorno', async function () {
           // Write code here that turns the phrase above into concrete actions
           console.log(`Url: ${urlget}`) 
           app.services.servicesSample.callServicesExample = {};

           ret= await request(app).get(urlget);
            console.log(`body: ${JSON.stringify(ret.text)}`) 
         });

         Then('precisa ser igual a {string}', (expectedResponse) =>{
           // Write code here that turns the phrase above into concrete actions
            assert.equal(ret.status, expectedResponse)
         });