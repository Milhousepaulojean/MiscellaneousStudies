
   
const servicesTest = require('../../services/servicesSample')
const app = require('../../config/server');

describe('teste com services',() =>{
    it('services 01', () => {
        app.repository.repositorySample.callDynamoDBGetItems = jest.fn().mockReturnValue("Teste vindo do repository.")
        let abc = servicesTest.callServicesExample({message: "abc"});

        console.log(`Testing services ${JSON.stringify(abc)}`);
    })
})