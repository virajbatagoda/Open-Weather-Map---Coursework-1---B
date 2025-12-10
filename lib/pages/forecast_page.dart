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

    // Limit to first 5 hourly forecasts
    final hourlyForecast = wp.nextSlots(5);

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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: hourlyForecast.map((f) {
                      final time = DateFormat('HH:mm').format(f.dateTime);
                      final condition = f.condition;
                      final iconCode = f.icon;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ModernForecastCard(
                          day: time, // time
                          temp: condition, 
                          condition: condition,
                          iconPath: 'https://openweathermap.org/img/wn/$iconCode.png',
                          width: 60, 
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                Column(
                  children: hourlyForecast.map((f) {
                    final dayTime = DateFormat('EEE HH:mm').format(f.dateTime);
                    final condition = f.condition;
                    final iconCode = f.icon;
                    final temp = '${f.temp.toStringAsFixed(1)}°C';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: HourlyForecastCard(
                        dayTime: dayTime,
                        condition: condition,
                        iconCode: iconCode,
                        temp: temp,
                        width: screenWidth - 32,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ActionButton(
                    title: "Search Weather",
                    width: screenWidth - 32,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
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
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day, // time
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.network(iconPath, height: 30, width: 30), // icon
          ),
          const SizedBox(height: 5),
          Text(
            temp, // weather condition
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

// ----- Vertical Hourly Forecast Card -----
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayTime, // e.g., Mon 12:00
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
