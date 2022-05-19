const aws = require('aws-sdk');
const { getUser } = require('./handler');
 

jest.mock('aws-sdk', () => {
  const mDocumentClient = { query: jest.fn() };
  const mDynamoDB = { DocumentClient: jest.fn(() => mDocumentClient) };
  return { DynamoDB: mDynamoDB };
});

const mDynamoDb = new aws.DynamoDB.DocumentClient();

describe('64564233', () => {
  afterAll(() => {
    jest.resetAllMocks();
  });
  it('should get user', async () => {
    const mResult = { name: 'teresa teng' };
    mDynamoDb.query.mockImplementationOnce((_, callback) => callback(null, mResult));
    
    const actual = await getUser(1);
    
    expect(actual).toEqual({ name: 'teresa teng' });
    expect(mDynamoDb.query).toBeCalledWith(
      {
        TableName: 'test-table',
        Key: {
          PK: '1',
          SK: '1',
        },
      },
      expect.any(Function),
    );
  });
});