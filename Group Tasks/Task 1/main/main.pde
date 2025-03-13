ArrayList<DataPoint> dataPoints;
String[] csvFileLines;

void setup() {
  
  size(800, 600);
  surface.setResizable(true);
  
  // Loads the CSV file
  csvFileLines = loadStrings("flights_reduced.csv");
  
  // Printing out the lines in the csv file to check if it is printing out properly
  for (String csvFileLines : csvFileLines) {
    
    println(csvFileLines);
  }
  
  // Initializes our dataPoints list
  dataPoints = new ArrayList<DataPoint>();
  
  // For each line, split the CSV fields and create a DataPoint instance
  for (String csvFileLines : csvFileLines) {
    
    // The CSV file we have in hand is a comma separated csv file so we use the "," as the splitter to make it show properly:
    String[] tokens = split(csvFileLines, ",");
    DataPoint dp = new DataPoint(tokens);
    dataPoints.add(dp);
  }
  
  // Print out the dataPoints to check if it is correct
  for (DataPoint dp : dataPoints) {
    
    println(dp);
  }
  
  // Setting up the font, font size and align
  PFont font = createFont("Arial", 16);
  textFont(font);
  textAlign(LEFT, TOP);
}

void draw() {
  
  background(255);
  fill(0);
  
  int y = 10;
  
  for (DataPoint dp : dataPoints) {
    
    text(dp.toString(), 10, y);
    y += 20;  // This line moves the next text down by 20 pixels to make it printed below the one above
  }
}


// class to store data from one line of the CSV file
class DataPoint {
  
  String[] fields;
  
  DataPoint(String[] fields) {
    
    this.fields = fields;
  }
  
  // Returns a comma separated string of the stored fields
  public String toString() {
    
    return join(fields, ", ");
  }
}
