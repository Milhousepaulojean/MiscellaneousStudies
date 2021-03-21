package Models;

import java.util.Objects;

public class GamesClass {
    private String  nomeJogo;
    private String categoriaJogo;
    private Boolean isJogou;


    public void setNomeJogo(String nomeJogo) {
        this.nomeJogo = nomeJogo;
    }

    public void setCategoriaJogo(String categoriaJogo) {
        this.categoriaJogo = categoriaJogo;
    }

    public void setJogou(Boolean jogou) {
        isJogou = jogou;
    }

    public String getNomeJogo() {
        return nomeJogo;
    }

    public String getCategoriaJogo() {
        return categoriaJogo;
    }

    public Boolean isJogou() {
        return isJogou;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof GamesClass)) return false;
        GamesClass that = (GamesClass) o;
        return Objects.equals(nomeJogo, that.nomeJogo) &&
                Objects.equals(categoriaJogo, that.categoriaJogo) &&
                Objects.equals(isJogou, that.isJogou);
    }


    @Override
    public String toString() {
        return "GamesClass{" +
                "nomeJogo='" + nomeJogo + '\'' +
                ", categoriaJogo='" + categoriaJogo + '\'' +
                ", isJogou=" + isJogou +
                '}';
    }
}
