class PieChart {
  String[] stateNames;
  int[] stateCounts;
  color[] stateColors; // Array to store unique colors for each state

  PieChart(ArrayList<FullFlight> flights) {
    processData(flights);
    assignStateColors(); // Assign unique colors to each state
  }

  void processData(ArrayList<FullFlight> flights) {
    ArrayList<String> tempStateNames = new ArrayList<String>();
    ArrayList<Integer> tempStateCounts = new ArrayList<Integer>();

    // Count flights per state
    for (FullFlight flight : flights) {
      String originState = flight.originState;
      int index = tempStateNames.indexOf(originState);
      if (index == -1) {
        tempStateNames.add(originState);
        tempStateCounts.add(1);
      } else {
        tempStateCounts.set(index, tempStateCounts.get(index) + 1);
      }
    }

    // Convert ArrayLists to arrays
    stateNames = tempStateNames.toArray(new String[0]);
    stateCounts = new int[tempStateCounts.size()];
    for (int i = 0; i < tempStateCounts.size(); i++) {
      stateCounts[i] = tempStateCounts.get(i);
    }
  }

  void assignStateColors() {
    // Predefined colors for each state
    color[] colors = {
      color(255, 99, 132),  // Red
      color(54, 162, 235),  // Blue
      color(255, 206, 86),  // Yellow
      color(75, 192, 192),  // Teal
      color(153, 102, 255), // Purple
      color(255, 159, 64),  // Orange
      color(199, 199, 199), // Gray
      color(83, 102, 255),  // Indigo
      color(255, 99, 255),  // Pink
      color(99, 255, 132),  // Green
      color(255, 99, 71),   // Tomato
      color(0, 255, 255),   // Cyan
      color(255, 0, 0),     // Bright Red
      color(0, 255, 0),     // Bright Green
      color(0, 0, 255),     // Bright Blue
      color(128, 0, 128),   // Purple
      color(255, 165, 0),   // Orange
      color(0, 128, 128),   // Teal
      color(128, 128, 0),   // Olive
      color(128, 0, 0)      // Maroon
    };

    // Assign colors to states
    stateColors = new color[stateNames.length];
    for (int i = 0; i < stateNames.length; i++) {
      stateColors[i] = colors[i % colors.length]; // Cycle through the predefined colors
    }
  }

  void display(boolean[] selectedStates) {
    textAlign(CENTER);
    textSize(16);
    fill(0);
    text("Flights Comparison by State", width / 2, 30);

    // Draw state selection checkboxes
    for (int i = 0; i < stateNames.length; i++) {
      float y = 100 + i * 20;
      fill(selectedStates[i] ? stateColors[i] : color(200)); // Use state-specific colors for selected states
      rect(20, y, 20, 20, 5);
      fill(0);
      textAlign(LEFT, CENTER);
      text(stateNames[i] + " (" + stateCounts[i] + ")", 50, y + 10);
    }

    // Calculate total flights for selected states
    float totalFlights = 0;
    for (int i = 0; i < stateNames.length; i++) {
      if (selectedStates[i]) {
        totalFlights += stateCounts[i];
      }
    }

    // Draw pie chart only for selected states
    if (totalFlights > 0) {
      float startAngle = 0;
      for (int i = 0; i < stateNames.length; i++) {
        if (selectedStates[i]) {
          float angle = map(stateCounts[i], 0, totalFlights, 0, TWO_PI);
          fill(stateColors[i]); // Use state-specific color
          arc(width / 2, height / 2, 400, 400, startAngle, startAngle + angle);

          // Display state name and count on the pie chart
          float midAngle = startAngle + angle / 2;
          float textX = width / 2 + cos(midAngle) * 150; // Position text along the arc
          float textY = height / 2 + sin(midAngle) * 150;
          fill(0);
          textAlign(CENTER, CENTER);
          text(stateNames[i] + " (" + stateCounts[i] + ")", textX, textY);

          startAngle += angle;
        }
      }
    } else {
      // Display a message if no states are selected
      fill(0);
      textAlign(CENTER, CENTER);
      text("No states selected", width / 2, height / 2);
    }
  }
}
