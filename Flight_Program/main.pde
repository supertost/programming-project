/****************************************************************/
/******COMMENT FOR THE BACKEND TEAM FROM THE FRONTEND TEAM*******/
/*

       For the destination and origin button, the variable for that is called "selectionDorO" -- Contents of this can either be "Destination" or "Origin" as written here
       
       For the calendar, there are the "startDate" and the "endDate" variables -- These variables hold an integer value from 1 to 31. For example if the "startDate" is 4 then the selected date is 4th of January 2022.
       As the date range is only between January 2022, we do not need any variables for the month or the year.
       
       For the late button, there is a boolean variable called "isLate" this variable is false by default, when switched on it turns into true.
       
       Lastly for the Search Bar, there is the "searchText" variable. After the user selects a state (using its abbreviation) and then an airport, the search bar will show the state and the airport chosen.
       
       selected airport in variable selectedAirport and state in selectedState
       
       Sincerely
       - Emir Dilekci

*/

// ------------------------
// Global Variables
// ------------------------

// window dimensions
PImage bg;
int screenW = 1200;
int screenH = 800;
int headerHeight = 150;

// RGB Colour Variable For The ORIGIN button
int colourValueButtonOriginR = 255;
int colourValueButtonOriginG = 255;
int colourValueButtonOriginB = 255;

// Variable that holds which button is pressed between Destination or Origin
String selectionDorO = "";

// RGB colour variables for the Destination button
int colourValueButtonDestR = 255;
int colourValueButtonDestG = 255;
int colourValueButtonDestB = 255;

int opacityValueButtonOrigin = 220;

// UI positions in header
int destX = 20, destY = 100, buttonW = 150, buttonH = 40;
int originX = destX + buttonW + 20, originY = destY;
int dateButtonX = originX + buttonW + 20, dateButtonY = destY, dateButtonW = 250, dateButtonH = 40;
int toggleX = dateButtonX + dateButtonW + 20, toggleY = destY + 9;
int searchX = toggleX + 150, searchY = destY, searchW = 200, searchH = 40;

// New Search Button position
int searchButtonX = searchX + searchW + 20;
int searchButtonY = searchY;
int searchButtonW = 100;
int searchButtonH = 40;

boolean isLate = false;

// Date range variables
int startDate = -1, endDate = -1;
boolean dateRangeActive = false;  // calendar open?
boolean selectingStart = true;    // if true, next date sets start; else sets end

// Search bar variables
boolean searchActive = false;
String searchText = "Search US State";

// Global variables for the search dropdown
String[] usStates = {"Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia"};
int searchDropdownItemHeight = 25;

// Creating the custom fonts
PFont mono;
PFont mono2;

// All flight objects stored here.
ArrayList<Flight> flights;

// ------------------------
// Global Variables for States Popup
// ------------------------
boolean showStatesPopup = false;
ArrayList<String> statesToShow = new ArrayList<String>();
String selectedState = ""; // holds the state abbreviation selected by the user

// Popup window coordinates for states (positioned below Destination/Origin buttons)
int popupX = destX; 
int popupY = destY + buttonH + 10; 
int popupW = 300;  // width of states popup
int popupH = 600;  // height of states popup

// ------------------------
// Global Variables for Airports Popup
// ------------------------
boolean showAirportsPopup = false;
ArrayList<String> airportsToShow = new ArrayList<String>();
String selectedAirport = ""; // holds the chosen airport
// Position the airports popup to the right of the states popup.
int airportPopupX = popupX + popupW + 10;
int airportPopupY = popupY;
int airportPopupW = 300;
int airportPopupH = 400;

// ------------------------
// Flight Class
// ------------------------
// (Flight class is defined in its own file)

// ------------------------
// setup() Function
// ------------------------
void setup() {
  size(1200, 800);
  pixelDensity(1);
  
  textSize(16);
  smooth();
  
  // Loads the background image
  bg = loadImage("background.png");
  
  // Load fonts
  mono = createFont("Fonts/Helvetica.ttf", 30);
  textFont(mono);
  
  mono2 = createFont("Fonts/Helvetica-Bold.ttf", 30);
  
  flights = new ArrayList<Flight>();

  // Load data from CSV
  Table table = loadTable("flights_full.csv", "header");
  
  // Reading flights to add into flights ArrayList.
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


// ------------------------
// draw() Function
// ------------------------
void draw() {
  // Draw background image or fallback color
  if (bg != null) {
    image(bg, 0, 0, screenW, screenH);
  } else {
    background(100);
  }
  
  // Draw header with semi-transparent background
  drawHeader();
  
  // Draw states popup if active
  if (showStatesPopup) {
    drawStatesPopup();
  }
  
  // Draw airports popup if active
  if (showAirportsPopup) {
    drawAirportsPopup();
  }
  
  // Draw calendar if active
  if (dateRangeActive) {
    drawCalendar(screenW/2 - 110, screenH/2 - 120);
  }
  
  // Draw search dropdown if active
  if (searchActive) {
    drawSearchDropdown();
  }
}


// ------------------------
// UI Drawing Functions
// ------------------------
void drawHeader() {
  noStroke();
  fill(100, 100, 255, 0); // Semi-transparent header
  rect(0, 0, screenW, headerHeight + 20);
  
  // Header title
  fill(255);
  textAlign(LEFT, CENTER);
  textFont(mono2);
  textSize(45);
  text("Group 5", 20, headerHeight/2 - 20);
  textFont(mono);
  textSize(16);
  
  // Draw header UI elements
  drawButtonD(destX, destY, buttonW, buttonH, "Destination");
  drawButtonO(originX, originY, buttonW, buttonH, "Origin");
  drawDateButton(dateButtonX, dateButtonY, dateButtonW, dateButtonH);
  drawToggle(toggleX, toggleY, "Late", isLate);
  drawSearchBar(searchX, searchY, searchW, searchH, searchText);
  drawSearchButton(searchButtonX, searchButtonY, searchButtonW, searchButtonH, "Search");
}


boolean isMouseOver(int x, int y, int w, int h) {
  return (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
}


void drawButtonD(int x, int y, int w, int h, String label) {
  noStroke();
  if (isMouseOver(x, y, w, h) && !selectionDorO.equals("Destination")) {
    fill(255, 255, 255, 255);
  } else {
    fill(colourValueButtonDestR, colourValueButtonDestG, colourValueButtonDestB, 220);
  }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}


void drawButtonO(int x, int y, int w, int h, String label) {
  noStroke();
  if (isMouseOver(x, y, w, h) && !selectionDorO.equals("Origin")) {
    fill(255, 255, 255, 255);
  } else {
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
  } else if (startDate != -1 && endDate == -1) {
    text("Start: " + startDate + " (select End Date)", x + w/2, y + h/2);
    
  }
  
  else{
    if (startDate <= endDate){
      text("Start: " + startDate + "   End: " + endDate, x + w/2, y + h/2);
    }
    else {
      text("Start: " + endDate + "   End: " + startDate, x + w/2, y + h/2);
    }
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


// New function to draw the Search Button.
void drawSearchButton(int x, int y, int w, int h, String label) {
  noStroke();
  if (isMouseOver(x, y, w, h)) fill(255, 255, 255, 255);
  else fill(255, 255, 255, 220);
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
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
    if (isMouseOver(dropdownX, itemY + 10, dropdownW, searchDropdownItemHeight)) {
      fill(200, 200, 255);
    } else {
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
      } else if (day == endDate) {
        fill(0, 100, 255);
      } else if (startDate != -1 && endDate != -1 && day > startDate && day < endDate) {
        fill(200, 200, 255);
      } else if (startDate != -1 && endDate != -1 && day < startDate && day > endDate) {
        fill(200, 200, 255);
      } else {
        fill(255);
      }
      
      // If hovered over a cell, add a border highlight
      if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) {
        stroke(255, 0, 0);
        strokeWeight(2);
      } else {
        noStroke();
      }
      
      rect(cellX - 10, cellY - 10, 25, 25, 5);
      fill((day == startDate || day == endDate) ? 255 : 0);
      textAlign(CENTER, CENTER);
      text(day, cellX, cellY);
      
      day++;
      strokeWeight(1);
    }
  }
}


// ------------------------
// Drawing the States Popup
// ------------------------
void drawStatesPopup() {
  // Draw a white rectangle (popup) with a border.
  noStroke();
  fill(255, 240);
  rect(popupX, popupY, popupW, popupH, 10);
  
  // Draw a "Close" button in the top-right corner.
  fill(175, 200);
  rect(popupX + popupW - 25, popupY + 5, 20, 20, 5);
  fill(0);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("X", popupX + popupW - 15, popupY + 15);
  
  // Title for the popup.
  fill(0);
  textSize(18);
  textAlign(CENTER, TOP);
  text("States (" + selectionDorO + ")", popupX + popupW/2, popupY + 30);
  
  // Display the states in a grid inside the popup.
  int cols = 3;
  int gapX = (popupW - 20) / cols;
  int gapY = 30;
  int startX = popupX + 10;
  int startY = popupY + 60;
  
  textSize(16);
  textAlign(LEFT, CENTER);
  for (int i = 0; i < statesToShow.size(); i++) {
    int col = i % cols;
    int row = i / cols;
    int x = startX + col * gapX;
    int y = startY + row * gapY;
    fill(0);
    text(statesToShow.get(i), x, y);
    
    // If this state is selected, draw a blue border around its text.
    if (statesToShow.get(i).equals(selectedState)) {
      noFill();
      stroke(0, 0, 255);
      strokeWeight(2);
      float tw = textWidth(statesToShow.get(i));
      float th = textAscent() + textDescent();
      rect(x - 2, y - th/2 - 2, tw + 4, th + 4);
      noStroke();
    }
  }
}


// ------------------------
// Drawing the Airports Popup
// ------------------------
void drawAirportsPopup() {
  // Draw a white rectangle (popup) with a border.
  noStroke();
  fill(255, 240);
  rect(airportPopupX, airportPopupY, airportPopupW, airportPopupH, 10);
  
  // Draw a "Close" button in the top-right corner.
  fill(175, 100);
  rect(airportPopupX + airportPopupW - 25, airportPopupY + 5, 20, 20, 5);
  fill(0);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("X", airportPopupX + airportPopupW - 15, airportPopupY + 15);
  
  // Title for the popup.
  fill(0);
  textSize(18);
  textAlign(CENTER, TOP);
  text("Airports (" + selectedState + ")", airportPopupX + airportPopupW/2, airportPopupY + 30);
  
  // Display the airports in a grid inside the popup.
  int cols = 2; // Adjust number of columns as needed.
  int gapX = (airportPopupW - 20) / cols;
  int gapY = 30;
  int startX = airportPopupX + 10;
  int startY = airportPopupY + 60;
  
  textSize(16);
  textAlign(LEFT, CENTER);
  for (int i = 0; i < airportsToShow.size(); i++) {
    int col = i % cols;
    int row = i / cols;
    int x = startX + col * gapX;
    int y = startY + row * gapY;
    fill(0);
    text(airportsToShow.get(i), x, y);
    
    // If this airport is selected, draw a blue border around its text.
    if (airportsToShow.get(i).equals(selectedAirport)) {
      noFill();
      stroke(0, 0, 255);
      float tw = textWidth(airportsToShow.get(i));
      float th = textAscent() + textDescent();
      rect(x - 2, y - th/2 - 2, tw + 4, th + 4);
      noStroke();
    }
  }
}


// ------------------------
// Mouse Interaction
// ------------------------
void mousePressed() {
  // If the states popup is visible, check for its interactions.
  if (showStatesPopup) {
    // Check for the states popup "Close" button.
    int closeBtnX = popupX + popupW - 25;
    int closeBtnY = popupY + 5;
    if (isMouseOver(closeBtnX, closeBtnY, 20, 20)) {
      showStatesPopup = false;
      showAirportsPopup = false;
      return;
    }
    // Check if a state is clicked.
    int cols = 3;
    int gapX = (popupW - 20) / cols;
    int gapY = 30;
    int startX = popupX + 10;
    int startY = popupY + 60;
    for (int i = 0; i < statesToShow.size(); i++) {
      int col = i % cols;
      int row = i / cols;
      int cellX = startX + col * gapX;
      int cellY = startY + row * gapY;
      if (mouseX >= cellX && mouseX <= cellX + gapX && mouseY >= cellY - gapY/2 && mouseY <= cellY + gapY/2) {
        selectedState = statesToShow.get(i);
        // Update searchText with the state abbreviation.
        searchText = selectedState;
        // Populate the airports list for the selected state.
        populateAirportsForState();
        showAirportsPopup = true;
        return;
      }
    }
  }
  
  // If the airports popup is visible, check for its interactions.
  if (showAirportsPopup) {
    int closeBtnX = airportPopupX + airportPopupW - 25;
    int closeBtnY = airportPopupY + 5;
    if (isMouseOver(closeBtnX, closeBtnY, 20, 20)) {
      showAirportsPopup = false;
      return;
    }
    int cols = 2;
    int gapX = (airportPopupW - 20) / cols;
    int gapY = 30;
    int startX = airportPopupX + 10;
    int startY = airportPopupY + 60;
    for (int i = 0; i < airportsToShow.size(); i++) {
      int col = i % cols;
      int row = i / cols;
      int cellX = startX + col * gapX;
      int cellY = startY + row * gapY;
      if (mouseX >= cellX && mouseX <= cellX + gapX && mouseY >= cellY - gapY/2 && mouseY <= cellY + gapY/2) {
        selectedAirport = airportsToShow.get(i);
        // Update searchText to include both the state and the airport.
        searchText = selectedState + " - " + selectedAirport;
        return;
      }
    }
  }
  
  boolean clickHandled = false;
  
  // Check if click is on fused Date Range button.
  if (isMouseOver(dateButtonX, dateButtonY, dateButtonW, dateButtonH)) {
    if (!dateRangeActive) {
      dateRangeActive = true;
      selectingStart = true;
      startDate = -1;
      endDate = -1;
      showStatesPopup = false;
      showAirportsPopup = false;
    }
    clickHandled = true;
  }
  
  // Check Destination button.
  if (isMouseOver(destX, destY, buttonW, buttonH)) {
    println("Destination button clicked");
    selectionDorO = "Destination";
    colourValueButtonDestR = 255;
    colourValueButtonDestG = 100;
    colourValueButtonDestB = 255;
    colourValueButtonOriginR = 255;
    colourValueButtonOriginG = 255;
    colourValueButtonOriginB = 255;
    opacityValueButtonOrigin = 220;
    
    populateStatesListForSelection();
    showStatesPopup = true;
    showAirportsPopup = false;
    clickHandled = true;
    
    dateRangeActive = false;
    selectingStart = false;
  }
  
  // Check Origin button.
  if (isMouseOver(originX, originY, buttonW, buttonH)) {
    println("Origin button clicked");
    selectionDorO = "Origin";
    colourValueButtonOriginR = 255;
    colourValueButtonOriginG = 100;
    colourValueButtonOriginB = 255;
    opacityValueButtonOrigin = 220;
    colourValueButtonDestR = 255;
    colourValueButtonDestG = 255;
    colourValueButtonDestB = 255;
    
    populateStatesListForSelection();
    showStatesPopup = true;
    showAirportsPopup = false;
    clickHandled = true;
    
    dateRangeActive = false;
    selectingStart = false;
  }
  
  // Check Toggle.
  if (isMouseOver(toggleX + 60, toggleY, 20, 25)) {
    isLate = !isLate;
    clickHandled = true;
  }
  if (isMouseOver(toggleX + 80, toggleY, 20, 25)) {
    isLate = !isLate;
    clickHandled = true;
  }
  
  // Check Search Button click.
  if (isMouseOver(searchButtonX, searchButtonY, searchButtonW, searchButtonH)) {
    println("Search button clicked");
    // Place search functionality here.
    clickHandled = true;
  }
  
  // Check Search Bar click.
  /*
  if (isMouseOver(searchX, searchY, searchW, searchH)) {
    searchActive = !searchActive;
    clickHandled = true;
  }*/
  
  // Check Search Dropdown click (if active).
  /*
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
  }*/
  
  // Check Calendar area click (if active).
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
            } else {
              endDate = day;
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
  
  // going to implement when search button added by front end.
  //ArrayList<Flight> filteredFlightsNotDest = limitedFlights(startDate, endDate, flights, isLate);
  
}


// ------------------------
// Helper Functions
// ------------------------
boolean checkIsLate(String expectedTime, String realTime) {
  while (expectedTime.length() < 4) {
    expectedTime = "0" + expectedTime;
  }
  while (realTime.length() < 4) {
    realTime = "0" + realTime;
  }
  int expectedHour = Integer.parseInt(expectedTime.substring(0, 2));
  int expectedMinute = Integer.parseInt(expectedTime.substring(2, 4));
  int realHour = Integer.parseInt(realTime.substring(0, 2));
  int realMinute = Integer.parseInt(realTime.substring(2, 4));
  int expectedTotalMinutes = expectedHour * 60 + expectedMinute;
  int realTotalMinutes = realHour * 60 + realMinute;
  return realTotalMinutes > expectedTotalMinutes;
}

String[] getRangeOfDates(int startDate, int endDate) {
  String[] array = new String[2];
  String start;
  String end;
  if(startDate <= endDate){
    start = String.format("01/%02d/2022 00:00", startDate);
    end = String.format("01/%02d/2022 00:00", endDate);
    array[0] = start;
    array[1] = end;
  }
  else{
    start = String.format("01/%02d/2022 00:00", endDate);
    end = String.format("01/%02d/2022 00:00", startDate);
    array[0] = end;
    array[1] = start;
  }
  return array;
}

ArrayList<Flight> limitedFlights(int startDateEntered, int endDateEntered, ArrayList<Flight> flights, boolean isLate) {
  ArrayList<Flight> sortedFlights = new ArrayList<Flight>();
  
  String[] dates;
  String startDateStr;
  String endDateStr;
  
  if(startDateEntered <= endDateEntered){
    dates = getRangeOfDates(startDateEntered, endDateEntered);
    
  }
  else{
    dates = getRangeOfDates(endDateEntered, startDateEntered);

  }
  
  
  if (startDateEntered >= endDateEntered){
    startDateStr = dates[1];
    endDateStr = dates[0];
  }
  else{
    startDateStr = dates[0];
    endDateStr = dates[1];
  }

  int start = Integer.parseInt(startDateStr.substring(3,5));
  int end = Integer.parseInt(endDateStr.substring(3,5));
  
  for (int i = 0; i < flights.size(); i++) {
    Flight flight = flights.get(i);
    String date = flight.date;
    // Normalize the date to ensure it is in "MM/dd/yyyy" (or "MM/dd/yyyy HH:mm") format
    String[] tokens = split(date, " ");
    String datePart = tokens[0];
    String[] dateTokens = split(datePart, "/");
    if (dateTokens.length >= 3) {
      if (dateTokens[0].length() == 1) {
        dateTokens[0] = "0" + dateTokens[0];
      }
      if (dateTokens[1].length() == 1) {
        dateTokens[1] = "0" + dateTokens[1];
      }
      datePart = join(dateTokens, "/");
    }
    if (tokens.length > 1) {
      date = datePart + " " + tokens[1];
    } else {
      date = datePart;
    }
    
    int day = Integer.parseInt(date.substring(3,5));
    
    boolean isLateFlight = false;
    if (selectionDorO.equals("Origin")) {
      isLateFlight = checkIsLate(String.valueOf(flight.expDepTime), String.valueOf(flight.depTime));
    } else {
      isLateFlight = checkIsLate(String.valueOf(flight.expArrTime), String.valueOf(flight.arrTime));
    }
    
    if (isLateFlight == isLate && day >= start && day <= end) {
      sortedFlights.add(flight);
    }
  }
  
  return sortedFlights;
}


// ------------------------
// New Functions for States and Airports
// ------------------------
void populateStatesListForSelection() {
  statesToShow.clear();
  selectedState = "";
  // Clear airports list when repopulating.
  airportsToShow.clear();
  selectedAirport = "";
  
  for (Flight flight : flights) {
    String state;
    if (selectionDorO.equals("Destination")) {
      state = flight.destState;
    } else {
      state = flight.originState;
    }
    if (!statesToShow.contains(state)) {
      statesToShow.add(state);
    }
  }
  statesToShow.sort(null);
}

void populateAirportsForState() {
  airportsToShow.clear();
  selectedAirport = "";
  
  // For each flight, if the flight's state matches the selected state, add the airport.
  for (Flight flight : flights) {
    String state;
    String airport;
    if (selectionDorO.equals("Destination")) {
      state = flight.destState;
      airport = flight.destination;
    } else {
      state = flight.originState;
      airport = flight.origin;
    }
    if (state.equals(selectedState) && !airportsToShow.contains(airport)) {
      airportsToShow.add(airport);
    }
  }
  airportsToShow.sort(null);
}
