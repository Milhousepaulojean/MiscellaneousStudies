var request = require('request');
var SpotifyWebApi = require('spotify-web-api-node');


var token;


module.exports = function(app){
    app.get('/token' , async function(req , res){


            // var authOptions = {
            // url: 'https://accounts.spotify.com/api/token',
            // headers: {
            //     'Authorization': 'Basic ' + (new Buffer('24df7c36d685477282301beba74058a9' + ':' + '96d69d1298df4cd4bf650a42a0d7d704').toString('base64'))
            // },
            // form: {
            //     grant_type: 'client_credentials'
            // },
            // json: true
            // };

            // request.post(authOptions, function(error, response, body) {
            // if (!error && response.statusCode === 200) {
            //     token = body.access_token;
            //     res.send(token)
            // }
        
        //});

        var spotifyApi = new SpotifyWebApi({
            clientID: '24df7c36d685477282301beba74058a9', // Your spotify application client id.
            clientSecret: '96d69d1298df4cd4bf650a42a0d7d704', // Your spotify application client secret.
            redirectURL: 'http://localhost:300/callback'
        });

        console.log(await spotifyApi.getAlbum())
    })

    app.get('/album' , function(req, res){
       spotifyApi.getArtistAlbums(token).then(
        function(data) {
            console.log('Artist albums', data.body);
        },
        function(err) {
            console.error(err);
        }
        );
    })

    app.get('/callback' , function(req, res){
        console.log(res.body)
    })
}
