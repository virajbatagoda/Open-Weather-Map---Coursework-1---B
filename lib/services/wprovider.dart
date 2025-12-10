import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:openweathermap/models/weather.dart';
import 'package:openweathermap/models/forecast.dart';
import 'package:openweathermap/services/weather_service.dart';

class Wprovider extends ChangeNotifier {
  final Weatherservice _weatherService =
      Weatherservice(apiKey: 'd18244b84c695fd54badffe6db0907f3');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Weather? _weather; // Current location weather
  Forecast? _forecast; // Current location forecast
  Weather? get weather => _weather;
  Forecast? get forecast => _forecast;

  Weather? _searchWeather; // Search weather
  Forecast? _searchForecast; // Search forecast
  Weather? get searchWeather => _searchWeather;
  Forecast? get searchForecast => _searchForecast;

  Future<void> fetchWeatherAndForecast() async {
    _isLoading = true;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _weather = await _weatherService.getWeatherByLatLon(pos.latitude, pos.longitude);
      _forecast = await _weatherService.getForecastByLatLon(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('fetchWeatherAndForecast error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search weather and forecast by city name
  Future<void> searchByQuery(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loc = await _weatherService.geocodeCity(query);
      _searchWeather = await _weatherService.getWeatherByLatLon(loc.lat, loc.lon);
      _searchForecast = await _weatherService.getForecastByLatLon(loc.lat, loc.lon);
    } catch (e) {
      debugPrint('searchByQuery error: $e');
      _searchWeather = null;
      _searchForecast = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ForecastEntry> nextSlots(int count, {Forecast? source}) {
    final f = source ?? _forecast;
    if (f == null || f.entries.isEmpty) return [];
    return f.entries.take(count).toList();
  }

  Map<DateTime, List<ForecastEntry>> groupByDay({Forecast? source}) {
    final f = source ?? _forecast;
    final map = <DateTime, List<ForecastEntry>>{};
    if (f == null || f.entries.isEmpty) return map;

    for (final e in f.entries) {
      final dayKey = DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
      map.putIfAbsent(dayKey, () => []).add(e);
    }
    return map;
  }

  ForecastEntry? daySummary(DateTime day, {Forecast? source}) {
    final items = groupByDay(source: source)[day] ?? [];
    if (items.isEmpty) return null;

    return items.firstWhere(
      (e) => e.dateTime.hour == 12,
      orElse: () => items[items.length ~/ 2],
    );
  }

  List<DateTime> firstFiveDays({Forecast? source}) {
    final grouped = groupByDay(source: source);
    final days = grouped.keys.toList()..sort();
    return days.take(5).toList();
  }
}
