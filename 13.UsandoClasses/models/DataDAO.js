function DataDAO(connection){
    this._conneciton = connection;
}

DataDAO.prototype.saveData = function(object, callback){
    this._conneciton.query('insert into Persons set ? ;', object, callback);
}

module.exports = function(){
    return DataDAO;
}