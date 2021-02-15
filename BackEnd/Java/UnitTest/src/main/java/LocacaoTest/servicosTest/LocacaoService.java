package LocacaoTest.servicosTest;

import Locacao.entidades.DataUtils;
import Locacao.entidades.LocadoraException;
import Locacao.entidades.FilmeSemEstoqueException;
import Locacao.utils.Filme;
import Locacao.utils.Locacao;
import Locacao.utils.Usuario;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class LocacaoService {
	
	public Locacao alugarFilme(Usuario usuario, List<Filme> filmes) throws Exception {

		Locacao locacao = new Locacao();

		if (usuario == null){
			throw new LocadoraException("Usuario sem nome");
		}

		if (filmes == null || filmes.isEmpty()) {
			throw new LocadoraException("Nome do filme nao informado.");
		}

		for(Filme filme : filmes){
			if (filme.getEstoque() == 0){
				throw new FilmeSemEstoqueException();
			}
			locacao.setValor(filme.getPrecoLocacao());
		}

		locacao.setFilme(filmes);
		locacao.setUsuario(usuario);
		locacao.setDataLocacao(new Date());


		//Entrega no dia seguinte
		Date dataEntrega = new Date();
		dataEntrega = DataUtils.adicionarDias(dataEntrega, 1);
		locacao.setDataRetorno(dataEntrega);
		
		//Salvando a locacao...	
		//TODO adicionar método para salvar
		
		return locacao;
	}

	public void main(String[] args) throws Exception {
		//Cenario
		LocacaoService service = new LocacaoService();
		Usuario usuario = new Usuario("Usuario 1");
		List<Filme> filmes = new ArrayList<Filme>();

		filmes.add(new Filme("Filme 1",15 , 2.1));

		//Acao
		Locacao locacao  =  service.alugarFilme(usuario, filmes);

		//Verificacao
		System.out.println(locacao.getValor() == 2.1);
		System.out.println(DataUtils.isMesmaData(locacao.getDataLocacao() , new Date()));
		System.out.println(DataUtils.isMesmaData(locacao.getDataRetorno() , DataUtils.obterDataComDiferencaDias(1)));
	}
}