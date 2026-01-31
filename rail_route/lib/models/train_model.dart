import 'package:cloud_firestore/cloud_firestore.dart';

class TrainModel {
  final String id;
  final String number;
  final String name;
  final String status; // 'on time', 'delayed', 'cancelled'
  final int delayMinutes;
  final int travelTimeMinutes;
  final String currentStation;
  final String nextStation;
  final String platform;
  final String sourceStationCode;
  final String destinationStationCode;
  final List<StationStopModel> stations;
  final DateTime updatedAt;

  const TrainModel({
    required this.id,
    required this.number,
    required this.name,
    required this.status,
    required this.delayMinutes,
    this.travelTimeMinutes = 0,
    required this.currentStation,
    required this.nextStation,
    required this.platform,
    this.sourceStationCode = '',
    this.destinationStationCode = '',
    required this.stations,
    required this.updatedAt,
  });

  factory TrainModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TrainModel(
      id: doc.id,
      number: data['number'] ?? '',
      name: data['name'] ?? '',
      status: data['status'] ?? 'on time',
      delayMinutes: data['delayMinutes'] ?? 0,
      travelTimeMinutes: data['travelTimeMinutes'] ?? 0,
      currentStation: data['currentStation'] ?? '',
      nextStation: data['nextStation'] ?? '',
      platform: data['platform'] ?? '',
      sourceStationCode: data['sourceStationCode'] ?? '',
      destinationStationCode: data['destinationStationCode'] ?? '',
      stations: (data['stations'] as List<dynamic>? ?? [])
          .map((s) => StationStopModel.fromMap(s))
          .toList(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'status': status,
      'delayMinutes': delayMinutes,
      'travelTimeMinutes': travelTimeMinutes,
      'currentStation': currentStation,
      'nextStation': nextStation,
      'platform': platform,
      'sourceStationCode': sourceStationCode,
      'destinationStationCode': destinationStationCode,
      'stations': stations.map((s) => s.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class StationStopModel {
  final String name;
  final String stationCode;
  final String arrivalTime;
  final String platform;
  final bool isPassed;

  const StationStopModel({
    required this.name,
    this.stationCode = '',
    required this.arrivalTime,
    required this.platform,
    this.isPassed = false,
  });

  factory StationStopModel.fromMap(Map<String, dynamic> map) {
    return StationStopModel(
      name: map['name'] ?? '',
      stationCode: map['stationCode'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      platform: map['platform'] ?? '',
      isPassed: map['isPassed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stationCode': stationCode,
      'arrivalTime': arrivalTime,
      'platform': platform,
      'isPassed': isPassed,
    };
  }
}
