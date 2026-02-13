import 'package:dio/dio.dart';
import '../models/earthquake.dart';

class EarthquakeService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://earthquake.usgs.gov',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  List<Earthquake> _cache = [];
  DateTime _lastFetch = DateTime.now();

  Future<List<Earthquake>> getRecentEarthquakes() async {
    if (DateTime.now().difference(_lastFetch).inMinutes < 1 && _cache.isNotEmpty) {
      return _cache;
    }

    try {
      final response = await _dio.get(
        '/earthquakes/feed/v1.0/summary/2.5_day.geojson',
      );

      _lastFetch = DateTime.now();

      if (response.statusCode == 200) {
        final features = response.data['features'] as List;
        
        final earthquakes = features
            .map((f) => Earthquake.fromJson(f))
            .where((e) => e.magnitude >= 2.5)
            .toList();
        
        earthquakes.sort((a, b) => b.time.compareTo(a.time));
        _cache = earthquakes;
      }
    } catch (e) {
      // Return cache on error
    }
    
    return _cache;
  }

  Future<Earthquake?> getLatestEarthquake() async {
    final all = await getRecentEarthquakes();
    return all.isNotEmpty ? all.first : null;
  }
}