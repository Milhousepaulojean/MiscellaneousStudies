var ActiveDirectory = require('activedirectory');
var config = { url: 'ldap://www.zflexldap.com',
               baseDN: 'dc=zflexsoftware,dc=com'
             }


             var query = 'cn=*George*';
 
             var ad = new ActiveDirectory(config);
             ad.findUsers(query, true, function(err, users) {
               if (err) {
                 console.log('ERROR: ' +JSON.stringify(err));
                 return;
               }
              
               if ((! users) || (users.length == 0)) console.log('No users found.');
               else {
                 console.log('findUsers: '+JSON.stringify(users));
               }
             });