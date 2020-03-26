import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget{
  final IconData icon;
  final Function func;
  final bool highlight;
  BottomButton({@required this.icon,@required this.func, @required this.highlight});

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: CircleBorder(),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onPressed: widget.func,
      child: Icon(widget.icon),
      color: widget.highlight ? Colors.blue[100] : Color.fromARGB(100, 255, 227, 242),
    );
  }
}