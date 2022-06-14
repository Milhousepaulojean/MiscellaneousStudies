module.exports = function(app){
    this.saveobj = async function(objectTARGET){
        
        const dynamodb = app.middleware.ConnectFactory;
        let retorno;  
        console.log(process.env.TABLENAME)
        var params = {
            TableName: process.env.TABLENAME,
            Item:{
                message: objectTARGET
            }
            };

         
            try {
                retorno = await dynamodb.put(params).promise();
                console.log(` sucesso ${JSON.stringify(retorno)}` );
            } catch (error) {
                console.log(` error ${JSON.stringify(error.message)}` );
                //throw new error(error.message)
            }

        return retorno
    }

    return this
}
