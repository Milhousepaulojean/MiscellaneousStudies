package Locacao.services;

import Locacao.entidades.*;
import Locacao.utils.*;
import org.junit.*;
import org.junit.rules.ErrorCollector;
import org.junit.rules.ExpectedException;

import java.util.*;

import static Locacao.entidades.DataUtils.isMesmaData;
import static Locacao.entidades.DataUtils.obterDataComDiferencaDias;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

@FixMethodOrder
public class LocacaoServiceTest {

    @Rule
    public ErrorCollector errorCollector = new ErrorCollector();

    @Rule
    public ExpectedException expectedException = ExpectedException.none();
    private  LocacaoService service;
    static int counter;

    @Before
    public void setupBefore(){
        System.out.println("Antes do Metodo");
        service = new LocacaoService();
        System.out.println(counter++);
    }

    @After
    public void setupAfter(){
        System.out.println("depois do metodo");
    }

    @BeforeClass
    public static void setupBeforeClass(){
        System.out.println("Antes da Classe ser Instanciada.");
    }

    @AfterClass
    public static void setupAfterClass(){
        System.out.println("Depois da Classe ser Instanciada.");
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

        assertEquals("Messagem que pode ser passada", 1, 1);
        assertEquals(0.51234, 0.512, 0.001);
        assertEquals(Math.PI, 3.14, 0.01);

        assertEquals(Integer.valueOf(i), i2);
        assertEquals(i, i2.intValue());

        assertEquals("bola", "bola");
        Assert.assertNotEquals("bola", "casa");
        Assert.assertTrue("bola".equalsIgnoreCase("Bola"));
        Assert.assertTrue("bola".startsWith("bo"));

        assertEquals(u1, u2);

        // Verifica se estao na mesma instacia
        Assert.assertSame(u3, u2);
        Assert.assertNotSame(u1, u3);

        Assert.assertNull(u4);
        Assert.assertNotNull(u2);

    }

    @Test
    public void deveAlugarFilme() throws Exception {
        Assume.assumeFalse(DataUtils.verificarDiaSemana(new Date(), Calendar.SATURDAY));
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));
        filmes.add(new Filme("Filme 2", 1, 2.2));

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        for (Filme locacaofilme : locacao.getFilme()) {
            if (locacaofilme.getPrecoLocacao() == 2.1) {
                assertThat(locacaofilme.getPrecoLocacao(), is(2.1));
            } else if (locacaofilme.getPrecoLocacao() == 2.2) {
                assertThat(locacaofilme.getPrecoLocacao(), is(2.2));
            } else {
                fail("Deveria retornar os valores, listados acima");
            }

        }


        assertEquals(4.3 , locacao.getValor(),0.01);
        assertThat((isMesmaData(locacao.getDataLocacao(), new Date())), is(true));
        assertThat((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1))), is(true));
    }

    @Test
    public void testeLocacaoErrorCollector() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        errorCollector.checkThat(locacao.getValor(), is(2.1));
        errorCollector.checkThat(((isMesmaData(locacao.getDataLocacao(), new Date()))), is(true));
        errorCollector.checkThat(((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1)))), is(true));
    }

    @Test(expected = FilmeSemEstoqueException.class)
    public void testeLocacaoSemEstoqueElegante() throws Exception {

        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 0, 2.1));

        //Acao
        service.alugarFilme(usuario, filmes);
    }

    @Test
    public void testeLocacaoSemEstoqueRobustaSemNomeUsuario() throws Exception {

        //Cenario
        List<Filme> filmes = new ArrayList<Filme>();

        //Acao
        try {
            service.alugarFilme(null, filmes);
            fail();
        } catch (LocadoraException e) {
            //Verificacao
            assertThat(e.getMessage(), is("Usuario sem nome"));
        }
    }

    @Test
    public void testeLocacaoSemEstoqueNovaSemNomedoFilme() throws Exception {
        Usuario usuario = new Usuario("Usuario 1");
        expectedException.expect(LocadoraException.class);
        expectedException.expectMessage("Nome do filme nao informado.");
        service.alugarFilme(usuario, null);
    }

    @Test
    public void deveLocarcomPromocaoPara3Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));
        filmes.add(new Filme("Filme 2", 1, 2.2));
        filmes.add(new Filme("Filme 3", 10, 2.3));

        Locacao locacao = service.alugarFilme(usuario, filmes);

        assertEquals(6.02, locacao.getValor()  ,  0.01);
    }

    @Test
    public void deveLocarcomPromocaoPara4Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));
        filmes.add(new Filme("Filme 2", 1, 2.2));
        filmes.add(new Filme("Filme 3", 10, 2.3));
        filmes.add(new Filme("Filme 4", 10, 2.4));

        Locacao locacao = service.alugarFilme(usuario, filmes);

        assertEquals(7.2 , locacao.getValor()  ,  0.1);
    }

    @Test
    public void deveLocarcomPromocaoPara5Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));
        filmes.add(new Filme("Filme 2", 1, 2.2));
        filmes.add(new Filme("Filme 3", 10, 2.3));
        filmes.add(new Filme("Filme 4", 10, 2.4));
        filmes.add(new Filme("Filme 5", 3, 2.5));

        Locacao locacao = service.alugarFilme(usuario, filmes);

        assertEquals(7.7 , locacao.getValor()  ,  0.1);
    }

    @Test
    public void deveLocarcomPromocaoPara6Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));
        filmes.add(new Filme("Filme 2", 1, 2.2));
        filmes.add(new Filme("Filme 3", 10, 2.3));
        filmes.add(new Filme("Filme 4", 10, 2.4));
        filmes.add(new Filme("Filme 5", 3, 2.5));
        filmes.add(new Filme("Filme 6", 3, 2.6));

        Locacao locacao = service.alugarFilme(usuario, filmes);

        assertEquals(10.3 , locacao.getValor()  ,  0.1);
    }

    @Test
    public void deveDevolvoerNaSegundaAlugarnoSabado() throws Exception {
        Assume.assumeTrue(DataUtils.verificarDiaSemana(new Date(), Calendar.SUNDAY));

        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificaco
        boolean ehsegunda =  DataUtils.verificarDiaSemana(locacao.getDataRetorno() , Calendar.MONDAY);
        assertTrue(ehsegunda);
    }
}