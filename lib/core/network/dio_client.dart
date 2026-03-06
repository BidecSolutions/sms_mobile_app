/// DIO_CLIENT
/// The main configured Dio HTTP client used for all API calls.
/// Created once and injected via get_it into all repositories.
///
/// Configured with:
///   → Base URL from ApiConstants
///   → Connection and receive timeouts
///   → AuthInterceptor — attaches Sanctum token
///   → ErrorInterceptor — converts errors to typed failures
///   → PrettyDioLogger — logs requests/responses in debug mode
///
/// Usage in Repository:
///   final response = await dioClient.dio.post(ApiConstants.login, data: params);
///
/// Changes from original:
///   → Fixed validateStatus to accept ALL status codes including 500+
///     Previously 500+ errors bypassed ErrorInterceptor and were thrown raw
///     Now ALL errors pass through ErrorInterceptor for proper conversion
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

class DioClient {
  /// The configured Dio instance
  /// Access this to make API calls: dioClient.dio.get(...)
  late final Dio dio;

  /// Constructor — builds and configures the Dio instance
  /// [authInterceptor] — handles Sanctum token attachment and 401 redirect
  /// [errorInterceptor] — handles all error conversion to typed failures
  DioClient({
    required AuthInterceptor authInterceptor,
    required ErrorInterceptor errorInterceptor,
  }) {
    dio = Dio(_buildBaseOptions());
    _attachInterceptors(authInterceptor, errorInterceptor);
    AppLogger.info(
      'DioClient: Initialized with base URL: ${ApiConstants.baseUrl}',
    );
  }

  // ─── Base Options ────────────────────────────────────────────────────────

  /// Builds the base configuration for Dio
  /// Sets base URL, timeouts, and default headers
  BaseOptions _buildBaseOptions() {
    return BaseOptions(
      /// Base URL for all requests — from ApiConstants
      /// All endpoints are appended to this
      /// TODO: Update ApiConstants.baseUrl when switching to production
      baseUrl: ApiConstants.baseUrl,

      /// How long to wait when connecting to the server
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectTimeout,
      ),

      /// How long to wait for the server to send back data
      receiveTimeout: const Duration(
        milliseconds: ApiConstants.receiveTimeout,
      ),

      /// Default headers sent with every request
      /// Authorization header is added dynamically by AuthInterceptor
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      /// Follow redirects automatically
      followRedirects: true,

      /// Accept ALL status codes — including 500+
      /// This ensures every response passes through ErrorInterceptor
      /// ErrorInterceptor is responsible for converting all errors to typed failures
      /// Without this fix, 500+ errors would bypass ErrorInterceptor entirely
      validateStatus: (status) => status != null,
    );
  }

  // ─── Interceptors ────────────────────────────────────────────────────────

  /// Attaches all interceptors to the Dio instance
  /// Order matters — interceptors run in the order they are added:
  ///   1. AuthInterceptor  → runs first, attaches token BEFORE request
  ///   2. ErrorInterceptor → runs second, converts errors AFTER response
  ///   3. PrettyDioLogger  → runs last, logs everything for debugging
  void _attachInterceptors(
      AuthInterceptor authInterceptor,
      ErrorInterceptor errorInterceptor,
      ) {
    dio.interceptors.addAll([
      /// 1. AuthInterceptor — attaches Sanctum Bearer token to every request
      /// Also handles 401 responses by clearing storage and redirecting to login
      authInterceptor,

      /// 2. ErrorInterceptor — converts all DioExceptions to typed DioAppExceptions
      /// Handles: timeout, no internet, 401, 403, 404, 422, 500
      errorInterceptor,

      /// 3. PrettyDioLogger — logs all requests and responses in debug mode
      /// Automatically disabled in release builds via kDebugMode check
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
    ]);

    AppLogger.info(
      'DioClient: ${dio.interceptors.length} interceptors attached',
    );
  }
}