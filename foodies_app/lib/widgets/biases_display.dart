import 'package:flutter/material.dart';
import 'package:foodiesapp/models/bias_model.dart';
import 'package:foodiesapp/services/user_service.dart';

class BiasesDisplay extends StatefulWidget {
  final List<Bias> biases;

  const BiasesDisplay({
    @required this.biases,
  });

  @override
  _BiasesDisplayState createState() => _BiasesDisplayState();
}

class _BiasesDisplayState extends State<BiasesDisplay> {
  List<int> values = List<int>();

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
        values.add(bias.bias ?? 0);
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
                    value: values[i].toDouble(),
                    divisions: 20,
                    min: -10.0,
                    max: 10.0,
                    label: values[i].toString(),
                    onChanged: (newBias) async {
                      await UserService().setBias(bias.cid, newBias.toInt());
                      setState(() {
                        values[i] = newBias.toInt();
                      });
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
