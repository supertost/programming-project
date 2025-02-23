
class Flight {

  
  // these are the all properties that one flight has.
  String date;
  String carrier;
  int flightNumber;
  String origin;
  String originCity;
  String originState;
  String originWac;
  String destination;
  String destCity;
  String destState;
  int destWac;
  int expDepTime;  // expected departure time
  int depTime;
  int expArrTime;  // expected arrive time
  int arrTime;
  boolean cancelled; 
  boolean diverted;
  int distance;
  
  
  // this is the constructor so we can store multiple flight objects. 
  Flight(String date, String carrier, int flightNumber, String origin, String originCity, String originState, String originWac, String destination, String destCity, String destState, int destWac, int expDepTime, int depTime, int expArrTime, int arrTime, boolean cancelled,  boolean diverted, int distance) {
    
    this.date = date;
    this.carrier = carrier;
    this.flightNumber = flightNumber;
    this.origin = origin;
    this.originCity = originCity;
    this.originState = originState;
    this.originWac = originWac;
    this.destination = destination;
    this.destCity = destCity;
    this.destState = destState;
    this.destWac = destWac;
    this.expDepTime = expDepTime;
    this.depTime = depTime;
    this.expArrTime = expArrTime;
    this.arrTime = arrTime;
    this.cancelled = cancelled;
    this.diverted = diverted;
    this.distance = distance;
    
    
  }
  
  
  

  
}
