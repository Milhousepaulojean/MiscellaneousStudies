const request = require('supertest');
const app = require('../../config/server');

describe('Testing routes',()=>{
    //Mocks
    it('should be active server return 200', async ()=>{
        app.services.servicesSample.callServicesExample = jest.fn().mockReturnValue("Teste vindo do Jest.");
        
        const response= await request(app).get('/');
        
        expect(response.statusCode).toEqual(200);
        expect(response.text).toEqual('Teste vindo do Jest.');
        

    });
});