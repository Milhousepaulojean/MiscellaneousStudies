var MongoClient = require('mongodb').MongoClient

//Create a MongoDB client, open a connection to DocDB; as a replica set,
//  and specify the read preference as secondary preferred

// var client = MongoClient.connect(
//     'mongodb://foo:barbut8chars@docdb-cluster-demo.cluster-cxuc64agk7j2.us-west-2.docdb.amazonaws.com:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false',
//     {
//         tlsCAFile: `global-bundle.pem` //Specify the DocDB; cert
//     },
//     function (err, client) {
//         if (err)
//             throw err;

//         //Specify the database to be used
//         db = client.db('sample-database');

//         //Specify the collection to be used
//         col = db.collection('sample-collection');

//         //Insert a single document
//         col.insertOne({ 'hello': 'Amazon DocumentDB' }, function (err, result) {
//             //Find the document that was previously written
//             col.findOne({ 'hello': 'DocDB;' }, function (err, result) {
//                 //Print the result to the screen
//                 console.log(result);

//                 //Close the connection
//                 client.close()
//             });
//         });
//     });

const uri = "mongodb://foo:barbut8chars@docdb-cluster-demo.cluster-cxuc64agk7j2.us-west-2.docdb.amazonaws.com:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false";


const client = new MongoClient(uri);

async function connect() {
    try {
        // Conectar ao cluster
        await client.connect();

        console.log("Conectado ao DocumentDB");

    } catch (error) {
        console.error("Erro ao conectar ao DocumentDB:", error);
    } finally {
        // Certifique-se de fechar a conexão quando terminar
        await client.close();
        console.log("Conexão fechada");
    }
}

// Chame a função connect para iniciar a conexão
connect();