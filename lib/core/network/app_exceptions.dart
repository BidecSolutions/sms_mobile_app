/// APP_EXCEPTIONS
/// Defines all exceptions thrown by data sources.
/// These are caught by repositories and converted into Failure objects.
///
/// Flow:
///   DataSource → throws AppException
///   Repository → catches AppException → returns Left(Failure)
///   Cubit      → receives Failure → emits error state
///   UI         → shows error message
///
/// Exception to Failure mapping:
///   ServerException      → ServerFailure
///   UnauthorizedException → UnauthorizedFailure
///   ValidationException  → ValidationFailure
///   NotFoundException    → NotFoundFailure
///   NoInternetException  → NoInternetFailure
///   TimeoutException     → TimeoutFailure
///   CacheException       → CacheFailure
///   UnknownException     → UnknownFailure

// ─── Base Exception ──────────────────────────────────────────────────────────

/// Base class for all exceptions thrown by data sources
/// Every exception type must extend this class
abstract class AppException implements Exception {
  /// Human-readable error message
  final String message;

  const AppException({required this.message});

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Network Exceptions ──────────────────────────────────────────────────────

/// Thrown when device has no internet connection
/// Maps to → NoInternetFailure
class NoInternetException extends AppException {
  const NoInternetException()
      : super(message: 'No internet connection. Please check your network.');
}

/// Thrown when request times out
/// Maps to → TimeoutFailure
class TimeoutException extends AppException {
  const TimeoutException()
      : super(message: 'Request timed out. Please try again.');
}

// ─── Server Exceptions ───────────────────────────────────────────────────────

/// Thrown when server returns a 500 error
/// Maps to → ServerFailure
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
  });
}

/// Thrown when server returns 401 Unauthorized
/// Sanctum token is invalid or expired
/// Maps to → UnauthorizedFailure
class UnauthorizedException extends AppException {
  const UnauthorizedException()
      : super(message: 'Session expired. Please login again.');
}

/// Thrown when server returns 403 Forbidden
/// User does not have permission for this action
/// Maps to → ForbiddenFailure
class ForbiddenException extends AppException {
  const ForbiddenException()
      : super(message: 'You do not have permission to perform this action.');
}

/// Thrown when server returns 404 Not Found
/// Requested resource does not exist
/// Maps to → NotFoundFailure
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
  });
}

/// Thrown when server returns 422 Validation Error
/// Laravel returns field-specific validation errors
/// Maps to → ValidationFailure
class ValidationException extends AppException {
  /// Map of field name to list of error messages
  /// Example: {'email': ['The email has already been taken']}
  final Map<String, dynamic>? errors;

  const ValidationException({
    required super.message,
    this.errors,
  });

  /// Returns the first validation error message
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstKey = errors!.keys.first;
    final firstValue = errors![firstKey];
    if (firstValue is List) return firstValue.first.toString();
    return firstValue.toString();
  }
}

// ─── Cache Exceptions ────────────────────────────────────────────────────────

/// Thrown when local secure storage read/write fails
/// Maps to → CacheFailure
class CacheException extends AppException {
  const CacheException({
    super.message = 'Local storage error. Please try again.',
  });
}

// ─── Unknown Exceptions ──────────────────────────────────────────────────────

/// Thrown for any unexpected error not covered above
/// Maps to → UnknownFailure
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Something went wrong. Please try again.',
  });
}