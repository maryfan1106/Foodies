import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show DotEnv;

import 'pages/login_screen.dart' show LoginScreen;

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.deepPurpleAccent,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
      },
    );
  }
}
