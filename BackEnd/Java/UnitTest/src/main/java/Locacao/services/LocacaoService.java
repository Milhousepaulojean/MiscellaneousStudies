package Locacao.services;
import Locacao.Dao.LocacaoDao;
import Locacao.entidades.*;
import Locacao.utils.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;


public class LocacaoService {

    private LocacaoDao locacaoDao;

    private SPCServices spcServices;

    private EmailServices emailServices;

    public Locacao alugarFilme(Usuario usuario, List<Filme> filmes) throws Exception {

        Locacao locacao = new Locacao();

        if (usuario == null) {
            throw new LocadoraException("Usuario sem nome");
        }

        if (filmes == null || filmes.isEmpty()) {
            throw new LocadoraException("Nome do filme nao informado.");
        }

        Double valorTotal = 0.0;

        for (int i = 0; i < filmes.size(); i++) {
            Filme filme = filmes.get(i);
            if (filme.getEstoque() == 0) {
                throw new FilmeSemEstoqueException();
            }

            switch (i) {
                case 2:
                    valorTotal += filme.getPrecoLocacao() * 0.75;
                    break;
                case 3:
                    valorTotal += filme.getPrecoLocacao() * 0.5;
                    break;
                case 4:
                    valorTotal += filme.getPrecoLocacao() * 0.2;
                    break;
                default:
                    valorTotal += filme.getPrecoLocacao();
                    break;
            }

        }

        if (spcServices.possuiNomeNegativo(usuario)){
            throw new LocadoraException("User negativado");
        }

        locacao.setFilme(filmes);
        locacao.setUsuario(usuario);
        locacao.setDataLocacao(new Date());

        Date dataEntrega = new Date();
        dataEntrega = DataUtils.adicionarDias(dataEntrega, 1);

        if (DataUtils.verificarDiaSemana(dataEntrega, Calendar.SUNDAY)){
            dataEntrega = DataUtils.adicionarDias(dataEntrega, 1);
        }

        locacao.setDataRetorno(dataEntrega);
        locacao.setValor(valorTotal);

        locacaoDao.salvar(locacao);

        return locacao;
    }

    public void setLocacaoDao(LocacaoDao locacaoDao) {
        this.locacaoDao = locacaoDao;
    }

    public void setSpcServices(SPCServices spcServices){
        this.spcServices = spcServices;
    }

    public void setSEmailServices(EmailServices emailServices){
        this.emailServices = emailServices;
    }

    public void main(String[] args) throws Exception {
        //Cenario
        LocacaoService service = new LocacaoService();
        Usuario usuario = new Usuario("Usuario 1");
        List<Filme> filmes = new ArrayList<Filme>();

        filmes.add(new Filme("Filme 1", 15, 2.1));

        //Acao
        Locacao locacao = service.alugarFilme(usuario, filmes);


        //Verificacao
        System.out.println(locacao.getValor() == 2.1);
        System.out.println(DataUtils.isMesmaData(locacao.getDataLocacao(), new Date()));
        System.out.println(DataUtils.isMesmaData(locacao.getDataRetorno(), DataUtils.obterDataComDiferencaDias(1)));
    }

    public void notificarAtraso(){
        List<Locacao> locacaos = locacaoDao.obterLocacoesPendentes();
        for (Locacao locacao: locacaos) {
            emailServices.notificarAtraso(locacao.getUsuario());
        }
    }
}