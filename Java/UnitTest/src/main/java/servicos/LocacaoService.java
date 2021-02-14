package servicos;

import entidades.DataUtils;

import org.junit.Assert;
import org.junit.Test;
import utils.Filme;
import utils.Locacao;
import utils.Usuario;
import static entidades.DataUtils.adicionarDias;

import java.util.Date;



public class LocacaoService {
	
	public Locacao alugarFilme(Usuario usuario, Filme filme) {
		Locacao locacao = new Locacao();
		locacao.setFilme(filme);
		locacao.setUsuario(usuario);
		locacao.setDataLocacao(new Date());
		locacao.setValor(filme.getPrecoLocacao());

		//Entrega no dia seguinte
		Date dataEntrega = new Date();
		dataEntrega = adicionarDias(dataEntrega, 1);
		locacao.setDataRetorno(dataEntrega);
		
		//Salvando a locacao...	
		//TODO adicionar método para salvar
		
		return locacao;
	}

	@Test
	public void teste() {
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