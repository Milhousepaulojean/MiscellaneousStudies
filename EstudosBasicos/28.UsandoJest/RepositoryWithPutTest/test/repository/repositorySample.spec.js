const repositoryTest = require('../../repository/repositorySample')
const app = require('../../config/server');

const mockput = jest.fn();

jest.mock('aws-sdk', () => {
  return {
    DynamoDB: { // just an object, not a function
      DocumentClient: jest.fn(() => ({
        put: jest.fn(() => ({
          promise: mockput
        }))
      }))
    }
  }});


describe('teste com Repository',() =>{
    beforeEach(() => {
        jest.resetModules() // Most important - it clears the cache
        process.env.TABLENAME = 'TableFake1'; // Make a copy
     });

    
    it('repository 01', async () => {

        mockput.mockImplementation(() => {
            return Promise.resolve({message: "true"});
        });
        let abc = await repositoryTest.saveobj({});

        console.log(`Testing repository ${JSON.stringify(JSON.stringify(abc))}`);
    
    })

    it('repository 02', async () => {

        mockput.mockImplementation(() => {
            return Promise.reject({message: "true"});
        });
        try {
           await repositoryTest.saveobj({});

        } catch (error) {
          console.log(`Error ${JSON.stringify(JSON.stringify(error.message))}`);
        }
        
    
    })

    afterEach(() => {
        delete process.env.TABLENAME; // Make a copy
     });
})