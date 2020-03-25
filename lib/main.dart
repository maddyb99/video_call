import 'package:flutter/material.dart';
import 'package:video_call/video_call/init.dart';

import 'Authentication/ui/authentication.dart';
import 'home_page/ui/home_page.dart';
import 'common/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CustomThemeData theme = new CustomThemeData();

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
        '/video': (BuildContext context) => StartVideo(),
        //'/wait_quiz':(BuildContext context)=>WaitQuiz(DocumentSnapshot),
      },
      home: AuthenticationPage(),
    );
  }
}
