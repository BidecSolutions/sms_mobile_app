/// AUTH_INTERCEPTOR
/// A Dio interceptor that automatically manages Sanctum token authentication.
///
/// BEFORE every request:
///   → Reads Sanctum token from flutter_secure_storage
///   → Attaches 'Authorization: Bearer {token}' header
///   → Attaches 'Accept: application/json' header
///
/// AFTER every response:
///   → If 401 Unauthorized → clears all stored data → redirects to login
///   → If other status → passes response through normally
///
/// This interceptor is attached to DioClient and runs automatically.
/// No need to manually add headers in any repository or datasource.
///
/// Changes from original:
///   → Fixed 401 redirect to use go_router instead of pushNamedAndRemoveUntil
///     Navigator named routes don't work with go_router
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../utils/app_logger.dart';

class AuthInterceptor extends Interceptor {
  /// Secure storage instance to read the Sanctum token
  final FlutterSecureStorage secureStorage;

  /// Navigator key to access context for go_router navigation
  /// Used to redirect to login without needing a BuildContext directly
  /// This key must be the same instance passed to GoRouter in main.dart
  final GlobalKey<NavigatorState> navigatorKey;

  const AuthInterceptor({
    required this.secureStorage,
    required this.navigatorKey,
  });

  // ─── On Request ──────────────────────────────────────────────────────────

  /// Called automatically BEFORE every API request is sent
  /// Attaches Sanctum token and required headers
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Read Sanctum token from secure storage
    final token = await secureStorage.read(key: AppConstants.tokenKey);

    // Attach standard headers required by Laravel backend
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Attach Sanctum Bearer token if available
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.debug('AuthInterceptor: Token attached to request');
    } else {
      AppLogger.warning(
        'AuthInterceptor: No token found — sending request without auth',
      );
    }

    // Continue with the request
    return handler.next(options);
  }

  // ─── On Response ─────────────────────────────────────────────────────────

  /// Called automatically AFTER every successful API response
  /// Passes response through without modification
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      'AuthInterceptor: Response ${response.statusCode} from ${response.requestOptions.path}',
    );
    return handler.next(response);
  }

  // ─── On Error ────────────────────────────────────────────────────────────

  /// Called automatically when an API request fails
  /// Handles 401 Unauthorized — clears storage and redirects to login
  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401) {
      AppLogger.warning(
        'AuthInterceptor: 401 Unauthorized — clearing storage and redirecting to login',
      );

      // Clear all stored auth data from secure storage
      await secureStorage.delete(key: AppConstants.tokenKey);
      await secureStorage.delete(key: AppConstants.roleKey);
      await secureStorage.delete(key: AppConstants.userIdKey);
      await secureStorage.delete(key: AppConstants.userNameKey);

      // Redirect to login screen using go_router
      // We access the context via navigatorKey since we have no BuildContext here
      // context.go() clears entire navigation stack — user cannot go back to previous screen
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.go(AppRoutes.login);
        AppLogger.info('AuthInterceptor: Redirected to login screen');
      } else {
        AppLogger.error(
          'AuthInterceptor: Could not redirect — navigatorKey context is null',
        );
      }
    }

    // Continue with the error so error_interceptor can also handle it
    return handler.next(err);
  }
}