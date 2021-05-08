var mongoose = require('mongoose');
// Setup schema
var contactSchema = mongoose.Schema({
    name: {
        type: String
    }
});
// Export Contact model
var Contact = module.exports = mongoose.model('listingsAndReviews', contactSchema);
module.exports.get = function (callback, limit) {
    Contact.find(callback).limit(limit);
}