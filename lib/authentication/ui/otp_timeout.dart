import 'dart:async';

import 'package:flutter/material.dart';

class OtpTimeout extends StatefulWidget{
  OtpTimeout(this.time);
  final int time;

  @override
  _OtpTimeoutState createState() => _OtpTimeoutState();
}

class _OtpTimeoutState extends State<OtpTimeout> {
  int time;
  Timer timer;
  @override
  void initState() {
    time=widget.time;
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (time < 1) {
            timer.cancel();
          } else {
            time = time - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text('Waiting for OTP: $time'),
      );
  }
}