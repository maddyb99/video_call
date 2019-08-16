import 'package:flutter/material.dart';
import 'package:video_call/Utils/floating_action_button.dart';
import 'package:video_call/video_call/init.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: GridView.count(crossAxisCount: 2,
        children: <Widget>[
          MaterialButton(onPressed: () {
            startVideo = new StartVideo();
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),);
          }, child: Text("Join"),),
          MaterialButton(onPressed: () {
            startVideo = new StartVideo();
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),);
          }, child: Text("Join"),),
          MaterialButton(onPressed: () {
            startVideo = new StartVideo();
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),);
          }, child: Text("Join"),),
          MaterialButton(onPressed: () {
            startVideo = new StartVideo();
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return startVideo;
              },
            ),);
          }, child: Text("Join"),),
        ],),
      floatingActionButton: FAB(),
    );
  }
}
