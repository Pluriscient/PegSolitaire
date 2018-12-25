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
  double holeDiameter = 40;

  @override
  void initState() {
    super.initState();
    //create our super nice holes
    reset();
  }

  void reset() {
    myHoles = List.generate(
        7,
        (x) => List.generate(7, (y) {
              if ((x < 2 || x > 4) && (y < 2 || y > 4)) return null;
              return HoleData(x, y, true);
            }));
    myHoles[3][3].hasPeg = false;
  }

  @override
  Widget build(BuildContext context) {
    var list = myHoles.expand((list) => list.map(createHole)).toList();
    list.addAll(<Widget>[
      Positioned(
          right: 10,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                reset();
              });
            },
            child: Icon(Icons.refresh, color: Colors.white),
          ))
    ]);
    return Container(
      child: Stack(
        children: list,
      ),
    );
  }

  Widget createHole(HoleData d) {
    if (d == null) return Container();
//    print("Creating $d");
    return Positioned(
        left: initOffsetX + (scaleFactor * d.x),
        top: initOffsetY + (scaleFactor * d.y),
        child: d.hasPeg ? createPeg(d) : createRealHole(d));
  }

  Widget createRealHole(HoleData d) {
    return new DragTarget(
      builder: (context, List<dynamic> candidateData, rejectedData) {
        print(
            "We have the following data: $candidateData, and rejected $rejectedData");
        return Container(
          width: holeDiameter,
          height: holeDiameter,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        );
      },
      onWillAccept: (HoleData origin) {
        bool res = canMove(origin, d);
        print("$d will accept $origin: $res");
        return canMove(origin, d);
      },
      onLeave: (HoleData origin) {
        print("WE LEFT THE SCREEN");
      },
      onAccept: (HoleData origin) {
        move(origin, d);
      },
    );
  }

  bool canMove(HoleData origin, HoleData destination) {
    if (destination.hasPeg) return false;
    if (origin.x == destination.x) {
      if (destination.y == origin.y + 2) {
        return this.myHoles[origin.x][origin.y + 1].hasPeg;
      } else if (destination.y == origin.y - 2) {
        return this.myHoles[origin.x][origin.y - 1].hasPeg;
      }
    } else if (origin.y == destination.y) {
      if (destination.x == origin.x + 2) {
        return this.myHoles[origin.x + 1][origin.y].hasPeg;
      } else if (destination.x == origin.x - 2) {
        return this.myHoles[origin.x - 1][origin.y].hasPeg;
      }
    }
    return false;
  }

  void move(HoleData origin, HoleData destination) {
    // at this point it has been established we can move
    assert(canMove(origin, destination));

    print("moving from $origin to $destination");
    int midx = ((origin.x + destination.x) / 2).floor();
    int midy = ((origin.y + destination.y) / 2).floor();
    HoleData middle = this.myHoles[midx][midy];
    print("Taking out $middle");
    middle.hasPeg = false;
    origin.hasPeg = false;
    destination.hasPeg = true;
    setState(() {});
  }

  Widget createPeg(HoleData d) {
    return Draggable(
      data: d,
      child: Container(
        width: this.holeDiameter,
        height: this.holeDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      ),
      childWhenDragging: Container(
        width: this.holeDiameter,
        height: this.holeDiameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
      ),
      feedback: Container(
        width: this.holeDiameter + 20,
        height: this.holeDiameter + 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
      ),
      onDragStarted: () {
        print("Dragging $d");
      },
      onDragCompleted: () {
        print("Completed dragging $d");
      },
    );
  }
}

class GameBoardData {
  List<HoleData> holes;
}

class HoleData {
  int x, y;
  bool hasPeg;

  HoleData(this.x, this.y, this.hasPeg);

  @override
  String toString() {
    return "${hasPeg ? "Peg" : "Hole"}[$x, $y]";
  }
}
