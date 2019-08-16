import 'package:flutter/material.dart';

import 'Login.dart';
import 'signUP.dart';
import 'signUpReq.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthenticationPage> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Authenticate authenticate = new Authenticate();
  PageController controller;

  @override
  void initState() {
    super.initState();
    authenticate.isSignIn(context);
    controller = new PageController(
        initialPage: 0, keepPage: true, viewportFraction: 0.85);
  }

  void switchPage() {
    setState(() {
      controller.animateToPage(1 - controller.page.round(),
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text("App"),),
        body: PageView(
      controller: controller,
      pageSnapping: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Login(signup: switchPage),
        SignUp(
          back: switchPage,
        ),
      ],
    ));
  }
}
