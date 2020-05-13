import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class FoodiesLogo extends StatelessWidget {
  const FoodiesLogo();

  static SizedBox _logo = SizedBox(
    height: 90.0,
    child: Center(
      child: Text(
        'Foodies',
        style: GoogleFonts.lobster(
          textStyle: TextStyle(
            color: Color(0xffefece7),
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => _logo;
}

const boxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment(1.2, -0.2),
    colors: [Color(0xff3799d4), Color(0xff81D4fa)],
    tileMode: TileMode.repeated,
  ),
);
