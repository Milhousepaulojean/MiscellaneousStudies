package Locacao.services;

import Locacao.entidades.DataUtils;
import Locacao.utils.Filme;
import Locacao.utils.Locacao;
import Locacao.utils.Usuario;
import org.junit.Assume;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.*;

import static Locacao.entidades.DataUtils.isMesmaData;
import static Locacao.entidades.DataUtils.obterDataComDiferencaDias;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;
import static org.junit.runners.Parameterized.*;

@RunWith(Parameterized.class)
public class CalculoValorLocacaoTest {

    @Parameter
    public List<Filme> filmes;

    @Parameter(value = 1)
    public Double valorLocacao;

    private LocacaoService service;

    @Before
    public void setupBefore() {
        service = new LocacaoService();
    }

    @Parameters
    public static Collection<Object[]> getParametros() {
        return Arrays.asList(new Object[][]{
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1)
                ),2.1},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2)
                ),4.3},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3)
                ),},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4)
                ),6.02},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4),
                        new Filme("Filme 5", 1, 2.5)
                ),7.2 },
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4),
                        new Filme("Filme 5", 1, 2.5),
                        new Filme("Filme 6", 1, 2.6)
                ),7.7}

        });
    }

    @Test
    public void deveAlugarFilme() throws Exception {
        Assume.assumeFalse(DataUtils.verificarDiaSemana(new Date(), Calendar.SATURDAY));
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //verificacao
        assertEquals(valorLocacao , locacao.getValor(),0.01);
        assertThat((isMesmaData(locacao.getDataLocacao(), new Date())), is(true));
        assertThat((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1))), is(true));
    }
}
