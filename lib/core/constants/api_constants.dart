/// API_CONSTANTS
/// Contains all API-related constants used throughout the app.
/// This is the single source of truth for all API-related values.
/// Endpoints will be added feature by feature as we build each screen.
class ApiConstants {
  ApiConstants._(); // Private constructor — prevents instantiation

  // ─── Base URL ────────────────────────────────────────────────────────────
  /// Base URL for all REST API requests
  static const String baseUrl = 'https://dev-api.revivefact.com/api/';

  // ─── WebSocket URL ───────────────────────────────────────────────────────
  /// Staging WebSocket URL for Laravel Reverb
  static const String socketUrl = 'ws://dev-api.revivefact.com:6002';

  /// Reverb App Key
  static const String socketAppKey = 'revivefact-staging-key';

  /// Reverb Port
  static const int socketPort = 6002;

  // ─── Timeouts ────────────────────────────────────────────────────────────
  /// Connection timeout in milliseconds
  static const int connectTimeout = 30000;

  /// Receive timeout in milliseconds
  static const int receiveTimeout = 30000;
}