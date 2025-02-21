import java.util.Random;

Alien theAlien;

void setup() {
    
    size(1200, 1000);

    theAlien = new Alien();
    
}

void draw() {

    background(0);

    
    if (theAlien.exploded == false) {

        theAlien.draw();
        theAlien.move();
        theAlien.explode();

    }
    


}
