import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/privateConstants.dart';

class UserRepo {
  static Future<void> createUser(User data) async {
    var body = json.encode(data.toJson());
//    print(body);
    var response = await http.post(
      "${WebApiInfo.apiURL}/user/",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 201)
      throw ("Bad API response! " + response.body);
  }

  static Future<User> fetchUser(String uid) async {
    if (uid == null) throw Exception('Invalid uid!');
    var response = await http.get(
      "${WebApiInfo.apiURL}/user/$uid",
      headers: {'Authorization': WebApiInfo.apiKey},
    );
//    print(response.body);
    if (jsonDecode(response.body) is bool &&
        (jsonDecode(response.body) as bool) == false) return User();
    return User.fromJson(jsonDecode(response.body));
  }

  static Future<List<User>> fetchAllUsers() async {
    var response = await http.get(
      "${WebApiInfo.apiURL}/user/",
      headers: {'Authorization': WebApiInfo.apiKey},
    );
    var userList = jsonDecode(response.body) as List;
    var ret = [];
    userList.forEach((element) => ret.add(User.fromJson(element)));
    print(ret);
    return ret;
  }

  static Future<void> updateUser(User updatedUser) async {
    if (updatedUser.uid == null) throw Exception('Invalid uid!');
    var response = await http.patch(
      "${WebApiInfo.apiURL}/user/${updatedUser.uid}",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
      body: json.encode(updatedUser.toJson()),
    );
    print(response.statusCode);
  }

  static void deleteUser(String uid) async {
    if (uid == null) throw Exception('Invalid uid!');
    var response = await http.delete(
      "${WebApiInfo.apiURL}/user/$uid",
      headers: {'Authorization': WebApiInfo.apiKey},
    );
    print(response.statusCode);
  }
}
