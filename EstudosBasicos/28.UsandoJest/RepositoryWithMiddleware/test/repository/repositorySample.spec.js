const repositoryTest = require('../../repository/repositorySample')
const app = require('../../config/server');

jest.mock('aws-sdk', () => {
    return {
        DynamoDB: jest.fn(() => {
            return {
                query: jest.fn(() => {
                    return {
                        promise: jest.fn().mockReturnValue({message: "true"})
                    };
                })
            };
        })
    };
});


describe('teste com Repository',() =>{
    beforeEach(() => {
        jest.resetModules() // Most important - it clears the cache
        process.env.TABLENAME = 'TableFake1'; // Make a copy
     });

    
    it('repository 01', async () => {

        let abc = await repositoryTest.callDynamoDBGetItems();

        console.log(`Testing repository ${JSON.stringify(abc)}`);
    
    })


    afterEach(() => {
        delete process.env.TABLENAME; // Make a copy
     });
})