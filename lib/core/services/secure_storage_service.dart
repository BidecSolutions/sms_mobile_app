/// SECURE_STORAGE_SERVICE
/// A clean wrapper around flutter_secure_storage.
/// Provides typed methods for all auth-related storage operations.
/// All keys are defined in AppConstants — never hardcoded here.
///
/// Stored Data:
///   → auth_token  : Sanctum Bearer token
///   → user_role   : 'student' | 'parent' | 'teacher'
///   → user_id     : User's ID from API
///   → user_name   : User's display name
///
/// Usage:
///   final token = await secureStorageService.getToken();
///   await secureStorageService.saveToken(token);
///   await secureStorageService.clearAll(); // on logout
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

class SecureStorageService {
  /// flutter_secure_storage instance
  /// Injected via constructor for testability
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  // ─── Token ───────────────────────────────────────────────────────────────

  /// Saves Sanctum Bearer token to secure storage
  /// Called after successful login
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(
        key: AppConstants.tokenKey,
        value: token,
      );
      AppLogger.debug('SecureStorageService: Token saved successfully');
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to save token', error: e);
      rethrow;
    }
  }

  /// Retrieves Sanctum Bearer token from secure storage
  /// Returns null if no token is stored
  /// Used by AuthInterceptor to attach token to every request
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      AppLogger.debug(
        'SecureStorageService: Token ${token != null ? 'found' : 'not found'}',
      );
      return token;
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to read token', error: e);
      return null;
    }
  }

  /// Returns true if a token exists in secure storage
  /// Used by Splash screen to determine if user is logged in
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ─── Role ────────────────────────────────────────────────────────────────

  /// Saves user role to secure storage
  /// Role is returned by API after login: 'student' | 'parent' | 'teacher'
  /// Used to determine which dashboard to show
  Future<void> saveRole(String role) async {
    try {
      await _storage.write(
        key: AppConstants.roleKey,
        value: role,
      );
      AppLogger.debug('SecureStorageService: Role saved — $role');
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to save role', error: e);
      rethrow;
    }
  }

  /// Retrieves user role from secure storage
  /// Returns null if no role is stored
  Future<String?> getRole() async {
    try {
      return await _storage.read(key: AppConstants.roleKey);
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to read role', error: e);
      return null;
    }
  }

  // ─── User ID ─────────────────────────────────────────────────────────────

  /// Saves user ID to secure storage
  /// Used for API calls that require user identification
  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(
        key: AppConstants.userIdKey,
        value: userId,
      );
      AppLogger.debug('SecureStorageService: User ID saved — $userId');
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to save user ID', error: e);
      rethrow;
    }
  }

  /// Retrieves user ID from secure storage
  /// Returns null if no user ID is stored
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: AppConstants.userIdKey);
    } catch (e) {
      AppLogger.error('SecureStorageService: Failed to read user ID', error: e);
      return null;
    }
  }

  // ─── User Name ───────────────────────────────────────────────────────────

  /// Saves user display name to secure storage
  /// Used for displaying user name in UI without extra API calls
  Future<void> saveUserName(String userName) async {
    try {
      await _storage.write(
        key: AppConstants.userNameKey,
        value: userName,
      );
      AppLogger.debug('SecureStorageService: User name saved — $userName');
    } catch (e) {
      AppLogger.error(
        'SecureStorageService: Failed to save user name',
        error: e,
      );
      rethrow;
    }
  }

  /// Retrieves user display name from secure storage
  /// Returns null if no user name is stored
  Future<String?> getUserName() async {
    try {
      return await _storage.read(key: AppConstants.userNameKey);
    } catch (e) {
      AppLogger.error(
        'SecureStorageService: Failed to read user name',
        error: e,
      );
      return null;
    }
  }

  // ─── Save All ────────────────────────────────────────────────────────────

  /// Saves all auth data at once after successful login
  /// Called by AuthRepository after successful login API response
  /// Saves token, role, userId and userName in one operation
  Future<void> saveAuthData({
    required String token,
    required String role,
    required String userId,
    required String userName,
  }) async {
    try {
      await Future.wait([
        saveToken(token),
        saveRole(role),
        saveUserId(userId),
        saveUserName(userName),
      ]);
      AppLogger.info('SecureStorageService: All auth data saved successfully');
    } catch (e) {
      AppLogger.error(
        'SecureStorageService: Failed to save auth data',
        error: e,
      );
      rethrow;
    }
  }

  // ─── Clear ───────────────────────────────────────────────────────────────

  /// Clears ALL stored auth data from secure storage
  /// Called on logout — user must login again after this
  Future<void> clearAll() async {
    try {
      await Future.wait([
        _storage.delete(key: AppConstants.tokenKey),
        _storage.delete(key: AppConstants.roleKey),
        _storage.delete(key: AppConstants.userIdKey),
        _storage.delete(key: AppConstants.userNameKey),
      ]);
      AppLogger.info('SecureStorageService: All auth data cleared — user logged out');
    } catch (e) {
      AppLogger.error(
        'SecureStorageService: Failed to clear auth data',
        error: e,
      );
      rethrow;
    }
  }
}