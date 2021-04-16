module.exports = function(){
    
    this.getData(connection, callback){
        connection.query('select * from Persons;', callback);
    }

    return this;
}