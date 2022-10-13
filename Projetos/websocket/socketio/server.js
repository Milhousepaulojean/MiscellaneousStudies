const {Server} = require('socket.io');

const io = new Server(3000);

io.on("connection", (socket) => {
    socket.emit("hello" , "world");

    socket.on("howdy", (arg)=> {
        console.log(arg);
    })

    socket.on("teste", (arg)=> {
        console.log(arg);
    })
})