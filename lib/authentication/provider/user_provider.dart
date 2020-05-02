import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/resource/user_repository.dart';
import 'package:video_call/common/userData.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    clear(notify: false);
    signInStat();
  }

  FirebaseUser firebaseUser;
  String _verificationId, _status, _phoneNum;
  User user;

  loadData() {
    _status = 'NOTIN';
    signInStat();
  }

  String get status => _status;

  String get phoneNum => _phoneNum;

  Future<bool> signInStat({FirebaseUser verify}) async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if (verify != null && firebaseUser.uid != verify.uid) {
      _status = 'NOTIN';
      notifyListeners();
      return false;
    }
    try {
      if (firebaseUser == null) {
        _status = StatusCodes.notLoggedIn;
        notifyListeners();
        return false;
      } else {
        if (await fetchUserData())
          _status = StatusCodes.loggedIn;
        else
          _status = StatusCodes.noProfile;
        print(_status);
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserData() async {
    if (firebaseUser?.uid != null) {
      user = await UserRepo.fetchUser(firebaseUser.uid);
      if (user.uid == firebaseUser.uid) return true;
    } else {
      clear(notify: false);
    }
    return false;
  }

  void clear({bool notify = true}) {
    firebaseUser = null;
    user = null;
    _status = null;
    if (notify) notifyListeners();
  }

  Future<void> signInManOTP(String smsCode) async {
//    clear();
    print(smsCode);
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);
    AuthResult _authResult = await FirebaseAuth.instance
        .signInWithCredential(_authCredential)
        .catchError((error) {
      _status = StatusCodes.otpError;
      notifyListeners();
      return;
    });
    if(status!=StatusCodes.otpError)
    await signInStat(verify: _authResult.user);
  }

  Future<bool> updateUser(String name)async{
    User tempUser;
    bool ret=false;
    print(phoneNum);
    tempUser=User(
      name: name,
      mobile: int.parse(phoneNum),
      uid: firebaseUser.uid,
      profilePic: '',
    );
    if(status==StatusCodes.noProfile)
    try{
      await UserRepo.createUser(tempUser);
      user=tempUser;
      _status=StatusCodes.loggedIn;
      ret=true;
    }catch(e){
      print(e);
    }
    else{
      try {
        await UserRepo.updateUser(tempUser);
        user=tempUser;
        if(_status!=StatusCodes.loggedIn)
        _status=StatusCodes.loggedIn;
        ret=true;
      }  catch (e) {
        print(e);
      }
    }
    notifyListeners();
    return ret;
  }

  Future<void> signInAutoOTP(String countryCode, String mobile) async {
    print(countryCode);
    print(mobile);
    _phoneNum = (countryCode+' '+mobile);
    notifyListeners();
    try {
      PhoneCodeSent codeSent = (String verID, [int forceResend]) async {
        this._verificationId = verID;
        _status=StatusCodes.waitOtp;
        print('Code sent to $mobile');
      };
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
        this._verificationId = verID;
        _status = StatusCodes.timeOut;
        notifyListeners();
      };
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential auth) {
        FirebaseAuth.instance
            .signInWithCredential(auth)
            .then((AuthResult value) async {
          if (value.user != null)
            await signInStat();
          else {
            _status = StatusCodes.verificationError;
          }
        }).catchError((error) {
          _status = StatusCodes.verificationError;
        });
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: (exp) {
          _status = StatusCodes.verificationError;
          notifyListeners();
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
      );
//      UserData.profileData = await FirebaseAuth.instance.currentUser();
      print(UserData.profileData.toString());
    } catch (e) {
      throw e == "Verify"
          ? "Verify email and then signIn"
          : e.toString().split(',')[1];
    }
  }
}

class StatusCodes{
  static get timeOut=>'TIMEOUT';
  static get loggedIn=>'LOGGEDIN';
  static get noProfile=>'NOPROFILE';
  static get waitOtp=>'WAITOTP';
  static get otpError=>'WRONGOTP';
  static get verificationError=>'UNKNOWNERROR';
  static get notLoggedIn=>'NOTIN';

}
