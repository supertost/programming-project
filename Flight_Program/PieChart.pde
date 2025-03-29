class PieChart {
  float x, y, radius;
  String title;
  String[] labels;
  int[] values;
  color[] sliceColors;
 
  PieChart(float x, float y, float radius, String title, String[] labels, int[] values, color[] sliceColors) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.title = title;
    this.labels = labels;
    this.values = values;
    this.sliceColors = sliceColors;
  }
 
  // Draw the pie chart with slice labels (including percentage)
  void display() {
    int total = 0;
    for (int v : values) { total += v; }
   
    float startAngle = 0;
    noStroke();
   
    for (int i = 0; i < values.length; i++) {
      float angle = (total > 0) ? map(values[i], 0, total, 0, TWO_PI) : 0;
      fill(sliceColors[i]);
      arc(x, y, radius*2, radius*2, startAngle, startAngle+angle, PIE);
     
      // Compute mid angle for labeling
      float midAngle = startAngle + angle/2;
      float labelX = x + cos(midAngle) * radius * 0.6;
      float labelY = y + sin(midAngle) * radius * 0.6;
      float percent = (total > 0) ? (values[i] / (float)total) * 100 : 0;
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(labels[i] + "\n" + nf(percent, 0, 1) + "%", labelX, labelY);
     
      startAngle += angle;
    }
   
    // Draw the title above the pie chart.
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text(title, x, y - radius - 40);
  }
 
  // Draw legend in a specified position.
  void drawLegend(float legendX, float legendY) {
    int total = 0;
    for (int v : values) { total += v; }
   
    textAlign(LEFT, CENTER);
    textSize(14);
    fill(0);
    text(title, legendX, legendY);
    for (int i = 0; i < labels.length; i++) {
      fill(sliceColors[i]);
      rect(legendX, legendY + 20 + i * 20, 15, 15);
      fill(0);
      float percent = (total > 0) ? (values[i] / (float)total) * 100 : 0;
      text(labels[i] + " (" + nf(percent, 0, 1) + "%)", legendX + 20, legendY + 27 + i * 20);
    }
  }
}
