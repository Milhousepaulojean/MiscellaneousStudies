const AWS = require('aws-sdk');
const config = require('./config');

    AWS.config.update(config.aws_remote_config);

    const docClient = new AWS.DynamoDB.DocumentClient();

    const params = {
        TableName: config.aws_table_name
    };

    docClient.scan(params, function (err, data) {

        if (err) {
            console.log(err)
            
        } else {
            console.log(data)
            const { Items } = data;
            console.log(Items)
        }
    });