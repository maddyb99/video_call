import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_call/Utils/customFields.dart';

import './../Utils/userData.dart';

class Authenticate {
  CollectionReference userReference;
  QuerySnapshot userSnapshot;
  AuthException exception;
  Map<String, dynamic> details;
  Future<void> Function(BuildContext context) fn;
  String msg;
  String verificationID;

  Authenticate() {
    //_isSignIn = false;
    details = new Map<String, dynamic>();
    getUser();
    msg = "Invalid details";
  }

  void clear() {
    details = new Map<String, dynamic>();
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

  Future<void> _OTP(BuildContext context, String title, String verID) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Form(key: formKey,
              child: InputField("Enter OTP", this.getOTP, prefix: null,)),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () async {
                FormState state = formKey.currentState;
                state.save();
                print(verificationID);
                print(verID);
                UserData.profileData =
                await FirebaseAuth.instance.currentUser();
                if (UserData.profileData == null) {
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                      verificationId: verID, smsCode: this.verificationID);
                  FirebaseAuth.instance.signInWithCredential(credential);
                }
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
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: details['Email'], password: details['Pass']);
        UserData.profileData = await FirebaseAuth.instance.currentUser();
        UserData.profileData.sendEmailVerification();
        currentUser = new Users(
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
        throw("Verify");
      } catch (e) {
        //_isSignIn = false;
        print(e);
        details.clear();
        currentUser = null;
        _ackAlert(
            context,
            e == "Verify" ? "Verification Required" : "SignUp Failed!",
            e.toString().contains("Mobile")
                ? e : e == "Verify" ? "Verify email and then signIn"
                : e.toString().split(',')[1]);
      }
    }
  }

  Future<void> signIn(
      GlobalKey<FormState> _formKey, BuildContext context) async {
    details.clear();
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      Future.delayed(Duration(seconds: 5));
      formState.save();
      print(details["CountryCode"] + details["Mobile"]);
      try {
        PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String ID) {
          this.verificationID = ID;
        };
        PhoneCodeSent codeSent = (String verID, [int forceResend]) {
          this.verificationID = verID;
          _OTP(context, "Code Sent", verID);
        };
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: details["CountryCode"] + details["Mobile"],
            timeout: Duration(seconds: 120),
            verificationCompleted: (auth) async {
              print(auth);
            },
            verificationFailed: (exp) {
              print(exp.message);
            },
            codeSent: codeSent,
            codeAutoRetrievalTimeout: autoRetrievalTimeout);

//        await FirebaseAuth.instance.signInWithEmailAndPassword(
//            email: details['Email'], password: details['Pass']);
        UserData.profileData = await FirebaseAuth.instance.currentUser();
//        if (!UserData.profileData.isEmailVerified) {
//          await UserData.profileData.sendEmailVerification();
//          await FirebaseAuth.instance.signOut();
//          throw("Verify");
//        }
        UserData.detailsData =
        await userReference.document(UserData.profileData.uid).get();
        nextPage(context);
        formState.reset();
      } catch (e) {
        details.clear();
        _ackAlert(context, "Login Failed!",
            e == "Verify" ? "Verify email and then signIn" : e.toString().split(
                ',')[1]);
      }
    }
  }
}
