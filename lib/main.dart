import 'dart:math';

import 'package:BullsEye/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BullsEye/prompt.dart';
import 'package:BullsEye/control.dart';
import 'package:BullsEye/score.dart';
import 'package:BullsEye/gameModel.dart';

void main() => runApp(BullsEyeApp());

class BullsEyeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MaterialApp(
      title: 'BullsEye',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(title: 'BullsEye'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _alertIsVisible = false;
  GameModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameModel(Random().nextInt(100) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Prompt(targetValue: _model.target),
          Control(
            model: _model,
          ),
          TextButton(
              onPressed: () {
                this._alertIsVisible = true;
                _showAlert(context);
                print("Button Pressed");
              },
              child: Text('Hit Me!', style: TextStyle(color: Colors.blue))),
          Score(totalScore: _model.totalScore, round: _model.round),
        ],
      ),
    ));
  }

  int _pointsForCurrentRound() {
    int maximumScore = 100;
    int difference;
    int sliderValue = _model.current;
    if (sliderValue > _model.target) {
      difference = sliderValue - _model.target;
    } else if (_model.target > sliderValue) {
      difference = _model.target - sliderValue;
    } else {
      difference = 0;
    }
    return maximumScore - difference;
  }

  void _showAlert(BuildContext context) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          this._alertIsVisible = false;
          print("Awesome pressed! $_alertIsVisible");
        },
        child: Text("Awesome"));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Hello there!"),
              content: Text("The slider's value is ${_model.current}.\n" +
                  "Your scored ${_pointsForCurrentRound()} points this round."),
              actions: <Widget>[
                okButton,
              ],
              elevation: 5);
        });
  }
}
