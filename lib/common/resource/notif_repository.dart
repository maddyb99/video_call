import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/private/web_api_constants.dart';

class NotificationRepo {
  static Future<void> updateNotifToken(String uid,String token) async {
    
    if (uid == null) throw Exception('Invalid uid!');
    if (token == null) throw Exception('Invalid token!');
    var response = await http.post(
      "${WebApiInfo.apiUrl}/notif/",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
      body: {
        'uid':uid,
        'token':token,
      },
    );
    if (response.statusCode != 201)
      throw ("Bad API response! " + response.body);
  }

  static Future<void> PushNotif(String uid) async {
    if (uid == null) throw Exception('Invalid uid!');
    var response = await http.post(
      "${WebApiInfo.apiUrl}/notif/send",
      headers: {'Authorization': WebApiInfo.apiKey},
      body:{
        'uid':uid,
      }
    );
    if (response.statusCode != 201)
      throw ("Bad API response! " + response.body);
  }
  
}
