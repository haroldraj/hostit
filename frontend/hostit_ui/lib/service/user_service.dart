import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:hostit_ui/models/user_model.dart';

class UserService {
  int getUserId() {
    var payload = _getPayload();
    int id = jsonDecode(payload)['id'];
    return id;
    //return 1;
  }

  String getUsername() {
    var payload = _getPayload();
    String username = jsonDecode(payload)['username'];
    return username;
    //return 'haroldraj';
  }

  String getEmail() {
    var payload = _getPayload();
    String email = jsonDecode(payload)['email'];
    return email;
    //return 'haroldraj';
  }

  User getUserDetails() {
    var payload = _getPayload();
    User user = User();
    user.email = getEmail();
    user.id = getUserId();
    user.name = getUsername();
    user.twoFactorEnabled = jsonDecode(payload)['twoFactorEnabled'];
    user.emailVerified = jsonDecode(payload)['emailVerified'];

    return user;
  }
}

String _getPayload() {
  final String? token = html.window.localStorage['authToken'];
  if (token != null) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return '';
    }
    var payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return payload;
  }
  return '';
}
