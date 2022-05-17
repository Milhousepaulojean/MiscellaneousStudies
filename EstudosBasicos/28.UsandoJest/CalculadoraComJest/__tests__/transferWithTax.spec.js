import { Account } from '../account.js';
import { transferWithTax } from '../transferWithTax.js';
 
describe('transferWithTax', () => {
    test('it should charge 100 from the payer account with 1000 for a 500 transfer to a receiver account with 0', () => {
        const payerAccount = new Account(1, 1000);
        const receiverAccount = new Account(2, 0);
 
        const updatedAccounts = transferWithTax(payerAccount, receiverAccount, 500);
 
        expect(updatedAccounts).toEqual(
            expect.arrayContaining([
                expect.objectContaining({id: 1, balance: 400}),
                expect.objectContaining({id: 2, balance: 500}),
            ])
        );
    });
});