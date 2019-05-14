package br.com.sample.prevayler;

import com.google.common.base.Objects;
import java.io.Serializable;

public class Loja implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;

    protected Loja() {
    }

    protected Loja(String nome) {
        this.nome = nome;
    }

    public static Loja newInstance(String nome) {
        return new Loja(nome);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this).add("nome", nome).toString();
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
}
