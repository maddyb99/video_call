import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/common/ui/customFields.dart';

class Login extends StatefulWidget {
  final VoidCallback signup;

  Login({@required this.signup});

  @override
  _LoginState createState() => _LoginState(signup: signup);
}

class _LoginState extends State<Login> {
  final VoidCallback signup;
  String countryCode,mobile ;

  _LoginState({this.signup});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context);
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Center(
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
                                items: <String>[
                                  '+91',
                                  '+65',
                                  '+44',
                                  '+45'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                onSaved: (v) => countryCode=v,
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
                                (String s) => mobile=s,
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
                onPressed: ()async {
                  FormState formState=formKey.currentState;
                  if(formState.validate()){
                    formState.save();
                    userProvider.signInAutoOTP(countryCode, mobile);
                    signup();
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
    );
  }
}
