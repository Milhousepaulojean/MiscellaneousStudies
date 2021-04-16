module.exports = function(){
    
<<<<<<< HEAD
    this.getData = function(connection, callback){
=======
    this.getData(connection, callback){
>>>>>>> ada7cf1 (nodejs: Commit aplicado demonstra os estudo de node Utilizando Models com Consign .)
        connection.query('select * from Persons;', callback);
    }

    return this;
}