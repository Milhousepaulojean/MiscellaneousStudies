const repositoryTest = require('../../repository/repositorySample')
const app = require('../../config/server');

let mockDocumentClient = {
    promise: jest.fn()
 }

jest.mock('aws-sdk', () => {
    return {
        DynamoDB: jest.fn(() => {
            return {
                query: jest.fn().mockImplementation(() => {
                    return {
                        //promise: jest.fn().mockReturnValue({message: "true"})
                        promise: mockDocumentClient.promise
                    };
                })
            };
        })
    };
});

describe('teste com Repository',() =>{
    beforeEach(() => {
        jest.resetModules(); // Most important - it clears the cache
        jest.clearAllMocks();
        process.env.TABLENAME = 'TableFake1'; // Make a copy
     });

    
    it('repository 01', async () => {
        mockDocumentClient.promise.mockReturnValue({message: "true"})
        let abc = await repositoryTest.callDynamoDBGetItems();

        console.log(`Testing repository ${JSON.stringify(abc)}`);
    
    })


    it('repository 02', async () => {
        mockDocumentClient.promise.mockReturnValue({message: "true2"})
        let abc = await repositoryTest.callDynamoDBGetItems();

        console.log(`Testing repository ${JSON.stringify(abc)}`);
    
    })


    afterEach(() => {
        delete process.env.TABLENAME; // Make a copy
     });
})