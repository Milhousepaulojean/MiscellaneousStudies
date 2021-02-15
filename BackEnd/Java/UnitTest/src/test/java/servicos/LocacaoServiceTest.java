package servicos;

import entidades.DataUtils;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.jupiter.api.Test;
import org.junit.rules.ErrorCollector;
import org.junit.rules.ExpectedException;
import utils.Filme;
import utils.Locacao;
import utils.Usuario;

import java.util.Date;

import static entidades.DataUtils.isMesmaData;
import static entidades.DataUtils.obterDataComDiferencaDias;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;


class LocacaoServiceTest {

    public ErrorCollector error = new ErrorCollector();
    @Rule
    ExpectedException exception = ExpectedException.none();

    @Test
    void testeLocacao() throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1",1 , 2.1);

        //Acao
        Locacao locacao  =  service.alugarFilme(usuario, filme);

        //Verificacao
        error.checkThat(locacao.getValor(), is(equalTo(2.1)));
        error.checkThat((isMesmaData(locacao.getDataLocacao() , new Date())) , is(true));
        error.checkThat((isMesmaData(locacao.getDataRetorno() , obterDataComDiferencaDias(1))) , is(true));
    }

    @Test
    public void testeLocacaoPorEstoque() throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1",0 , 2.1);

        //Acao
        try{
            Locacao locacao  =  service.alugarFilme(usuario, filme);
            Assert.fail("Deveria ter lancado uma excessao.");
        }
        catch (Exception e){
            assertThat(e.getMessage() , is("Nao esta no estoque."));
        }
    }
    
    @Test
    void asserts(){
        Assert.assertTrue(true);
        Assert.assertFalse(false);

        Assert.assertEquals("Erro de comparacao", 1, 1);
        Assert.assertEquals(0.51234, 0.512, 0.001);
        Assert.assertEquals(Math.PI, 3.14, 0.01);

        int i = 5;
        Integer i2 = 5;
        Assert.assertEquals(Integer.valueOf(i), i2);
        Assert.assertEquals(i, i2.intValue());

        Assert.assertEquals("bola", "bola");
        Assert.assertNotEquals("bola", "casa");
        Assert.assertTrue("bola".equalsIgnoreCase("Bola"));
        Assert.assertTrue("bola".startsWith("bo"));

        Usuario u1 = new Usuario("Usuario 1");
        Usuario u2 = new Usuario("Usuario 1");
        Usuario u3 = null;

        Assert.assertEquals(u1, u2);

        Assert.assertSame(u2, u2);
        Assert.assertNotSame(u1, u2);

        Assert.assertNull(u3);
        Assert.assertNotNull(u2);

    }
}




