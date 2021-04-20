const { check , validationResult} = require('express-validator');

module.exports = function(application){

    application.post('/testePost',
    [
        check('City').not().isEmpty().withMessage('Name must have more than 5 characters'),
    ],
    function(req , res){
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            return res.status(422).jsonp(errors.array());
          } else {
            res.send({});
          }
    })
}

