class ForecastEntry {
  final DateTime dateTime;
  final double temp;
  final String condition;
  final String icon; // Added icon

  ForecastEntry({
    required this.dateTime,
    required this.temp,
    required this.condition,
    required this.icon,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) {
    return ForecastEntry(
      dateTime: DateTime.parse(json['dt_txt']),
      temp: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class Forecast {
  final List<ForecastEntry> entries;

  Forecast({required this.entries});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;
    final entries = list.map((e) => ForecastEntry.fromJson(e)).toList();
    return Forecast(entries: entries);
  }
}
