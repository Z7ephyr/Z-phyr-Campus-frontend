import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _studentIdKey = 'student_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

 
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

 
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

 
  Future<void> saveUserInfo({
    required String userId,
    required String studentId,
    required String userName,
    required String userEmail, 
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _studentIdKey, value: studentId);
    await _storage.write(key: _userNameKey, value: userName);
    await _storage.write(key: _userEmailKey, value: userEmail); 
  }

 
  Future<Map<String, String?>> getUserInfo() async {
    return {
      'userId': await _storage.read(key: _userIdKey),
      'studentId': await _storage.read(key: _studentIdKey),
      'userName': await _storage.read(key: _userNameKey),
      'userEmail': await _storage.read(key: _userEmailKey), 
    };
  }


  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}