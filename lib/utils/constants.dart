import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'QuakeVault';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Seconds Before Seconds Count';
  
  // Colors
  static const Color primaryDark = Color(0xFF0A0E21);
  static const Color secondaryDark = Color(0xFF1A1E35);
  static const Color accentBlue = Color(0xFF4A80F0);
  static const Color accentRed = Color(0xFFFF4C4C);
  static const Color accentOrange = Color(0xFFFFA500);
  static const Color accentGreen = Color(0xFF4CAF50);
  
  // Earthquake thresholds
  static const double minMagnitudeAlert = 3.0;
  static const double tsunamiMagnitudeThreshold = 7.0;
  static const double criticalShakingMMI = 5.0;
  
  // Timing
  static const int dataRefreshInterval = 60; // seconds
  static const int alertCooldown = 300; // seconds
  
  // URLs
  static const String usgsApiBase = 'https://earthquake.usgs.gov';
  static const String usgsFeed = '$usgsApiBase/earthquakes/feed/v1.0/summary';
  static const String bmkgApi = 'https://data.bmkg.go.id';
  static const String ingvApi = 'https://webservices.ingv.it';
  
  // Map
  static const double defaultMapLat = 20.0;
  static const double defaultMapLon = 0.0;
  static const double defaultMapZoom = 2.0;
}