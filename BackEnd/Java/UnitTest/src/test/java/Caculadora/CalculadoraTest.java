package Caculadora;

import org.junit.Assert;
import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;

public class CalculadoraTest {

    @Test
    public void deveSomarDoisNumero() {
        //Cenario
        int a = 3;
        int b = 3;

        //Acao
        int resultado = new Caculadora().soma(a, b);

        //Verificacao
        Assert.assertThat(resultado, is(6));
    }

    @Test
    public void deveSubtrairDoisNumero() {
        //Cenario
        int a = 3;
        int b = 2;

        //Acao
        int resultado = new Caculadora().subtrair(a, b);

        //Verificacao
        Assert.assertThat(resultado, is(1));
    }

    @Test
    public void deveMultiplicacoDoisNumero() {
        //Cenario
        int a = 5;
        int b = 2;

        //Acao
        int resultado = new Caculadora().multiplicar(a, b);

        //Verificacao
        Assert.assertThat(resultado, is(10));
    }

    @Test
    public void deveDividirDoisNumero() throws NumeroNaoEDivisivelPorZero {
        //Cenario
        int a = 6;
        int b = 2;

        //Acao
        int resultado = new Caculadora().divisao(a, b);

        //Verificacao
        Assert.assertThat(resultado, is(3));
    }

    @Test(expected = NumeroNaoEDivisivelPorZero.class)
    public void naoDeveDividirDoisNumeroPorZero() throws NumeroNaoEDivisivelPorZero {
        //Cenario
        int a = 6;
        int b = 0;

        //Acao
       new Caculadora().divisao(a, b);
    }
}
