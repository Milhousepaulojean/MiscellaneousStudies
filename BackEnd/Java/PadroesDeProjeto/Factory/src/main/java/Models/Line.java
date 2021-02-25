package Models;

import Interfaces.GeometricShape;

public class Line implements GeometricShape {
    @Override
    public void draw() {
        System.out.println("Line Drawn.");
    }
}
