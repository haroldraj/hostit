import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class UserService {
  int getUserId() {
    var payload = _getPayload();
    int id = jsonDecode(payload)['id'];
    return id;
  }

  String getUsername() {
    var payload = _getPayload();
    String username = jsonDecode(payload)['username'];
    return username;
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
