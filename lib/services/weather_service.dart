
// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openweathermap/models/weather.dart';
import 'package:openweathermap/models/forecast.dart';

class Weatherservice {
  static const _baseCurrent = 'https://api.openweathermap.org/data/2.5/weather';
  static const _baseForecast = 'https://api.openweathermap.org/data/2.5/forecast';
  static const _baseGeocode = 'http://api.openweathermap.org/geo/1.0/direct';

  final String apiKey;
  Weatherservice({required this.apiKey});

  Future<Weather> getWeatherByLatLon(double lat, double lon) async {
    final url = '$_baseCurrent?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<Forecast> getForecastByLatLon(double lat, double lon) async {
    final url = '$_baseForecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Forecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<({double lat, double lon, String displayName})> geocodeCity(String query) async {
    final url = '$_baseGeocode?q=${Uri.encodeQueryComponent(query)}&limit=1&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final arr = jsonDecode(response.body) as List;
      if (arr.isNotEmpty) {
        final m = arr.first as Map<String, dynamic>;
        return (
          lat: (m['lat'] as num).toDouble(),
          lon: (m['lon'] as num).toDouble(),
          displayName: (m['name'] as String? ?? query),
        );
      }
      throw Exception('Location not found');
    } else {
      throw Exception('Geocoding failed');
    }
  }
}
