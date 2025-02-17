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
 
/* Should input the total dataset, then the following params */
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
