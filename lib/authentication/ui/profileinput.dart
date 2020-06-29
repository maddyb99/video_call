import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/common/provider/notif_provider.dart';
import 'package:video_call/common/provider/user_provider.dart';
import 'package:video_call/common/ui/customFields.dart';
import 'package:video_call/home_page/provider/contacts_provider.dart';

class ProfileInput extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String name, profilePhoto;
    var userProvider = Provider.of<UserProvider>(context);
    var notificationProvider=Provider.of<NotificationProvider>(context);
    if (userProvider.status == UserStatus.loggedIn)
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          ModalRoute.withName(':'),
        ),
      );
    else if (scaffoldKey.currentState!=null&&userProvider.status == UserStatus.authenticated)
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error Saving.'),
        ),
      );
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
        key: scaffoldKey,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Card(
//            shape: RoundedRectangleBorder(borderRadius: kCardBorderRadiusAll),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            InputField(
                              'Name',
                              (s) => name = s,
                              initailValue: userProvider.user==null?null:userProvider.user.name,
                              elevation: 2.0,
                              inputAction: TextInputAction.next,
                              prefix: Icons.person,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: MaterialButton(
                        color: Colors.green[400],
                        onPressed: () {
                          FormState formState = formKey.currentState;
                          if (formState.validate()) {
                            formState.save();
                            userProvider.updateUser(name);
                            notificationProvider.updateToken(userProvider.user.uid);
                          }
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
