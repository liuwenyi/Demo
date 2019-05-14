package br.com.sample.prevayler;
  
import org.junit.Assert;
import org.junit.Test;
import org.prevayler.Prevayler;

public class EmpresaFacadeTest {

    @Test
    public void testSomeMethod() {

        Prevayler<Empresa> prevayler = PrevaylerContext.getInstance();
        prevayler.execute(new CadastroFuncionario("José da Silva Jr"));
        prevayler.execute(new CadastroFuncionario("José"));
        prevayler.execute(new CadastroFuncionario("José Jr"));
        prevayler.execute(new CadastroFuncionario("Jr"));
        prevayler.execute(new CadastroLoja("Loja da maria"));

        Empresa empresa = prevayler.prevalentSystem();


        Assert.assertEquals(4, empresa.getFuncionarios().size());
        Assert.assertEquals(1, empresa.getLojas().size());

        Assert.assertEquals(3, ConsultaNomeFuncionario.consultaNome("José").size());
        Assert.assertEquals(1, ConsultaNomeFuncionario.consultaNome("Silva").size());
        Assert.assertEquals(3, ConsultaNomeFuncionario.consultaNome("Jr").size());
    }
}

