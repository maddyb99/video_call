import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/auth_bloc.dart';
import 'package:video_call/video_call/init.dart';

import 'authentication/ui/authentication.dart';
import 'common/theme.dart';
import 'home_page/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  UserProvider userProvider=UserProvider();
  final CustomThemeData theme = CustomThemeData();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>userProvider),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme.lightTheme(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/video': (BuildContext context) => StartVideo(),
        },
        home: AuthenticationPage(),
      ),
    );
  }
}
