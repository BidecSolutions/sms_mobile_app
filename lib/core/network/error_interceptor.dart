/// ERROR_INTERCEPTOR
/// A Dio interceptor that catches all API errors and converts them
/// into typed DioAppExceptions that repositories can handle consistently.
///
/// Error handling flow:
///   DioException → ErrorInterceptor → DioAppException → Repository → Failure
///
/// This interceptor works alongside AuthInterceptor:
///   AuthInterceptor handles 401 redirect to login
///   ErrorInterceptor handles converting ALL errors to typed exceptions
///
/// NOTE: DioAppException is different from AppException in app_exceptions.dart
///   DioAppException → wraps a Failure, used internally by Dio interceptor
///   AppException    → base class for data source exceptions
import 'package:dio/dio.dart';
import '../utils/app_logger.dart';
import 'failure.dart';

// ─── Dio App Exception ───────────────────────────────────────────────────────

/// Internal exception used only by ErrorInterceptor
/// Wraps a Failure object to pass through Dio's error handling
/// Different from AppException in app_exceptions.dart
class DioAppException implements Exception {
  /// The typed failure associated with this exception
  final Failure failure;

  const DioAppException(this.failure);

  @override
  String toString() => 'DioAppException: ${failure.message}';
}

// ─── Error Interceptor ───────────────────────────────────────────────────────

/// Dio interceptor that handles all API errors
/// Converts DioException into typed DioAppException with appropriate Failure
class ErrorInterceptor extends Interceptor {
  // ─── On Error ──────────────────────────────────────────────────────────

  /// Called automatically when any API request fails
  /// Converts DioException to typed DioAppException
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ErrorInterceptor: ${err.type} — ${err.message}',
      error: err.error,
      stackTrace: err.stackTrace,
    );

    // Convert DioException to typed DioAppException
    final dioAppException = _handleError(err);

    // Reject with our typed exception
    // Repositories will catch DioAppException and convert to Failure
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: dioAppException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  // ─── Error Handler ───────────────────────────────────────────────────────

  /// Converts a [DioException] into a typed [DioAppException]
  DioAppException _handleError(DioException err) {
    switch (err.type) {

    // ── No Internet ────────────────────────────────────────────────────
      case DioExceptionType.connectionError:
        AppLogger.warning('ErrorInterceptor: No internet connection');
        return const DioAppException(NoInternetFailure());

    // ── Timeout ────────────────────────────────────────────────────────
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        AppLogger.warning('ErrorInterceptor: Request timed out');
        return const DioAppException(TimeoutFailure());

    // ── Server Response Errors ─────────────────────────────────────────
      case DioExceptionType.badResponse:
        return _handleResponseError(err.response);

    // ── Request Cancelled ──────────────────────────────────────────────
      case DioExceptionType.cancel:
        AppLogger.warning('ErrorInterceptor: Request was cancelled');
        return const DioAppException(UnknownFailure());

    // ── Unknown ────────────────────────────────────────────────────────
      default:
        AppLogger.error('ErrorInterceptor: Unknown error — ${err.message}');
        return const DioAppException(UnknownFailure());
    }
  }

  // ─── Response Error Handler ──────────────────────────────────────────────

  /// Handles HTTP status code errors from the server
  DioAppException _handleResponseError(Response? response) {
    if (response == null) {
      return const DioAppException(UnknownFailure());
    }

    // Extract error message from Laravel response
    // Laravel returns errors in 'message' field
    final message = _extractMessage(response.data);
    final errors = _extractErrors(response.data);

    AppLogger.error(
      'ErrorInterceptor: HTTP ${response.statusCode} — $message',
    );

    switch (response.statusCode) {

    // ── 401 Unauthorized ───────────────────────────────────────────────
    /// AuthInterceptor handles the redirect to login
    /// ErrorInterceptor just creates the failure object
      case 401:
        return const DioAppException(UnauthorizedFailure());

    // ── 403 Forbidden ──────────────────────────────────────────────────
      case 403:
        return const DioAppException(ForbiddenFailure());

    // ── 404 Not Found ──────────────────────────────────────────────────
      case 404:
        return DioAppException(NotFoundFailure(message: message));

    // ── 422 Validation Error ───────────────────────────────────────────
    /// Laravel returns field-specific validation errors
      case 422:
        return DioAppException(
          ValidationFailure(message: message, errors: errors),
        );

    // ── 500 Server Error ───────────────────────────────────────────────
      case 500:
        return DioAppException(
          ServerFailure(message: 'Server error. Please try again later.'),
        );

    // ── Other Status Codes ─────────────────────────────────────────────
      default:
        return DioAppException(ServerFailure(message: message));
    }
  }

  // ─── Helper Methods ──────────────────────────────────────────────────────

  /// Extracts error message from Laravel response body
  /// Laravel typically returns: {'message': 'Error message here'}
  String _extractMessage(dynamic data) {
    if (data == null) return 'Something went wrong';
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }

  /// Extracts validation errors from Laravel 422 response
  /// Laravel returns: {'errors': {'field': ['error message']}}
  Map<String, dynamic>? _extractErrors(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['errors'] as Map<String, dynamic>?;
    }
    return null;
  }
}