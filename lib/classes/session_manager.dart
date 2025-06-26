import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/constants.dart';

class SessionManager {
  final GetStorage _storage;
  final Dio _dio;

  SessionManager(this._storage, this._dio);

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email, // Only store if absolutely necessary
    required DateTime expiresAt,
  }) async {
    await _storage.write('accessToken', accessToken);
    await _storage.write('refreshToken', refreshToken);
    await _storage.write('userId', userId);
    await _storage.write('email', email);
    await _storage.write('sessionExpiresAt', expiresAt.toIso8601String());
  }

  Future<bool> restoreSession() async {
    final accessToken = _storage.read<String>('accessToken');
    final refreshToken = _storage.read<String>('refreshToken');
    final expiresAtStr = _storage.read<String>('sessionExpiresAt');
    
    if (accessToken == null || refreshToken == null || expiresAtStr == null) {
      return false;
    }

    final expiresAt = DateTime.parse(expiresAtStr);
    if (expiresAt.isBefore(DateTime.now())) {
      // Session expired, try to refresh
      return await _refreshSession(refreshToken);
    }
    
    return true;
  }

  Future<bool> _refreshSession(String refreshToken) async {
    try {
      final response = await _dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200) {
        await saveSession(
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
          userId: response.data['userId'],
          email: response.data['email'],
          expiresAt: DateTime.parse(response.data['expiresAt']),
        );
        return true;
      }
    } catch (e) {
      log('Session refresh failed: $e');
    }
    return false;
  }

  Future<void> clearSession() async {
    await _storage.erase();
  }

  Future<bool> isLoggedIn() async {
    final hasToken = _storage.read<String>('accessToken') != null;
    if (!hasToken) return false;
    
    return await restoreSession();
  }
}
  final GetStorage _storage = GetStorage();
  final Dio _dio = Dio();

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    String? email,
    String? accountType,
  }) async {
    await _storage.write('accessToken', accessToken);
    await _storage.write('refreshToken', refreshToken);
    await _storage.write('userId', userId);
    
    if (email != null) await _storage.write('email', email);
    if (accountType != null) await _storage.write('account_type', accountType);
    
    // Set the authorization header for future requests
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<bool> isLoggedIn() async {
    final accessToken = _storage.read('accessToken');
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<String?> getAccessToken() async {
    return _storage.read('accessToken');
  }

  Future<String?> getRefreshToken() async {
    return _storage.read('refreshToken');
  }

  Future<String?> getUserId() async {
    return _storage.read('userId');
  }

  Future<void> restoreSession() async {
    if (await isLoggedIn()) {
      final accessToken = await getAccessToken();
      if (accessToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $accessToken';
        
        try {
          // Validate token with server
          await _dio.get('${EnvConstants.APP_API_ENDPOINT}/auth/validate');
        } catch (e) {
          await clearSession();
          throw Exception('Session validation failed');
        }
      }
    }
  }

  Future<void> clearSession() async {
    await _storage.remove('accessToken');
    await _storage.remove('refreshToken');
    await _storage.remove('userId');
    await _storage.remove('email');
    await _storage.remove('account_type');
    _dio.options.headers.remove('Authorization');
  }

  Future<bool> tryAutoLogin() async {
    if (!await isLoggedIn()) return false;
    
    try {
      await restoreSession();
      final userId = await getUserId();
      if (userId != null) {
        return true;
      }
      return false;
    } catch (e) {
      await clearSession();
      return false;
    }
  }