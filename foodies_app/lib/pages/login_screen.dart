import 'package:flutter/material.dart';

import '../services/auth.dart' show logIn;
import '../widgets/circ_textinput.dart' show CircTextInput;
import '../widgets/logo.dart' show FoodiesLogo;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CircTextInput _emailField = CircTextInput(hintText: 'Email');
  final CircTextInput _pwField =
      CircTextInput(hintText: 'Password', hidden: true);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _error;

  void _setError(String err) => setState(() => _error = err);

  void _processLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (await logIn(_emailField.text, _pwField.text, _setError)) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/home",
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Widget _errorText() {
    return Text(
      _error,
      style: const TextStyle(color: Colors.red, fontSize: 14.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Material _loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: CircTextInput.padding,
        onPressed: () => _processLogin(context),
        child: const Text('Login', textAlign: TextAlign.center),
      ),
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(36, 54, 36, 36),
              child: Column(
                children: <Widget>[
                  const FoodiesLogo(),
                  if (_error != null) _errorText(),
                  const SizedBox(height: 45.0),
                  _emailField,
                  const SizedBox(height: 25.0),
                  _pwField,
                  const SizedBox(height: 35.0),
                  _loginButton,
                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/register', (_) => false);
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
      ),
    );
  }
}
