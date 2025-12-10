import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:openweathermap/services/wprovider.dart';
import 'package:openweathermap/components/app_header.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wp = Provider.of<Wprovider>(context);

    final isLoading = wp.isLoading;
    final current = wp.searchWeather;
    final forecast = wp.searchForecast;

    // Summaries & slots from provider
    final days = wp.firstFiveDays(source: forecast);
    final dailySummaries = days.map((d) => wp.daySummary(d, source: forecast)).toList();
    final slots = wp.nextSlots(5, source: forecast);

    return Scaffold(
      backgroundColor: const Color(0xFF07233B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const AppHeader(title: "Search Weather", showBack: true),

              const SizedBox(height: 10),

              // ---- Search Box ----
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter location",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
                onSubmitted: (value) {
                  wp.searchByQuery(value);
                },
              ),

              const SizedBox(height: 20),

              // ---- LOADING ----
              if (isLoading) const CircularProgressIndicator(color: Colors.white),

              // ---- CURRENT WEATHER ----
              if (!isLoading && current != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                     const Image(
                          image: AssetImage('lib/images/four.png'),
                          height: 120,
                          width: 120,
                        ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoText("City", current.cityName),
                          infoText("Weather", current.condition),
                          infoText("Temp", "${current.temp.toStringAsFixed(1)}°C"),
                          infoText("Humidity", "${current.hum}%"),
                          infoText("Wind", "${current.wind} km/h"),
                        ],
                      )
                    ],
                  ),
                ),

              // ---- HORIZONTAL 5-CARDS ----
              if (!isLoading && forecast != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: slots.map((slot) {
                    String time = DateFormat('HH:mm').format(slot.dateTime);
                    String condition = slot.condition;
                    String iconUrl =
                        'https://openweathermap.org/img/wn/${slot.icon}@2x.png';

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(time,
                                style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Image.network(iconUrl, height: 35, width: 35),
                            const SizedBox(height: 8),
                            Text(condition,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),

              // ---- VERTICAL NEXT 5 FORECAST SLOTS ----
              if (!isLoading && forecast != null)
                Column(
                  children: slots.take(5).map((slot) {
                    String dayLabel = DateFormat('EEE, MMM d').format(slot.dateTime);
                    String iconUrl =
                        'https://openweathermap.org/img/wn/${slot.icon}@2x.png';
                    String condition = slot.condition;
                    String temp = '${slot.temp.toStringAsFixed(1)}°C';

                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.network(iconUrl, height: 40, width: 40),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dayLabel,
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 4),
                              Text(condition,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                          const Spacer(),
                          Text(temp,
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 30),

              Text(
                "OpenWeatherMap",
                style: GoogleFonts.roboto(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label: $value",
        style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
