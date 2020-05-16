import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_call/common/model/user.dart';
import 'package:video_call/common/private/web_api_constants.dart';

class UserRepo {
  static Future<void> createUser(User data) async {
    var body = json.encode(data.toJson());
//    print(body);
    var response = await http.post(
      "${WebApiInfo.apiUrl}/user/",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 201)
      throw ("Bad API response! " + response.body);
  }

  static Future<List<dynamic>> multiUserExist(List<String> numbers) async {
    print('here i am');
    var body = jsonEncode({'numbers': numbers});
//    print(body);
    var response = await http.post(
      "${WebApiInfo.apiUrl}/user/exist/",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
      body: body,
    );
    var ret = jsonDecode(response.body);
    print(ret);
    return ret;
  }

  static Future<bool> userExists(String mobile) async {
    var response = await http.get(
      "${WebApiInfo.apiUrl}/user/exist/$mobile",
      headers: {
        'Authorization': WebApiInfo.apiKey,
        'content-type': 'application/json',
      },
//      body: body,
    );
    print(response.body);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  static Future<User> fetchUser(String uid) async {
    if (uid == null) throw Exception('Invalid uid!');
    var response = await http.get(
      "${WebApiInfo.apiUrl}/user/$uid",
      headers: {'Authorization': WebApiInfo.apiKey},
    );
    if (jsonDecode(response.body) is bool &&
        (jsonDecode(response.body) as bool) == false) return null;
    return User.fromJson(jsonDecode(response.body));
  }

  static Future<List<User>> fetchAllUsers() async {
    var response = await http.get(
      "${WebApiInfo.apiUrl}/user/",
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
      "${WebApiInfo.apiUrl}/user/${updatedUser.uid}",
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
      "${WebApiInfo.apiUrl}/user/$uid",
      headers: {'Authorization': WebApiInfo.apiKey},
    );
    print(response.statusCode);
  }
}
