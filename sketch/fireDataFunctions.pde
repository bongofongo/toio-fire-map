//  PGraphics offscreen;

FireData[] filterFireDataByTime(FireData[] dataArray, int startTime, int endTime) {
  ArrayList<FireData> filteredList = new ArrayList<FireData>();

  for (FireData fire : dataArray) {
    if (fire.time >= startTime && fire.time <= endTime) {
      filteredList.add(fire);
    }
  }

  //rows = ceil((float) filteredList.size());
  FireData[] res = new FireData[filteredList.size()];

  for (int i = 0; i < filteredList.size(); i++) {
    res[i] = filteredList.get(i);
  }
  return res;
}

/* Helper function clusters using the earliest start time,
    a cumulative brightness, and the average latitude and longitude */
 FireData[] clusterFireData(FireData[] data, int clusterRadius) {
  ArrayList<FireData> clusteredFires = new ArrayList<FireData>();
  boolean[] visited = new boolean[data.length];

  for (int i = 0; i < data.length; i++) {
    if (visited[i]) continue;

    float sumLat = data[i].latitude;
    float sumLon = data[i].longitude;
    int totalBrightness = data[i].brightness;
    int earliestTime = data[i].time;
    int count = 1;
    
    visited[i] = true;

    for (int j = 0; j < data.length; j++) {
      if (i == j || visited[j]) continue;
      
      // If the fire is within the clustering radius, merge it
      float distance = sqrt(pow((data[i].latitude - data[j].latitude), 2) + pow((data[i].longitude - data[j].longitude), 2));
      if (distance <= clusterRadius) {
        sumLat += data[j].latitude;
        sumLon += data[j].longitude;
        totalBrightness += data[j].brightness;
        earliestTime = min(earliestTime, data[j].time);
        count++;
        
        visited[j] = true;
      }
    }

    clusteredFires.add(new FireData(sumLat / count, sumLon / count, data[i].date, earliestTime, totalBrightness));
  }

  return clusteredFires.toArray(new FireData[0]);
}
 
/* toioFireData() returns a clustered splice of firedata
   data: the full firedata dataset
   maxTOIOS: the total number of datapoints you want
   clusterRadius: max distance (km) that you want datapoints to cluster by
   start: start time (in hrs:min ex 1:45am = 0145)
   end: end time.
   returns: FireData[] splice of data.
   */
FireData[] toioFireData(FireData[] data, int maxTOIOS, int clusterRadius, int start, int end) {
  FireData[] filteredFires = filterFireDataByTime(fireDataArray, start, end);
  FireData[] clusteredFires = clusterFireData(filteredFires, clusterRadius);
  
  FireData[] res = new FireData[maxTOIOS];
  for (int i = 0; i < maxTOIOS; i++) {
    res[i] = clusteredFires[i];
    println(res[i]);
  }
  
  return res;
}

void displayClusterInfo(FireData cluster, float x, float y) {
  String info = "Lat: " + nf(cluster.latitude, 0, 2) +
                "\nLon: " + nf(cluster.longitude, 0, 2) +
                "\nDate: " + cluster.date +
                "\nTime: " + cluster.time +
                "\nBrightness: " + cluster.brightness;
  
  offscreen.textSize(12);
  offscreen.textAlign(LEFT, TOP);
  
  float margin = 5;
  float boxWidth = textWidth("Brightness: " + cluster.brightness) + margin * 2;
  float lineHeight = textAscent() + textDescent() + 2;
  float boxHeight = lineHeight * 5 + margin * 2;  // 5 lines
  
  offscreen.noStroke();
  offscreen.fill(255, 200, 200); // light red background
  offscreen.rect(x, y, boxWidth, boxHeight, 5);
  
  offscreen.fill(0);
  offscreen.text(info, x + margin, y + margin);
}
