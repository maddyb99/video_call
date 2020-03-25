import 'package:flutter/material.dart';

import '../../common/ui/customFields.dart';
import '../resource/signUpReq.dart';

class Login extends StatefulWidget {
  final VoidCallback signup;

  Login({@required this.signup});

  @override
  _LoginState createState() => _LoginState(signup: signup);
}

class _LoginState extends State<Login> {
  final VoidCallback signup;
  String dropVal = '+91';

  _LoginState({this.signup});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Authenticate authenticate = new Authenticate();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Padding(padding: EdgeInsets.all(10.0),child: Text("Login",textScaleFactor: 2.0,),),
            Card(
              elevation: 10.0,
              margin: EdgeInsets.all(15.0),
              color: Colors.cyanAccent[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(bottom: 20.0),
//                        child: Text(
//                          "Login",
//                          textScaleFactor: 2.0,
//                        ),
//                      ),
//                      InputField(
//                        "Email",
//                        (String s) => authenticate.getEmail(s),
//                        elevation: 2.0,
//                        inputType: TextInputType.emailAddress,
//                        inputAction: TextInputAction.next,
//                        prefix: Icons.email,
//                      ),
                      Padding(padding: EdgeInsets.all(5.0)),

                      Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: DropdownButtonFormField<String>(
                              items: <String>[
                                '+91',
                                '+65',
                                'Free',
                                'Four'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  dropVal = v;
                                });
                              },
                              value: dropVal,
                              onSaved: (v) => authenticate.getCountryCode(v),
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
                              (String s) => authenticate.getMobile(s),
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
                authenticate.getCountryCode(dropVal);
                authenticate.signIn(formKey, context);
              },
              child: Text("Sign in"),
              color: Colors.blueAccent,
              height: 35,
              elevation: 10.0,
            ),
            MaterialButton(
              onPressed: signup,
              child: Text("Sign up?"),
            ),
          ],
        ),
      ),
    );
  }
}
