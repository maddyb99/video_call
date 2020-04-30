import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/common/userData.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {}
  FirebaseUser firebaseUser;
  DocumentSnapshot userSnapshot;
  Users userData;
  String _verificationId,_status;

  loadData() {}

  Future<bool> isSignIn() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    try {
      if (firebaseUser == null) {
        notifyListeners();
        return false;
      } else {
        userSnapshot = await Firestore.instance
            .collection('Users')
            .document(firebaseUser.uid)
            .get();
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> signInManOTP(String smsCode) async{

    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(_authCredential).catchError((error) {
//      setState(() {
      _status = 'Something has gone wrong, please try later';
//      });
    });
    isSignIn();
  }

  Future<void> signInAutoOTP(String countryCode, String mobile) async {
    print(countryCode + mobile);
    try {
      PhoneCodeSent codeSent = (String verID, [int forceResend]) async {
        this._verificationId = verID;
        print('Code sent to $mobile');
        _status = "Enter the code sent to " + mobile;
      };
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
        this._verificationId = verID;
        _status = "\nAuto retrieval time out";
      };
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential auth) {
        _status = 'Auto retrieving verification code';
        FirebaseAuth.instance
            .signInWithCredential(auth)
            .then((AuthResult value) {
          if (value.user != null) {
            _status = 'Authentication successful';
            isSignIn();
//              onAuthenticationSuccessful();
          } else {
            _status = 'Invalid code/invalid authentication';
          }
        }).catchError((error) {
          _status = 'Something has gone wrong, please try later';
        });
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + mobile,
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
    } catch (e) {
        throw  e == "Verify"
              ? "Verify email and then signIn"
              : e.toString().split(',')[1];
    }
  }
}
