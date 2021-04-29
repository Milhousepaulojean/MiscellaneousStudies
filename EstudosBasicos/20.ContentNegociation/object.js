var http = require('http');

var options = {
    hostname: 'localhost',
    port: 3000,
    path: '/',
    Headers: {
        'Accept' : 'application/json'
    }

}


var buffer_body = []

http.get(options , function(res){
    
    res.on('data', function(chunck){
        buffer_body.push(chunck)
    });

    res.on('end', function(){
        var body_response =  Buffer.concat(buffer_body).toString();
        console.log(body_response);
    
    });

    res.on('error', function(){
        
    });

})