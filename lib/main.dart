import 'package:flutter/material.dart';

import 'Authentication/Authentication.dart';
import 'HomePage/HomePage.dart';
import 'Utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  themeData theme = new themeData();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.lightTheme(),
      routes: <String, WidgetBuilder>{
        // '/DispQ': (BuildContext context) => DispQuestion(),
//        '/signUP':(BuildContext context) =>SignUp(),
//        '/user_login':(BuildContext context)=>AuthenticationPage(),
        // '/result':(BuildContext context)=>Result(),
        '/home': (BuildContext context) => HomePage(),
        //'/wait_quiz':(BuildContext context)=>WaitQuiz(DocumentSnapshot),
      },
      home: AuthenticationPage(),
    );
  }
}
