import 'package:flutter/material.dart';


class PegData {
  int x, y;

  PegData(this.x, this.y);

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
