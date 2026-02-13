import 'package:flutter/material.dart';

class Earthquake {
  final String id;
  final double magnitude;
  final double depth;
  final double latitude;
  final double longitude;
  final DateTime time;
  final String place;
  final int? tsunami;

  Earthquake({
    required this.id,
    required this.magnitude,
    required this.depth,
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.place,
    this.tsunami,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final geometry = json['geometry'];
    final coordinates = geometry['coordinates'];

    return Earthquake(
      id: properties['code'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      magnitude: (properties['mag'] ?? 0.0).toDouble(),
      depth: coordinates[2].toDouble(),
      latitude: coordinates[1].toDouble(),
      longitude: coordinates[0].toDouble(),
      time: DateTime.fromMillisecondsSinceEpoch(properties['time']),
      place: properties['place'] ?? 'Unknown location',
      tsunami: properties['tsunami'],
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  String get magnitudeString => magnitude.toStringAsFixed(1);
  
  Color get magnitudeColor {
    if (magnitude < 3.0) return Colors.green;
    if (magnitude < 4.0) return Colors.yellow;
    if (magnitude < 5.0) return Colors.orange;
    if (magnitude < 6.0) return Colors.red;
    if (magnitude < 7.0) return Colors.red.shade900;
    return Colors.purple;
  }

  String get depthString => '${depth.toStringAsFixed(1)} km';
  
  String get locationString {
    final parts = place.split(' of ');
    if (parts.length > 1) {
      return parts[1].trim();
    }
    return place;
  }

  String get usgsUrl => 'https://earthquake.usgs.gov/earthquakes/eventpage/$id';

  Map<String, dynamic> get mapPopupInfo => {
    'title': 'M$magnitudeString - $locationString',
    'description': '$timeAgo at $depthString depth',
    'tsunami': tsunami == 1,
  };
}