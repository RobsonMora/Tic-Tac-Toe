import 'package:flutter/cupertino.dart';

const NONE = '0';
const DRAW = '3';
const PLAYER_ONE = '1';
const PLAYER_TWO = '2';

class Round {
  bool _playerOne = true;
  bool _playing = true;
  bool _computer = true;
  VoidCallback onChange;
  BuildContext context;
  List<int> winRows = [];
  List<int> winColumns = [];

  void ChangeState() {
    _playerOne = !_playerOne;
    onChange();
  }

  bool getState() {
    return _playerOne;
  }

  void startGame() {
    _playing = true;
  }

  void stopGame() {
    _playing = false;
  }

  bool isPlaying() {
    return _playing;
  }

  bool getComputer() {
    return _computer;
  }

  void setComputer(bool value) {
    _computer = value;
  }
}
