import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/ui/country_picker.dart';
import 'package:video_call/authentication/ui/otp_verify.dart';
import 'package:video_call/common/provider/user_provider.dart';
import 'package:video_call/common/ui/customFields.dart';

class Login extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String mobile;
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatus.waitOtp)
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OTPVerify(),
          ),
        ),
      );
    else if (scaffoldKey.currentState!=null&&(userProvider.status == UserStatus.logInFailure ||
        userProvider.status == UserStatus.wrongOtp ||
        userProvider.status == UserStatus.verificationError))
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Unknown Error'),
        ),
      );
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//            Padding(padding: EdgeInsets.all(10.0),child: Text("Login",textScaleFactor: 2.0,),),
                Card(
                  margin: EdgeInsets.all(15.0),
                  color: Colors.cyanAccent[100],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(5.0)),

                          Row(
                            children: <Widget>[
                              CountryPicker(),
                              Container(
                                width: 179,
                                child: InputField(
                                  "Mobile",
                                  (String s) => mobile = s,
                                  inputType: TextInputType.phone,
                                  prefix: null,
                                ),
                              ),
                            ],
                          ),
//                      Padding(padding: EdgeInsets.all(5.0)),
//                      InputField(
//                        "Password",
//                        (String s) => authenticate.getPass(s),
//                        elevation: 2.0,
//                        inputAction: TextInputAction.done,
//                        isPassword: true,
//                        prefix: Icons.vpn_key,
//                      ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    FormState formState = formKey.currentState;
                    if (formState.validate()) {
                      formState.save();
                      userProvider.signInAutoOTP(mobile: mobile);
                    }
                  },
                  child: Text("Sign in"),
                  color: Colors.blueAccent,
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
