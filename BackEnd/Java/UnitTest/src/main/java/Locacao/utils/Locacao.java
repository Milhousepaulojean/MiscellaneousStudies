package Locacao.utils;

import java.util.Date;
import java.util.List;

public class Locacao {

    public Locacao(){}
    public Locacao(Usuario usuario, List<Filme> filme, Date dataLocacao, Date dataRetorno, Double valor) {
        this.usuario = usuario;
        this.filme = filme;
        this.dataLocacao = dataLocacao;
        this.dataRetorno = dataRetorno;
        this.valor = valor;
    }

    private Usuario usuario;
    private List<Filme> filme;
    private Date dataLocacao;
    private Date dataRetorno;
    private Double valor;



    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public List<Filme> getFilme() {
        return filme;
    }

    public void setFilme(List<Filme> filme) {
        this.filme = filme;
    }

    public Date getDataLocacao() {
        return dataLocacao;
    }

    public void setDataLocacao(Date dataLocacao) {
        this.dataLocacao = dataLocacao;
    }

    public Date getDataRetorno() {
        return dataRetorno;
    }

    public void setDataRetorno(Date dataRetorno) {
        this.dataRetorno = dataRetorno;
    }

    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }

    @Override
    public String toString() {
        return "Locacao{" +
                "usuario=" + usuario +
                ", filme=" + filme +
                ", dataLocacao=" + dataLocacao +
                ", dataRetorno=" + dataRetorno +
                ", valor=" + valor +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Locacao)) return false;
        Locacao locacao = (Locacao) o;
        return usuario.equals(locacao.usuario) &&
                filme.equals(locacao.filme) &&
                dataLocacao.equals(locacao.dataLocacao) &&
                dataRetorno.equals(locacao.dataRetorno) &&
                valor.equals(locacao.valor);
    }
}