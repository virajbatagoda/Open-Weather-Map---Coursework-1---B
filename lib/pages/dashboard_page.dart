import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:openweathermap/services/wprovider.dart';
import 'package:openweathermap/pages/forecast_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Wprovider>(context, listen: false).fetchWeatherAndForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<Wprovider>(context);
    final weather = weatherProvider.weather;
    final isLoading = weatherProvider.isLoading;

    String today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 35, 59),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TITLE
              Text(
                'OPEN WEATHER MAP - DASHBOARD',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 214, 214, 214),
                ),
              ),

              const SizedBox(height: 20),

              // MAIN WEATHER
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(today,
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: const Color.fromARGB(177, 214, 214, 214),
                                )),
                            const SizedBox(height: 3),
                            Text(
                                weather?.cityName ?? '',
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 214, 214, 214),
                                )),
                          ],
                        ),
                        const Spacer(),
                        const Image(
                          image: AssetImage('lib/images/compass.gif'),
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Image(
                          image: AssetImage('lib/images/four.png'),
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(width: 25),
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Color.fromARGB(255, 214, 214, 214),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weather?.temp != null
                                        ? '${weather!.temp.toStringAsFixed(1)} °C'
                                        : '',
                                    style: GoogleFonts.roboto(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 214, 214, 214),
                                    ),
                                  ),
                                  Text(
                                    weather?.condition ?? '',
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 214, 214, 214),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // WIND / HUMIDITY / RAIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  basicInfoBox(
                      'Wind',
                      weather?.wind != null
                          ? '${weather!.wind.toStringAsFixed(1)} Km/h'
                          : ''),
                  basicInfoBox(
                      'Humidity',
                      weather?.hum != null
                          ? '${weather!.hum.toStringAsFixed(0)} %'
                          : ''),
                  basicInfoBox(
                      'Rain',
                      weather?.rain != null
                          ? '${weather!.rain.toStringAsFixed(1)} %'
                          : ''),
                ],
              ),

              const SizedBox(height: 20),

              // 3-HOUR FORECAST
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (weatherProvider.forecast?.entries ?? [])
                      .take(5)
                      .map((f) {
                    String time = DateFormat('HH:mm').format(f.dateTime);
                    String iconCode = f.icon;
                    return todayForecastBox(time, iconCode);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // NAVIGATION BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForecastPage()),
                  );
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'View Weather Forecast',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(183, 214, 214, 214),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BASIC INFO BOX
Widget basicInfoBox(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(6),
    child: Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: const Color.fromARGB(183, 214, 214, 214),
              )),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 214, 214, 214),
              )),
        ],
      ),
    ),
  );
}

// TODAY FORECAST BOX 
Widget todayForecastBox(String time, String iconCode) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Container(
      height: 70,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: const Color.fromARGB(183, 214, 214, 214),
            ),
          ),
          const SizedBox(height: 6),
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode.png',
            height: 30,
            width: 30,
          ),
        ],
      ),
    ),
  );
}
