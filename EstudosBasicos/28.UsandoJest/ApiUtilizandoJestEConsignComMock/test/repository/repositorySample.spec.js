const repositoryTest = require('../../repository/repositorySample')
const app = require('../../config/server');

describe('teste com services',() =>{
    it('services 01', () => {
        let abc = repositoryTest.callRepository();

        console.log(`Testing repository ${JSON.stringify(abc)}`);
    
    })
})