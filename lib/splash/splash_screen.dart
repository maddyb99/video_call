import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';

class SplashScreen extends StatelessWidget {
//  final SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
//    sizeConfig.init(context);
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status != UserStatusCodes.loginInProgress) {
      if (userProvider.status == UserStatusCodes.loggedIn) {
        Future.delayed(Duration.zero, () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', ModalRoute.withName(':'),
              arguments: userProvider);
        });
      } else {
        Future.delayed(
          Duration(seconds: 2),
        ).then((val) {
          Navigator.of(context).pushReplacementNamed(
            '/auth',
            arguments: userProvider,
          );
        });
      }
    }
    // requestStorage();
    //TODO: Design actual splash screen
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Scaffold(
//            backgroundColor: Colors.transparent,
            body: Center(child: Text('Insert Splash Screen here...')),
          ),
//          Shimmer(),
        ],
      ),
    );
  }
}
