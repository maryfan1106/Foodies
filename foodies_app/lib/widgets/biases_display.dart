import 'package:flutter/material.dart';

import '../models/category.dart' show Category;

class BiasesDisplay extends StatelessWidget {
  final List<Category> categories;

  const BiasesDisplay({
    @required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        Category category = categories[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    category.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Center(
                  child: Slider.adaptive(
                    value: category.bias?.toDouble() ?? 0,
                    divisions: 20,
                    min: -10.0,
                    max: 10.0,
                    onChanged: (newBias) => {
                      // TODO: update state
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}
