var CryptoJS = require("crypto-js");

// Encrypt
var ciphertext = CryptoJS.AES.encrypt('my message', 'secret key 123').toString();

console.log(ciphertext); // 'my message'
// Decrypt
var bytes  = CryptoJS.AES.decrypt(ciphertext, 'secret key 123');

var deciphertext = bytes.toString(CryptoJS.enc.Utf8);

console.log(deciphertext); // 'my message'