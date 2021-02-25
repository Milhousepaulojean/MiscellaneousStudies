package Factories;

import Abstract.AbstractFactory;
import Interfaces.GeometricShape;
import Models.Circle;

public class OneDShapeFactory extends AbstractFactory {
    @Override
    public GeometricShape getShape() {
        return new Circle();
    }
}
