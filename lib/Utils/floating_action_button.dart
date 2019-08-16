import './../video_call/init.dart';
import 'package:flutter/material.dart';

StartVideo startVideo;

class FAB extends StatelessWidget {
  final color;

  FAB({this.color = Colors.cyan});

  @override
  Widget build(BuildContext context) {
    print(startVideo);
    if (startVideo != null) {
      return FloatingActionButton.extended(
        heroTag: "dfgdfgdf",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),
          );
        },
        label: Text("Return"),
        icon: Icon(Icons.call),
        backgroundColor: color,
      );
    } else
      return Container(
        height: 0,
        width: 0,
      );
  }
}
