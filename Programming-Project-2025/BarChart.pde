class BarChart {
  String[] stateNames;
  int[] stateCounts;
  int barWidth;
  int maxFlights;

  BarChart(ArrayList<Flight> flights) {
    processData(flights);
    this.barWidth = width / stateNames.length;
    this.maxFlights = max(stateCounts);
  }

  void processData(ArrayList<Flight> flights) {
    ArrayList<String> tempStateNames = new ArrayList<String>();
    ArrayList<Integer> tempStateCounts = new ArrayList<Integer>();

    // Count flights per state
    for (Flight flight : flights) {
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

  void display() {
    textAlign(CENTER);
    textSize(16);
    fill(0);
    text("Flights Per State", width / 2, 30);

    for (int i = 0; i < stateNames.length; i++) {
      int barHeight = int(map(stateCounts[i], 0, maxFlights, 0, height - 100));

      // Draw bar
      fill(100, 150, 250);
      rect(i * barWidth + 10, height - barHeight - 50, barWidth - 5, barHeight);

      // Draw state name
      fill(0);
      textSize(12);
      text(stateNames[i], i * barWidth + (barWidth / 2), height - 30);

      // Draw flight count above the bar
      text(stateCounts[i], i * barWidth + (barWidth / 2), height - barHeight - 55);
    }
  }
}
