class FunFacts {
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
    text("Fun Facts", 40, 40);
    
    //ArrayList<String> facts = new ArrayList<>(getRandomFunFacts(funFacts));
    
    int textHeight = 175;
    
    for (int i = 0; i < facts.size(); i++) {
      textFont(mono);
      fill(0);
      
      text(facts.get(i), 65, textHeight, 600, 1000);
      
      image(airport1, width - 400, 170, 300, 200);
      
      image(airport2, width - 400, 440, 300, 200);
      
      
      textHeight += 150;
    }

    drawHamburgerIcon();
    updateMenu();
    drawMenu();
  }
}
