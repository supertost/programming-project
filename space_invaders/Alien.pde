public class Alien {

    int posX = 0;
    int posY = 0;
    int baseY = 0;  // Maintain a base Y position

    // test to see if this works

    // Github'da gözükecek mi diye test

    // Git test, Yusuf'un bilgisayarı intihar etti

    float x = 0;

    int alienWidth = 80;
    int alienHeight = 80;

    boolean goDown = false;

    int counter = 0;
    int explosionCounter = 0;
    int tempY = 0;

    PImage alien = loadImage("alien.gif");
    PImage greenAlien = loadImage("greenAlien.gif");
    PImage explosion = loadImage("explosion.gif");

    boolean firstTime = true;
    boolean moveRight = true;
    boolean moveLeft = false;

    boolean exploded = false;
    boolean explosionAnim = false;

    boolean colRanFirstTime = true;
    boolean white = false;
    boolean green = false;

    float speed = 10;

    Alien(int positionX, int positionY) {

        posX = positionX;
        posY = positionY;
        baseY = positionY;
    }


    void sinMoveY() {

        posY = baseY + (int) (20 * sin(x));
        x += 0.2;
    }

    void move() {

        if (posX + alienWidth >= width) { //<>//

            goDown = true;
            moveRight = false;
            firstTime = false;
        }

        if (posX <= 0 && !firstTime) {

            goDown = true;
            moveLeft = false;
        }

        if (goDown) {

            baseY += 10;
            posY += 10;
            counter++;
            speed+=0.1;
        }

        if (counter >= 8) {

            goDown = false;

            if (posX + alienWidth >= width) {

                moveLeft = true;
            }

            if (posX <= 0) {

                moveRight = true;
            }

            counter = 0;
        }

        if (moveRight && !goDown && !moveLeft) {

            posX += speed;
        }

        if (!moveRight && moveLeft && !goDown) {

            posX -= speed;
        }
    }

    void draw() {

        Random colRand = new Random();
        double randNumbForCol = colRand.nextInt(0, 2);

        if (white || (randNumbForCol == 0 && colRanFirstTime)) {

            white = true;
            colRanFirstTime = false;
            alien.resize(alienWidth, alienHeight);
            image(alien, posX, posY);
        } 
        
        if (green || (randNumbForCol == 1 && colRanFirstTime)) {

            green = true;
            colRanFirstTime = false;
            greenAlien.resize(alienWidth, alienHeight);
            image(greenAlien, posX, posY);
            
            sinMoveY();
        }
    }

    void explode() {

        Random rand = new Random();
        double randomNumber = rand.nextInt(500);

        if ((int) randomNumber == 3) {

            exploded = true;
            explosionAnim = true;
        }
    }

    void explosionAni() {

        if (explosionCounter < 20) {
            
            explosionCounter++;
            
            explosion.resize(80, 80);
            image(explosion, posX, posY);
        }
    }
}
