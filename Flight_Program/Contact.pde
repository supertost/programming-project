class Contact {
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
    text("Contact", 40, 40);
    
    image(contact, 10, 120, 800, 533.333333);
    //image(customer, 400, 120, 800, 533.333333);

    drawHamburgerIcon();
    updateMenu();
    drawMenu();


  }
}
