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
    text("What is CloudCruiser?", 40, 40);
    
    textFont(mono);
    textSize(30);
    fill(0);
    text("CloudCruiser is an interactive desktop application developed in Java Processing by a talented team of six based in Dublin. It aims to present flight data in the US from January 1st, 2022, to January 31st, 2022, in a user-friendly manner using bar charts, line charts, world maps, and pie charts.\n\nCloudCruiser offers four powerful filtering systems: Destination, Origin, Date, and a Late toggle, which allows users to highlight delayed flights. These filters can be combined to gain deeper insights into specific travel trends, patterns of delay, and airport activity during the selected time frame.", 65, 170, 600, 1000);

    image(about, width - 400, 170, 200, 200);
    image(screenshots, width - 450, 400, 350, 350);
    
    drawHamburgerIcon();
    updateMenu();
    drawMenu();
  }
}
