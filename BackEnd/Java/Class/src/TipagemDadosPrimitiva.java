public class TipagemDadosPrimitiva {
    public static void main(String[] args) {
        ///Boolean
        boolean verdadeiro = true;
        boolean falso = false;
        System.out.println("o valor e: "+verdadeiro);
        System.out.println("o valor e: "+ falso);

        //Number
        int valorInteiro = 50;
        System.out.println("O Valor inteiro informado foi: "+valorInteiro);

        //Long
        Long valorLong = 50l;
        System.out.println("O Valor Long informado foi: "+ valorLong);

        //Float
        float pontoflutuante = 5.000000f;
        System.out.println("O Valor Float informado foi: "+ pontoflutuante);

        //Double
        double doub = 5.5;
        System.out.println("O Valor Double informado foi: "+ doub);

        //Character
        char c = 't';
        System.out.println("O Valor Character informado foi: "+ c);

        //Operadores: +, -, *, /
        System.out.println("O Valor do resultado da soma informado foi: " + (10 + 1));
        System.out.println("O Valor do resultado da subtracao e informado foi: " + (8 - 1));
        System.out.println("O Valor do resultado da multiplicacao informado foi: " + (100 * 0.5F));
        System.out.println("O Valor do resultado da Divisao informado foi: " + (0.5 / 30));
        System.out.println("O Valor do resultado da resto informado foi: " + (11 % 2));

        //Incremeto & Decremento
        int valuePositivo = 3;
        int valueNegativo = 1;
        System.out.println("O Valor do Incremento informado foi: " + (++valuePositivo));
        System.out.println("O Valor do Decremento informado foi: " + (--valueNegativo));

        //Relacionais
        System.out.println("Valore sao iguais: " + (5==5));
        System.out.println("Valore sao diferentes: " + (3!=5));
        System.out.println("3 e menor que 5: " + (3<=5));
        System.out.println("5 e maior que 3: " + (3>=5));

        //Operadores lógicos
        System.out.println("Valores com e: " + (true && false));
        System.out.println("Valores com ou: " + (true || false));
        System.out.println("Valores diferente: " +  (!true));

    }
}
