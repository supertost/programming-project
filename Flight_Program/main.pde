/****************************************************************/
/******COMMENT FOR THE BACKEND TEAM FROM THE FRONTEND TEAM*******/
/*

       For the destination and origin button, the variable for that is called "selectionDorO" -- Contents of this can either be "Destination" or "Origin" as written here
       
       For the calendar, there are the "startDate" and the "endDate" variables -- These variables hold an integer value from 1 to 31. For example if the "startDate" is 4 than the selected date is 4th of January 2022.
       As the date range is only between January 2022, we do not need any variables for the month or the year.
       
       For the late button, there is a boolean variable called "isLate" this variable is false by default, when switched on it turns into true.
       
       Lastly for the Search Bar, there is the "searchText" variable, when a state is selected this variable will contain the name of that state.
       
       There are a few print statements in comments in the first part of the "draw" method, by uncommenting them you can test their function and see the output in the console below
       
       Sincerely
       - Emir Dilekci

*/


// window dimensions
PImage bg;
int screenW = 1200;
int screenH = 800;
int headerHeight = 150;


// RGB Colour Variable For The ORIGIN button
int colourValueButtonOriginR = 255;
int colourValueButtonOriginG = 255;
int colourValueButtonOriginB = 255;

// Varible that holds which button is pressed between the destination or the origin
String selectionDorO = null;

// RGB colour variables for the destiantion button
int colourValueButtonDestR = 255;
int colourValueButtonDestG = 255;
int colourValueButtonDestB = 255;

int opacityValueButtonOrigin = 220;

// UI positions in header
int destX = 20, destY = 100, buttonW = 150, buttonH = 40;
int originX = destX + buttonW + 20, originY = destY;
int dateButtonX = originX + buttonW + 20, dateButtonY = destY, dateButtonW = 250, dateButtonH = 40;
int toggleX = dateButtonX + dateButtonW + 20, toggleY = destY+9;
int searchX = toggleX + 150, searchY = destY, searchW = 200, searchH = 40;

boolean isLate = false;

// Date range variables
int startDate = -1, endDate = -1;
boolean dateRangeActive = false;  // calendar open?
boolean selectingStart = true;    // if true, next date sets start; else sets end

// Search bar variables
boolean searchActive = false;
String searchText = "Search US State";
String[] usStates = {"Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia"};
int searchDropdownItemHeight = 25; // height for each dropdown item

// settings() to set the size of the window.


// Creating the custom font, one for normal font the other is bold font
PFont mono;
PFont mono2;

// All flight objects stored here.
ArrayList<Flight> flights;

void setup() {
  
  size(1200, 800);
  pixelDensity(1);
  
  textSize(16);
  smooth();
  
  // Loads the background image
  bg = loadImage("background.png");
  
  
  // First font that's for normal usage
  mono = createFont("Fonts/Helvetica.ttf", 30);
  textFont(mono);
  
  //Second Font that's for the title
  mono2 = createFont("Fonts/Helvetica-Bold.ttf", 30);
  //textFont(mono2);
  
  
  flights = new ArrayList<Flight>();

  // Load data from CSV
  Table table = loadTable("flights2k.csv", "header");
  
  // reading flights to add into flights ArrayList.
  for (TableRow row : table.rows()) {
    
    Flight flight = new Flight(
      row.getString("FL_DATE"), row.getString("MKT_CARRIER"), row.getInt("MKT_CARRIER_FL_NUM"),
      row.getString("ORIGIN"), row.getString("ORIGIN_CITY_NAME"), row.getString("ORIGIN_STATE_ABR"),
      row.getString("ORIGIN_WAC"), row.getString("DEST"), row.getString("DEST_CITY_NAME"),
      row.getString("DEST_STATE_ABR"), row.getInt("DEST_WAC"), row.getInt("CRS_DEP_TIME"),
      row.getInt("DEP_TIME"), row.getInt("CRS_ARR_TIME"), row.getInt("ARR_TIME"),
      row.getInt("CANCELLED") == 1, row.getInt("DIVERTED") == 1, row.getInt("DISTANCE")
    );
    
    flights.add(flight);
  }
  
  
  
}




void draw() {
  
  //println(startDate);
  //println(endDate);
  
  //println(isLate);
  
  //println(selectionDorO);
  
  //println(searchText);
  
  
  // Draw background image or fallback color
  if (bg != null) {
    
    image(bg, 0, 0, screenW, screenH);
  } 
  else {
    
    background(100);
  }
  
  // Draw header with semi-transparent background
  drawHeader();
  
  // Draw calendar if active
  if (dateRangeActive) {
    
    drawCalendar(screenW/2 - 110, screenH/2 - 120);
  }
  
  // Draw search dropdown if active
  if (searchActive) {
    
    drawSearchDropdown();
  }
}





// Although there is still a header, its visibility is turned all the way down
// Currently the only use for the header is for the UI 
void drawHeader() {
  
  noStroke();
  fill(100, 100, 100, 0); // Semi-transparent header
  rect(0, 0, screenW, headerHeight);
  
  // Header title
  fill(255);
  textAlign(LEFT, CENTER);
  textFont(mono2);
  textSize(45);
  text("Group 5", 20, headerHeight/2-20);
  textFont(mono);
  textSize(16);
  
  // Draw header UI elements
  drawButtonD(destX, destY, buttonW, buttonH, "Destination");
  
  drawButtonO(originX, originY, buttonW, buttonH, "Origin");
  
  drawDateButton(dateButtonX, dateButtonY, dateButtonW, dateButtonH);
  
  drawToggle(toggleX, toggleY, "Late", isLate);
  
  drawSearchBar(searchX, searchY, searchW, searchH, searchText);
}

// Helper: check if mouse is over a rectangle
boolean isMouseOver(int x, int y, int w, int h) {
  
  return (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
}






void drawButtonD(int x, int y, int w, int h, String label) {
  
  noStroke();
  
  if (isMouseOver(x, y, w, h) && selectionDorO != "Destination") {
    
    fill(255, 255, 255, 255);
  }
  
  else {
   
    fill(colourValueButtonDestR, colourValueButtonDestG, colourValueButtonDestB, 220);
  }
  
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}


void drawButtonO(int x, int y, int w, int h, String label) {
  
  noStroke();
  
  if (isMouseOver(x, y, w, h) && selectionDorO != "Origin") {
    
    fill(255, 255, 255, 255);
  }
  
  else {
    
    fill(colourValueButtonOriginR, colourValueButtonOriginG, colourValueButtonOriginB, 220);
  }
  
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}






void drawDateButton(int x, int y, int w, int h) {
  
  noStroke();
  if (isMouseOver(x, y, w, h)) fill(255, 255, 255, 255);
  else fill(255, 255, 255, 220);
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  
  if (startDate == -1) {
    
    text("Pick Date Range", x + w/2, y + h/2);
  }
  else if (startDate != -1 && endDate == -1) {
    
    text("Start: " + startDate + " (select End Date)", x + w/2, y + h/2);
  } 
  else {
    
    text("Start: " + startDate + "   End: " + endDate, x + w/2, y + h/2);
  }
}






void drawToggle(int x, int y, String label, boolean active) {
  
  fill(255);
  textAlign(LEFT, CENTER);
  text(label, x + 15, y + 11);
  
  noStroke();
  
  if (isMouseOver(x+60, y, 40, 25)) fill(active ? color(0, 220, 0) : color(220));
  
  else fill(active ? color(0, 200, 0) : color(200));
  
  rect(x + 60, y, 40, 25, 12);
  
  fill(255);
  float knobX = active ? x + 60 + 20 : x + 60;
  rect(knobX, y, 20, 25, 12);
}





void drawSearchBar(int x, int y, int w, int h, String textContent) {
  
  noStroke();
  
  if (isMouseOver(x, y, w, h)) fill(255, 255, 255, 255);
  
  else fill(255, 255, 255, 220);
  
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(LEFT, CENTER);
  text(" " + textContent, x + 5, y + h/2);
}





void drawSearchDropdown() {
  
  int dropdownX = searchX;
  int dropdownY = searchY + searchH + 10;
  int dropdownW = searchW;
  int dropdownH = usStates.length * searchDropdownItemHeight;
  
  noStroke();
  fill(255, 255, 255, 230);
  rect(dropdownX, dropdownY, dropdownW, dropdownH, 10);
  
  for (int i = 0; i < usStates.length; i++) {
    
    int itemY = dropdownY + i * searchDropdownItemHeight;
    
    if (isMouseOver(dropdownX, itemY+10, dropdownW, searchDropdownItemHeight)) {
      
      fill(200, 200, 255);
    } 
    else {
      
      fill(255);
    }
    
    rect(dropdownX, itemY, dropdownW, searchDropdownItemHeight, 10);
    fill(0);
    textAlign(LEFT, CENTER);
    text(" " + usStates[i], dropdownX + 5, itemY + searchDropdownItemHeight/2);
  }
}





void drawCalendar(int x, int y) {
  
  // Calendar container
  noStroke();
  fill(240, 170);
  rect(x-115, y-120, 220, 240, 10);
  
  // Calendar header: month and year
  fill(0);
  textAlign(CENTER, CENTER);
  text("January 2022", x + 110 - 115, y + 25 - 120);
  
  // Draw day grid (1 to 31)
  int gridStartX = x + 20 - 115;
  int gridStartY = y + 60 - 120;
  int colWidth = 30;
  int rowHeight = 30;
  int day = 1;
  
  for (int row = 0; row < 5; row++) {
    
    for (int col = 0; col < 7; col++) {
      
      if (day > 31) break;
      int cellX = gridStartX + col * colWidth;
      int cellY = gridStartY + row * rowHeight;
      
      // Highlight: start date, end date, and in-between range
      if (day == startDate) {
        
        fill(0, 150, 255); 
      } 
      else if (day == endDate) {
        
        fill(0, 100, 255);
      } 
      else if (startDate != -1 && endDate != -1 && day > startDate && day < endDate) {
        fill(200, 200, 255);
      } 
      else {
        
        fill(255);
      }
      
      // If hovered over a cell, add a border highlight
      if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) {
        
        stroke(255, 0, 0);
        strokeWeight(2);
      } 
      else {
        
        noStroke();
      }
      
      rect(cellX - 10, cellY - 10, 25, 25, 5);
      fill( (day==startDate || day==endDate) ? 255 : 0);
      textAlign(CENTER, CENTER);
      text(day, cellX, cellY);
      
      day++;
      strokeWeight(1);
    }
  }
}





void mousePressed() {
  
  boolean clickHandled = false;
  
  // Check if click is on fused Date Range button
  if (isMouseOver(dateButtonX, dateButtonY, dateButtonW, dateButtonH)) {
    
    if (!dateRangeActive) {
      
      dateRangeActive = true;
      selectingStart = true;
      startDate = -1;
      endDate = -1;
    }
    
    clickHandled = true;
  }
  
  // Check Destination button
  if (isMouseOver(destX, destY, buttonW, buttonH)) {
    
    println("Destination button clicked");
    
    
    selectionDorO = "Destination";
    
    // Changes the destination button colour to make it selected
    colourValueButtonDestR = 100;
    colourValueButtonDestG = 100;
    colourValueButtonDestB = 255;
    
    //opacityValueButtonOrigin = 220;
    

    // Changes the origin button colours to deselect it
    colourValueButtonOriginR = 255;
    colourValueButtonOriginG = 255;
    colourValueButtonOriginB = 255;
    
    opacityValueButtonOrigin = 220;
    

    
    
    clickHandled = true;
  }
  
  // Check Origin button
  if (isMouseOver(originX, originY, buttonW, buttonH)) {
    
    println("Origin button clicked");
    
    // Changes the string variable to origin
    selectionDorO = "Origin";
    
    // Changes the origin button colour to make it selected
    colourValueButtonOriginR = 100;
    colourValueButtonOriginG = 100;
    colourValueButtonOriginB = 255;
    
    opacityValueButtonOrigin = 220;
    
    
    // Changes the destination button colours to deselect it
    colourValueButtonDestR = 255;
    colourValueButtonDestG = 255;
    colourValueButtonDestB = 255;
    
    
    clickHandled = true;
  }
  
  // Check Toggle
  if (isMouseOver(toggleX+60, toggleY, 20, 25)) {
    
    isLate = !isLate;
    clickHandled = true;
  }
  
  // Check Search Bar click
  if (isMouseOver(searchX, searchY, searchW, searchH)) {
    
    searchActive = !searchActive;
    clickHandled = true;
  }
  
  // Check Search Dropdown click (if active)
  if (searchActive) {
    
    int dropdownX = searchX;
    int dropdownY = searchY + searchH;
    int dropdownW = searchW;
    int dropdownH = usStates.length * searchDropdownItemHeight;
    
    if (isMouseOver(dropdownX, dropdownY, dropdownW, dropdownH)) {
      
      int index = (mouseY - dropdownY) / searchDropdownItemHeight;
      
      if (index >= 0 && index < usStates.length) {
        
        searchText = usStates[index];
        searchActive = false;
      }
      
      clickHandled = true;
    }
  }
  
  // Check Calendar area click (if active)
  if (dateRangeActive) {
    
    int calX = screenW/2 - 110 - 115, calY = screenH/2 - 120 - 120;
    
    if (isMouseOver(calX, calY, 220, 240)) {
      
      int gridStartX = calX + 20;
      int gridStartY = calY + 60;
      int colWidth = 30, rowHeight = 30;
      int day = 1;
      
      for (int row = 0; row < 5; row++) {
        
        for (int col = 0; col < 7; col++) {
          
          if (day > 31) break;
          
          int cellX = gridStartX + col * colWidth;
          int cellY = gridStartY + row * rowHeight;
          
          if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) {
            
            if (selectingStart) {
              
              startDate = day;
              selectingStart = false;
            } 
            else {
              
              endDate = day;
              // Remain in calendar mode so user can adjust if needed
            }
            
            break;
          }
          
          day++;
        }
      }
      
      clickHandled = true;
    }
  }
  
  // If click wasn't on any UI element, hide calendar and search dropdown.
  if (!clickHandled) {
    
    dateRangeActive = false;
    searchActive = false;
  }
}



boolean checkIsLate(String expectedTime, String realTime) {

  // Fixing the format: ensuring both time strings are 4 characters long
  while (expectedTime.length() < 4) {
    expectedTime = "0" + expectedTime;
  }

  while (realTime.length() < 4) {
    realTime = "0" + realTime;
  }

  // Extract hours and minutes correctly
  int expectedHour = Integer.parseInt(expectedTime.substring(0, 2));
  int expectedMinute = Integer.parseInt(expectedTime.substring(2, 4));
  int realHour = Integer.parseInt(realTime.substring(0, 2));
  int realMinute = Integer.parseInt(realTime.substring(2, 4));

  // Convert to total minutes for easy comparison
  int expectedTotalMinutes = expectedHour * 60 + expectedMinute;
  int realTotalMinutes = realHour * 60 + realMinute;

  // Return true if realTime is later than expectedTime
  return realTotalMinutes > expectedTotalMinutes;

}


// array[0] = startDate, array[1] = endDate
String[] getRangeOfDates(int startDate, int endDate) {

  String[] array = new String[2];

  String start = "01/" + startDate + "/2022 " + "00:00";
  String end = "01/" + endDate + "/2022 " + "00:00";

  array[0] = start;
  array[1] = end;
  
  return array;

}



