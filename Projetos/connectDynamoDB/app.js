const AWS = require('aws-sdk');
const connectFac = require('./connectFactory');
const config = require('./config');

    const params = {
        TableName: config.aws_table_name
    };

    connectFac().scan(params, function (err, data) {

        if (err) {
            console.log(err)
            
        } else {
            console.log(data)
            const { Items } = data;
            console.log(Items)
        }
    });