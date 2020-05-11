import 'package:flutter/material.dart';

//import '../models/bias_model.dart';
import '../models/category.dart' show Category;
import '../services/categories.dart' show getCategories;
import '../widgets/biases_display.dart' show BiasesDisplay;
import '../widgets/biases_display.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Category> _userBiases;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          _userBiases = snapshot.data;
          body = BiasesDisplay(categories: _userBiases);
        } else {
          body = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
