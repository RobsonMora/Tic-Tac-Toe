import 'dart:async';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tictactoe/game.dart';
import 'package:tictactoe/requestMove.dart';
import 'package:tictactoe/round.dart';
import 'package:loading_indicator/loading_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<int, Map<int, String>> grid = <int, Map<int, String>>{
    0: <int, String>{0: NONE, 1: NONE, 2: NONE},
    1: <int, String>{0: NONE, 1: NONE, 2: NONE},
    2: <int, String>{0: NONE, 1: NONE, 2: NONE},
  };
  String winner = NONE;
  final Round round = Round();
  //static bool computer = false;
  bool computerThinking = false;

  @override
  void initState() {
    // TODO: implement initState
    round.onChange = checkStatus;
    super.initState();
  }

  void reset() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        grid[i][j] = NONE;
      }
    }
    winner = NONE;
    cleanWins();
    round.startGame();
    setState(() {});
  }

  void computerMakeMove() async {
    RequestMove req = RequestMove();
    await req.getMove(grid).then((value) {
      int pos = req.getRecommendation(value);
      int index = 0;
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          if (index == pos) {
            grid[i][j] = PLAYER_TWO;
            pos = -1;
            break;
          }
          index++;
        }
        if (pos == -1) {
          break;
        }
      }
      round.ChangeState();
      computerThinking = false;
      setState(() {});
    });
  }

  void cleanWins() {
    round.winRows.clear();
    round.winColumns.clear();
  }

  void checkStatus() async {
    if (!checkWin()) {
      //TODO Change player indicator
      if (winner == DRAW) {
        cleanWins();
      }
      if (round.getComputer() && !round.getState()) {
        computerThinking = true;
        setState(() {});
        computerMakeMove();
      } else {
        setState(() {});
      }
    } else {
      round.stopGame();
      if (winner == DRAW) {
        cleanWins();
      }
      setState(() {});
      callWinner();
    }
  }

  bool checkWin() {
    winner = NONE;
    if (checkDiagonalWin() || checkHorizontalWin() || checkVerticalWin()) {
      return true;
    } else if (checkDraw()) {
      winner = DRAW;
      return true;
    }
    return false;
  }

  void callWinner() async {
    Timer(Duration(milliseconds: 1500), () {
      EasyDialog(
          closeButton: false,
          topImage: AssetImage(
              'assets/' + (winner == DRAW ? 'atie' : 'winner') + '.gif'),
          height: 350,
          width: 300,
          contentList: [
            Center(
                child: Text(
              winner == DRAW ? 'Draw!' : 'Player $winner!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: FlatButton(
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  Navigator.of(round.context).pop();
                  checkStatus();
                },
                child: Text('Ok'),
              ),
            )
          ]).show(round.context);
      reset();
    });
  }

  bool checkHorizontalWin() {
    for (var i = 0; i < 3; i++) {
      if ((grid[i][0] == grid[i][1]) && (grid[i][1] == grid[i][2])) {
        round.winRows = [i, i, i];
        round.winColumns = [0, 1, 2];
        winner = grid[i][0];
        if (winner != NONE) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkVerticalWin() {
    for (var i = 0; i < 3; i++) {
      if ((grid[0][i] == grid[1][i]) && (grid[1][i] == grid[2][i])) {
        round.winColumns = [i, i, i];
        round.winRows = [0, 1, 2];
        winner = grid[0][i];
        if (winner != NONE) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkDiagonalWin() {
    if (((grid[0][0] == grid[1][1]) && (grid[2][2] == grid[1][1])) ||
        ((grid[2][0] == grid[1][1]) && (grid[0][2] == grid[1][1]))) {
      winner = grid[1][1];
      round.winColumns = winner == grid[0][0] ? [0, 1, 2] : [2, 1, 0];
      round.winRows = [0, 1, 2];
      if (winner != NONE) {
        return true;
      }
    }
    return false;
  }

  bool checkDraw() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (grid[i][j] == NONE) {
          return false;
        }
      }
    }
    return true;
  }

  Color getColor(bool value) {
    return value ? Color(0xFFE29292) : Color(0xFFD5EEED);
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFF9DCFCE),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      home: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: NeumorphicBackground(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(color: getColor(round.getState())),
                    child: SizedBox(
                      width: 100,
                      height: 45,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeumorphicText(
                            "Player 1",
                            style: NeumorphicStyle(
                              depth: 4, //customize depth here
                              color: Colors.blueGrey, //customize color here
                            ),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 15, //custom
                                fontWeight: FontWeight.bold
                                // AND others usual text style properties (fontFamily, fontWeight, ...)
                                ),
                          ),
                          NeumorphicIcon(
                            Icons.clear,
                            size: 25,
                            style: NeumorphicStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(color: getColor(!round.getState())),
                    child: SizedBox(
                      width: 100,
                      height: 45,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeumorphicIcon(
                            Icons.crop_square,
                            size: 25,
                            style: NeumorphicStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                          NeumorphicText(
                            "Player 2",
                            style: NeumorphicStyle(
                              depth: 4, //customize depth here
                              color: Colors.blueGrey, //customize color here
                            ),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 15, //custom
                                fontWeight: FontWeight.bold
                                // AND others usual text style properties (fontFamily, fontWeight, ...)
                                ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Game(round, grid),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 25,
              ),
              NeumorphicSwitch(
                height: 60,
                isEnabled: true,
                style:
                    NeumorphicSwitchStyle(activeTrackColor: Color(0xFFE29292)),
                value: round.getComputer(),
                onChanged: (value) {
                  round.setComputer(value);
                  if (value && !round.getState() && !computerThinking) {
                    computerThinking = true;
                    setState(() {});
                    computerMakeMove();
                  }
                  setState(() {});
                },
              ),
              if (computerThinking)
                Center(
                  child: Container(
                    height: 120,
                    width: 70,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballGridPulse,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
