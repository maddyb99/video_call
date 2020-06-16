
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:video_call/common/resource/notif_repository.dart';

class NotificationProvider extends ChangeNotifier{
  NotificationProvider(){
    initialize();
  }

  String _notifToken;
  FirebaseMessaging _firebaseMessaging;
  String _status;

  String get status=>status;

  set status(String s)=>_status=s;

  String get notifToken {
    if(_notifToken.isNotEmpty)
      return _notifToken;
    else
      status=NotificationStatusCodes.notInitialized;
      return"";
  }

  void initialize(){
    _firebaseMessaging=FirebaseMessaging();
    _notifToken="";
    _configureNotifications();
    _getToken();
    status=NotificationStatusCodes.initialized;
    print(notifToken);
  }

  Future<void> updateToken(String uid)async{
    if (notifToken.length==0)
      initialize();
    await NotificationRepo.updateNotifToken(uid,notifToken);
  }

  void _getToken(){
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _notifToken=token;
      print(_notifToken);
    });
  }

  void _configureNotifications(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
  }

}

class NotificationStatusCodes{
  static get initialized=>'INITIALIZED';
  static get notInitialized=>'NOTINITIALIZED';

}
