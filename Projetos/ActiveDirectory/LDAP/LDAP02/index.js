var ActiveDirectory = require('activedirectory');
var config = { url: 'ldap://www.zflexldap.com',
               baseDN: 'dc=zflexsoftware,dc=com'
             }


var ad = new ActiveDirectory(config);
var username = 'guest1';
var password = 'guest1password';
 
ad.authenticate(username, password, function(err, auth) {
  if (err) {
    console.log('ERROR: '+JSON.stringify(err));
    return;
  }
  
  if (auth) {
    console.log('Authenticated!');
  }
  else {
    console.log('Authentication failed!');
  }
});