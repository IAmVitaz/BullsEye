import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class Control extends StatefulWidget {
  Control({Key key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  double _currentValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text("1"),
        ),
        Expanded(
          child: Slider(
          value: _currentValue,
          onChanged: (newValue) {
            setState(() {
              _currentValue = newValue;
              print(_currentValue);
            });
          },
          min: 1.0,
          max: 100.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text("100"),
        ),
      ],
    );
  }
}
