var Request = require("request");

Request.get("http://localhost:3000/posts", (error, response, body) => {
    if(error) {
        return console.dir(error);
    }

    JSON.parse(body).map(function(e){
        console.log(e.id);
        console.log(e.title);
        console.log(e.author)
        e.arrayObjects.map(function(f){
            if(f.teste == 2){
                console.log("Valor testado corresponde a ", f.teste)
            }else{
                console.log(f.teste)
            }
        })

    })
});