import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _pendingRoute;
  GoogleSignInAccount? _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleInitialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get pendingRoute => _pendingRoute;
  GoogleSignInAccount? get currentUser => _currentUser;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    try {
      if (!_isGoogleInitialized) {
        await _googleSignIn.initialize(
          serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
        );
        _isGoogleInitialized = true;
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      _currentUser = googleUser;
      
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final url = Uri.parse('${dotenv.env['BASE_URL']}/login/google');
        print('Calling backend: $url');
        
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id_token': idToken}),
        );

        if (response.statusCode == 200) {
          print('Google Login Success: ${response.body}');
          _isLoggedIn = true;
          notifyListeners();
          return true;
        } else {
          print('Backend Login Failed: ${response.statusCode} - ${response.body}');
          return false;
        }
      }
    } catch (error) {
      print('Google Sign In Error: $error');
      return false;
    }
    return false;
  }

  void logout() async {
    try {
      if (!_isGoogleInitialized) {
        await _googleSignIn.initialize(
           serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
        );
         _isGoogleInitialized = true;
      }
      await _googleSignIn.signOut();
    } catch (e) {
      print("Sign out error: $e");
    }
    _isLoggedIn = false;
    _currentUser = null;
    _pendingRoute = null;
    notifyListeners();
  }

  void setPendingRoute(String? route) {
    _pendingRoute = route;
  }

  void clearPendingRoute() {
    _pendingRoute = null;
  }
}

