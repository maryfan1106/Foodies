import 'package:flutter/material.dart';
import 'package:foodiesone/pages/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange[100],
        accentColor: Colors.orange[100],
      ),
      home: HomeScreen(),
    );
  }
}