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
    stateShape.setFill(color(random(50, 255), random(50, 255), random(50, 255)));
    stateShape.setStroke(color(0));
    mapStates.add(stateShape);
  }
}

// ------------------------
// NEW: Modified draw3DMap() to show complete flight counts per state.
// ------------------------
void draw3DMap() {
  if (bg2 != null) {
    image(bg2, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  }

  // >>> Modified: Draw a title at a new vertical position above the shifted map.
  String mapTitle = "";
  if (selectionDorO.equals("Destination")) {
    mapTitle = ("Information about all flights per state");
  } else if (selectionDorO.equals("Origin")) {
    mapTitle = ("Information about all flights per state");
  } else {
    mapTitle = "US Map View";
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


  drawFrequencyPanel(flights.size());
}


// Adjusted point-in-polygon test using an offset for the Y coordinate.
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
      if (mouseX < intersectX) {
        inside = !inside;
      }
    }
  }
  return inside;
}

// Draws the state info popup at a fixed position (top left) with increased size.
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
  noStroke();
  rect(popupX, popupY, popupW, popupH, 30);
  fill(0);
  noStroke();
  textAlign(LEFT, TOP);
  text(line1, popupX + padding, popupY + padding);
  text(line2, popupX + padding, popupY + padding + lineHeight);
  text(line3, popupX + padding, popupY + padding + 2 * lineHeight);
  popStyle();
}


// Draws a frequency panel showing total flights, repositioned to the bottom right and made larger.
void drawFrequencyPanel(int flightCount) {
  pushStyle();

  int panelW = 280;
  int panelH = 80;
  int panelX = SCREEN_WIDTH - panelW - 20;
  int panelY = SCREEN_HEIGHT - panelH - 20;
  fill(255, 230);
  noStroke();
  rect(panelX, panelY, panelW, panelH, 20);
  fill(0);
  noStroke();
  textAlign(LEFT, CENTER);
  textFont(mono);
  textSize(24);
  text("Total Flights: " + flightCount, panelX + 15, panelY + panelH/2);
  popStyle();
}
