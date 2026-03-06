/// FAILURE
/// Defines all possible failure/error types in the app.
/// In Clean Architecture, we never pass raw exceptions to the UI.
/// Every error is converted to a typed Failure object.
///
/// Usage in Repository:
///   try {
///     final result = await dataSource.login(params);
///     return Right(result);
///   } on ServerException catch (e) {
///     return Left(ServerFailure(message: e.message));
///   } on NoInternetException {
///     return Left(NoInternetFailure());
///   }
///
/// Usage in Cubit:
///   result.fold(
///     (failure) => emit(AuthError(failure.message)),
///     (user) => emit(AuthSuccess(user)),
///   );

/// Base class for all failures
/// Every failure type must extend this class
abstract class Failure {
  /// Human-readable error message shown to the user
  final String message;

  const Failure({required this.message});
}

// ─── Network Failures ────────────────────────────────────────────────────────

/// No internet connection available
/// Shown when device is offline
class NoInternetFailure extends Failure {
  const NoInternetFailure()
      : super(message: 'No internet connection. Please check your network.');
}

/// Request timed out
/// Shown when server takes too long to respond
class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super(message: 'Request timed out. Please try again.');
}

// ─── Server Failures ─────────────────────────────────────────────────────────

/// General server error (500)
/// Shown when backend returns an unexpected error
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Unauthorized error (401)
/// Shown when Sanctum token is invalid or expired
/// App will redirect to login screen
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super(message: 'Session expired. Please login again.');
}

/// Forbidden error (403)
/// Shown when user doesn't have permission for an action
class ForbiddenFailure extends Failure {
  const ForbiddenFailure()
      : super(message: 'You do not have permission to perform this action.');
}

/// Not found error (404)
/// Shown when requested resource doesn't exist
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'The requested resource was not found.'});
}

/// Validation error (422)
/// Shown when backend returns validation errors
/// Contains field-specific error messages from Laravel
class ValidationFailure extends Failure {
  /// Map of field name to error message
  /// Example: {'email': 'The email has already been taken'}
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
  });
}

// ─── Cache Failures ──────────────────────────────────────────────────────────

/// Local cache/storage error
/// Shown when secure storage read/write fails
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local storage error. Please try again.'});
}

// ─── Unknown Failures ────────────────────────────────────────────────────────

/// Unknown or unexpected error
/// Fallback for any error we didn't anticipate
class UnknownFailure extends Failure {
  const UnknownFailure()
      : super(message: 'Something went wrong. Please try again.');
}