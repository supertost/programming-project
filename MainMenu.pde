PImage bg;
String[] menuItems = {"Pie Chart", "Bar Chart", "Heat Map", "Histogram"};

// For basic menu hit detection:
float menuX, menuY;
float menuItemSpacing = 60;
float menuItemWidth = 200;   // approximate clickable width
float menuItemHeight = 40;   // approximate clickable height

void setup() {
  size(1280, 720);
  // Load your background image from the data folder
  bg = loadImage("background.png"); 
  
  // Position the menu on the right
  menuX = width - 300;  
  // Where the first menu item should be placed vertically
  menuY = 200;
  
  textAlign(LEFT, TOP);
  noStroke();
}

void draw() {
  background(0);
  
  // Draw background image, resized to fill window
  image(bg, 0, 0, width, height);
  
  // Draw title text
  fill(255);
  textSize(48);
  text("What do you want to do today?", 50, 50);
  
  // Draw subtitle text
  textSize(24);
  text("Please select your desired action\nfrom the menu on the right", 50, 120);
  
  // Draw the menu items on the right
  textSize(32);
  for (int i = 0; i < menuItems.length; i++) {
    float itemY = menuY + i * menuItemSpacing;
    // Optionally, highlight if mouse is over this item
    if (isMouseOverItem(i)) {
      fill(255, 200); // Slightly transparent highlight
      rect(menuX - 10, itemY - 5, menuItemWidth, menuItemHeight);
      fill(0);
    } else {
      fill(255);
    }
    text(menuItems[i], menuX, itemY);
  }
}

// Detect mouse clicks on a menu item
void mousePressed() {
  for (int i = 0; i < menuItems.length; i++) {
    if (isMouseOverItem(i)) {
      // For demo, print which item was clicked
      println(menuItems[i] + " clicked!");
      
      // You could call another function, switch state, load new UI, etc.
      // e.g., if (menuItems[i].equals("Pie Chart")) { ... }
    }
  }
}

// Helper function to check if the mouse is over a specific menu item
boolean isMouseOverItem(int index) {
  float itemY = menuY + index * menuItemSpacing;
  return (mouseX >= menuX - 10 && mouseX <= menuX - 10 + menuItemWidth &&
          mouseY >= itemY - 5 && mouseY <= itemY - 5 + menuItemHeight);
}
