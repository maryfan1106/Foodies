import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodiesapp/pages/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    signUp(String name, email, password) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final Map<String, String> data = {
        'name': name,
        'email': email,
        'password': password
      };
      final response = await http.post(
          "https://the-last-resort.herokuapp.com/users/login",
          body: jsonEncode(data),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          });
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          sharedPreferences.setString("token", jsonResponse['token']);
          print(response.body);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        print(response.body);
      }
    }

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final nameField = TextField(
      controller: nameController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print(emailController.text);
          print(passwordController.text);
          signUp(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
        },
        child: const Text(
          "Register",
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
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
                ),
                const SizedBox(height: 45.0),
                nameField,
                const SizedBox(height: 25.0),
                emailField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(height: 35.0),
                registerButton,
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
