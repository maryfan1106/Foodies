import 'package:flutter/material.dart';

class CircTextInput extends StatefulWidget {
  static const EdgeInsets padding = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  static final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32.0),
  );

  final String hintText;
  final bool hidden;
  _CircTextInputState _state;

  get text => _state._textfield.controller.text;

  CircTextInput({Key key, this.hintText = '', this.hidden = false})
      : super(key: key);

  _CircTextInputState createState() =>
      _state = _CircTextInputState(hintText: hintText, hidden: hidden);
}

class _CircTextInputState extends State<CircTextInput> {
  final TextFormField _textfield;

  _CircTextInputState({hintText, hidden})
      : _textfield = TextFormField(
          controller: TextEditingController(),
          obscureText: hidden,
          decoration: InputDecoration(
            contentPadding: CircTextInput.padding,
            hintText: hintText,
            border: CircTextInput._border,
          ),
        );

  @override
  void dispose() {
    _textfield.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _textfield;
}
