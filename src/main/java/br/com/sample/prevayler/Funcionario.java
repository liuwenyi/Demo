package br.com.sample.prevayler;

import com.google.common.base.Objects;
import java.io.Serializable;

public class Funcionario implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;

    protected Funcionario() {
    }

    protected Funcionario(String nome) {
        this.nome = nome;
    }

    public static Funcionario newInstance(String nome) {
        return new Funcionario(nome);
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
