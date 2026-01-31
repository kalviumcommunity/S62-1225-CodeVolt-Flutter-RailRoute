class RapidApiTrainModel {
  final String trainNumber;
  final String trainName;
  final String currentStation;
  final String nextStation;
  final String status; // 'delayed' or 'on time'
  final int delayMinutes;
  final String platform;
  final List<RapidApiStation> stations;

  RapidApiTrainModel({
    required this.trainNumber,
    required this.trainName,
    required this.currentStation,
    required this.nextStation,
    required this.status,
    required this.delayMinutes,
    required this.platform,
    required this.stations,
  });

  factory RapidApiTrainModel.fromJson(Map<String, dynamic> json) {
    // Note: Adjust these fields based on exact API response
    // This is a "best guess" structure often seen in these APIs
    final data = json['data'] ?? json;
    
    return RapidApiTrainModel(
      trainNumber: data['train_number'] ?? '',
      trainName: data['train_name'] ?? '',
      currentStation: data['current_station_name'] ?? '',
      nextStation: data['next_station_name'] ?? '',
      status: (data['delay'] ?? 0) > 0 ? 'delayed' : 'on time',
      delayMinutes: int.tryParse(data['delay']?.toString() ?? '0') ?? 0,
      platform: data['platform'] ?? 'TBD',
      stations: [], // We might need a separate call for full schedule
    );
  }
}

class RapidApiStation {
  final String name;
  final String arrival;
  final String departure;
  
  RapidApiStation({required this.name, required this.arrival, required this.departure});
}
