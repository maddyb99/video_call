import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/authentication/resource/signUpReq.dart';
import 'package:video_call/authentication/ui/login.dart';
import 'package:video_call/authentication/ui/otp_verify.dart';
import 'package:video_call/authentication/ui/profileinput.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthenticationPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Authenticate authenticate = Authenticate();
  PageController controller;

  @override
  void initState() {
    super.initState();
    getPermissions();
    authenticate.isSignIn(context);
    controller =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  }

  Future<void> getPermissions() async {
    List<PermissionGroup> permission = [
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.storage,
      PermissionGroup.contacts
    ];
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permission);
    /*permission.forEach((PermissionGroup p)async{
      PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(p);
      if(permissionStatus.value==0){
        bool isShown= await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.contacts);
        if(!isShown)
          _ackAlert(context, "Permissions", "The app requires "+p.value.toString()+" permission to function");
      }
    });*/
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
        controller.animateToPage(controller.page.round()+1,
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
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Login(signup: nextpage),
        OTPVerify(
          phoneNo: 'fsdf',
          back: backpage,
          submit:nextpage,
        ),
        ProfileInput(back: backpage,),
      ],
    ));
  }
}
