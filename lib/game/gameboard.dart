import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GameBoardState();
  }
}

class GameBoardState extends State<GameBoard> {
  List<HoleData> holes;
  List<List<HoleData>> myHoles;
  double scaleFactor = 60.0;
  double initOffsetX = 10;
  double initOffsetY = 150;
  double holeDiameter = 30;

  @override
  void initState() {
    super.initState();
    //create our super nice holes
    holes = new List();
    myHoles = List.generate(
        7,
        (y) => List.generate(7, (x) {
              if ((x < 2 || x > 4) && (y < 2 || y > 4)) return null;
              return HoleData(x, y, true);
            }));

    for (int x = 0; x < 7; x++) {
      for (int y = 0; y < 7; y++) {
        if ((x < 2 || x > 4) && (y < 2 || y > 4)) continue;
        var hole = new HoleData(x, y, true);
        if (x == 3 && y == 3) hole.hasPeg = false;
        holes.add(hole);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Creating a new stack");
    return Container(
//      decoration: BoxDecoration(
//          color: Colors.grey.withOpacity(0.5),
//          border: Border.all(color: Colors.orange)),
      child: Stack(
        children: myHoles.expand((list) => list.map(createHole)).toList(),
      ),
    );
  }

  Widget createHole(HoleData d) {
    if (d == null) return Container();
    return Positioned(
        left: initOffsetX + (scaleFactor * d.x),
        top: initOffsetY + (scaleFactor * d.y),
        child: new DragTarget(
          builder: (context, List<dynamic> candidateData, rejectedData) {
            if (d.hasPeg) {
              return PegWidget(holeDiameter, Colors.red, d.x, d.y);
            }
            return Container(
              width: holeDiameter,
              height: holeDiameter,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            );
          },
          onWillAccept: (data) {
            print("HEYEYYE");
            print(data);
            return true;
          },
          onLeave: (data) {
            print("WE LEFT THE SCREEN");
          },
          onAccept: (data) {
            print("WE ACCEPTED>>>>");
            setState(() {
              d.hasPeg = true;
            });
          },
        ));
  }
}

class GameBoardData {
  List<HoleData> holes;
}

class HoleData {
  int x, y;
  bool hasPeg;

  HoleData(this.x, this.y, this.hasPeg);
}

class PegData {
  int holeIndex;

  PegData(this.holeIndex);
}

class PegWidget extends StatelessWidget {
  final double diameter;
  final double increase;
  final Color color;
  final Color highlightColor;
  final int x;
  final int y;

  PegWidget(this.diameter, this.color, this.x, this.y,
      [this.increase = 20, this.highlightColor = Colors.amber]) {
//    this.highlightColor = this.color.withOpacity(0.75);
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: [x, y],
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      feedback: Container(
        width: diameter + increase,
        height: diameter + increase,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlightColor,
        ),
      ),
    );
  }
}

class Peg extends StatefulWidget {
  final Offset initPos;
  final Color itemColor;

  Peg(this.initPos, this.itemColor);

  @override
  State<StatefulWidget> createState() {
    return new PegState();
  }
}

class PegState extends State<Peg> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        data: widget.itemColor,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange,
          ),
          height: 100,
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = offset;
          });
        },
        feedback: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
