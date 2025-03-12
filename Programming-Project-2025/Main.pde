PFont defaultFont, boldFont;

ArrayList<FullFlight> fullFlights;
BarChart barChart;
PieChart pieChart;

// Toggle between bar chart and pie chart -- This part can be removed as a main menu is added
boolean showBarChart = true; 
boolean[] selectedStates; 
String[] stateNames; 

// Main Menu Variables
boolean showMenu = true;             // true = display main menu, false = display charts
PImage bg;                           // background image for the menu
String[] menuItems = {"Pie Chart", "Bar Chart", "Heat Map", "Histogram"};
float menuX, menuY;                  // top-left corner of menu items
float menuItemSpacing = 60;          // vertical spacing between items
float menuItemWidth = 200;           // approximate clickable width
float menuItemHeight = 40; 

void setup() {
  size(1000, 935);
  
  // Loads the background image from the folder
  bg = loadImage("background.png"); 
  
  // Positions the menu on the right side
  menuX = width - 300;  
  menuY = 200; 

  textAlign(LEFT, TOP);
  noStroke();
  
  defaultFont = createFont("SansSerif", 24, true);
  boldFont = createFont("SansSerif.bold", 48, true);
  
  
  
  fullFlights = new ArrayList<FullFlight>();

  // Load data from CSV
  Table table = loadTable("flights2k.csv", "header");
  
  for (TableRow row : table.rows()) {
    
    FullFlight flight = new FullFlight(
      row.getString("FL_DATE"), row.getString("MKT_CARRIER"), row.getInt("MKT_CARRIER_FL_NUM"),
      row.getString("ORIGIN"), row.getString("ORIGIN_CITY_NAME"), row.getString("ORIGIN_STATE_ABR"),
      row.getString("ORIGIN_WAC"), row.getString("DEST"), row.getString("DEST_CITY_NAME"),
      row.getString("DEST_STATE_ABR"), row.getInt("DEST_WAC"), row.getInt("CRS_DEP_TIME"),
      row.getInt("DEP_TIME"), row.getInt("CRS_ARR_TIME"), row.getInt("ARR_TIME"),
      row.getInt("CANCELLED") == 1, row.getInt("DIVERTED") == 1, row.getInt("DISTANCE")
    );
    
    fullFlights.add(flight);
  }


// showing that we are reading data
  for(int i = 0; i < fullFlights.size(); i++) {
    
    FullFlight flight = fullFlights.get(i);
    
    println(flight.date);
    println(i);
  }
  
  // Initialize charts
  barChart = new BarChart(fullFlights);
  pieChart = new PieChart(fullFlights);

  // Get list of all states
  stateNames = barChart.getStateNames();
  selectedStates = new boolean[stateNames.length]; // Initialize selection array


  // example interaction for searching for specific flight.
  println(getFlight(1, "New York, NY", false, 2475).date);

}

void draw() {
  
  if (showMenu) {
    
    background(0);
    
    // Draw the background image to fill the window
    image(bg, 0, 0, width, height);

    // Big title Text
    fill(255);
    textSize(48);
    textFont(boldFont);
    text("What do you want\nto do today?", 50, height/2 - 90);

    // Subtitle Text
    textSize(24);
    textFont(defaultFont);
    text("Please select your desired action\nfrom the menu on the right", 50, height/2 + 40);

    // Draw the menu items on the righthand side
    textSize(32);
    
    for (int i = 0; i < menuItems.length; i++) {
      
      float itemY = menuY + i * menuItemSpacing;
      
      // Highlighting if mouse is over this item
      if (isMouseOverItem(i)) {
        
        fill(255, 200);
        rect(menuX - 20, itemY - 10, menuItemWidth, menuItemHeight+5, 10);
        fill(0);
      } 
      
      else {
        
        fill(255);
      }
      
      text(menuItems[i], menuX, itemY);
    }

  } 
  
  else {
    
  // THIS PART IS FROM THE PREVIOUS BAR CHART PIE CHART SELECTION MENU - THIS PART CAN BE REMOVED LATER (Emir D.)
    
    background(240);

    // Draw the chart toggle buttons (Bar / Pie)
    drawButtons();

    // Display whichever chart is selected
    if (showBarChart) {
      barChart.display();
    } else {
      pieChart.display(selectedStates);
    }
  }
}


void mousePressed() {
  
  if (showMenu) {
    
    // Check if a menu item is clicked
    for (int i = 0; i < menuItems.length; i++) {
      
      if (isMouseOverItem(i)) {
        
        String choice = menuItems[i];
        println(choice + " clicked!");

        // Depending on the choice, sets up the screen
        if (choice.equals("Bar Chart")) {
          
          showBarChart = true;
          showMenu = false; 
        } 
        
        else if (choice.equals("Pie Chart")) {
          
          showBarChart = false;
          showMenu = false;
        } 
        
        else if (choice.equals("Heat Map")) {

          // This part is empty for now as we don't have a heatmap
          
          showMenu = false; 
          println("Heat Map not yet implemented");
        } 
        
        else if (choice.equals("Histogram")) {
          
          
          // This part is also empty for now as we don't have an histogram either
          
          showMenu = false; 
          println("Histogram not yet implemented");
        }
      }
    }
  } 
  
  else {
    
// THIS PART IS FROM THE OLD UNREMOVED MENU -- CAN BE REMOVED LATER ON

    if (mouseX > 600 && mouseX < 750 && mouseY > 20 && mouseY < 60) {
      
      showBarChart = true;
    }

    // Check if pie chart button is clicked
    if (mouseX > 800 && mouseX < 950 && mouseY > 20 && mouseY < 60) {
      
      showBarChart = false;
    }

    // Allow state selection for pie chart
    if (!showBarChart) {
      
      for (int i = 0; i < stateNames.length; i++) {
        
        float y = 100 + i * 20;
        
        if (mouseX > 20 && mouseX < 40 && mouseY > y && mouseY < y + 20) {
          
          selectedStates[i] = !selectedStates[i]; // Toggle selection
        }
      }
    }
  }
}


boolean isMouseOverItem(int index) {
  
  float itemY = menuY + index * menuItemSpacing;
  
  return (mouseX >= menuX - 10 && mouseX <= menuX - 10 + menuItemWidth && mouseY >= itemY - 5 && mouseY <= itemY - 5 + menuItemHeight);
}



// THIS PART IS ALSO FOR THE OLD MENU THAT HAS NOT BEEN REMOVED YET

void drawButtons() {
  // Button for bar chart
  fill(showBarChart ? color(0, 150, 200) : color(200));
  rect(600, 20, 150, 40, 5);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Bar Chart", 675, 40);

  // Button for pie chart
  fill(!showBarChart ? color(0, 150, 200) : color(200));
  rect(800, 20, 150, 40, 5);
  fill(0);
  text("Pie Chart", 875, 40);
}

// Search for a flight by flight number, origin city, cancellation status, and distance
FullFlight getFlight(int flightNumber, String originCity, boolean cancelled, int distance) {
  
  for (FullFlight flight : fullFlights) {
    
    if (flight.flightNumber == flightNumber 
        && flight.originCity.equals(originCity) 
        && flight.cancelled == cancelled
        && flight.distance == distance) {
          
      return flight;
    }
  }
  return null; // Return null if no flight is found
}
