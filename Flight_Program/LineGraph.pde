

class LineGraph {
  
  // Arrays to store airports and their corresponding flight frequencies.
  ArrayList<String> airports = new ArrayList<String>();
  ArrayList<Integer> frequencies = new ArrayList<Integer>();
  
  // The airport that the user has selected to highlight.
  String highlightAirport;
  
  // Constructor: receives flights that already match the date range and on-time/late filter,
  // along with the selection type, state, and the highlighted airport.
  LineGraph(ArrayList<Flight> flightsForLineGraph, String selectionDorO, 
            String selectedState, String selectedAirport) {
    
    this.highlightAirport = selectedAirport;
    
    // Build a frequency map: airport -> count
    HashMap<String, Integer> freqMap = new HashMap<String, Integer>();
    
    for (Flight f : flightsForLineGraph) {
      String key;
      if (selectionDorO.equals("Destination")) {
        key = f.destination;  // grouping by destination airport
      } else {
        key = f.origin;       // grouping by origin airport
      }
      // Increment count
      freqMap.put(key, freqMap.getOrDefault(key, 0) + 1);
    }
    
    // Transfer freqMap into arrays for display.
    for (String ap : freqMap.keySet()) {
      airports.add(ap);
      frequencies.add(freqMap.get(ap));
    }
    
    // Sort by airport name for consistency.
    ArrayList<String> sortedAirports = new ArrayList<String>(airports);
    Collections.sort(sortedAirports);
    
    ArrayList<Integer> sortedFreqs = new ArrayList<Integer>();
    for (String sAp : sortedAirports) {
      sortedFreqs.add(freqMap.get(sAp));
    }
    
    airports = sortedAirports;
    frequencies = sortedFreqs;
  }
  
  // Display the line graph with adjusted scaling and padding.
  void display() {
    // Define margins and extra padding inside the graph area.
    int leftMargin = 100;
    int rightMargin = 100;
    int topMargin = 180;
    int bottomMargin = 150;
    
    // Extra horizontal padding so the first and last points don't touch the borders.
    int horizontalPadding = 80;
    
    // Vertical padding fraction (10% on top and bottom)
    float verticalPaddingFraction = 0.1;
    
    float graphWidth = width - (leftMargin + rightMargin);
    float graphHeight = height - (topMargin + bottomMargin);
    
    // Draw the graph background.
    fill(255, 0);
    noStroke();
    rect(leftMargin, topMargin, graphWidth, graphHeight);
    
    // Draw Y-axis label.
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    pushMatrix();
    translate(leftMargin - 80, height/2);
    rotate(-HALF_PI);
    text("Number of Flights", 0, 0);
    popMatrix();
    
    // Draw X-axis label.
    textAlign(CENTER, CENTER);
    text("Airports", leftMargin + graphWidth/2, topMargin + graphHeight + 40);
    
    // Draw y-axis tick marks and labels.
    int numYTicks = 5;
    int maxFreq = 0;
    for (int freq : frequencies) {
      if (freq > maxFreq) {
        maxFreq = freq;
      }
    }
    if (maxFreq == 0) maxFreq = 1;
    
    for (int i = 0; i <= numYTicks; i++) {
      float tickValue = i * (maxFreq / (float)numYTicks);
      float yTick = topMargin + verticalPaddingFraction * graphHeight + 
                    (1 - i / (float)numYTicks) * (graphHeight * (1 - 2 * verticalPaddingFraction));
      stroke(200);
      line(leftMargin - 5, yTick, leftMargin, yTick);
      noStroke();
      fill(0);
      textAlign(RIGHT, CENTER);
      text((int)tickValue, leftMargin - 10, yTick);
    }
    
    // Calculate effective width and horizontal step.
    float effectiveWidth = graphWidth - 2 * horizontalPadding;
    int n = airports.size();
    if(n < 2) n = 2; // avoid division by zero
    float stepX = effectiveWidth / (n - 1);
    
    // Draw connecting lines.
    stroke(0, 0, 200);
    strokeWeight(3);
    for (int i = 0; i < airports.size() - 1; i++) {
      float x1 = leftMargin + horizontalPadding + i * stepX;
      float y1 = topMargin + verticalPaddingFraction * graphHeight + 
                 (1 - frequencies.get(i) / (float)maxFreq) * (graphHeight * (1 - 2 * verticalPaddingFraction));
      float x2 = leftMargin + horizontalPadding + (i + 1) * stepX;
      float y2 = topMargin + verticalPaddingFraction * graphHeight + 
                 (1 - frequencies.get(i + 1) / (float)maxFreq) * (graphHeight * (1 - 2 * verticalPaddingFraction));
      line(x1, y1, x2, y2);
    }
    
    // Draw data points and airport labels.
    for (int i = 0; i < airports.size(); i++) {
      float x = leftMargin + horizontalPadding + i * stepX;
      float y = topMargin + verticalPaddingFraction * graphHeight + 
                (1 - frequencies.get(i) / (float)maxFreq) * (graphHeight * (1 - 2 * verticalPaddingFraction));
      
      // Draw the point (highlight if selected).
      if (airports.get(i).equals(highlightAirport)) {
        fill(255, 0, 0);
        stroke(0);
        strokeWeight(1);
        ellipse(x, y, 20, 20);
      } else {
        fill(0, 0, 255);
        noStroke();
        ellipse(x, y, 15, 15);
      }
      
      // Draw the airport label below the point with a gap.
      fill(0);
      textSize(12);
      textAlign(CENTER, TOP);
      text(airports.get(i), x, y + 10);
    }

    // Mouse hover detection: Show frequency tooltip
    for (int i = 0; i < airports.size(); i++) {
      float x = leftMargin + horizontalPadding + i * stepX;
      float y = topMargin + verticalPaddingFraction * graphHeight + 
                (1 - frequencies.get(i) / (float)maxFreq) * (graphHeight * (1 - 2 * verticalPaddingFraction));
      
      // Check if mouse is close to the point
      if (dist(mouseX, mouseY, x, y) < 10) {
        fill(255);
        //rect(x + 10, y - 20, 40, 20); // Tooltip background
        fill(0);
        textSize(18);
        textAlign(LEFT, CENTER);
        text(frequencies.get(i), x + 15, y - 10); // Show frequency
      }
    }
  }
}
