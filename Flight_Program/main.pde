// ------------------------
// Global Variables
// ------------------------
import processing.core.*;
import processing.data.*;
import java.util.*;

// constant window dimensions
PImage bg;
PImage bg2;
final int SCREEN_WIDTH = 1200;
final int SCREEN_HEIGHT = 800;
final int HEADER_HEIGHT = 150;

// Global screen indicator: 0 = main UI, 1 = chart screen.
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

// NEW: Global variable to store filtered flights for 3D Map view.
ArrayList<Flight> filteredFlightsForMap;

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

// ------------------------
// NEW Global Variable for Pie Chart Data (for the pie chart view)
ArrayList<Flight> pieChartFlights;

// ------------------------
// NEW Global Variables for Header Menu (Chart Views)
// ------------------------
String chartType = "Bar Chart"; // default view after search

// Header Menu Button positions and dimensions
int headerMenuXStart = 230;
int headerMenuY = 10;
int headerMenuButtonW = 150;
int headerMenuButtonH = 40;
int headerMenuButtonGap = 45;

LineGraph lineGraph;

// ==================================================
// NEW Global Variables for 3D Map Integration
// ==================================================
PShape usMap;                // The complete SVG map
ArrayList<PShape> mapStates; // List of individual state shapes

// New offset variables to move the map and popup down
// >>> Modified: Increase offset to move map further down.
int mapYOffset = 150; 
int statePopupYOffset = 80;

// NEW: Global variable to store total filtered flights across all states.
int totalFilteredFlights = 0;

// --------------------------------------------------
// Loads the SVG map and initializes the state shapes.
// --------------------------------------------------
void setupMap() {
  usMap = loadShape("map2.svg");
  mapStates = new ArrayList<PShape>();
  for (int i = 0; i < usMap.getChildCount(); i++) {
    PShape stateShape = usMap.getChild(i);
    // Uncomment disableStyle() if you want to override the SVG’s built-in styling.
    // stateShape.disableStyle();
    stateShape.setFill(color(random(50,255), random(50,255), random(50,255)));
    stateShape.setStroke(color(0));
    mapStates.add(stateShape);
  }
}

void setup() {
  size(1200, 800);
  pixelDensity(1);
  textSize(16);
  smooth();
  windowTitle("CloudCruiser");

  // Loads the background images
  bg = loadImage("background.png");
  bg2 = loadImage("background3.png");

  // Load fonts
  mono = createFont("Fonts/Helvetica.ttf", 30);
  textFont(mono);
  mono2 = createFont("Fonts/Helvetica-Bold.ttf", 30);

  flights = new ArrayList<Flight>();

  // Load data from CSV
  Table table = loadTable("flights_full.csv", "header");
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
 
  // Initialize the map for the 3D Map view.
  setupMap();
}

void draw() {
  if (currentScreen == 0) {
    // Main UI screen.
    searchButtonY = searchY;
    backButtonY = searchY + height + 1000;
    if (bg != null) { image(bg, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); }
    else { background(100); }
    drawHeader();
    if (showStatesPopup) { drawStatesPopup(); }
    if (showAirportsPopup) { drawAirportsPopup(); }
    if (dateRangeActive) { drawCalendar(SCREEN_WIDTH/2 - 110, SCREEN_HEIGHT/2 - 120); }
    if (showErrorSearch == true) { showErrorSearch(); }
  }
  else if (currentScreen == 1) {
    if (bg2 != null) { image(bg2, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); }
    else { background(240); }
    backButtonY = searchY;
    searchButtonY = searchY + height + 1000;
   
    // Draw chart view based on header menu selection.
    if(chartType.equals("Bar Chart")) {
      if (barChart != null) {
        barChart.display();
        fill(0);
        textFont(mono2);
        textSize(32);
        textAlign(CENTER, TOP);
        String title = "";
        if (selectionDorO.equals("Destination")) {
          title = isLate ? "Late Flights to " : "On Time Flights to ";
        } else if (selectionDorO.equals("Origin")) {
          title = isLate ? "Late Flights from " : "On Time Flights from ";
        }
        title += selectedState + ", " + selectedAirport + ": (" + startDate + "/1/2022 - " + endDate + "/1/2022)" ;
        text(title, SCREEN_WIDTH/2, 106);
      }
    }
    else if(chartType.equals("Line Graph")) {
        
      drawLineGraph();
      lineGraph.display();
      
      
        fill(0);
        textFont(mono2);
        textSize(32);
        textAlign(CENTER, TOP);
        String title = "";
        if (selectionDorO.equals("Destination")) {
          title = isLate ? "Late Flights per airport in " : "On Time Flights per airport in ";
        } else if (selectionDorO.equals("Origin")) {
          title = isLate ? "Late Flights from " : "On Time Flights from ";
        }
        title += selectedState + ": (" + startDate + "/1/2022 - " + endDate + "/1/2022)" ;
        text(title, SCREEN_WIDTH/2, 106);
    }
    else if(chartType.equals("Pie Chart")) {
      // Original Pie Chart functionality remains unchanged.
      int cancelledCount = 0;
      int lateCount = 0;
      int normalCount = 0;
    
      for (Flight flight : pieChartFlights) {
        if (flight.cancelled) {
          cancelledCount++;
        } else {
          boolean lateFlight = false;
          if (selectionDorO.equals("Origin")) {
            lateFlight = checkIsLate(String.valueOf(flight.expDepTime), String.valueOf(flight.depTime));
          } else {
            lateFlight = checkIsLate(String.valueOf(flight.expArrTime), String.valueOf(flight.arrTime));
          }
        
          if (lateFlight) {
            lateCount++;
          } else {
            normalCount++;
          }
        }
      }
    
      int divertedCount = 0;
      int nonDivertedCount = 0;
    
      for (Flight flight : pieChartFlights) {
        if (flight.diverted) {
          divertedCount++;
        } else {
          nonDivertedCount++;
        }
      }
    
      String[] labels1 = { "Cancelled", "Late", "Normal" };
      int[] values1 = { cancelledCount, lateCount, normalCount };
      color[] colors1 = { color(255,0,0), color(255,165,0), color(0,200,0) };
    
      String[] labels2 = { "Diverted", "Not Diverted" };
      int[] values2 = { divertedCount, nonDivertedCount };
      color[] colors2 = { color(128,0,128), color(0,0,255) };
    
      float radius = 190;
    
      PieChart pie1 = new PieChart(SCREEN_WIDTH/3, SCREEN_HEIGHT/2, radius, "Flights (Cancelled / Late / Normal)", labels1, values1, colors1);
      PieChart pie2 = new PieChart(2*SCREEN_WIDTH/3, SCREEN_HEIGHT/2, radius, "Flights (Diverted / Not Diverted)", labels2, values2, colors2);
    
      pie1.display();
      pie2.display();
    
      float legendX = SCREEN_WIDTH/3 - radius;
      float legendY = SCREEN_HEIGHT/2 + radius + 20;
      float legendSpacing = 20;
      textFont(mono);
      textSize(20);
    
      fill(255,0,0);
      rect(legendX, legendY, 15, 15);
      fill(0);
      textAlign(LEFT, CENTER);
      text("Cancelled (" + cancelledCount + ")", legendX + 20, legendY + 7);
    
      fill(255,165,0);
      rect(legendX, legendY + legendSpacing, 15, 15);
      fill(0);
      text("Late (" + lateCount + ")", legendX + 20, legendY + legendSpacing + 7);
    
      fill(0,200,0);
      rect(legendX, legendY + 2*legendSpacing, 15, 15);
      fill(0);
      text("Normal (" + normalCount + ")", legendX + 20, legendY + 2*legendSpacing + 7);
    
      legendX = 2*SCREEN_WIDTH/3 - radius;
      legendY = SCREEN_HEIGHT/2 + radius + 20;
    
      fill(128,0,128);
      rect(legendX, legendY, 15, 15);
      fill(0);
      text("Diverted (" + divertedCount + ")", legendX + 20, legendY + 7);
    
      fill(0,0,255);
      rect(legendX, legendY + legendSpacing, 15, 15);
      fill(0);
      text("Not Diverted (" + nonDivertedCount + ")", legendX + 20, legendY + legendSpacing + 7);
    }
    else if(chartType.equals("3D Map")) {
      // ------------------------
      // NEW: Draws the 3D map with complete flight data.
      // ------------------------
      draw3DMap();
    }

    textFont(mono);
    textSize(20);
    drawBackButton(backButtonX, backButtonY, backButtonW, backButtonH);
    drawHeaderMenu();
  }
}

// ------------------------
// UI Drawing Functions (Header, Buttons, Calendar, etc.)
// ------------------------

void drawHeader() {
  noStroke();
  fill(100, 100, 255, 0);
  rect(0, 0, SCREEN_WIDTH, HEADER_HEIGHT + 20);
  fill(255);
  textAlign(LEFT, CENTER);
  textFont(mono2);
  textSize(45);
  text("CloudCruiser", 20, HEADER_HEIGHT/2 - 20);
  textFont(mono);
  textSize(16);
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
  if (isMouseOver(x, y, w, h) && !selectionDorO.equals("Destination")) { fill(255, 255, 255, 255); }
  else { fill(colourValueButtonDestR, colourValueButtonDestG, colourValueButtonDestB, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawButtonO(int x, int y, int w, int h, String label) {
  noStroke();
  if (isMouseOver(x, y, w, h) && !selectionDorO.equals("Origin")) { fill(255, 255, 255, 255); }
  else { fill(colourValueButtonOriginR, colourValueButtonOriginG, colourValueButtonOriginB, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawDateButton(int x, int y, int w, int h) {
  noStroke();
  if (isMouseOver(x, y, w, h)) { fill(255, 255, 255, 255); }
  else { fill(255, 255, 255, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  if (startDate == -1) { text("Pick Date Range", x + w/2, y + h/2); }
  else if (startDate != -1 && endDate == -1) { text("Start: " + startDate + " (select End Date)", x + w/2, y + h/2); }
  else {
    if (startDate <= endDate){ text("Start: " + startDate + "   End: " + endDate, x + w/2, y + h/2); }
    else { text("Start: " + endDate + "   End: " + startDate, x + w/2, y + h/2); }
  }
}

void drawToggle(int x, int y, String label, boolean active) {
  fill(255);
  textAlign(LEFT, CENTER);
  text(label, x + 15, y + 11);
  noStroke();
  if (isMouseOver(x+60, y, 40, 25)) { fill(active ? color(0, 220, 0) : color(220)); }
  else { fill(active ? color(0, 200, 0) : color(200)); }
  rect(x + 60, y, 40, 25, 12);
  fill(255);
  float knobX = active ? x + 60 + 20 : x + 60;
  rect(knobX, y, 20, 25, 12);
}

void drawSearchBar(int x, int y, int w, int h, String textContent) {
  noStroke();
  if (isMouseOver(x, y, w, h)) { fill(255, 255, 255, 255); }
  else { fill(255, 255, 255, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(LEFT, CENTER);
  text(" " + textContent, x + 5, y + h/2);
}

void drawSearchButton(int x, int y, int w, int h, String label) {
  noStroke();
  if (isMouseOver(x, y, w, h)) { fill(255, 255, 255, 255); }
  else { fill(255, 255, 255, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawBackButton(int x, int y, int w, int h) {
  noStroke();
  if (isMouseOver(x, y, w, h)) { fill(255, 255, 255, 255); }
  else { fill(255, 255, 255, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Back", x + w/2, y + h/2);
}

void drawCalendar(int x, int y) {
  noStroke();
  fill(240, 170);
  rect(x-115, y-120, 220, 240, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text("January 2022", x + 110 - 115, y + 25 - 120);
  int gridStartX = x + 20 - 115;
  int gridStartY = y + 60 - 120;
  int colWidth = 30;
  int rowHeight = 30;
  int day = 1;
  for (int row = 0; row < 5; row++) {
    for (int col = 0; col < 7; col++) {
      if (day > 31) { break; }
      int cellX = gridStartX + col * colWidth;
      int cellY = gridStartY + row * rowHeight;
      if (day == startDate) { fill(0, 150, 255); }
      else if (day == endDate) { fill(0, 100, 255); }
      else if (startDate != -1 && endDate != -1 && day > startDate && day < endDate) { fill(200, 200, 255); }
      else if (startDate != -1 && endDate != -1 && day < startDate && day > endDate) { fill(200, 200, 255); }
      else { fill(255); }
      if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) { stroke(255, 0, 0); strokeWeight(2); }
      else { noStroke(); }
      rect(cellX - 10, cellY - 10, 25, 25, 5);
      fill((day == startDate || day == endDate) ? 255 : 0);
      textAlign(CENTER, CENTER);
      text(day, cellX, cellY);
      day++;
      strokeWeight(1);
    }
  }
}

void drawStatesPopup() {
  noStroke();
  fill(255, 240);
  rect(popupX, popupY, popupW, popupH, 10);
  fill(175, 200);
  rect(popupX + popupW - 25, popupY + 5, 20, 20, 5);
  fill(0);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("X", popupX + popupW - 15, popupY + 15);
  fill(0);
  // >>> Modified: Increase popup title size and vertical spacing.
  textSize(22);
  textAlign(CENTER, TOP);
  text("States (" + selectionDorO + ")", popupX + popupW/2, popupY + 40);
  int cols = 3;
  int gapX = (popupW - 20) / cols;
  int gapY = 30;
  int startX = popupX + 10;
  int startY = popupY + 80;
  textSize(16);
  textAlign(LEFT, CENTER);
  for (int i = 0; i < statesToShow.size(); i++) {
    int col = i % cols;
    int row = i / cols;
    int x = startX + col * gapX;
    int y = startY + row * gapY;
    fill(0);
    text(statesToShow.get(i), x, y);
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

void drawAirportsPopup() {
  noStroke();
  fill(255, 240);
  rect(airportPopupX, airportPopupY, airportPopupW, airportPopupH, 10);
  fill(175, 100);
  rect(airportPopupX + airportPopupW - 25, airportPopupY + 5, 20, 20, 5);
  fill(0);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("X", airportPopupX + airportPopupW - 15, airportPopupY + 15);
  fill(0);
  textSize(18);
  textAlign(CENTER, TOP);
  text("Airports (" + selectedState + ")", airportPopupX + airportPopupW/2, airportPopupY + 30);
  int cols = 2;
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

void drawHeaderMenu() {
  noStroke();
  fill(255, 200);
  rect(0, 0, SCREEN_WIDTH, headerMenuButtonH + 20);
  int x = headerMenuXStart;
  textFont(mono2);
  textSize(16);
  drawChartMenuButton(x, headerMenuY, headerMenuButtonW, headerMenuButtonH, "Line Graph", chartType.equals("Line Graph"));
  x += headerMenuButtonW + headerMenuButtonGap;
  drawChartMenuButton(x, headerMenuY, headerMenuButtonW, headerMenuButtonH, "Bar Chart", chartType.equals("Bar Chart"));
  x += headerMenuButtonW + headerMenuButtonGap;
  drawChartMenuButton(x, headerMenuY, headerMenuButtonW, headerMenuButtonH, "Pie Chart", chartType.equals("Pie Chart"));
  x += headerMenuButtonW + headerMenuButtonGap;
  // >>> Modified: For 3D Map, reset filteredFlightsForMap to flights.
  drawChartMenuButton(x, headerMenuY, headerMenuButtonW, headerMenuButtonH, "3D Map", chartType.equals("3D Map"));
}

void drawChartMenuButton(int x, int y, int w, int h, String label, boolean active) {
  noStroke();
  if (active) { fill(200, 200, 255); }
  else { fill(255, 255, 255, 220); }
  rect(x, y, w, h, 10);
  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawLineGraph() {
  if (lineGraph != null) { lineGraph.display(); }
  else {
    fill(0);
    textFont(mono2);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Line Graph View", SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
  }
}

// ------------------------
// NEW: Modified draw3DMap() to show complete flight counts per state.
// ------------------------
void draw3DMap() {
  if (bg2 != null) { image(bg2, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); }
 
  // >>> Modified: Draw a title at a new vertical position above the shifted map.
  String mapTitle = "";
  if (selectionDorO.equals("Destination")) {
    mapTitle = ("Information about all flights per state");
  } else if (selectionDorO.equals("Origin")) {
    mapTitle = ("Information about all flights per state");
  } else {
    mapTitle = "3D Map View";
  }
  fill(0);
  textFont(mono2);
  textSize(36);
  textAlign(CENTER, TOP);
  text(mapTitle, SCREEN_WIDTH/2, 112);
 
  // Draw the map shifted down by mapYOffset.
  pushMatrix();
  translate(0, mapYOffset);
  for (PShape state : mapStates) {
    pushStyle();
    shape(state);
    popStyle();
  }
  popMatrix();
 
  // Draw the state info popup (top left) – it is now bigger.
  // Use the complete flights dataset regardless of any filters.
  ArrayList<Flight> sourceFlights = flights;
  for (PShape state : mapStates) {
    if (isMouseInShapeAdjusted(state, mapYOffset)) {
      String stateAbbr = state.getName();
      int flightCount = 0;
      HashSet<String> airportSet = new HashSet<String>();
      // Only check if a flight belongs to a state by comparing state abbreviations.
      for (Flight flight : sourceFlights) {
        if (selectionDorO.equals("Origin")) {
          if (flight.originState.equals(stateAbbr)) {
            flightCount++;
            airportSet.add(flight.origin);
          }
        } else if (selectionDorO.equals("Destination")) {
          if (flight.destState.equals(stateAbbr)) {
            flightCount++;
            airportSet.add(flight.destination);
          }
        }
      }
      int airportCount = airportSet.size();
      drawStateInfoPopup(stateAbbr, flightCount, airportCount);
      break;
    }
  }
 
  // >>> Modified: For the frequency panel, show the total flights from the complete dataset.
  drawFrequencyPanel(flights.size());
}

// ------------------------
// NEW: Adjusted point-in-polygon test using an offset for the Y coordinate.
// ------------------------
boolean isMouseInShapeAdjusted(PShape s, int offsetY) {
  int n = s.getVertexCount();
  if (n == 0) return false;
  boolean inside = false;
  float my = mouseY - offsetY;
  for (int i = 0, j = n - 1; i < n; j = i++) {
    PVector vi = s.getVertex(i);
    PVector vj = s.getVertex(j);
    if ((vi.y > my) != (vj.y > my)) {
      float intersectX = (vj.x - vi.x) * (my - vi.y) / (vj.y - vi.y) + vi.x;
      if (mouseX < intersectX) { inside = !inside; }
    }
  }
  return inside;
}

// ------------------------
// NEW: Draws the state info popup at a fixed position (top left) with increased size.
// ------------------------
void drawStateInfoPopup(String stateName, int flightCount, int airportCount) {
  pushStyle();
  int popupX = 20;
  int popupY = statePopupYOffset;
  int padding = 20;  // >>> Modified: increased padding for a bigger popup.
  textSize(18);
  String line1 = "State: " + stateName;
  String line2 = "Total Flights: " + flightCount;
  String line3 = "Airports: " + airportCount;
  float tw1 = textWidth(line1);
  float tw2 = textWidth(line2);
  float tw3 = textWidth(line3);
  float popupW = max(max(tw1, tw2), tw3) + 2 * padding;
  float lineHeight = textAscent() + textDescent() + 6;
  float popupH = lineHeight * 3 + 2 * padding;
  fill(255, 230);
  stroke(0);
  rect(popupX, popupY, popupW, popupH, 5);
  fill(0);
  noStroke();
  textAlign(LEFT, TOP);
  text(line1, popupX + padding, popupY + padding);
  text(line2, popupX + padding, popupY + padding + lineHeight);
  text(line3, popupX + padding, popupY + padding + 2 * lineHeight);
  popStyle();
}

// ------------------------
// NEW: Draws a frequency panel showing total flights, repositioned to the bottom right and made larger.
// ------------------------
void drawFrequencyPanel(int flightCount) {
  pushStyle();
  // >>> Modified: Position at bottom right and enlarge the panel.
  int panelW = 280;
  int panelH = 80;
  int panelX = SCREEN_WIDTH - panelW - 20;
  int panelY = SCREEN_HEIGHT - panelH - 20;
  fill(255, 230);
  stroke(0);
  rect(panelX, panelY, panelW, panelH, 10);
  fill(0);
  noStroke();
  textAlign(LEFT, CENTER);
  textFont(mono);
  textSize(24);
  text("Total Flights: " + flightCount, panelX + 15, panelY + panelH/2);
  popStyle();
}

// ------------------------
// Mouse Click Handling
// ------------------------
void mousePressed() {
  if (currentScreen == 1) {
    int x = headerMenuXStart;
    if (isMouseOver(x, headerMenuY, headerMenuButtonW, headerMenuButtonH)) { chartType = "Line Graph"; return; }
    x += headerMenuButtonW + headerMenuButtonGap;
    if (isMouseOver(x, headerMenuY, headerMenuButtonW, headerMenuButtonH)) { chartType = "Bar Chart"; return; }
    x += headerMenuButtonW + headerMenuButtonGap;
    if (isMouseOver(x, headerMenuY, headerMenuButtonW, headerMenuButtonH)) { chartType = "Pie Chart"; return; }
    x += headerMenuButtonW + headerMenuButtonGap;
    // >>> Modified: For 3D Map, reset filteredFlightsForMap to the complete flights dataset.
    if (isMouseOver(x, headerMenuY, headerMenuButtonW, headerMenuButtonH)) {
      chartType = "3D Map";
      filteredFlightsForMap = flights; 
      return;
    }
  }
 
  if (showStatesPopup) {
    int closeBtnX = popupX + popupW - 25;
    int closeBtnY = popupY + 5;
    if (isMouseOver(closeBtnX, closeBtnY, 20, 20)) { showStatesPopup = false; showAirportsPopup = false; return; }
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
        searchText = selectedState;
        populateAirportsForState();
        showAirportsPopup = true;
        return;
      }
    }
  }
 
  if (showAirportsPopup) {
    int closeBtnX = airportPopupX + airportPopupW - 25;
    int closeBtnY = airportPopupY + 5;
    if (isMouseOver(closeBtnX, closeBtnY, 20, 20)) { showAirportsPopup = false; return; }
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
        searchText = selectedState + " - " + selectedAirport;
        return;
      }
    }
  }
 
  boolean clickHandled = false;
 
  if (isMouseOver(dateButtonX, dateButtonY, dateButtonW, dateButtonH)) {
    showErrorSearch = false;
    if (!dateRangeActive) { dateRangeActive = true; selectingStart = true; startDate = -1; endDate = -1; showStatesPopup = false; showAirportsPopup = false; }
    clickHandled = true;
  }
 
  if (isMouseOver(destX, destY, buttonW, buttonH)) {
    println("Destination button clicked");
    selectionDorO = "Destination";
    colourValueButtonDestR = 255; colourValueButtonDestG = 100; colourValueButtonDestB = 255;
    colourValueButtonOriginR = 255; colourValueButtonOriginG = 255; colourValueButtonOriginB = 255;
    opacityValueButtonOrigin = 220;
    populateStatesListForSelection();
    showStatesPopup = true; showAirportsPopup = false;
    clickHandled = true; dateRangeActive = false; selectingStart = false; showErrorSearch = false;
  }
 
  if (isMouseOver(originX, originY, buttonW, buttonH)) {
    println("Origin button clicked");
    selectionDorO = "Origin";
    colourValueButtonOriginR = 255; colourValueButtonOriginG = 100; colourValueButtonOriginB = 255;
    opacityValueButtonOrigin = 220;
    colourValueButtonDestR = 255; colourValueButtonDestG = 255; colourValueButtonDestB = 255;
    populateStatesListForSelection();
    showStatesPopup = true; showAirportsPopup = false;
    clickHandled = true; dateRangeActive = false; selectingStart = false; showErrorSearch = false;
  }
 
  if (isMouseOver(toggleX + 60, toggleY, 20, 25)) { isLate = !isLate; clickHandled = true; }
  if (isMouseOver(toggleX + 80, toggleY, 20, 25)) { isLate = !isLate; clickHandled = true; }
 
  if (isMouseOver(searchButtonX, searchButtonY, searchButtonW, searchButtonH)) {
    showStatesPopup = false; showAirportsPopup = false; dateRangeActive = false; selectingStart = false;
    if ((!selectionDorO.equals("")) && !selectedAirport.equals("") && !selectedState.equals("") && startDate != -1 && endDate != -1) {
      println("Search button clicked");
      ArrayList<Flight> filteredFlights = limitedFlights(startDate, endDate, flights, isLate);
      // NEW: Store filtered flights for 3D Map use.
      filteredFlightsForMap = filteredFlights;
     
      ArrayList<Flight> filteredFlightsNotDest = limitedFlights(startDate, endDate, flights, isLate);
      ArrayList<Flight> filteredFlightsDest = destFiltering(filteredFlightsNotDest, selectionDorO, selectedAirport, selectedState);
      barChart = new BarChart(filteredFlights);
     
      ArrayList<Flight> flightsForLineGraph = new ArrayList<Flight>();
      for (Flight f : filteredFlights) {
        if (selectionDorO.equals("Destination") && f.destState.equals(selectedState)) { flightsForLineGraph.add(f); }
        else if (selectionDorO.equals("Origin") && f.originState.equals(selectedState)) { flightsForLineGraph.add(f); }
      }
      lineGraph = new LineGraph(flightsForLineGraph, selectionDorO, selectedState, selectedAirport);
     
      ArrayList<Flight> flightsByDate = filterFlightsByDate(startDate, endDate, flights);
      pieChartFlights = destFiltering(flightsByDate, selectionDorO, selectedAirport, selectedState);
     
      // Compute total filtered flights for all states.
      totalFilteredFlights = filteredFlights.size();
     
      currentScreen = 1;
      clickHandled = true;
    } else {
      showErrorSearch = true;
      showErrorSearch();
      println("Please select an origin or a destination and a date");
    }
  }
 
  if (isMouseOver(width/2 - 500, height/2 - 100, 1000, 200)) { showErrorSearch = false; println(showErrorSearch); }
 
  if (isMouseOver(backButtonX, backButtonY, backButtonW, backButtonH)) { currentScreen = 0; clickHandled = false; }
 
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
          if (day > 31) { break; }
          int cellX = gridStartX + col * colWidth;
          int cellY = gridStartY + row * rowHeight;
          if (isMouseOver(cellX - 10, cellY - 10, 25, 25)) {
            if (selectingStart) { startDate = day; selectingStart = false; }
            else { endDate = day; }
            break;
          }
          day++;
        }
      }
      clickHandled = true;
    }
  }
 
  if (!clickHandled) { dateRangeActive = false; searchActive = false; }
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

// ------------------------
// Helper Functions
// ------------------------

String[] getRangeOfDates(int startDate, int endDate) {
  String[] array = new String[2];
  if(startDate <= endDate) {
    array[0] = String.format("01/%02d/2022 00:00", startDate);
    array[1] = String.format("01/%02d/2022 00:00", endDate);
  } else {
    array[0] = String.format("01/%02d/2022 00:00", endDate);
    array[1] = String.format("01/%02d/2022 00:00", startDate);
  }
  return array;
}

ArrayList<Flight> limitedFlights(int startDateEntered, int endDateEntered, ArrayList<Flight> flights, boolean isLate) {
  ArrayList<Flight> sortedFlights = new ArrayList<Flight>();
  String[] dates = getRangeOfDates(startDateEntered, endDateEntered);
  String startDateStr = dates[0];
  String endDateStr = dates[1];
  int start = Integer.parseInt(startDateStr.substring(3,5));
  int end = Integer.parseInt(endDateStr.substring(3,5));
  for (Flight flight : flights) {
    String date = flight.date;
    String[] tokens = split(date, " ");
    String datePart = tokens[0];
    String[] dateTokens = split(datePart, "/");
    if (dateTokens.length >= 3) {
      if (dateTokens[0].length() == 1) { dateTokens[0] = "0" + dateTokens[0]; }
      if (dateTokens[1].length() == 1) { dateTokens[1] = "0" + dateTokens[1]; }
      datePart = join(dateTokens, "/");
    }
    if (tokens.length > 1) { date = datePart + " " + tokens[1]; }
    else { date = datePart; }
    int day = Integer.parseInt(date.substring(3,5));
    boolean isLateFlight = false;
    if (selectionDorO.equals("Origin")) {
      isLateFlight = checkIsLate(String.valueOf(flight.expDepTime), String.valueOf(flight.depTime));
    } else {
      isLateFlight = checkIsLate(String.valueOf(flight.expArrTime), String.valueOf(flight.arrTime));
    }
    if (isLateFlight == isLate && day >= start && day <= end) { sortedFlights.add(flight); }
  }
  return sortedFlights;
}

ArrayList<Flight> filterFlightsByDate(int startDateEntered, int endDateEntered, ArrayList<Flight> flights) {
  ArrayList<Flight> sortedFlights = new ArrayList<Flight>();
  String[] dates = getRangeOfDates(startDateEntered, endDateEntered);
  String startDateStr = dates[0];
  String endDateStr = dates[1];
  int start = Integer.parseInt(startDateStr.substring(3,5));
  int end = Integer.parseInt(endDateStr.substring(3,5));
  for (Flight flight : flights) {
    String date = flight.date;
    String[] tokens = split(date, " ");
    String datePart = tokens[0];
    String[] dateTokens = split(datePart, "/");
    if (dateTokens.length >= 3) {
      if (dateTokens[0].length() == 1) { dateTokens[0] = "0" + dateTokens[0]; }
      if (dateTokens[1].length() == 1) { dateTokens[1] = "0" + dateTokens[1]; }
      datePart = join(dateTokens, "/");
    }
    if (tokens.length > 1) { date = datePart + " " + tokens[1]; }
    else { date = datePart; }
    int day = Integer.parseInt(date.substring(3,5));
    if (day >= start && day <= end) { sortedFlights.add(flight); }
  }
  return sortedFlights;
}

void populateStatesListForSelection() {
  statesToShow.clear();
  selectedState = "";
  airportsToShow.clear();
  selectedAirport = "";
  for (Flight flight : flights) {
    String state;
    if (selectionDorO.equals("Destination")) { state = flight.destState; }
    else { state = flight.originState; }
    if (!statesToShow.contains(state)) { statesToShow.add(state); }
  }
  statesToShow.sort(null);
}

void populateAirportsForState() {
  airportsToShow.clear();
  selectedAirport = "";
  for (Flight flight : flights) {
    String state;
    String airport;
    if (selectionDorO.equals("Destination")) { state = flight.destState; airport = flight.destination; }
    else { state = flight.originState; airport = flight.origin; }
    if (state.equals(selectedState) && !airportsToShow.contains(airport)) { airportsToShow.add(airport); }
  }
  airportsToShow.sort(null);
}

boolean checkIsLate(String expectedTime, String realTime) {
  while (expectedTime.length() < 4) { expectedTime = "0" + expectedTime; }
  while (realTime.length() < 4) { realTime = "0" + realTime; }
  int expectedHour = Integer.parseInt(expectedTime.substring(0, 2));
  int expectedMinute = Integer.parseInt(expectedTime.substring(2, 4));
  int realHour = Integer.parseInt(realTime.substring(0, 2));
  int realMinute = Integer.parseInt(realTime.substring(2, 4));
  int expectedTotalMinutes = expectedHour * 60 + expectedMinute;
  int realTotalMinutes = realHour * 60 + realMinute;
  return realTotalMinutes > expectedTotalMinutes;
}

ArrayList<Flight> destFiltering(ArrayList<Flight> filteredFlightsNotDest, String selectionDorO, String selectedAirport, String selectedState) {
  ArrayList<Flight> array = new ArrayList<Flight>();
  if (selectionDorO.equals("Origin")) {
    for (int i = 0; i < filteredFlightsNotDest.size(); i++) {
      Flight flight = filteredFlightsNotDest.get(i);
      if (flight.origin.equals(selectedAirport) && flight.originState.equals(selectedState)) { array.add(flight); }
    }
  } else {
    for (int i = 0; i < filteredFlightsNotDest.size(); i++) {
      Flight flight = filteredFlightsNotDest.get(i);
      if (flight.destination.equals(selectedAirport) && flight.destState.equals(selectedState)) { array.add(flight); }
    }
  }
  return array;
}
