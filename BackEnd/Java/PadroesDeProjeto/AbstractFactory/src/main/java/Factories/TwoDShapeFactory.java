package Factories;

import Abstract.AbstractFactory;
import Interfaces.GeometricShape;
import Models.Line;

public class TwoDShapeFactory extends AbstractFactory {

    @Override
    public GeometricShape getShape() {
        return new Line();
    }
}
