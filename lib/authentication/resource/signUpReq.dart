import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_call/common/userData.dart';

class Authenticate {
  CollectionReference userReference;
  QuerySnapshot userSnapshot;
  AuthException exception;
  Map<String, dynamic> details;
  Future<void> Function(BuildContext context) fn;
  String msg;
  String verificationID,status;

  Authenticate() {
    //_isSignIn = false;
    details = Map<String, dynamic>();
    getUser();
    msg = "Invalid details";
  }

  void clear() {
    details = Map<String, dynamic>();
    getUser();
    msg = "Invalid details";
    UserData.profileData = null;
  }

  void nextPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName(':'));
  }

  Future<bool> isSignIn(context) async {
    UserData.profileData = await FirebaseAuth.instance.currentUser();
    try {
      if (UserData.profileData == null) {
        return false;
      } else {
        userSnapshot = await Firestore.instance
            .collection('Users')
            .where('emailID', isEqualTo: UserData.profileData.email)
            .getDocuments();
        UserData.detailsData = userSnapshot.documents[0];
        nextPage(context);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _ackAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  getUser() async {
    userReference = Firestore.instance.collection("Users");
  }

  getName(String x) => details.addAll({'Name': x});

  getPass(String x) => details.addAll({'Pass': x});

  getMobile(String x) => details.addAll({'Mobile': x});

  getCountryCode(String x) => details.addAll({'CountryCode': x});

  getEmail(String x) => details.addAll({'Email': x});

  getOTP(String x) => verificationID = x;

  Future<void> signUp(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    FormState formState = _formKey.currentState;
    details.clear();
    if (formState.validate()) {
      formState.save();
      try {
        //_isSignIn = true;
        print(details);
        QuerySnapshot val = await userReference
            .where("Mobile", isEqualTo: int.parse(details['Mobile']))
            .getDocuments();
        if (val.documents.length != 0) throw ("Mobile Number already in use");
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: details['Email'], password: details['Pass']);
        UserData.profileData = await FirebaseAuth.instance.currentUser();
        UserData.profileData.sendEmailVerification();
        currentUser = Users(
          email: details['Email'],
          name: details['Name'],
          m: details['Mobile'],
        );
        Firestore.instance.runTransaction((Transaction t) async {
          await userReference
              .document(UserData.profileData.uid)
              .setData(currentUser.toJson());
        });
        userSnapshot = await userReference
            .where('emailID', isEqualTo: details['Email'])
            .getDocuments();
        await UserData.profileData.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        formState.reset();
        throw ("Verify");
      } catch (e) {
        //_isSignIn = false;
        print(e);
        details.clear();
        currentUser = null;
        _ackAlert(
            context,
            e == "Verify" ? "Verification Required" : "SignUp Failed!",
            e.toString().contains("Mobile")
                ? e
                : e == "Verify"
                    ? "Verify email and then signIn"
                    : e.toString().split(',')[1]);
      }
    }
  }
Future<void> signInManOTP(GlobalKey<FormState> _formKey,String smsCode) async{

  AuthCredential _authCredential = PhoneAuthProvider.getCredential(
      verificationId: verificationID, smsCode: smsCode);
  FirebaseAuth.instance.signInWithCredential(_authCredential).catchError((error) {
//      setState(() {
    status = 'Something has gone wrong, please try later';
//      });
  });
  //        .then((FirebaseUser user) async {
////      setState(() {
//        status = 'Authentication successful';
////      });
////      onAuthenticationSuccessful();
//    return true;
//    });
}
  Future<void> signInAutoOTP(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    details.clear();
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      print(details["CountryCode"] + details["Mobile"]);
      try {
        PhoneCodeSent codeSent = (String verID, [int forceResend]) async {
          this.verificationID = verID;
          print('Code sent to ${details['Mobile']}');
          status = "Enter the code sent to " + details['Mobile'];
        };
        PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
          this.verificationID = verID;
          status = "\nAuto retrieval time out";
        };
        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential auth) {
            status = 'Auto retrieving verification code';
          FirebaseAuth.instance.signInWithCredential(auth)
              .then((AuthResult value) {
            if (value.user != null) {
                status = 'Authentication successful';
//              onAuthenticationSuccessful();
            } else {
                status = 'Invalid code/invalid authentication';
            }
          }).catchError((error) {
              status = 'Something has gone wrong, please try later';
          });
        };
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: details["CountryCode"] + details["Mobile"],
          timeout: Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: (exp) {
            print(exp.message);
          },
          codeSent: codeSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout,
        );

//        await FirebaseAuth.instance.signInWithEmailAndPassword(
//            email: details['Email'], password: details['Pass']);
        UserData.profileData = await FirebaseAuth.instance.currentUser();
        print(UserData.profileData.toString());
        nextPage(context);
        formState.reset();
      } catch (e) {
        details.clear();
        _ackAlert(
            context,
            "Login Failed!",
            e == "Verify"
                ? "Verify email and then signIn"
                : e.toString().split(',')[1]);
      }
    }
  }
}
Authenticate authenticate;
