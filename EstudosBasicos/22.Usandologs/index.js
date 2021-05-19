const logger = require('./logger');
 
const obj = { name: 'teste' }
 
try {
    console.log(obj.name);
    logger.info('tudo funcionando!');
}
catch (error) {
    logger.error(error);
}