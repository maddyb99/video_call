import 'package:flutter/material.dart';
import 'package:video_call/authentication/resource/signUpReq.dart';
import 'package:video_call/common/ui/customFields.dart';

class SignUp extends StatefulWidget {
  final VoidCallback back;

  SignUp({@required this.back});

  @override
  _SignUpPageState createState() => _SignUpPageState(back: back);
}

class _SignUpPageState extends State<SignUp> {
  final VoidCallback back;

  _SignUpPageState({this.back});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final Authenticate authenticate = new Authenticate();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Padding(padding: EdgeInsets.all(10.0),child: Text("Sign Up",textScaleFactor: 2.0,),),
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Sign Up",
                          textScaleFactor: 2.0,
                        ),
                      ),
                      InputField(
                        "Name",
                        (String s) => authenticate.getName(s),
                        elevation: 2.0,
                        inputAction: TextInputAction.next,
                        prefix: Icons.person,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      InputField(
                        "Mobile",
                        (String s) => authenticate.getMobile(s),
                        elevation: 2.0,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        prefix: Icons.phone,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      InputField(
                        "Email",
                        (String s) => authenticate.getEmail(s),
                        elevation: 2.0,
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        prefix: Icons.email,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      InputField(
                        "Password",
                        (String s) => authenticate.getPass(s),
                        elevation: 2.0,
                        inputAction: TextInputAction.next,
                        isPassword: true,
                        prefix: Icons.vpn_key,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      InputField(
                        "Re-enter Password",
                        (String s) => authenticate.getPass(s),
                        elevation: 2.0,
                        inputAction: TextInputAction.done,
                        isPassword: true,
                        prefix: Icons.vpn_key,
                      ),
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
                authenticate.signUp(formKey, context);
              },
              child: Text("Sign Up"),
              color: Colors.blueAccent,
              height: 35,
              elevation: 10.0,
            ),
            MaterialButton(
              onPressed: back,
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
