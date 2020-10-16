import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tictactoe/round.dart';

class Game extends StatelessWidget {
  final Map<int, Map<int, String>> grid;
  final Round round;

  Game(this.round, this.grid);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        child: FractionallySizedBox(
          widthFactor: 0.85,
          //heightFactor: 0.5,
          child: Container(
            width: 100,
            height: 300,
            child: Column(
              children: [
                Line(0, grid, round),
                Line(1, grid, round),
                Line(2, grid, round),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Line extends StatelessWidget {
  final int row;
  final Map<int, Map<int, String>> grid;
  final Round round;

  Line(this.row, this.grid, this.round);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Item(row, 0, grid, round),
          Item(row, 1, grid, round),
          Item(row, 2, grid, round),
        ],
      ),
    );
  }
}

class Item extends StatefulWidget {
  final int row;
  final int column;
  final Map<int, Map<int, String>> grid;
  final Round round;

  Item(this.row, this.column, this.grid, this.round);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  IconData getIcon() {
    switch (widget.grid[widget.row][widget.column]) {
      case PLAYER_ONE:
        return Icons.clear;
        break;
      case PLAYER_TWO:
        return Icons.check_box_outline_blank;
        break;
      default:
        return IconData(0);
    }
  }

  Color getColor() {
    if (widget.round.isPlaying()) {
      return Color(0xFFCEEBEA);
    } else {
      return (widget.round.winRows.length > 0) &&
              !(((widget.round.winRows[0] == widget.row) &&
                      (widget.round.winColumns[0] == widget.column)) ||
                  ((widget.round.winRows[1] == widget.row) &&
                      (widget.round.winColumns[1] == widget.column)) ||
                  ((widget.round.winRows[2] == widget.row) &&
                      (widget.round.winColumns[2] == widget.column)))
          ? Color(0xFFCEEBEA)
          : Color(0xFFE29292);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: NeumorphicButton(
        onPressed: () {
          if (widget.round.isPlaying() &&
              (widget.grid[widget.row][widget.column] == NONE)) {
            if (widget.round.getState() || !widget.round.getComputer()) {
              widget.grid[widget.row][widget.column] =
                  widget.round.getState() ? PLAYER_ONE : PLAYER_TWO;
              setState(() {});
              widget.round.context = context;
              widget.round.ChangeState();
            }
          }
        },
        style: NeumorphicStyle(
          border: NeumorphicBorder(color: Colors.white, width: 1.5),
          color: getColor(),
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
          //border: NeumorphicBorder()
        ),
        child: Center(
          child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1.01,
              child: NeumorphicIcon(
                getIcon(),
                size: 70,
                style: NeumorphicStyle(
                  color: Colors.blueGrey,
                ),
              )),
        ),
      ),
    ));
  }
}
