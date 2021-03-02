package Models;

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



}
