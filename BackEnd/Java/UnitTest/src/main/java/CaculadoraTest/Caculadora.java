package CaculadoraTest;

public class Caculadora {

    public int soma(int a, int b){
        return a + b;
    }

    public int subtrair(int a, int b) {
        return a - b;
    }

    public int multiplicar(int a, int b) {
        return a * b;
    }

    public int divisao(int a, int b) throws NumeroNaoEDivisivelPorZero {
        if (a == 0 || b == 0){
            throw new NumeroNaoEDivisivelPorZero();
        }

        return a / b;
    }
}
