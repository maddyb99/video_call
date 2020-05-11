import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call/authentication/provider/user_provider.dart';
import 'package:video_call/common/ui/customFields.dart';

class ProfileInput extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String name, profilePhoto;
    var userProvider = Provider.of<UserProvider>(context);
    if (userProvider.status == UserStatusCodes.loggedIn) {
      print("im in");
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          ModalRoute.withName(':'),
        ),
      );
    }
    //TODO: fix snackbar
//    else if (userProvider.status == UserStatusCodes.noProfile)
//      Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text('Error Saving.'),
//        ),
//      );
//    else if (userProvider.status == UserStatusCodes.verificationError)
//      Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text('Could not verify. Please try again!'),
//        ),
//      );
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: Scaffold(
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
