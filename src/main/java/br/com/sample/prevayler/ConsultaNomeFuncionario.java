package br.com.sample.prevayler;

import java.util.LinkedList;
import java.util.List;
import org.prevayler.Prevayler;

public class ConsultaNomeFuncionario {

    public static List<Funcionario> consultaNome(String nome) {
        List<Funcionario> list = new LinkedList<Funcionario>();
        Prevayler<Empresa> prevayler = PrevaylerContext.getInstance();
        for (Funcionario f : prevayler.prevalentSystem().getFuncionarios()) {
            if (f.getNome().contains(nome)) {
                list.add(f);
            }
        }
        return list;
    }
}
