ArrayList<FullFlight> fullFlights;
BarChart barChart;
PieChart pieChart;
boolean showBarChart = true; // Toggle between bar chart and pie chart
boolean[] selectedStates; // Tracks which states are selected for the pie chart
String[] stateNames; // List of all states

void setup() {
  size(1000, 600);
  fullFlights = new ArrayList<FullFlight>();

  // Load data from CSV
  Table table = loadTable("flights_full.csv", "header");
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
}

void draw() {
  background(240);

  // Draw buttons
  drawButtons();

  // Display the selected chart
  if (showBarChart) {
    barChart.display();
  } else {
    pieChart.display(selectedStates);
  }
}

void drawButtons() {
  // Button for bar chart
  fill(showBarChart ? color(0, 150, 200) : color(200));
  rect(20, 20, 150, 40, 5);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Bar Chart", 95, 40);

  // Button for pie chart
  fill(!showBarChart ? color(0, 150, 200) : color(200));
  rect(200, 20, 150, 40, 5);
  fill(0);
  text("Pie Chart", 275, 40);
}

void mousePressed() {
  // Check if bar chart button is clicked
  if (mouseX > 20 && mouseX < 170 && mouseY > 20 && mouseY < 60) {
    showBarChart = true;
  }

  // Check if pie chart button is clicked
  if (mouseX > 200 && mouseX < 350 && mouseY > 20 && mouseY < 60) {
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
