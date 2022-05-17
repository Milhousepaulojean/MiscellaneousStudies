import { Account } from '../account.js';
import { transfer } from '../transfer.js';
 
describe("transfer", () => {
  it("it should transfer 500 from an account with 1000 to another with 0", () => {
    // Criação do cenário
    const payerAccount = new Account(1, 1000)
    const receiverAccount = new Account(2, 0)
 
    // Execução do que está sendo testado
    const updatedAccounts = transfer(payerAccount, receiverAccount, 500)
 
    // Asserts
    expect(updatedAccounts.length).toBe(2);
 
    expect(updatedAccounts[0].id).toBe(1);
    expect(updatedAccounts[0].balance).toBe(500);
 
    expect(updatedAccounts[1].id).toBe(2);
    expect(updatedAccounts[1].balance).toBe(500);
  });

  it("it should transfer 50 from an account with 100 to another with 600", () => {
    const payerAccount = new Account(1, 100)
    const receiverAccount = new Account(2, 600)
    const updatedAccounts = transfer(payerAccount, receiverAccount, 50)
 
    expect(updatedAccounts).toHaveLength(2);
    expect(updatedAccounts).toEqual(
        expect.arrayContaining([
            expect.objectContaining({ id: 2, balance: 650 }),
            expect.objectContaining({ id: 1, balance: 50 })
        ]));
  });

  it('it should throw an error when transfer amount is negative', () => {
        const payerAccount = new Account(1, 1000);
        const receiverAccount = new Account(2, 1000);
    
        const updatedAccounts = () => {
            transfer(payerAccount, receiverAccount, -10);
        };
    
        expect(updatedAccounts).toThrow(Error('Invalid transfer amount: -10'));
    });
});