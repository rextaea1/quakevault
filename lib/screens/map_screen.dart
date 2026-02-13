import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../services/earthquake_service.dart';
import '../models/earthquake.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final EarthquakeService _service = EarthquakeService();
  List<Earthquake> _earthquakes = [];
  bool _isLoading = true;
  final MapController _mapController = MapController();
  
  final LatLng _center = const LatLng(20.0, 0.0);
  final double _zoom = 2.0;

  @override
  void initState() {
    super.initState();
    _loadEarthquakes();
  }

  Future<void> _loadEarthquakes() async {
    final earthquakes = await _service.getRecentEarthquakes();
    if (mounted) {
      setState(() {
        _earthquakes = earthquakes;
        _isLoading = false;
      });
    }
  }

  double _getMarkerSize(double magnitude) {
    if (magnitude < 3) return 30;
    if (magnitude < 4) return 40;
    if (magnitude < 5) return 50;
    if (magnitude < 6) return 60;
    if (magnitude < 7) return 70;
    return 80;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Earthquake Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEarthquakes,
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () {
              _mapController.move(_center, _zoom);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _zoom,
              maxZoom: 10,
              minZoom: 2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.quakevault.windows',
              ),
              
              MarkerLayer(
                markers: _earthquakes.map((eq) {
                  return Marker(
                    point: LatLng(eq.latitude, eq.longitude),
                    width: _getMarkerSize(eq.magnitude),
                    height: _getMarkerSize(eq.magnitude),
                    child: GestureDetector(
                      onTap: () => _showEarthquakeDetails(context, eq),
                      child: Container(
                        decoration: BoxDecoration(
                          color: eq.magnitudeColor.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: eq.tsunami == 1 ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: eq.magnitudeColor.withValues(alpha: 0.5),
                              blurRadius: _getMarkerSize(eq.magnitude) / 2,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            eq.magnitudeString,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors | USGS Real-time Feed',
                    onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1E35).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${_earthquakes.length} earthquakes in 24h',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Auto-refresh',
                      style: TextStyle(
                        color: Colors.blue.shade200,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadEarthquakes,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
        backgroundColor: const Color(0xFF1A1E35),
      ),
    );
  }

  void _showEarthquakeDetails(BuildContext context, Earthquake eq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1E35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: eq.magnitudeColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            eq.magnitudeString,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: eq.magnitudeColor,
                            ),
                          ),
                          const Text('M', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eq.locationString,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eq.place,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              _buildDetailRow(Icons.timer, 'Time', eq.timeAgo),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.arrow_downward, 'Depth', eq.depthString),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.location_on, 'Coordinates', 
                  '${eq.latitude.toStringAsFixed(3)}, ${eq.longitude.toStringAsFixed(3)}'),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, 'Date', 
                  DateFormat('MMM dd, yyyy HH:mm:ss').format(eq.time)),
              
              if (eq.tsunami == 1) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade700),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'TSUNAMI WARNING - Evacuate coastal areas',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _mapController.move(
                          LatLng(eq.latitude, eq.longitude),
                          7.0,
                        );
                      },
                      icon: const Icon(Icons.center_focus_strong),
                      label: const Text('Center Map'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final url = Uri.parse(eq.usgsUrl);
                        launchUrl(url);
                      },
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('USGS'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}