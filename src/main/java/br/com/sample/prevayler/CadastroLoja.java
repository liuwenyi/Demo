package br.com.sample.prevayler;

import java.util.Date;
import org.prevayler.Transaction;

public class CadastroLoja implements Transaction {

    private static final long serialVersionUID = 1L;

    String nome;

    protected CadastroLoja() {
    }

    public CadastroLoja(String nome) {
        this.nome = nome;
    }

    @Override
    public void executeOn(Object prevalentSystem, Date date) {
        Empresa empresa = (Empresa) prevalentSystem;
        empresa.cadastraLoja(nome);
    }
}
