const fs = require('fs');
require('dotenv').config()
var qtd = 0; 

fs.readdir(process.env.PATH_FOLDER, (err, files) => {
    files.forEach(file => {
        console.log(file);
        qtd++;
    });
    console.log("Quantidade de itens: ",qtd)
});
