import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  String? _pendingRoute;
  gsi.GoogleSignInAccount? _currentUser; 
  Map<String, dynamic>? _backendUser;

  late final gsi.GoogleSignIn _googleSignIn; 
  
  bool get isLoggedIn => _isLoggedIn;
  String? get pendingRoute => _pendingRoute;
  gsi.GoogleSignInAccount? get currentUser => _currentUser;
  Map<String, dynamic>? get backendUser => _backendUser;

  Future<void> init() async {
    _googleSignIn = gsi.GoogleSignIn(
      serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      scopes: ['email', 'profile'],
    );

    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken != null) {
      final success = await fetchUserProfile(accessToken);
      if (success) {
        _isLoggedIn = true;
        notifyListeners();
      } else {
        await logout();
      }
    }
  }

  Future<bool> fetchUserProfile(String accessToken) async {
    try {
      final url = Uri.parse('${dotenv.env['BASE_URL']}/profile');
      final response = await http.get(
        url,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _backendUser = data['data']; 
        return true;
      }
      return false;
    } catch (e) {
      print('Fetch profile error: $e');
      return false;
    }
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    try {
      final gsi.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
       if (googleUser == null) return false; 

      _currentUser = googleUser;
      
      final gsi.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final url = Uri.parse('${dotenv.env['BASE_URL']}/login/google');
        
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id_token': idToken}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final accessToken = data['data']['access_token'];
          final refreshToken = data['data']['refresh_token'];
          _backendUser = data['data']['user'];

          await _storage.write(key: 'access_token', value: accessToken);
          await _storage.write(key: 'refresh_token', value: refreshToken);

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

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print("Sign out error: $e");
    }
    
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    
    _isLoggedIn = false;
    _currentUser = null;
    _backendUser = null;
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

