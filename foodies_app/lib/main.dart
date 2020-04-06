import 'package:flutter/material.dart';
import 'package:foodiesapp/pages/home_screen.dart';
import 'package:foodiesapp/pages/login_screen.dart';
import 'package:foodiesapp/pages/profile_screen.dart';
import 'package:foodiesapp/pages/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.white,
      ),
      initialRoute: '/home',
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen()
      },
    );
  }
}