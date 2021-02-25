package Abstract;

import Interfaces.GeometricShape;
import Enum.FactoriesEnum.*;

public abstract class AbstractFactory {
    public abstract GeometricShape getShape();
}
