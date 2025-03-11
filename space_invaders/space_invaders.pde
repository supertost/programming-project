import java.util.Random;

Alien[] theAlien;

// comment


    // Test to see if this text will show up in the github repository
    // test to see if i like it
void setup() {
    
    size(1200, 1000);

    theAlien = new Alien[10];  
    
    for (int i = 0; i < theAlien.length; i++) {
      
        int xPosition = i * 100;
        int yPosition = 50;
        
        theAlien[i] = new Alien(xPosition, yPosition);
    }
    
}

void draw() {

    background(0);

    
    for (int i = 0; i < theAlien.length; i++) {
      
        Alien currentAlien = theAlien[i];
        
        if (!currentAlien.exploded) {
          
            currentAlien.draw();
            currentAlien.move();
            currentAlien.explode();
            //currentAlien.sinMoveY();
        }
        
        if (currentAlien.exploded) {

            currentAlien.explosionAni();    
        }
    }
    


}
