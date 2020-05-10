import 'package:flutter/material.dart';

import '../models/categorymap.dart' show CategoryMap;
import '../services/categories.dart' show getCategories;
import '../widgets/biases_display.dart' show BiasesDisplay;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CategoryMap _categories;

  void _updateBias(int k, int v) => setState(() => _categories[k] = v);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot<CategoryMap> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          body = BiasesDisplay(
            categories: _categories ??= snapshot.data,
            updateBias: _updateBias,
          );
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
