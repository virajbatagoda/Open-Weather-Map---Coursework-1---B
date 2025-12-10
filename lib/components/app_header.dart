
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      color: const Color.fromARGB(255, 7, 35, 59),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 219, 219, 219),
                size: 22,
              ),
            ),
          if (showBack) const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 219, 219, 219),
            ),
          ),
        ],
      ),
    );
  }
}
