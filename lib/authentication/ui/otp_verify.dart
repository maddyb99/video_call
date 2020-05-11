import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/authentication/ui/profileinput.dart';
import 'package:video_call/common/ui/customFields.dart';

class OTPVerify extends StatefulWidget {
  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  int time = 60, origtime = 60;
  Timer timer;
  bool enableResend;
  String smsCode, phoneNum;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatusCodes.noProfile ||
        userProvider.status == UserStatusCodes.loggedIn) {
      dispose();
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProfileInput(),
          ),
        ),
      );
    }
//    else if (userProvider.status == UserStatusCodes.otpError)
//      Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text('Invalid OTP'),
//        ),
//      );
//    else if (userProvider.status == UserStatusCodes.verificationError)
//      Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text('Could not verify. Please try again!'),
//        ),
//      );
    phoneNum = userProvider.phoneNum;
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
        body: LayoutBuilder(
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
                            'OTP Has been sent to the phone number $phoneNum'),
                      ),
                      Form(
                        key: formKey,
                        child: Container(
                          width: constraints.maxWidth * 0.4,
                          child: InputField(
                            'Enter OTP',
                            (str) => smsCode = str,
                            inputType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text('Waiting for OTP: $time'),
                      ),
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        onPressed:
                            userProvider.status != UserStatusCodes.waitOtp
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
                        onPressed:
                            userProvider.status != UserStatusCodes.waitOtp &&
                                    userProvider.status != null
                                ? () {
                                    FormState formState = formKey.currentState;
                                    if (formState.validate()) {
                                      formState.save();
                                      print(smsCode);
                                      userProvider.signInManOTP(smsCode);
                                    }
                                  }
                                : null,
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
