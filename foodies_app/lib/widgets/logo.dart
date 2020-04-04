import 'package:flutter/material.dart';

class FoodiesLogo extends StatelessWidget {
  const FoodiesLogo();

  static const SizedBox _logo = SizedBox(
    height: 90.0,
    child: Center(
      child: Text(
        'Foodies',
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => _logo;
}
