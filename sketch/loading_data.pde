class FireData {
  float latitude;
  float longitude;
  String date;
  int time;
  int brightness;
  
  FireData(float lat, float lon, String d, int t, int b) {
    latitude = lat;
    longitude = lon;
    date = d;
    time = t;
    brightness = b;
  }
  String toString() {
     return String.format("latidude: %f longitude: %f date: %s time: %d brightness: %d", latitude, longitude, date, time, brightness); 
  }
}


// Used https://processing.org/reference/loadTable_.html as a guide to load csv file
FireData[] loadData2FireDataArray(String filename) {
  Table table = loadTable(filename, "header"); 
  int rowCount = table.getRowCount();
  FireData[] fireDataArray = new FireData[rowCount];
  
  int i = 0;
  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");
    String date = row.getString("acq_date");
    int time = row.getInt("acq_time");
    int brightness = row.getInt("brightness");
    fireDataArray[i++] = new FireData(lat, lon, date, time, brightness);
  }
  println("Loaded " + fireDataArray.length + " entries as an array of FireData structs.");
  return fireDataArray;
}

// Used https://processing.org/reference/loadTable_.html as a guide to load csv file
String[][] loadData2StringArray(String filename) {
  Table table = loadTable(filename, "header"); 
  int rowCount = table.getRowCount();
  String[][] stringArray = new String[rowCount][];
  
  int i = 0;
  for (TableRow row : table.rows()) {
    String lat = row.getString("latitude");
    String lon = row.getString("longitude");
    String date = row.getString("acq_date");
    String time = row.getString("acq_time");
    String brightness = row.getString("brightness");
    stringArray[i++] = new String[] {lat, lon, date, time, brightness};
  }
  println("Loaded " + stringArray.length + " entries as an array of strings.");
  return stringArray;
}
