module.exports = function(){
    
    this.saveData = function(object , connection, callback){
        connection.query('insert into Persons set ? ;', object, callback);
    }

    return this;
}