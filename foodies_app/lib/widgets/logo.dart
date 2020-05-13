import 'package:flutter/material.dart';


class FoodiesLogo extends StatelessWidget {
  const FoodiesLogo();

  static const SizedBox _logo = SizedBox(
    height: 90.0,
    child: Center(
      child: Text(
        'Foodies',
        textDirection: TextDirection.ltr,
          style: TextStyle(
          fontFamily: "lobster",
          color: const Color(0xffEFECE7),
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
  );

  @override
  Widget build(BuildContext context) => _logo;
}
