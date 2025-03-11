

// all flights are here. you can see what properties have one flight by going to flight class.
// all flights_all.csv file flights are here.
ArrayList<FullFlight> fullFlights = new ArrayList<FullFlight>();

void setup() {
  Table table = loadTable("flights_full.csv", "header");

  // basically here im storing one flight to the flight arrayList.
  for (TableRow row : table.rows()) {
    String date = row.getString("FL_DATE");
    String carrier = row.getString("MKT_CARRIER");
    int flightNumber = row.getInt("MKT_CARRIER_FL_NUM");
    String origin = row.getString("ORIGIN");
    String originCity = row.getString("ORIGIN_CITY_NAME");
    String originState = row.getString("ORIGIN_STATE_ABR");
    String originWac = row.getString("ORIGIN_WAC");
    String destination = row.getString("DEST");
    String destCity = row.getString("DEST_CITY_NAME");
    String destState = row.getString("DEST_STATE_ABR");
    int destWac = row.getInt("DEST_WAC");
    int expDepTime = row.getInt("CRS_DEP_TIME");
    int depTime = row.getInt("DEP_TIME");  
    int expArrTime = row.getInt("CRS_ARR_TIME");
    int arrTime = row.getInt("ARR_TIME");  
    boolean cancelled = row.getInt("CANCELLED") == 1;
    boolean diverted = row.getInt("DIVERTED") == 1;
    int distance = row.getInt("DISTANCE");

    // Create and store the Flight object
    FullFlight flight = new FullFlight(date, carrier, flightNumber, origin, originCity, originState, 
                               originWac, destination, destCity, destState, destWac, 
                               expDepTime, depTime, expArrTime, arrTime, cancelled, diverted, distance);
    fullFlights.add(flight);
  }
  for(int i = 0; i <= fullFlights.size(); i++)
  {
    println(i);
  }
 
}
