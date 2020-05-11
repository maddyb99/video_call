import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/authentication/ui/otp_verify.dart';
import 'package:video_call/common/ui/customFields.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String countryCode, mobile;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatusCodes.waitOtp)
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => OTPVerify(),
          ),
        ),
      );
    else if (scaffoldKey.currentState!=null&&(userProvider.status == UserStatusCodes.logInFailure ||
        userProvider.status == UserStatusCodes.otpError ||
        userProvider.status == UserStatusCodes.verificationError))
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
                              Container(
                                width: 100,
                                child: DropdownButtonFormField<String>(
                                  items: <String>['+91', '+65', '+44', '+45']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      countryCode = v;
                                    });
                                  },
                                  value: countryCode,
                                  onSaved: (v) => countryCode = v,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.phone,
                                    ),
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                              ),
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
                      userProvider.signInAutoOTP(countryCode, mobile);
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
