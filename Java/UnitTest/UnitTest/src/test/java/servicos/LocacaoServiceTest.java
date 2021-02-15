package servicos;

import entidades.FilmeSemEstoqueException;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ErrorCollector;
import org.junit.rules.ExpectedException;
import utils.Filme;
import utils.Locacao;
import utils.Usuario;
import java.util.Date;
import static entidades.DataUtils.isMesmaData;
import static entidades.DataUtils.obterDataComDiferencaDias;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;

public class LocacaoServiceTest {

    @Rule
    public ErrorCollector errorCollector = new ErrorCollector();

    @Rule
    public ExpectedException expectedException = ExpectedException.none();

    @Test
    public void testeLocacao() throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1", 1, 2.1);

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filme);

        //Verificacao
        assertThat(locacao.getValor(), is(2.1));
        assertThat((isMesmaData(locacao.getDataLocacao(), new Date())), is(true));
        assertThat((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1))), is(true));
    }

    @Test
    public void testeLocacaoErrorCollector() throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1", 1, 2.1);

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filme);

        //Verificacao
        errorCollector.checkThat(locacao.getValor(), is(2.1));
        errorCollector.checkThat(((isMesmaData(locacao.getDataLocacao(), new Date()))), is(true));
        errorCollector.checkThat(((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1)))), is(true));
    }

    @Test(expected = Exception.class)
    public void testeLocacaoSemEstoqueElegante() throws Exception {

        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1", 0, 2.1);

        //Acao
        service.alugarFilme(usuario, filme);
    }

    @Test
    public void testeLocacaoSemEstoqueRobusta() throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1", 0, 2.1);

        //Acao
        try {
            Locacao locacao = service.alugarFilme(usuario, filme);
            fail("Deveria ter lancado uma excessao.");
        } catch (Exception e) {
            //Verificacao
            assertThat("Nao esta no estoque.", is(e.getMessage()));
        }
    }

    @Test
    public void testeLocacaoSemEstoqueNova() throws Exception {

        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1", 0, 2.1);

        expectedException.expect(Exception.class);
        expectedException.expectMessage("Nao esta no estoque.");

        //Acao
        service.alugarFilme(usuario, filme);

    }


    @Test
    public void asserts() {

        Usuario u1 = new Usuario("Usuario 1");
        Usuario u2 = new Usuario("Usuario 1");
        Usuario u3 = u2;
        Usuario u4 = null;
        int i = 5;
        Integer i2 = 5;

        Assert.assertTrue(true);
        Assert.assertFalse(false);

        Assert.assertEquals("Messagem que pode ser passada", 1, 1);
        Assert.assertEquals(0.51234, 0.512, 0.001);
        Assert.assertEquals(Math.PI, 3.14, 0.01);

        Assert.assertEquals(Integer.valueOf(i), i2);
        Assert.assertEquals(i, i2.intValue());

        Assert.assertEquals("bola", "bola");
        Assert.assertNotEquals("bola", "casa");
        Assert.assertTrue("bola".equalsIgnoreCase("Bola"));
        Assert.assertTrue("bola".startsWith("bo"));

        Assert.assertEquals(u1, u2);

        // Verifica se estao na mesma instacia
        Assert.assertSame(u3, u2);
        Assert.assertNotSame(u1, u3);

        Assert.assertNull(u4);
        Assert.assertNotNull(u2);

    }
}




