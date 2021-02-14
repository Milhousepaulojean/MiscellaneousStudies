package servicos;

import entidades.DataUtils;
import org.junit.Assert;
import org.junit.jupiter.api.Test;
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

    @Test
    void main() {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        Filme filme = new Filme("Filme 1",15 , 2.1);

        //Acao
        Locacao locacao  =  service.alugarFilme(usuario, filme);

        //Verificacao
        assertThat(locacao.getValor(), is(equalTo(2.1)));
        assertThat(isMesmaData(locacao.getDataLocacao() , new Date()) , is(true));
        assertThat(isMesmaData(locacao.getDataRetorno() , obterDataComDiferencaDias(1)) , is(true));
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




