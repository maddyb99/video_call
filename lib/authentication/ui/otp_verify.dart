import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_call/common/ui/customFields.dart';

class OTPVerify extends StatefulWidget {
  final String phoneNo;
  final Function back,submit;

  OTPVerify({@required this.phoneNo, this.back,this.submit});

  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  int time = 60, origtime = 60;
  Timer timer;
  bool enableResend;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (time < 1) {
            enableResend = true;
            timer.cancel();
          } else {
            time = time - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    enableResend = false;
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.only(
            top: constraints.maxHeight / 10,
            bottom: constraints.maxHeight / 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'OTP Has been sent to the phone number ${widget.phoneNo}'),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.4,
                    child: InputField('Enter OTP', (str) {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text('Waiting for OTP: $time'),
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.all(0),
                    onPressed: enableResend
                        ? () {
                            setState(() {
                              origtime += 60;
                              time = origtime;
                              enableResend = false;
                            });
                            startTimer();
                          }
                        : null,
                    child: Text('Resend'),
                  ),
                  MaterialButton(
                    color: Colors.green[400],
                    onPressed:widget.submit,
                    child: Text('Submit'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text('Go back to change number'),
                  ),
                  BackButton(
                    onPressed: widget.back,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
