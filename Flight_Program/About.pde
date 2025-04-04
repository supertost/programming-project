class About {
  void display() {

    if (bg2 != null) {
      image(bg3, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
      background(240);
    }

    fill(255);
    textFont(mono2);
    textSize(60);
    textAlign(LEFT, TOP);
    text("About", 40, 40);
    
    textFont(mono);
    textSize(25);
    fill(0);
    //text("ClousCruiser is a desktop app written in Java Processing, it aims to present flight data in the US between 1st of January 2022 to 31st of January 2022\n to the user in a user-friendly manner by using barcharts, line charts, world maps, and pie charts.\nThere are four different filtration system which are: Destination, Origin, Date, and Late toggle.", 20, 200);

    image(about, 10, 120, 960, 639.9999996);
    
    drawHamburgerIcon();
    updateMenu();
    drawMenu();
  }
}
