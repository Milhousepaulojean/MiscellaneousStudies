package Models;

import org.junit.Test;
import java.lang.reflect.Field;
import java.util.Objects;

import static org.junit.jupiter.api.Assertions.*;

public class GamesClassTest {

    @Test
    public void TestGamesClassExist() {
        GamesClass gamesClass = new GamesClass();
        assertNotNull(gamesClass);
    }

    @Test
    public void TestGamesClassQuantitiesAttributesExists() throws NoSuchFieldException {
        GamesClass gamesClass = new GamesClass();
        Field nomeJogoAtributo = gamesClass.getClass().getDeclaredField("nomeJogo");
        Field categoriaJogoAtributo = gamesClass.getClass().getDeclaredField("categoriaJogo");
        Field isJogouAtributo = gamesClass.getClass().getDeclaredField("isJogou");
        assertEquals("nomeJogo", nomeJogoAtributo.getName());
        assertEquals("categoriaJogo", categoriaJogoAtributo.getName());
        assertEquals("isJogou", isJogouAtributo.getName());
    }

    @Test
    public void TestGamesClassGettersAttributesExists() throws NoSuchFieldException {
        GamesClass gamesClass = new GamesClass();
        assertEquals(3 ,gamesClass.getClass().getDeclaredFields().length);
    }

    @Test
    public void TestGamesClassGettersAttributesTypes() throws NoSuchFieldException {
        GamesClass gamesClass = new GamesClass();
        Field nomeJogoAtributo = gamesClass.getClass().getDeclaredField("nomeJogo");
        Field categoriaJogoAtributo = gamesClass.getClass().getDeclaredField("categoriaJogo");
        Field isJogouAtributo = gamesClass.getClass().getDeclaredField("isJogou");
        assertEquals(String.class, nomeJogoAtributo.getType());
        assertEquals(String.class, categoriaJogoAtributo.getType());
        assertEquals(Boolean.class, isJogouAtributo.getType());
    }

    @Test
    public void TestGamesClassSettersAttributesExists()  {
        GamesClass gamesClass = new GamesClass();
        gamesClass.setNomeJogo("TesteGame1");
        gamesClass.setCategoriaJogo("CategoriaJogo1");
        gamesClass.setJogou(false);

        assertEquals("TesteGame1",gamesClass.getNomeJogo());
        assertEquals("CategoriaJogo1", gamesClass.getCategoriaJogo());
        assertEquals(false, gamesClass.isJogou());
    }

    @Test
    public void TestGamesClassToStringAttributesExists()  {
        GamesClass gamesClass = new GamesClass();
        gamesClass.setNomeJogo("TesteGame1");
        gamesClass.setCategoriaJogo("CategoriaJogo1");
        gamesClass.setJogou(false);

        assertEquals("GamesClass{nomeJogo='TesteGame1', categoriaJogo='CategoriaJogo1', isJogou=false}",gamesClass.toString());
    }

    @Test
    public void TestGamesClassToEqualsWithInstancesEquals()  {
        GamesClass gamesClass = new GamesClass();
        gamesClass.setNomeJogo("TesteGame1");
        gamesClass.setCategoriaJogo("CategoriaJogo1");
        gamesClass.setJogou(false);

        GamesClass gamesClass2 = new GamesClass();
        gamesClass2.setNomeJogo("TesteGame1");
        gamesClass2.setCategoriaJogo("CategoriaJogo1");
        gamesClass2.setJogou(false);

        assertEquals(true , Objects.equals(gamesClass, gamesClass2));
    }

    @Test
    public void TestGamesClassToEqualsWithInstancesDiferents()  {
        GamesClass gamesClass = new GamesClass();
        gamesClass.setNomeJogo("TesteGame1");
        gamesClass.setCategoriaJogo("CategoriaJogo1");
        gamesClass.setJogou(false);

        GamesClass gamesClass2 = new GamesClass();
        gamesClass2.setNomeJogo("TesteGame2");
        gamesClass2.setCategoriaJogo("CategoriaJogo2");
        gamesClass2.setJogou(true);

        assertEquals(false , Objects.equals(gamesClass, gamesClass2));
    }

}