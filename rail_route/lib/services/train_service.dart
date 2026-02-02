import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/train_model.dart';
import 'package:intl/intl.dart';

class TrainService {
  static const String _apiKey = 'rr_jfv5rxhlv5rrogceougmkc7tbjqdik6n';
  static const String _apiBase = 'https://api.railradar.in/api/v1';

  // Search trains by number or name
  Future<List<TrainModel>> searchTrains(String query) async {
    // If strict number, try status directly
    if (RegExp(r'^\d{5}$').hasMatch(query)) {
       try {
         final train = await getTrainStatus(query);
         return [train];
       } catch (e) {
         // Fallthrough to search
       }
    }
    return []; // TODO: Implement search endpoint if needed
  }

  // Get live status
  Future<TrainModel> getTrainStatus(String trainNumber) async {
    // 1. Try fetching FULL data (Static + Live) to get Station Names
    try {
      return await _fetchTrainData(trainNumber, 'full');
    } catch (e) {
      print('Full data failed for $trainNumber, trying live only: $e');
      // 2. Fallback to LIVE only (Station names might be codes)
      return await _fetchTrainData(trainNumber, 'live');
    }
  }

  Future<TrainModel> _fetchTrainData(String trainNumber, String dataType) async {
    final uri = Uri.parse('$_apiBase/trains/$trainNumber?dataType=$dataType');
    
    final response = await http.get(uri, headers: {
      'X-API-Key': _apiKey,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true && json['data'] != null) {
         return _mapRailRadarToModel(json['data'], trainNumber);
      } else {
        throw Exception(json['error']?['message'] ?? 'Unknown API Error');
      }
    } else {
       throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  TrainModel _mapRailRadarToModel(Map<String, dynamic> data, String trainNumber) {
    // Determine data parts
    final trainInfo = data['train'] ?? {}; // Available in 'full'
    final liveData = data['liveData'] ?? data; // In 'live' mode, top level IS live data
    final staticRoute = (data['route'] as List<dynamic>?); // Static schedule from 'full'
    
    // Live Route (actual status)
    final liveRouteRaw = (liveData['route'] as List<dynamic>? ?? []);
    final Map<String, dynamic> liveRouteMap = {
      for (var s in liveRouteRaw) s['stationCode']: s
    };

    // Current Location & Status
    final currentLocation = liveData['currentLocation'] ?? {};
    final currentStationCode = currentLocation['stationCode'];
    final trainName = trainInfo['trainName'] ?? liveData['trainName'] ?? 'Train $trainNumber';
    
    // Build stations list
    List<StationStopModel> stations = [];
    
    // Source of truth for keys: Static Route if available (has names), else Live Route
    final routeSource = staticRoute ?? liveRouteRaw;
    
    for (var i = 0; i < routeSource.length; i++) {
      final stop = routeSource[i];
      final code = stop['stationCode'];
      // If we are using static route, try to find live data for this stop
      final liveStop = liveRouteMap[code] ?? (staticRoute == null ? stop : null);
      
      // Name: Static has 'stationName', Live usually doesn't (or has it in some versions)
      String name = stop['stationName'] ?? code;
      
      // Times
      String arrival = '';
      if (liveStop != null && liveStop['actualArrival'] != null) {
         // Unix Timestamp
         final dt = DateTime.fromMillisecondsSinceEpoch(liveStop['actualArrival'] * 1000);
         arrival = DateFormat('HH:mm').format(dt);
      } else if (stop['scheduledArrival'] != null) {
         // Minutes from midnight
         final mins = stop['scheduledArrival'] as int;
         final dt = DateTime(2024,1,1).add(Duration(minutes: mins));
         arrival = DateFormat('HH:mm').format(dt);
      }
      
      // Platform
      String platform = liveStop?['platform']?.toString() ?? stop['platform']?.toString() ?? '-';

      // isPassed logic: Simple - if current location sequence > this stop sequence
      // Warning: 'sequence' might differ between static and live. Safe to rely on live index if possible?
      // Let's use simple logic: If live data says "DEPARTED" or we are past index.
      bool isPassed = false;
      if (currentStationCode != null) {
         // Find index of current station in THIS list
         int currentIndex = -1;
         for(int j=0; j<routeSource.length; j++) {
            if(routeSource[j]['stationCode'] == currentStationCode) {
               currentIndex = j; break;
            }
         }
         if (currentIndex != -1 && i <= currentIndex) {
            isPassed = true;
            // Precise adjustment: if i == currentIndex, check status
            if (i == currentIndex && currentLocation['status'] != 'DEPARTED') {
               isPassed = false; // Currently AT this station
            }
         }
      }

      stations.add(StationStopModel(
        name: name,
        stationCode: code,
        arrivalTime: arrival,
        platform: platform,
        isPassed: isPassed,
      ));
    }

    // Current/Next Labels
    String currentStn = 'Unknown';
    String nextStn = 'Unknown';
    if (currentLocation['stationCode'] != null) {
       // Try to map code to name
       final match = stations.where((s) => s.name.contains(currentLocation['stationCode']) || 
                           (staticRoute != null && staticRoute.any((r) => r['stationCode'] == currentLocation['stationCode'] && r['stationName'] == s.name))
                     ).firstOrNull;
       // Simpler: Just find the station object we created that matches the logic
       // Actually, we can just use the name we derived earlier properly? 
       // Let's iterate stations to find "at" or "next"
       // Ideally we use the "isPassed" boundary.
       
       for(int i=0; i<stations.length; i++) {
          if (!stations[i].isPassed) {
             // First non-passed station is roughly where we are or next
             if (i > 0) {
               currentStn = stations[i-1].name;
               nextStn = stations[i].name;
             } else {
               currentStn = stations[0].name;
               nextStn = stations.length > 1 ? stations[1].name : '';
             }
             break;
          }
       }
    }
    
    // Fallback if loop didn't set them (e.g. all passed)
    if (stations.isNotEmpty && stations.last.isPassed) {
       currentStn = stations.last.name;
       nextStn = 'Terminated';
    }

    return TrainModel(
      id: trainNumber,
      number: trainNumber,
      name: trainName,
      status: (liveData['overallDelayMinutes'] ?? 0) > 0 ? 'delayed' : 'on time',
      delayMinutes: (liveData['overallDelayMinutes'] ?? 0),
      travelTimeMinutes: trainInfo['travelTimeMinutes'] ?? 0,
      currentStation: currentStn,
      nextStation: nextStn,
      platform: '-',
      sourceStationCode: trainInfo['sourceStationCode'] ?? liveData['sourceStationCode'] ?? '',
      destinationStationCode: trainInfo['destinationStationCode'] ?? liveData['destinationStationCode'] ?? '',
      stations: stations,
      updatedAt: DateTime.now(),
    );
  }

  // Get live station board (departures/arrivals)
  Future<List<TrainModel>> getLiveStationBoard(String stationCode) async {
    final uri = Uri.parse('$_apiBase/stations/$stationCode/live?hours=4');
    
    final response = await http.get(uri, headers: {
      'X-API-Key': _apiKey,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true && json['data'] != null) {
        final List<dynamic> trainsData = json['data']['trains'] ?? [];
        return trainsData.map((t) {
          final trainInfo = t['train'] ?? {};
          final live = t['live'] ?? {};
          final status = t['status'] ?? {};
          
          bool isDelayed = live['departureDelayDisplay'] != 'On Time' && 
                          live['arrivalDelayDisplay'] != 'On Time';

          return TrainModel(
            id: trainInfo['number'] ?? '',
            number: trainInfo['number'] ?? '',
            name: trainInfo['name'] ?? '',
            status: status['isCancelled'] == true ? 'cancelled' : (isDelayed ? 'delayed' : 'on time'),
            delayMinutes: 0,
            currentStation: stationCode,
            nextStation: trainInfo['destinationStationCode'] ?? '',
            platform: t['platform'] ?? '-',
            sourceStationCode: trainInfo['sourceStationCode'] ?? '',
            destinationStationCode: trainInfo['destinationStationCode'] ?? '',
            stations: [],
            updatedAt: DateTime.now(),
          );
        }).toList();
      }
    }
    return [];
  }

  // Find trains between two stations
  Future<List<TrainModel>> getTrainsBetweenStations(String from, String to) async {
    final uri = Uri.parse('$_apiBase/trains/between?from=$from&to=$to');
    
    final response = await http.get(uri, headers: {
      'X-API-Key': _apiKey,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['success'] == true && json['data'] != null) {
        final List<dynamic> trainsData = json['data']['trains'] ?? [];
        return trainsData.map((t) {
          return TrainModel(
            id: t['trainNumber'] ?? '',
            number: t['trainNumber'] ?? '',
            name: t['trainName'] ?? '',
            status: 'on time',
            delayMinutes: 0,
            travelTimeMinutes: t['travelTimeMinutes'] ?? 0,
            currentStation: t['sourceStationCode'] ?? '',
            nextStation: t['destinationStationCode'] ?? '',
            platform: t['fromStationSchedule']?['platform']?.toString() ?? '-',
            sourceStationCode: t['sourceStationCode'] ?? '',
            destinationStationCode: t['destinationStationCode'] ?? '',
            stations: [], 
            updatedAt: DateTime.now(),
          );
        }).toList();
      }
    }
    return [];
  }

  // Get stream of all trains (for Dashboard)
  Stream<List<TrainModel>> getLiveTrains() async* {
    // Default to Bengaluru (SBC) live board
    try {
      final trains = await getLiveStationBoard('SBC');
      yield trains;
      
      // Periodically refresh (e.g., every 60 seconds)
      while (true) {
        await Future.delayed(const Duration(seconds: 60));
        final updatedTrains = await getLiveStationBoard('SBC');
        yield updatedTrains;
      }
    } catch (e) {
      print('Error fetching live trains: $e');
      yield [];
    }
  }

  Future<void> seedInitialData() async {}
}
