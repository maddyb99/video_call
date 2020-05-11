import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/authentication/ui/login.dart';
import 'package:video_call/home_page/provider/contacts_provider.dart';
import 'package:video_call/splash/splash_screen.dart';
import 'package:video_call/video_call/init.dart';
import 'common/theme.dart';
import 'home_page/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CustomThemeData theme = CustomThemeData();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme.lightTheme(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => Login(),
          '/home': (BuildContext context) => HomePage(),
          '/video': (BuildContext context) => StartVideo(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
