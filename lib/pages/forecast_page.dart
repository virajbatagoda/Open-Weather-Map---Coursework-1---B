import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:openweathermap/components/app_header.dart';
import 'package:openweathermap/pages/search_page.dart';
import 'package:openweathermap/services/wprovider.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final wp = Provider.of<Wprovider>(context);

    // ----- Horizontal Hourly Forecast (next 12 hours) -----
    final hourlyForecast = wp.nextSlots(12);

    // ----- Vertical 5-Day Forecast -----
    final dailyForecast = wp.groupByDay()
        .entries
        .take(5) // first 5 days
        .map((e) => e.value.first) // pick first forecast of the day as summary
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 7, 35, 59),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(title: "Weather Forecast", showBack: true),
                const SizedBox(height: 20),

                // ----- Horizontal Hourly Forecast -----
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: hourlyForecast.map((f) {
                      final time = DateFormat('HH:mm').format(f.dateTime);
                      final iconCode = f.icon;
                      final temp = '${f.temp.toStringAsFixed(1)}°C';
                      final condition = f.condition;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ModernForecastCard(
                          day: time,
                          temp: temp,
                          condition: condition,
                          iconPath:
                              'https://openweathermap.org/img/wn/$iconCode.png',
                          width: 70,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // ----- Vertical 5-Day Forecast -----
                Column(
                  children: dailyForecast.map((f) {
                    final day = DateFormat('EEE, MMM d').format(f.dateTime);
                    final iconCode = f.icon;
                    final temp = '${f.temp.toStringAsFixed(1)}°C';
                    final condition = f.condition;

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: HourlyForecastCard(
                        dayTime: day,
                        condition: condition,
                        iconCode: iconCode,
                        temp: temp,
                        width: screenWidth - 32,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // ----- Search Button -----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ActionButton(
                    title: "Search Weather",
                    width: screenWidth - 32,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----- Horizontal Modern Forecast Card -----
class ModernForecastCard extends StatelessWidget {
  final String day, temp, condition, iconPath;
  final double width;

  const ModernForecastCard({
    super.key,
    required this.day,
    required this.temp,
    required this.condition,
    required this.iconPath,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(iconPath, height: 40, width: 40),
          ),
          const SizedBox(height: 6),
          Text(
            temp,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ----- Vertical Daily Forecast Card -----
class HourlyForecastCard extends StatelessWidget {
  final String dayTime, condition, iconCode, temp;
  final double width;

  const HourlyForecastCard({
    super.key,
    required this.dayTime,
    required this.condition,
    required this.iconCode,
    required this.temp,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode.png',
            height: 50,
            width: 50,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayTime,
                style: GoogleFonts.roboto(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                condition,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(
            temp,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ----- Modern Action Button -----
class ActionButton extends StatelessWidget {
  final String title;
  final double width;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.title,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.15),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
