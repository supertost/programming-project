// ------------------------
// Global Variables
// ------------------------

// constant window dimensions
PImage bg;
PImage bg2;
final int SCREEN_WIDTH = 1200;
final int SCREEN_HEIGHT = 800;
final int HEADER_HEIGHT = 150;

// Global screen indicator: 0 = main UI, 1 = bar chart screen.
int currentScreen = 0;

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


int backButtonX = 1050;
int backButtonY = -100;
int backButtonW = 100;
int backButtonH = 40;

boolean showErrorSearch = false;

boolean isLate = false;

// Date range variables
int startDate = -1, endDate = -1;
boolean dateRangeActive = false;  // calendar open?
boolean selectingStart = true;    // if true, next date sets start; else sets end

// Search bar variables
boolean searchActive = false;
String searchText = "Search US State";

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
// Global Variables for Bar Chart
// ------------------------
BarChart barChart;


void setup() {
  
  size(1200, 800);
  pixelDensity(1);
  
  textSize(16);
  smooth();
  
  windowTitle("CloudCruiser");
  
  // Loads the background image
  bg = loadImage("background.png");
  bg2 = loadImage("background3.png");
  
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



void draw() {
  
  if (currentScreen == 0) {
    
    // Putting the search button in focus
    searchButtonY = searchY;
    
    // Putting the back button out of focus
    backButtonY = searchY + height + 1000;
    
    // Main UI screen.
    if (bg != null) {
      
      image(bg, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } 
    else {
      
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
      
      drawCalendar(SCREEN_WIDTH/2 - 110, SCREEN_HEIGHT/2 - 120);
    }

    if (showErrorSearch == true) {

      showErrorSearch();
    }
    
  } 
  
  else if (currentScreen == 1) {

    if (bg2 != null) {
      
      image(bg2, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    else {

      background(240);
    }
   
    // Putting the back button in focus
    backButtonY = searchY;
    
    // Putting the search button out of focus
    searchButtonY = searchY + height + 1000;
    
    // Bar chart screen.
    // Display the title
    fill(0);
    textFont(mono2);
    textSize(32);
    String title = "";
    
    if (selectionDorO.equals("Destination")) {
      
      title = isLate ? "Late Flights to " : "On Time Flights to ";
    } 
    else if (selectionDorO.equals("Origin")) {
      
      title = isLate ? "Late Flights from " : "On Time Flights from ";
    }
    
    title += selectedState + ", " + selectedAirport + ": (" + startDate + "/1/2022 - "+ endDate + "/1/2022)"  ;
    textAlign(CENTER, TOP);
    text(title, SCREEN_WIDTH/2, 120 - 85);


    textFont(mono);
    textSize(20);
    drawBackButton(backButtonX, backButtonY, backButtonW, backButtonH);
    
    // Display the bar chart
    if (barChart != null) {
      
      barChart.display();
    }
  }
}


// Function to draw the header
void drawHeader() {

  noStroke();
  fill(100, 100, 255, 0); // Semi-transparent header
  rect(0, 0, SCREEN_WIDTH, HEADER_HEIGHT + 20);
  
  // Header title
  fill(255);
  textAlign(LEFT, CENTER);
  textFont(mono2);
  textSize(45);
  text("CloudCruiser", 20, HEADER_HEIGHT/2 - 20);
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

  if (isMouseOver(x, y, w, h) && !selectionDorO.equals("Origin")) {

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

  if (isMouseOver(x, y, w, h)) {
    
    fill(255, 255, 255, 255);
  }
  else {
    
    fill(255, 255, 255, 220);
  }

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

  if (isMouseOver(x+60, y, 40, 25)) {

    fill(active ? color(0, 220, 0) : color(220));
  }   
  else {

    fill(active ? color(0, 200, 0) : color(200));
  }

  rect(x + 60, y, 40, 25, 12);
  
  fill(255);
  float knobX = active ? x + 60 + 20 : x + 60;
  rect(knobX, y, 20, 25, 12);
}


void drawSearchBar(int x, int y, int w, int h, String textContent) {

  noStroke();

  if (isMouseOver(x, y, w, h)) {
    
    fill(255, 255, 255, 255);
  }
  else {
    
    fill(255, 255, 255, 220);
  }

  rect(x, y, w, h, 10);
  fill(0);
  textAlign(LEFT, CENTER);
  text(" " + textContent, x + 5, y + h/2);
}


// New function to draw the Search Button.
void drawSearchButton(int x, int y, int w, int h, String label) {

  noStroke();

  if (isMouseOver(x, y, w, h)) {
    
    fill(255, 255, 255, 255);
  }
  else {
    
    fill(255, 255, 255, 220);
  }

  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

// Back button to return back to the ain menu from the bar chart menu
void drawBackButton(int x, int y, int w, int h) {

  noStroke();

  if (isMouseOver(x, y, w, h)) {
    
    fill(255, 255, 255, 255);
  }
  else {
   
    fill(255, 255, 255, 220);
  }

  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Back", x + w/2, y + h/2);
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

      if (day > 31) {
        
        break;
      }

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
      else if (startDate != -1 && endDate != -1 && day < startDate && day > endDate) {
        
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
      fill((day == startDate || day == endDate) ? 255 : 0);
      textAlign(CENTER, CENTER);
      text(day, cellX, cellY);
      
      day++;
      strokeWeight(1);
    }
  }
}


// Function to draw the state selection screen
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


// Function to draw the airport selection screen
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


// Function that controls the mouse clickes
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

    showErrorSearch = false;

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

    showErrorSearch = false;
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

    showErrorSearch = false;
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
    
    showStatesPopup = false;
    showAirportsPopup = false;
    
    dateRangeActive = false;
    selectingStart = false;

    
    if ((!selectionDorO.equals("")) && !selectedState.equals("") && !selectedAirport.equals("") && startDate != -1 && endDate != -1) {
      
      println("Search button clicked");

      // Filter flights based on the date range and late condition.
      ArrayList<Flight> filteredFlights = limitedFlights(startDate, endDate, flights, isLate);
      
      ArrayList<Flight> filteredFlightsNotDest = limitedFlights(startDate, endDate, flights, isLate);

      ArrayList<Flight> filteredFlightsDest = destFiltering(filteredFlightsNotDest, selectionDorO, selectedAirport, selectedState);


      // Create a new BarChart object (the constructor will filter further based on the selected airport).
      barChart = new BarChart(filteredFlights);

      // Switch to bar chart screen.
      currentScreen = 1;
      clickHandled = true; 
    }
    else {

      showErrorSearch = true;
      showErrorSearch();

      println("Please select an origin or destination and a date");
    }
  }


  if (isMouseOver(width/2 - 500, height/2 - 100, 1000, 200)) {

    showErrorSearch = false;
    println(showErrorSearch);
  }
  
  if (isMouseOver(backButtonX, backButtonY, backButtonW, backButtonH)) {

    // Switch back to the main menu.
    currentScreen = 0;
    clickHandled = false;
  }
  
  // Check Calendar area click (if active).
  if (dateRangeActive) {

    int calX = SCREEN_WIDTH/2 - 110 - 115, calY = SCREEN_HEIGHT/2 - 120 - 120;

    if (isMouseOver(calX, calY, 220, 240)) {

      showErrorSearch = false;

      int gridStartX = calX + 20;
      int gridStartY = calY + 60;
      int colWidth = 30, rowHeight = 30;
      int day = 1;
      
      for (int row = 0; row < 5; row++) {

        for (int col = 0; col < 7; col++) {

          if (day > 31) {
            
            break;
          }

          int cellX = gridStartX + col * colWidth;
          int cellY = gridStartY + row * rowHeight;
          
          if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) {

            if (selectingStart) {

              startDate = day;
              selectingStart = false;

            } 
            else {

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
}

void showErrorSearch() {

    fill(0, 100);
    rect(width/2 - 500, height/2 - 100, 1000, 200, 20);

    fill(255, 175);
    rect(width/2 - 500, height/2 - 100, 1000, 200, 20);
    textFont(mono2);
    fill(0);
    text("Please select an origin or a destination point and a date", width/2, height/2);
}



// Helper Functions
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

  if(startDate <= endDate) {
    
    start = String.format("01/%02d/2022 00:00", startDate);
    end = String.format("01/%02d/2022 00:00", endDate);
    array[0] = start;
    array[1] = end;
  }
  else {

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
    } 
    else {

      date = datePart;
    }
    
    int day = Integer.parseInt(date.substring(3,5));
    
    boolean isLateFlight = false;

    if (selectionDorO.equals("Origin")) {

      isLateFlight = checkIsLate(String.valueOf(flight.expDepTime), String.valueOf(flight.depTime));
    } 
    else {

      isLateFlight = checkIsLate(String.valueOf(flight.expArrTime), String.valueOf(flight.arrTime));
    }
    
    if (isLateFlight == isLate && day >= start && day <= end) {

      sortedFlights.add(flight);
    }
  }
  
  return sortedFlights;
}


// Functions for the states and the airports
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
    } 
    else {

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
    } 
    else {

      state = flight.originState;
      airport = flight.origin;
    }

    if (state.equals(selectedState) && !airportsToShow.contains(airport)) {

      airportsToShow.add(airport);
    }
  }

  airportsToShow.sort(null);
}

// -- Dev Joshi 
ArrayList<Flight> destFiltering(ArrayList<Flight> filteredFlightsNotDest, String selectionDorO, String selectedAirport, String selectedState) {

ArrayList<Flight> array = new ArrayList<Flight>();

if (selectionDorO.equals("Origin")) {
 for (int i = 0; i < filteredFlightsNotDest.size(); i++) {
   Flight flight = filteredFlightsNotDest.get(i);
   if (flight.origin.equals(selectedAirport) && flight.originState.equals(selectedState)) {
     array.add(flight);
   }
   
 } 
 
 
} else {
 
 for (int i = 0; i < filteredFlightsNotDest.size(); i++) {
   Flight flight = filteredFlightsNotDest.get(i);
   if (flight.destination.equals(selectedAirport) && flight.destState.equals(selectedState)) {
     array.add(flight);
   }
   
 } 
 
}

return array;


}
