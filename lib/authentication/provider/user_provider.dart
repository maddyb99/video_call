import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/resource/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    loadData();
//  _status=UserStatusCodes.logInFailure;
  }

  FirebaseUser firebaseUser;
  String _verificationId, _status, _phoneNum,_countryCode;
  int _timeOut = 30;
  User user;

  loadData() {
    clear(notify: false);
    _status = UserStatusCodes.loginInProgress;
    print(status);
    signInStatus();
  }

  String get status => _status;

  String get phoneNum => _countryCode+_phoneNum;

  String get prettyPhoneNum=> '$_countryCode ${_phoneNum.substring(0,5)} ${_phoneNum.substring(5)}';

  int get timeOut => _timeOut;

  Future<bool> signInStatus({FirebaseUser verify}) async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if (verify != null && firebaseUser.uid != verify.uid) {
      _status = UserStatusCodes.logInFailure;
      print(_status);
      notifyListeners();
      return false;
    }
    try {
      if (firebaseUser == null) {
        _status = UserStatusCodes.logInFailure;
        print(_status);
        notifyListeners();
        return false;
      } else {
        if (await fetchUserData())
          _status = UserStatusCodes.loggedIn;
        else
          _status = UserStatusCodes.noProfile;
        _phoneNum = firebaseUser.phoneNumber;
        print(status);
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
    _status = UserStatusCodes.initState;
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
      _status = UserStatusCodes.otpError;
      print(_status);
      notifyListeners();
      return;
    });
    if (status != UserStatusCodes.otpError)
      await signInStatus(verify: _authResult.user);
  }

  Future<bool> updateUser(String name) async {
    User tempUser;
    bool ret = false;
    print(phoneNum);
    tempUser = User(
      name: name,
      mobile: int.parse(phoneNum),
      uid: firebaseUser.uid,
      profilePic: '',
    );
    if (status == UserStatusCodes.noProfile)
      try {
        await UserRepo.createUser(tempUser);
        user = tempUser;
        _status = UserStatusCodes.loggedIn;
        ret = true;
      } catch (e) {
        print(e);
      }
    else {
      try {
        await UserRepo.updateUser(tempUser);
        user = tempUser;
        if (_status != UserStatusCodes.loggedIn)
          _status = UserStatusCodes.loggedIn;
        ret = true;
      } catch (e) {
        print(e);
      }
    }
    print(_status);
    notifyListeners();
    return ret;
  }

  Future<void> signInAutoOTP(String countryCode, String mobile) async {
    print(countryCode);
    print(mobile);
    _phoneNum = mobile;
    _countryCode=countryCode;
    print(_phoneNum);
//    notifyListeners();
    try {
      PhoneCodeSent codeSent = (String verID, [int forceResend]) async {
        this._verificationId = verID;
        _status = UserStatusCodes.waitOtp;
        notifyListeners();
        print('Code sent to $mobile');
      };
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
        this._verificationId = verID;
        _status = UserStatusCodes.timeOut;
        print(_status);
        notifyListeners();
      };
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential auth) {
        FirebaseAuth.instance
            .signInWithCredential(auth)
            .then((AuthResult value) async {
          if (value.user != null)
            await signInStatus();
          else {
            _status = UserStatusCodes.verificationError;
          }
        }).catchError((error) {
          _status = UserStatusCodes.verificationError;
        });
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        timeout: Duration(seconds: _timeOut),
        verificationCompleted: verificationCompleted,
        verificationFailed: (exp) {
          print(exp.message);
          _status = UserStatusCodes.verificationError;
          print(_status);
          notifyListeners();
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
      );
//      UserData.profileData = await FirebaseAuth.instance.currentUser();
//      print("here" + UserData.profileData.toString());
    } catch (e) {
      throw e == "Verify"
          ? "Verify email and then signIn"
          : e.toString().split(',')[1];
    }
  }
}

class UserStatusCodes {
  static get initState => 'INIT';
  static get timeOut => 'TIMEOUT';
  static get loggedIn => 'LOGGEDIN';
  static get noProfile => 'NOPROFILE';
  static get waitOtp => 'WAITOTP';
  static get otpError => 'WRONGOTP';
  static get verificationError => 'UNKNOWNERROR';
  static get logInFailure => 'NOTIN';
  static get loginInProgress => 'INPROGRESS';
}
