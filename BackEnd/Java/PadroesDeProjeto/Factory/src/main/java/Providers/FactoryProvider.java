package Providers;

import Abstract.AbstractFactory;
import Factories.OneDShapeFactory;
import Factories.ThreeDShapeFactory;
import Factories.TwoDShapeFactory;
import Enum.FactoriesEnum.*;

import javax.print.DocFlavor;

public class FactoryProvider {

    public static AbstractFactory getFactory(FactoryType factoryType){
        switch (factoryType) {
            case ONE_D_SHAPE_FACTORY:
                return  new OneDShapeFactory();
            case TWO_D_SHAPE_FACTORY:
                return new TwoDShapeFactory();
            case THREE_D_SHAPE_FACTORY:
                return new ThreeDShapeFactory();
            default:
                return null;
        }
    }
}
