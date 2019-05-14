package br.com.sample.prevayler;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Empresa implements Serializable {

    private static final long serialVersionUID = 1L;

    List<Funcionario> funcionarios = new ArrayList<Funcionario>();

    List<Loja> lojas = new ArrayList<Loja>();

    protected Empresa() {
    }

    public static Empresa newInstance() {
        return new Empresa();
    }

    public List<Loja> getLojas() {
        return lojas;
    }

    public List<Funcionario> getFuncionarios() {
        return funcionarios;
    }

    public void cadastraFuncionario(String nome) {
        funcionarios.add(Funcionario.newInstance(nome));
    }

    public void cadastraLoja(String nome) {
        lojas.add(Loja.newInstance(nome));
    }
}
