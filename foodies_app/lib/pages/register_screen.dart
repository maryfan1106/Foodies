import 'package:flutter/material.dart';

import '../services/auth.dart' show signUp;
import '../widgets/circ_textinput.dart' show CircTextInput;
import '../widgets/logo.dart' show FoodiesLogo;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final CircTextInput _nameField = CircTextInput(hintText: 'Name');
  static final CircTextInput _emailField = CircTextInput(hintText: 'Email');
  static final CircTextInput _pwField =
      CircTextInput(hintText: 'Password', hidden: true);

  void _processSignup(BuildContext context) async {
    final bool success = await signUp(
      _nameField.text,
      _emailField.text,
      _pwField.text,
    );

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Material _registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: CircTextInput.padding,
        onPressed: () => _processSignup(context),
        child: const Text('Register', textAlign: TextAlign.center),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 54, 36, 36),
            child: Column(
              children: <Widget>[
                const FoodiesLogo(),
                const SizedBox(height: 45.0),
                _nameField,
                const SizedBox(height: 25.0),
                _emailField,
                const SizedBox(height: 25.0),
                _pwField,
                const SizedBox(height: 35.0),
                _registerButton,
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  },
                  child: const Text(
                    'Already have an account? Log In',
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
