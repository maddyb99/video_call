import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/authentication/ui/login.dart';
import 'package:video_call/authentication/ui/otp_verify.dart';
import 'package:video_call/authentication/ui/profileinput.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthenticationPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PageController controller;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  Future<void> getPermissions() async {
    List<PermissionGroup> permission = [
      PermissionGroup.camera,
      PermissionGroup.microphone,
//      PermissionGroup.storage,
      PermissionGroup.contacts
    ];
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permission);
    permissions.forEach((PermissionGroup pg, PermissionStatus ps) {
      print(pg.toString() + " " + ps.toString() + "\n");
    });
  }

  void backpage() {
    if (controller.page.round() != 0)
      setState(() {
        controller.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
  }

  void nextpage() {
    if (controller.page.round() != 2)
      setState(() {
        controller.animateToPage(controller.page.round() + 1,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatusCodes.noProfile)
      controller =
          PageController(initialPage: 2, keepPage: true, viewportFraction: 1);
    else
      controller =
          PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
          //appBar: AppBar(title: Text("App"),),
          body: PageView(
        controller: controller,
        pageSnapping: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Login(),
          OTPVerify(
          ),
          ProfileInput(
          ),
        ],
      )),
    );
  }
}
