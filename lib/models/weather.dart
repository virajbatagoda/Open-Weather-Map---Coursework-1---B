
class Weather {
  final String cityName;
  final double temp;
  final String condition;
  final double wind;
  final double hum;
  final double rain;
  Weather({
    required this.cityName,
    required this.temp,
    required this.condition,
    required this.wind,
    required this.hum,
    required this.rain,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    final rain1h = (json['rain'] != null && json['rain']['1h'] != null)
        ? (json['rain']['1h'] as num).toDouble()
        : 0.0;
    return Weather(
      cityName: json['name'],
      temp: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      wind: (json['wind']['speed'] as num).toDouble(),
      hum: (json['main']['humidity'] as num).toDouble(),
      rain: rain1h,
    );
  }
}
