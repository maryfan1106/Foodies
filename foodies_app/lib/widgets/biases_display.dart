import 'package:flutter/material.dart';

import '../models/category.dart' show Category;
import '../services/categories.dart' show setBias;

class BiasesDisplay extends StatefulWidget {
  final List<Category> categories;

  const BiasesDisplay({
    @required this.categories,
  });

  @override
  _BiasesDisplayState createState() => _BiasesDisplayState();
}

class _BiasesDisplayState extends State<BiasesDisplay> {
  List<int> values = List<int>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        Category category = widget.categories[i];
        values.add(category.bias ?? 0);
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
                  child: Slider(
                    value: values[i].toDouble(),
                    divisions: 20,
                    min: -10.0,
                    max: 10.0,
                    label: values[i].toString(),
                    onChanged: (newBias) {
                      setState(() {
                        values[i] = newBias.toInt();
                      });
                    },
                    onChangeEnd: (newBias) async {
                      await setBias(category.cid, newBias.toInt());
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
