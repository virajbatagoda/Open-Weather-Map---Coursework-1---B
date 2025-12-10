import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openweathermap/pages/dashboard_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        color: const Color.fromARGB(255, 7, 35, 59),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App intro image
            Image.asset(
              'lib/images/welcomeimage.png',
              height: 200,
              width: 200,
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Open Weather Map',
              style: GoogleFonts.roboto(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 214, 214, 214),
              ),
            ),

            const SizedBox(height: 60),

            // Start button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              },
              child: Container(
                height: 50,
                width: 170,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 214, 214, 214),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(201, 23, 117, 199),
                      blurRadius: 10,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/sun.gif',
                      height: 35,
                      width: 35,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GET STARTED',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 7, 35, 59),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
