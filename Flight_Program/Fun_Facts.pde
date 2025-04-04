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
    
    int textHeight = 150;
    
    for (int i = 0; i < facts.size(); i++) {
      textFont(mono);
      fill(0);
      
      text(facts.get(i), 30, textHeight, 1100, 1000);
      
      textHeight += 100;
    }

    drawHamburgerIcon();
    updateMenu();
    drawMenu();
  }
}
