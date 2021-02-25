package Factories;

import Abstract.AbstractFactory;
import Interfaces.GeometricShape;
import Models.Sphere;

public class ThreeDShapeFactory extends AbstractFactory {
    @Override
    public GeometricShape getShape() {
        return new Sphere();
    }
}
