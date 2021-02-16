package Locacao.Matchers;
import org.hamcrest.Description;
import org.hamcrest.TypeSafeMatcher;


import java.util.Date;

import static Locacao.entidades.DataUtils.verificarDiaSemana;

public class DiasdaSemana extends TypeSafeMatcher<Date> {

    private Integer diaSemana;

    public DiasdaSemana(Integer diaSemana) {
        this.diaSemana = diaSemana;
    }

    @Override
    protected boolean matchesSafely(Date date) {
        return verificarDiaSemana(date, diaSemana);
    }

    @Override
    public void describeTo(Description description) {

    }
}
