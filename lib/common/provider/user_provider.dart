import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:video_call/authentication/provider/country_codes_const.dart';
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/resource/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    loadData();
//  _status=UserStatusCodes.logInFailure;
  }

  FirebaseUser firebaseUser;
  String _verificationId, _status, _phoneNum, _countryCode;
  int _timeOut = 30;
  User user;

  loadData() {
    clear(notify: false);
    _status = UserStatus.loginInProgress;
    countryCode = '+91';
    print(status);
    autoLogin();
  }

  set countryCode(String code) {
    _countryCode = code;
//    notifyListeners();
  }

  set phoneNum(String num){
    if(num.startsWith('+'))
      for (var code in countryCodes){
        if(num.startsWith(code['dial_code'])){
          countryCode=code['dial_code'];
          _phoneNum=phoneNum.substring(countryCode.length);
        }
      }
    else
      _phoneNum=num;
  }

  String get countryCode => _countryCode;

  String get status => _status;

  String get phoneNum => _countryCode + _phoneNum;

  String get prettyPhoneNum =>
      '$_countryCode ${_phoneNum.substring(0, 5)} ${_phoneNum.substring(5)}';

  int get timeOut => _status == UserStatus.timedOut ? 0 : _timeOut;

  Future<void> autoLogin() async {
    await signInStatus(notify: false);
    if (_status == UserStatus.logInFailure) _status = UserStatus.initialState;
    notifyListeners();
    return;
  }

  Future<bool> signInStatus({FirebaseUser verify, bool notify: true}) async {
    bool isAutoLogin = (verify == null);
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if (!isAutoLogin && firebaseUser.uid != verify.uid) {
      _status = UserStatus.logInFailure;
      print(_status);
      notifyListeners();
      return false;
    }
    try {
      if (firebaseUser == null) {
        _status = UserStatus.logInFailure;
        print(_status);
        if (notify) notifyListeners();
        return false;
      } else {
        if (await fetchUserData())
          _status =
              isAutoLogin ? UserStatus.loggedIn : UserStatus.authenticated;
        else
          _status = UserStatus.authenticated;
        phoneNum = firebaseUser.phoneNumber;
        print(status);
        if (notify) notifyListeners();
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
    _status = UserStatus.initialState;
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
      _status = UserStatus.wrongOtp;
      print(_status);
      notifyListeners();
      return;
    });
    if (status != UserStatus.wrongOtp)
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
    if (user != null)
      try {
        await UserRepo.createUser(tempUser);
        user = tempUser;
        _status = UserStatus.loggedIn;
        ret = true;
      } catch (e) {
        print(e);
      }
    else {
      try {
        await UserRepo.updateUser(tempUser);
        user = tempUser;
        if (_status != UserStatus.loggedIn) _status = UserStatus.loggedIn;
        ret = true;
      } catch (e) {
        print(e);
      }
    }
    print(_status);
    notifyListeners();
    return ret;
  }

  Future<void> signInAutoOTP({String mobile}) async {
    print(countryCode);
    print(mobile);
    _phoneNum = mobile == null ? _phoneNum : mobile;
//    _countryCode=countryCode;
    print(_phoneNum);
//    notifyListeners();
    try {
      PhoneCodeSent codeSent = (String verID, [int forceResend]) async {
        this._verificationId = verID;
        _status = UserStatus.waitOtp;
        notifyListeners();
        print('Code sent to $mobile');
      };
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
        if (status == UserStatus.authenticated || status == UserStatus.loggedIn)
          return;
        this._verificationId = verID;
        _status = UserStatus.timedOut;
        print(_status);
        notifyListeners();
      };
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential auth) {
        if (status == UserStatus.authenticated || status == UserStatus.loggedIn)
          return;
        FirebaseAuth.instance
            .signInWithCredential(auth)
            .then((AuthResult value) async {
          if (value.user != null)
            await signInStatus();
          else {
            _status = UserStatus.verificationError;
            notifyListeners();
          }
        }).catchError((error) {
          _status = UserStatus.verificationError;
          notifyListeners();
        });
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        timeout: Duration(seconds: _timeOut),
        verificationCompleted: verificationCompleted,
        verificationFailed: (exp) {
          print(exp.message);
          _status = UserStatus.verificationError;
          print(_status);
          notifyListeners();
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
      );
//      UserData.profileData = await FirebaseAuth.instance.currentUser();
//      print("here" + UserData.profileData.toString());
    } catch (e) {
      _status = UserStatus.verificationError;
      notifyListeners();
      throw e;
    }
  }
}

class UserStatus {
  static get initialState => 'INIT';

  static get timedOut => 'TIMEDOUT';

  static get loggedIn => 'LOGGEDIN';

  static get authenticated => 'AUTHENTICATED';

  static get waitOtp => 'WAITOTP';

  static get wrongOtp => 'WRONGOTP';

  static get verificationError => 'UNKNOWNERROR';

  static get logInFailure => 'NOTIN';

  static get loginInProgress => 'INPROGRESS';
}
