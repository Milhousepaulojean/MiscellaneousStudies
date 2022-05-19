//const aws = require('aws-sdk');
const repositories = require('./repositorySample');

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

describe('64564233', () => {
    afterAll(() => {
    jest.resetAllMocks();
  });

    it('should get user', async () => {
        const actual = await repositories.callDynamoDBGetItems();
        expect(actual).toEqual({message: "true"});
    })
});
