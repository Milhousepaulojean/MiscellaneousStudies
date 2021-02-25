import Abstract.AbstractFactory;
import Interfaces.GeometricShape;
import Providers.FactoryProvider;
import Enum.FactoriesEnum.*;

import static Enum.FactoriesEnum.FactoryType.*;

public class Application {
    public static void main(String[] args) {
        AbstractFactory factory;
        GeometricShape shape;
        //drawing 2D shape
        factory = FactoryProvider.getFactory(ONE_D_SHAPE_FACTORY);
        if (factory == null) {
            System.out.println("Factory for given name doesn't exist.");
            System.exit(1);
        }
        //getting shape using factory obtained
        shape = factory.getShape();
        if (shape != null) {
            shape.draw();
        } else {
            System.out.println("Shape with given name doesn't exist.");
        }

        //drawing 2D shape
        factory = FactoryProvider.getFactory(TWO_D_SHAPE_FACTORY);
        if (factory == null) {
            System.out.println("Factory for given name doesn't exist.");
            System.exit(1);
        }
        //getting shape using factory obtained
        shape = factory.getShape();
        if (shape != null) {
            shape.draw();
        } else {
            System.out.println("Shape with given name doesn't exist.");
        }

        //drawing 3D shape
        factory = FactoryProvider.getFactory(THREE_D_SHAPE_FACTORY);
        if (factory == null) {
            System.out.println("Factory for given name doesn't exist.");
            System.exit(1);
        }
        //getting shape using factory obtained
        shape = factory.getShape();
        if (shape != null) {
            shape.draw();
        } else {
            System.out.println("Factory for given name doesn't exist.");
            System.exit(1);
        }
    }
}
