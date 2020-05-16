import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/authentication/ui/otp_timeout.dart';
import 'package:video_call/authentication/ui/profileinput.dart';
import 'package:video_call/common/ui/customFields.dart';

class OTPVerify extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    String smsCode;
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatus.authenticated ||
        userProvider.status == UserStatus.loggedIn) {
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProfileInput(),
          ),
        ),
      );
    }
    else if (scaffoldKey.currentState!=null&&userProvider.status == UserStatus.wrongOtp)
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Invalid OTP'),
        ),
      );
    else if (scaffoldKey.currentState!=null&&userProvider.status == UserStatus.verificationError)
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Could not verify. Please try again!'),
        ),
      );
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
                                'OTP Has been sent to the phone number ${userProvider.prettyPhoneNum}'),
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
                        OtpTimeout(userProvider.timeOut),
                        FlatButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(0),
                          onPressed:
                              userProvider.status == UserStatus.waitOtp
                                  ? null:()=>userProvider.signInAutoOTP(),
                          child: Text('Resend'),
                        ),
                        MaterialButton(
                          color: Colors.green[400],
                          onPressed:() {
                                      FormState formState = formKey.currentState;
                                      if (formState.validate()) {
                                        formState.save();
                                        print(smsCode);
                                        userProvider.signInManOTP(smsCode);
                                      }
                                    }
                                  ,
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
