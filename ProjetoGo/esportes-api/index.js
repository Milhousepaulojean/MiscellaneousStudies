import express from 'express';
import morgan from 'morgan';
import path from 'path'
import fs from 'fs';

const port = 8080
const app = express();
app.use(morgan('tiny'))
// app.use(express.static("public", { extensions: "json", redirect: false, index: false }))


app.use(async (req, res, next) => {
    const [max, min] = [10, 0];
    const timeToWait = Math.random() * (max - min) + min
    setTimeout(() => {
        const file = `${path.resolve()}/public/${req.url}.json`;
        if (fs.existsSync(file) ) {
            res.sendFile(file)
            return
        }
        res.sendStatus(404)
    }, timeToWait * 1000);
})

app.listen(port, () => console.log(`listening on port=${port}`))