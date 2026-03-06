/// INJECTION_CONTAINER
/// Single source of truth for all dependency registrations.
/// Uses get_it as a service locator — register once, inject anywhere.
///
/// Registration Types:
///   → registerSingleton     — created once, lives forever (services, clients)
///   → registerLazySingleton — created once on first use (repositories)
///   → registerFactory       — new instance every time (cubits)
///
/// Usage anywhere in app:
///   final dioClient = getIt<DioClient>();
///   final storageService = getIt<SecureStorageService>();
///
/// Setup:
///   Call setupDependencies() once in main.dart before runApp()
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/error_interceptor.dart';
import '../services/notification_service.dart';
import '../services/secure_storage_service.dart';
import '../services/websocket_service.dart';
import '../utils/app_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/network_info.dart';

/// Global get_it instance
/// Use this to access any registered dependency anywhere in the app
final getIt = GetIt.instance;

/// Sets up all dependencies
/// Called once in main.dart before runApp()
/// Order matters — dependencies must be registered before they are used
Future<void> setupDependencies({
  required GlobalKey<NavigatorState> navigatorKey,
}) async {
  AppLogger.info('DI: Setting up dependencies...');

  // ─── External ──────────────────────────────────────────────────────────

  /// Flutter Secure Storage instance
  /// Used by SecureStorageService to read/write token and user data
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  // ─── Core Services ─────────────────────────────────────────────────────

  /// SecureStorageService — wrapper around FlutterSecureStorage
  /// Singleton — same instance used everywhere token is needed
  getIt.registerSingleton<SecureStorageService>(
    SecureStorageService(getIt<FlutterSecureStorage>()),
  );

  /// NotificationService — manages FCM push notifications
  /// Singleton — initialized once, used throughout app lifecycle
  getIt.registerSingleton<NotificationService>(
    NotificationService(navigatorKey: navigatorKey),
  );

  /// WebSocketService — manages Laravel Reverb WebSocket connection
  /// Singleton — one connection shared across all features
  getIt.registerSingleton<WebSocketService>(
    WebSocketService(),
  );

  // ─── Network ───────────────────────────────────────────────────────────

  /// NetworkInfo — checks internet connectivity
  /// Singleton — shared across all repositories
  getIt.registerSingleton<Connectivity>(
    Connectivity(),
  );

  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(getIt<Connectivity>()),
  );

  /// AuthInterceptor — attaches Sanctum token to every request
  /// Depends on SecureStorageService + navigatorKey for 401 redirect
  getIt.registerSingleton<AuthInterceptor>(
    AuthInterceptor(
      storageService: getIt<SecureStorageService>(),
      navigatorKey: navigatorKey,
    ),
  );

  /// ErrorInterceptor — converts DioExceptions to typed failures
  /// No dependencies — pure error conversion
  getIt.registerSingleton<ErrorInterceptor>(
    ErrorInterceptor(),
  );

  /// DioClient — main HTTP client used by all repositories
  /// Depends on AuthInterceptor + ErrorInterceptor
  getIt.registerSingleton<DioClient>(
    DioClient(
      authInterceptor: getIt<AuthInterceptor>(),
      errorInterceptor: getIt<ErrorInterceptor>(),
    ),
  );

  AppLogger.info('DI: All dependencies registered successfully');
}