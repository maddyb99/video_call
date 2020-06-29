import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/video_call/init.dart';

class NotificationManger {
  static BuildContext _context;

  static init({@required BuildContext context}) {
    _context = context;
  }

  static onMessage(Map<String, dynamic> message) {
    print("onmessage");
    print(message);
    Navigator.of(_context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return StartVideo();
        },
      ),
    );
    _showSnackbar(data: message);
  }

  static onLaunch(Map<String, dynamic> message) {
    print("onlaunch");
    print(message);
  }

  static onResume(Map<String, dynamic> message) {
    print(message);
  }

  static _showSnackbar({@required Map<String, dynamic> data}) {
    // showDialog(context: _context, builder: (_) => );
    SnackBar snackBar = SnackBar(
      content: Text(
        data['notification']['title'],
      ),
    );
    Scaffold.of(_context).showSnackBar(snackBar);
  }
}