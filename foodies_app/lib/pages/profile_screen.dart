import 'package:flutter/material.dart';

import '../models/category.dart' show Category;
import '../services/categories.dart' show getCategories;
import '../widgets/biases_display.dart' show BiasesDisplay;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          body = BiasesDisplay(categories: snapshot.data);
        } else {
          body = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_horiz),
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
