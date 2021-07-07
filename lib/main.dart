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
              },
              child: Text('Hit Me!', style: TextStyle(color: Colors.blue))),
          Score(totalScore: _model.totalScore, round: _model.round),
        ],
      ),
    ));
  }

  int _sliderValue() => _model.current;

  int _pointsForCurrentRound() {
    var maximumScore = 100;
    var difference = _amountOff();
    var bonusScore = 0;
    if (difference == 0)
      bonusScore = 100;
    else if (difference == 1) 
      bonusScore = 50;
    return maximumScore - difference + bonusScore;
  }

  void _showAlert(BuildContext context) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          this._alertIsVisible = false;
          setState(() {
            _model.totalScore += _pointsForCurrentRound();
            _model.target = Random().nextInt(100) + 1;
            _model.round += 1;
          });
        },
        child: Text("Awesome"));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(_alertATitle()),
              content: Text("The slider's value is ${_sliderValue()}.\n" +
                  "Your scored ${_pointsForCurrentRound()} points this round."),
              actions: <Widget>[
                okButton,
              ],
              elevation: 5);
        });
  }

  int _amountOff() => (_model.target - _sliderValue()).abs();

  String _alertATitle() {
    var difference = _amountOff();

    String title;
    if (difference == 0) {
      title = "Perfect!";
    } else if (difference < 5) {
      title = "You almost had it!";
    } else if (difference <= 10) {
      title = "Not bad.";
    } else {
      title = "Are you even trying?";
    }

    return title;
  }
}
