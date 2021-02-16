package Locacao.Dao;

import Locacao.utils.Locacao;

import java.util.List;

public interface LocacaoDao {

    public void salvar(Locacao locacao);

    List<Locacao> obterLocacoesPendentes();
}
