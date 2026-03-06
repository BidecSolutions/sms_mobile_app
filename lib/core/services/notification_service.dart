/// NOTIFICATION_SERVICE
/// Manages Firebase Cloud Messaging (FCM) for push notifications.
/// Handles all 3 app states: foreground, background, and terminated.
///
/// Responsibilities:
///   → Initialize Firebase Messaging
///   → Request notification permissions from user
///   → Get and refresh FCM device token
///   → Handle foreground notifications (show local notification)
///   → Handle background notification taps (navigate to correct screen)
///   → Handle terminated app notification taps (navigate on launch)
///
/// Usage in main.dart:
///   await notificationService.initialize();
///
/// Notification tap navigation:
///   Notification data contains 'type' and 'id' fields
///   These are used to navigate to the correct screen
///   Example: {'type': 'homework', 'id': '123'} → HomeworkDetail screen
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_routes.dart';
import '../utils/app_logger.dart';

/// Background message handler
/// MUST be a top-level function (not inside a class)
/// Called when app is in background or terminated and notification arrives
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// Ensure Firebase is initialized in background isolate
  await Firebase.initializeApp();
  AppLogger.info(
    'NotificationService: Background message received — ${message.messageId}',
  );
}

class NotificationService {
  /// Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Flutter Local Notifications plugin
  /// Used to show notification banners when app is in foreground
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Navigator key to navigate from notification tap without BuildContext
  /// Must be the same instance used in go_router and main.dart
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationService({required this.navigatorKey});

  // ─── Initialize ──────────────────────────────────────────────────────────

  /// Initializes the entire notification service
  /// Call this once in main.dart before runApp()
  Future<void> initialize() async {
    AppLogger.info('NotificationService: Initializing...');

    /// Step 1 — Request notification permissions from user
    await _requestPermissions();

    /// Step 2 — Initialize local notifications for foreground display
    await _initializeLocalNotifications();

    /// Step 3 — Setup background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Step 4 — Handle foreground messages
    _handleForegroundMessages();

    /// Step 5 — Handle notification taps when app is in background
    _handleBackgroundNotificationTap();

    /// Step 6 — Handle notification taps when app was terminated
    await _handleTerminatedNotificationTap();

    /// Step 7 — Get and log FCM token
    await _getFCMToken();

    /// Step 8 — Listen for token refresh
    _listenForTokenRefresh();

    AppLogger.info('NotificationService: Initialized successfully');
  }

  // ─── Permissions ─────────────────────────────────────────────────────────

  /// Requests notification permissions from the user
  /// iOS requires explicit permission — Android 13+ also requires it
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    AppLogger.info(
      'NotificationService: Permission status — ${settings.authorizationStatus}',
    );
  }

  // ─── Local Notifications ─────────────────────────────────────────────────

  /// Initializes flutter_local_notifications
  /// Used to show notification banners when app is in foreground
  /// FCM does NOT show banners automatically when app is open
  Future<void> _initializeLocalNotifications() async {
    /// Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // App icon used for notification
    );

    /// iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      /// Called when user taps on a local notification
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    /// Create notification channel for Android
    /// Required for Android 8.0+ (API 26+)
    await _createAndroidNotificationChannel();

    AppLogger.debug('NotificationService: Local notifications initialized');
  }

  /// Creates Android notification channel
  /// Required for Android 8.0+ to show notifications
  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'sms_high_importance_channel', // Channel ID
      'SMS Notifications',           // Channel name shown in settings
      description: 'School Management System Notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation
    AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AppLogger.debug('NotificationService: Android notification channel created');
  }

  // ─── Foreground Messages ─────────────────────────────────────────────────

  /// Handles notifications when app is in FOREGROUND
  /// FCM doesn't show banners automatically when app is open
  /// We use flutter_local_notifications to show them manually
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info(
        'NotificationService: Foreground message — ${message.notification?.title}',
      );

      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
          data: message.data,
        );
      }
    });
  }

  /// Shows a local notification banner
  /// Called when a FCM message arrives while app is in foreground
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sms_high_importance_channel',
      'SMS Notifications',
      channelDescription: 'School Management System Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      title,
      body,
      details,
      payload: data.toString(), // Pass data for navigation on tap
    );
  }

  // ─── Notification Tap Handlers ───────────────────────────────────────────

  /// Called when user taps a local notification (foreground)
  void _onLocalNotificationTap(NotificationResponse response) {
    AppLogger.info(
      'NotificationService: Local notification tapped — ${response.payload}',
    );
    /// TODO: Parse payload and navigate to correct screen
    /// Will be implemented when notification types are defined
  }

  /// Handles notification tap when app is in BACKGROUND
  /// App is already running — just navigate to correct screen
  void _handleBackgroundNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info(
        'NotificationService: Background notification tapped — ${message.data}',
      );
      _navigateFromNotification(message.data);
    });
  }

  /// Handles notification tap when app was TERMINATED
  /// App launches from scratch — navigate after app is ready
  Future<void> _handleTerminatedNotificationTap() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.info(
        'NotificationService: Terminated notification tapped — ${initialMessage.data}',
      );
      /// Small delay to ensure app is fully initialized before navigating
      await Future.delayed(const Duration(seconds: 1));
      _navigateFromNotification(initialMessage.data);
    }
  }

  // ─── Navigation ──────────────────────────────────────────────────────────

  /// Navigates to the correct screen based on notification data
  /// Notification data must contain 'type' field to determine destination
  ///
  /// TODO: Update navigation cases when all features are built
  /// Expected notification data structure:
  ///   {'type': 'homework', 'id': '123'}
  ///   {'type': 'live_class', 'id': '456'}
  ///   {'type': 'notification', 'id': '789'}
  void _navigateFromNotification(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    AppLogger.info(
      'NotificationService: Navigating from notification — type: $type, id: $id',
    );

    final context = navigatorKey.currentContext;
    if (context == null) {
      AppLogger.error(
        'NotificationService: Cannot navigate — context is null',
      );
      return;
    }

    switch (type) {
    /// TODO: Add navigation cases as features are built
    /// Example:
    /// case 'homework':
    ///   context.push('${AppRoutes.homework}/$id');
    ///   break;
    /// case 'live_class':
    ///   context.push('${AppRoutes.liveClasses}/$id');
    ///   break;
      default:
      /// Default — navigate to notifications screen
        context.pushTo(AppRoutes.notifications);
        break;
    }
  }

  // ─── FCM Token ───────────────────────────────────────────────────────────

  /// Gets the FCM device token and logs it
  /// This token must be sent to your Laravel backend
  /// Backend uses it to send push notifications to this specific device
  ///
  /// TODO: Send token to backend when auth feature is built
  ///   Call an API endpoint to register device token after login
  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      AppLogger.info('NotificationService: FCM Token — $token');
      /// TODO: Save token and send to backend after login
      /// secureStorageService.saveFCMToken(token);
    } catch (e) {
      AppLogger.error(
        'NotificationService: Failed to get FCM token',
        error: e,
      );
    }
  }

  /// Listens for FCM token refresh
  /// Token can change — always keep backend updated with latest token
  void _listenForTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      AppLogger.info(
        'NotificationService: FCM Token refreshed — $newToken',
      );
      /// TODO: Send new token to backend when auth feature is built
    });
  }
}