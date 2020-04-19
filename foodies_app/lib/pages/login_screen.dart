import 'package:flutter/material.dart';
import 'package:foodiesapp/pages/home_screen.dart';
import 'package:foodiesapp/services/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  String _error = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _emailController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await _auth.logIn(
            _emailController.text,
            _passwordController.text,
          );
          if (result == null) {
            setState(() {
              _error = 'Wrong email or password';
            });
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: const Text(
          "Login",
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
                Text(
                  _error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                const SizedBox(height: 45.0),
                emailField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(height: 35.0),
                loginButton,
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
