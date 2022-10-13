const {io} = require('socket.io-client');

const socket = io('ws://localhost:3000');

socket.on("hello" , (arg) =>{
    console.log(arg)
})

socket.on("message" , (arg) =>{
    console.log(arg)
})

socket.emit("howdy" , "stranger")
socket.emit("teste" , "teste 1")
