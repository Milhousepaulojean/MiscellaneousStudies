package Locacao.services;

import Locacao.Dao.LocacaoDao;
import Locacao.Dao.LocacaoDaoFake;
import Locacao.Matchers.DiasdaSemana;
import Locacao.entidades.*;
import Locacao.utils.*;
import org.junit.*;
import org.junit.rules.ErrorCollector;
import org.junit.rules.ExpectedException;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import java.util.*;

import static Locacao.entidades.DataUtils.*;
import static Locacao.entidades.DataUtils.isMesmaData;
import static Locacao.entidades.DataUtils.obterDataComDiferencaDias;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;
import static org.junit.runners.Parameterized.*;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@FixMethodOrder
@RunWith(Parameterized.class)
public class LocacaoServiceTest {

    @Parameter
    public List<Filme> filmes;

    @Parameter(value = 1)
    public Double valorLocacao;

    @Parameter(value = 2)
    public String descripton;

    private LocacaoService service;
    private LocacaoDao locacaoDao;
    private EmailServices emailServices;

    private SPCServices spcServices;

    //@Parameters(name="Teste: [JSON] {0} - [Valor] {1} - [Descricao] {2}")
    @Parameters(name = "Teste: [Descricao] {2}")
    public static Collection<Object[]> getParametros() {
        return Arrays.asList(new Object[][]{
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1)
                ), 2.1, "Descricao 1"},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2)
                ), 4.3, "Descricao 2"},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3)
                ), 6.02, "Descricao 3"},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4)
                ), 7.2, "Descricao 4"},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4),
                        new Filme("Filme 5", 1, 2.5)
                ), 7.7, "Descricao 5"},
                {Arrays.asList(
                        new Filme("Filme 1", 1, 2.1),
                        new Filme("Filme 2", 1, 2.2),
                        new Filme("Filme 3", 1, 2.3),
                        new Filme("Filme 4", 1, 2.4),
                        new Filme("Filme 5", 1, 2.5),
                        new Filme("Filme 6", 1, 2.6)
                ), 10.3, "Descricao 6"}

        });
    }

    @Rule
    public ErrorCollector errorCollector = new ErrorCollector();

    @Rule
    public ExpectedException expectedException = ExpectedException.none();

    static int counter;

    @Before
    public void setupBefore() {
        System.out.println("Antes do Metodo");
        service = new LocacaoService();
        locacaoDao = mock(LocacaoDao.class);
        spcServices = mock(SPCServices.class);
        emailServices = mock(EmailServices.class);

        service.setSpcServices(spcServices);
        service.setLocacaoDao(locacaoDao);
        service.setSEmailServices(emailServices);

        System.out.println(counter++);
    }

    @After
    public void setupAfter() {
        System.out.println("depois do metodo");
    }

    @BeforeClass
    public static void setupBeforeClass() {
        System.out.println("Antes da Classe ser Instanciada.");
    }

    @AfterClass
    public static void setupAfterClass() {
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
    public void testeLocacaoErrorCollector() throws Exception {
        //Cenario
        Usuario user = new Usuario("Usuario 1");
        List<Filme> listFilme = new ArrayList<Filme>();
        listFilme.add(new Filme("Filme 1", 1, 2.1));

        //Acao
        Locacao locacao = service.alugarFilme(user, listFilme);

        //Verificacao
        errorCollector.checkThat(locacao.getValor(), is(2.1));
        errorCollector.checkThat(((isMesmaData(locacao.getDataLocacao(), new Date()))), is(true));
        errorCollector.checkThat(((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1)))), is(true));
    }

    @Test(expected = FilmeSemEstoqueException.class)
    public void testeLocacaoSemEstoqueElegante() throws Exception {

        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> listFilme = new ArrayList<Filme>();

        listFilme.add(new Filme("Filme 1", 0, 2.1));

        //Acao
        service.alugarFilme(usuario, listFilme);
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
    public void deveLocarcomPromocaoPara2Filmes() throws Exception {
        Assume.assumeFalse(verificarDiaSemana(new Date(), Calendar.SATURDAY));
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        assertEquals(valorLocacao, locacao.getValor(), 0.1);
        assertThat((isMesmaData(locacao.getDataLocacao(), new Date())), is(true));
        assertThat((isMesmaData(locacao.getDataRetorno(), obterDataComDiferencaDias(1))), is(true));
    }

    @Test
    public void deveLocarcomPromocaoPara3Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        assertEquals(valorLocacao, locacao.getValor(), 0.1);
    }

    @Test
    public void deveLocarcomPromocaoPara4Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        assertEquals(valorLocacao, locacao.getValor(), 0.1);
    }

    @Test
    public void deveLocarcomPromocaoPara5Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        assertEquals(valorLocacao, locacao.getValor(), 0.1);
    }

    @Test
    public void deveLocarcomPromocaoPara6Filmes() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificacao
        assertEquals(valorLocacao, locacao.getValor(), 0.1);
    }

    @Test
    public void deveDevolvoerNaSegundaAlugarnoSabado() throws Exception {
        Assume.assumeTrue(verificarDiaSemana(new Date(), Calendar.SUNDAY));

        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 1, 2.1));

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        //Verificaco
        boolean ehsegunda = verificarDiaSemana(locacao.getDataRetorno(), Calendar.MONDAY);
        assertTrue(ehsegunda);

       assertThat(locacao.getDataRetorno(), new DiasdaSemana(Calendar.MONDAY));
    }

    @Test
    public void naoDeveAlugarFilmeParaUsuariosNegativados() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();
        filmes.add(new Filme("Filme 1", 1, 2.1));

        when(spcServices.possuiNomeNegativo(usuario)).thenReturn(true);


        try{
            //Acao
            service.alugarFilme(usuario, filmes);
            //Verificacao
            fail();
        }catch (LocadoraException e){
            assertThat(e.getMessage(), is("User negativado"));
        }

        verify(spcServices).possuiNomeNegativo(usuario);
    }

    @Test
    public void deveAlugarFilmeParaUsuariosNaoNegativados() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();
        filmes.add(new Filme("Filme 1", 1, 2.1));

        when(spcServices.possuiNomeNegativo(usuario)).thenReturn(false);

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);

        verify(spcServices).possuiNomeNegativo(usuario);
    }

    @Test
    public void deveEnviarEmailParaLocacoesAtrasadas() throws Exception {
        //Cenario
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();
        filmes.add(new Filme("Filme 1", 1, 2.1));

        List<Locacao> locacoespendentes = Arrays.asList(new Locacao(usuario,filmes, obterDataComDiferencaDias(-3), obterDataComDiferencaDias(-1) ,2.1));
        when(locacaoDao.obterLocacoesPendentes()).thenReturn(locacoespendentes);

        //Acao
        service.notificarAtraso();

        verify(emailServices).notificarAtraso(usuario);

    }
}