import { sum, sub } from '../calculator';
 
describe("calculator sum", () => {
    it("it should sum two positive values", () => {
        const result = sum(2, 2);
        expect(result).toBe(4);
    });

    it("it should sum numbers with a negative value", () => {
        const result = sum(2, -2);
        expect(result).toBe(0);
    });

    it("it should subtract numbers value", () => {
        const result = sub(2, 2);
        expect(result).toBe(0);
    });

});