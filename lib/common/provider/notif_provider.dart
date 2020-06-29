
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:video_call/common/resource/notif_repository.dart';
import 'package:video_call/common/resource/notification_manager.dart';
import 'package:video_call/video_call/init.dart';

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
//    if (Platform.isIOS) _iosPermission();

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.autoInitEnabled();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async =>NotificationManger.onMessage(message),
      onLaunch: (Map<String, dynamic> message) async =>NotificationManger.onLaunch(message),
      onResume: (Map<String, dynamic> message) async =>NotificationManger.onResume(message),
    );
  }

}

class NotificationStatusCodes{
  static get initialized=>'INITIALIZED';
  static get notInitialized=>'NOTINITIALIZED';

}
