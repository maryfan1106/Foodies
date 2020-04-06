import 'package:flutter/material.dart';
import 'package:foodiesapp/models/bias_model.dart';

class BiasesDisplay extends StatefulWidget {
  final List<Bias> biases;

  BiasesDisplay({
    this.biases,
  });

  @override
  _BiasesDisplayState createState() => _BiasesDisplayState();
}

class _BiasesDisplayState extends State<BiasesDisplay> {
  List<double> values = List<double>();

  @override
  Widget build(BuildContext context) {
    if (widget.biases == null) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: widget.biases.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        Bias bias = widget.biases[i];
        values.add(0.0);
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    bias.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Center(
                  child: Slider(
                    value: values[i],
                    divisions: 20,
                    min: -10.0,
                    max: 10.0,
                    onChanged: (newBias) => {
                      setState(() {
                        values[i] = newBias;
                      })
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
