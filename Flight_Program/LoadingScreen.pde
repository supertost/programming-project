//PImage img;
Gif myAnimation;
public class LoadingScreen {
  
  public boolean screenKey;

 
  public LoadingScreen(boolean screenKey) {
    this.screenKey = screenKey;
  }


  public void draw() {
    if (screenKey) {
      //image(img, 0, 0);
      image(myAnimation, 10, 10, 1200, 800);
    }  
  }
}
