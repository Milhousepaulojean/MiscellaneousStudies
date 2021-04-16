module.exports = function(){
    
    this.getData = function(connection, callback){
        connection.query('select * from Persons;', callback);
    };

    return this;
}