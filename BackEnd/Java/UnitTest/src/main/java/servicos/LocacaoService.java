package servicos;

import entidades.DataUtils;
import entidades.FilmeSemEstoqueException;
import entidades.LocadoraException;
import utils.Filme;
import utils.Locacao;
import utils.Usuario;
import static entidades.DataUtils.adicionarDias;

import java.util.Date;



public class LocacaoService {
	
	public Locacao alugarFilme(Usuario usuario, Filme filme) throws Exception {

		if (usuario == null){
			throw new LocadoraException("Usuario sem nome");
		}

		if (filme == null){
			throw new LocadoraException("Nome do filme nao informado.");
		}

		if (filme.getEstoque() == 0){
			throw new FilmeSemEstoqueException();
		}

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

	public void main(String[] args) throws Exception {
		//Cenario
		LocacaoService service = new LocacaoService();
		Usuario usuario = new Usuario("Usuario 1");
		Filme filme = new Filme("Filme 1",15 , 2.1);

		//Acao
		Locacao locacao  =  service.alugarFilme(usuario, filme);

		//Verificacao
		System.out.println(locacao.getValor() == 2.1);
		System.out.println(DataUtils.isMesmaData(locacao.getDataLocacao() , new Date()));
		System.out.println(DataUtils.isMesmaData(locacao.getDataRetorno() , DataUtils.obterDataComDiferencaDias(1)));
	}
}