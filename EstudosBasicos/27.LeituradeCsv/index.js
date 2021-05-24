const csv = require('csv-parser');
const fs = require('fs');
var livro = [];

fs.createReadStream('Livros.csv')
    .pipe(csv())
    .on('data', (row) => {
        livro.push(row);
        console.log(livro)
    }
    )
    .on('end', () => {
        console.log('CSV file successfully processed');
    });