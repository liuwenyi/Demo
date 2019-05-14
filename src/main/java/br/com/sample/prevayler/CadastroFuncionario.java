package br.com.sample.prevayler;

import java.util.Date;
import org.prevayler.Transaction;

public class CadastroFuncionario implements Transaction<Empresa> {

    private static final long serialVersionUID = 1L;

    String nome;

    public CadastroFuncionario(String nome) {
        this.nome = nome;
    }

    @Override
    public void executeOn(Empresa prevalentSystem, Date date) {
        Empresa empresa = prevalentSystem;
        empresa.cadastraFuncionario(nome);
    }
}
