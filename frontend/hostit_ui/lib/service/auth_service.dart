// ignore_for_file: file_names, avoid_web_libraries_in_flutter
import 'dart:convert';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import 'package:logger/logger.dart';

class AuthService {
  final Logger _logger = Logger();
  final String _baseUrl = UrlConfig.baseAuthUrl;

  String? getUserToken() {
    return html.window.localStorage['authToken'];
  }

  bool isTokenValid() {
    final String? token = getUserToken();
    if (token == null) {
      return false;
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      return false;
    }

    var payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));

    int tokenExpiration = jsonDecode(payload)['exp'] * 1000;
    return DateTime.now().millisecondsSinceEpoch < tokenExpiration;
  }

  Future<String?> logIn(User user) async {
    try {
      Map<String, String> jsonUser = user.toJsonLogin();
      final urlBackend = '$_baseUrl/login';

      final response = await http.post(
        Uri.parse(urlBackend),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "set7up",
        },
        body: jsonEncode(jsonUser),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        String? isTwoFactorRequired = jsonResponse['2fa_required'] ?? "";
        if (isTwoFactorRequired == 'true') {
          return '2fa is required';
        }
        String? authToken = jsonResponse['token'] ?? "";
        html.window.localStorage['authToken'] = authToken!;

        _logger.i('response:200 user logged in, body: ${response.body}');
        return null;
      } else {
        const errorMessage = 'Failed to sign in. Please check you credentials';
        _logger.e('Failed to sign in. Status code: ${response.statusCode}');
        return errorMessage;
      }
    } catch (e) {
      _logger.e('Error signing up user: $e');
      return 'An error occurred while signing in. Please try again.';
    }
  }

  Future<String> signUp(User user) async {
    try {
      final urlBackend = '$_baseUrl/register';

      final response = await http.post(
        Uri.parse(urlBackend),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "set7up",
        },
        body: jsonEncode(user.toJsonSignup()),
      );

      if (response.statusCode == 200) {
        _logger.i('User signed up and logged in, body: ${response.body}');
        return '';
      } else {
        final errorMessage =
            'Failed to sign up. Status code: ${response.statusCode}';
        _logger.e(errorMessage);
        return errorMessage;
      }
    } catch (e) {
      _logger.e('Error signing up user: $e');
      return 'An error occurred while signing up. Please try again.';
    }
  }

  void logout() {
    html.window.localStorage.remove('authToken');
    _logger.i("logged out");
  }
}
