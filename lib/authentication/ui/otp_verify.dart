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
  int time ;
  Timer timer;
  String smsCode, phoneNum;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void startTimer() {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    if(userProvider.status==UserStatusCodes.waitOtp&&(timer==null||!timer.isActive))
      {time=userProvider.timeOut;startTimer();}
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
    else if (scaffoldKey.currentState!=null&&userProvider.status == UserStatusCodes.otpError)
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Invalid OTP'),
        ),
      );
    else if (scaffoldKey.currentState!=null&&userProvider.status == UserStatusCodes.verificationError)
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Could not verify. Please try again!'),
        ),
      );
    phoneNum = userProvider.prettyPhoneNum;
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: LayoutBuilder(
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'OTP Has been sent to the phone number $phoneNum'),
                          ),
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
                              userProvider.status == UserStatusCodes.waitOtp
                                  ? null:null,
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
      ),
    );
  }
}
