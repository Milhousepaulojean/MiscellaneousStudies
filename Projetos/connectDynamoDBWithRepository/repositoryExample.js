const connectFac = require('./connectFactory');
const config = require('./config');

var repositorioTabelaChamadaDeTodosOsItems = async function (req, res, next) {
   const params = {
        TableName: config.aws_table_name
    };

   return await connectFac().scan(params).promise();
}

 module.exports = {
  repositorioTabelaChamadaDeTodosOsItems
}