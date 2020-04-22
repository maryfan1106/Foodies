import 'package:flutter/material.dart';
import 'package:foodiesapp/pages/create_event_screen.dart';
import 'package:foodiesapp/pages/home_screen.dart';
import 'package:foodiesapp/pages/login_screen.dart';
import 'package:foodiesapp/pages/profile_screen.dart';
import 'package:foodiesapp/pages/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snap) {
        return MaterialApp(
          title: 'Foodies',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.lightBlue,
            accentColor: Colors.white,
          ),
          initialRoute:
              snap.data?.getString('token') == null ? '/login' : '/home',
          routes: {
            '/register': (context) => RegisterScreen(),
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/profile': (context) => ProfileScreen(),
            '/create': (context) => CreateEventScreen()
          },
        );
      },
    );
  }
}
