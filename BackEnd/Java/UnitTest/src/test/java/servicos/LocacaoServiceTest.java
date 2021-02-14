package servicos;

import entidades.DataUtils;
import org.junit.Assert;
import org.junit.jupiter.api.Test;
import utils.Filme;
import utils.Locacao;
import utils.Usuario;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

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
        Assert.assertTrue(locacao.getValor() == 2.1);
        Assert.assertTrue(DataUtils.isMesmaData(locacao.getDataLocacao() , new Date()));
        Assert.assertTrue(DataUtils.isMesmaData(locacao.getDataRetorno() , DataUtils.obterDataComDiferencaDias(1)));
    }
}




