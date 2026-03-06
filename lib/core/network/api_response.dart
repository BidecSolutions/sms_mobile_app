/// API_RESPONSE
/// A generic wrapper for all API responses from the backend.
/// Every API call returns an ApiResponse<T> where T is the expected data type.
/// This ensures consistent response handling across the entire app.
///
/// TODO: Verify and update fromJson success detection when login API
///       response is shared. Current implementation checks for:
///       → json['success'] == true
///       → json['status'] == true
///       → json['status'] == 'success'
///       Update these conditions to match actual API response structure.
///
/// Usage in DataSource:
///   final response = await dio.post('/auth/login', data: params);
///   return ApiResponse<UserModel>.fromJson(
///     response.data,
///     (json) => UserModel.fromJson(json),
///   );
///
/// Usage in Repository:
///   if (response.success) {
///     return Right(response.data!);
///   } else {
///     return Left(ServerFailure(message: response.message));
///   }

class ApiResponse<T> {
  /// Whether the API call was successful
  final bool success;

  /// Human-readable message from the backend
  /// Contains error message on failure, success message on success
  final String message;

  /// The actual data returned by the API
  /// Null on failure
  final T? data;

  /// HTTP status code returned by the backend
  final int? statusCode;

  /// Validation errors returned by Laravel (422 responses)
  /// Example: {'email': ['The email is required']}
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.errors,
  });

  // ─── Factory Constructors ────────────────────────────────────────────────

  /// Creates a successful ApiResponse with data
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  /// Creates a failed ApiResponse with error message
  factory ApiResponse.failure({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  /// Creates an ApiResponse from raw JSON returned by the backend
  /// [fromJson] is a function that converts the data field to type T
  ///
  /// TODO: Update success detection conditions when login API response
  ///       is shared. Verify which field Laravel uses for success status.
  ///
  /// Example:
  ///   ApiResponse.fromJson(
  ///     response.data,
  ///     (json) => UserModel.fromJson(json),
  ///   );
  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJson,
      ) {
    /// TODO: Verify these conditions match actual API response structure
    /// Current checks: 'success' boolean OR 'status' boolean OR 'status' string
    /// Update when login API response JSON is shared
    final isSuccess = json['success'] == true ||
        json['status'] == true ||
        json['status'] == 'success';

    /// TODO: Verify 'data' field name matches actual API response
    /// Some Laravel APIs return data in 'result', 'payload' or other fields
    /// Update field name when login API response JSON is shared
    final responseData = json['data'];

    /// TODO: Verify 'message' field name matches actual API response
    final responseMessage = json['message'] as String? ?? '';

    /// TODO: Verify 'status_code' field exists or remove if not in response
    final responseStatusCode = json['status_code'] as int?;

    /// TODO: Verify 'errors' field name matches actual Laravel validation errors
    final responseErrors = json['errors'] as Map<String, dynamic>?;

    return ApiResponse<T>(
      success: isSuccess,
      message: responseMessage,
      data: isSuccess && responseData != null
          ? fromJson(responseData)
          : null,
      statusCode: responseStatusCode,
      errors: responseErrors,
    );
  }

  // ─── Helper Getters ──────────────────────────────────────────────────────

  /// Returns true if response failed
  bool get isFailure => !success;

  /// Returns true if response has validation errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Returns the first validation error message if available
  /// Used to show the first validation error below form fields
  String? get firstError {
    if (!hasErrors) return null;
    final firstKey = errors!.keys.first;
    final firstValue = errors![firstKey];
    if (firstValue is List) return firstValue.first.toString();
    return firstValue.toString();
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}