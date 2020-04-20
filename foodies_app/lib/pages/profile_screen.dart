import 'package:flutter/material.dart';
import 'package:foodiesapp/models/bias_model.dart';
import 'package:foodiesapp/services/user_service.dart';
import 'package:foodiesapp/widgets/biases_display.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Bias> _biases;

  @override
  void initState() {
    super.initState();
    getBiases();
  }

  getBiases() async {
    List<Bias> biases = await UserService().getBiases();
    setState(() {
      _biases = biases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: BiasesDisplay(biases: _biases),
    );
  }
}
