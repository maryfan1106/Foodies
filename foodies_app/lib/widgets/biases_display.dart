import 'package:flutter/material.dart';

import '../models/category.dart' show Category;
import '../models/categorymap.dart' show CategoryMap;
import '../services/categories.dart' show setBias;

class BiasesDisplay extends StatelessWidget {
  final CategoryMap categories;
  final Function(int, int) updateBias;

  const BiasesDisplay({
    @required this.categories,
    @required this.updateBias,
  });

  Icon _getBiasIcon(int bias) {
    if (bias == 0) {
      return const Icon(Icons.favorite_border, color: Colors.grey);
    }

    if (bias > 0) {
      return Icon(Icons.favorite, color: Colors.pink[bias ~/ 2 * 100 + 100]);
    }

    return Icon(Icons.favorite, color: Colors.grey[-bias ~/ 2 * 100 + 300]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        Category category = categories[i];
        int bias = category.bias ?? 0;
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            title: Chip(
              avatar: _getBiasIcon(bias),
              label: Text(category.description),
            ),
            subtitle: Slider(
              value: bias.toDouble(),
              divisions: 20,
              min: -10.0,
              max: 10.0,
              onChanged: (val) => updateBias(category.cid, val.toInt()),
              onChangeEnd: (newBias) async {
                await setBias(category.cid, newBias.toInt());
              },
            ),
          ),
        );
      },
    );
  }
}
