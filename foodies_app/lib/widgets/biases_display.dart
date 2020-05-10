import 'package:flutter/material.dart';

import '../models/category.dart' show Category;
import '../models/categorymap.dart' show CategoryMap;

class BiasesDisplay extends StatelessWidget {
  final CategoryMap categories;
  final Function(int, int) updateBias;

  const BiasesDisplay({
    @required this.categories,
    @required this.updateBias,
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
                    onChanged: (val) => updateBias(category.cid, val.toInt()),
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
