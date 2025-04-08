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
    
    image(contact, 20, 120 + 100, 800, 533.333333);
    //image(customer, 400, 120, 800, 533.333333);
    
    fill(0);
    textSize(50);
    text("How Can We Help?", 65, 150);
    
    
    textFont(mono2);
    textSize(30);
    text("Shoot us an e-mail", 65, 200);
    
    image(pc, width - 600, 230, 400, 300);

    drawHamburgerIcon();
    updateMenu();
    drawMenu();


  }
}
