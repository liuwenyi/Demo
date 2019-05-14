package br.com.sample.prevayler;

import org.prevayler.Prevayler;
import org.prevayler.PrevaylerFactory;

public class PrevaylerContext {

    private static Prevayler prevayler;

    private PrevaylerContext() {
        super();
    }

    public static Prevayler getInstance() {
        if (prevayler == null) {

            PrevaylerFactory factory = new PrevaylerFactory();
            factory.configurePrevalentSystem(Empresa.newInstance());
            factory.configurePrevalenceDirectory("data");

            try {
                prevayler = factory.create();
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException("Não foi possível criar o ambiente prevalente.", e);
            }
        }

        return prevayler;
    }
}
