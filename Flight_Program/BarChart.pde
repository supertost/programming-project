// ------------------------
// BarChart Class
// ------------------------
class BarChart {
  // Map to store counts for each state.
  HashMap<String, Integer> stateCounts;
  ArrayList<String> states; // sorted keys
  
  // Dimensions for the chart area
  int chartX, chartY, chartW, chartH;
  float barWidth;

  BarChart(ArrayList<Flight> filteredFlights) {
    stateCounts = new HashMap<String, Integer>();
    
    // Filter further by the selected airport and group by opposite state.
    if (selectionDorO.equals("Destination")) {
      for (Flight flight : filteredFlights) {
        if (flight.destination.equals(selectedAirport)) {
          String state = flight.originState;
          stateCounts.put(state, stateCounts.containsKey(state) ? stateCounts.get(state) + 1 : 1);
        }
      }
    } else if (selectionDorO.equals("Origin")) {
      for (Flight flight : filteredFlights) {
        if (flight.origin.equals(selectedAirport)) {
          String state = flight.destState;
          stateCounts.put(state, stateCounts.containsKey(state) ? stateCounts.get(state) + 1 : 1);
        }
      }
    }
    
    // Sort the state keys alphabetically
    states = new ArrayList<String>(stateCounts.keySet());
    states.sort(null);
    
    // Define the chart area (tweak these to suit your preference)
    chartX = 70;
    chartY = 150;
    chartW = width - 100;  // fill most of the width
    chartH = 600;          // taller chart for more room
  }
  
  void display() {
    // Light background for the chart (no black border)
    noStroke();
    fill(255, 0);   // light, subtle background color
    rect(chartX, chartY, chartW, chartH, 10);
    
    // Determine the maximum frequency to scale bar heights.
    int maxCount = 0;
    for (Integer count : stateCounts.values()) {
      if (count > maxCount) {
        maxCount = count;
      }
    }
    if (maxCount == 0) {
      maxCount = 1; // avoid division by zero
    }
    
    int numBars = states.size();
    if (numBars == 0) {
      // If there are no flights for these filters, show a message.
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("No flights to display for these filters.", chartX + chartW/2, chartY + chartH/2);
      return;
    }
        
    if (numBars < 7 ) {
      
       barWidth = 100.0;    
    }
    else {     
       // Bar width and spacing
        barWidth = chartW / (float) numBars;  
    }
      
        
    // We'll use a smaller text for state labels to help avoid overlap
    textSize(12);
    textAlign(CENTER, TOP);
    
    // Draw bars
    for (int i = 0; i < numBars; i++) {
      String state = states.get(i);
      int count = stateCounts.get(state);
      
      // Scale bar height
      float barHeight = map(count, 0, maxCount, 0, chartH - 60); 
      // Subtract extra space (e.g., 60) so we have room for labels
      
      float x = chartX + i * barWidth;
      float y = chartY + chartH - barHeight - 20; 
      // Move up 20 more pixels to leave space at bottom for state labels
      
      if (numBars == 1) {        
        x = 570;       
      }
      
      if (numBars == 2) {
        x = 520 + i * barWidth;
      }
      
      if (numBars == 3) {
        x = 470 + i * barWidth;
      }
      
      if (numBars == 4) {
        x = 420 + i * barWidth;
      }
      
      if (numBars == 5) {
        x = 370 + i * barWidth;
      }
      if (numBars == 6) {
        x = 320 + i * barWidth;
      }
           
      // Bar color
      fill(80, 140, 255);
      noStroke();
      rect(x + 2, y, barWidth - 4, barHeight); 
      // small horizontal margin (2 px) so bars have a little gap
      
      // Frequency label above each bar
      fill(0);
      textAlign(CENTER, BOTTOM);
      text(count, x + barWidth / 2, y - 2);
      
      // State label below the chart area
      textAlign(CENTER, TOP);
      text(state, x + barWidth / 2, chartY + chartH - 15);
    }
    
    // Axis labels: "States" and "Frequency"
    fill(0);
    textSize(25);
    
    // X-axis label (States)
    textAlign(CENTER, TOP);
    text("States", chartX + chartW / 2, chartY + chartH + 20);
    
    // Y-axis label (Frequency) - rotated
    pushMatrix();
    translate(chartX - 40 - 5, chartY + chartH / 2);
    rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Frequency", 0, 0);
    popMatrix();
  }
}
