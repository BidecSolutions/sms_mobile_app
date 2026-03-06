/// WEBSOCKET_SERVICE
/// Manages Laravel Reverb WebSocket connection using laravel_echo_null.
/// Handles connecting, disconnecting, and channel subscriptions.
///
/// Authentication:
///   Uses Sanctum token for private channel authentication
///   Token is read from SecureStorageService
///
/// Channel Types:
///   Public  → anyone can listen (no auth needed)
///   Private → requires Sanctum token authentication
///
/// Usage:
///   // Connect on login
///   await websocketService.connect(token);
///
///   // Listen to a private channel
///   websocketService.listenToPrivateChannel(
///     channel: 'homework.1',
///     event: 'HomeworkAssigned',
///     onEvent: (data) => print(data),
///   );
///
///   // Disconnect on logout
///   websocketService.disconnect();
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';
import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class WebSocketService {
  /// Laravel Echo instance
  /// Used to subscribe to channels and listen for events
  Echo? _echo;

  /// Pusher client instance
  /// The underlying WebSocket connection driver
  PusherClient? _pusherClient;

  /// Whether the WebSocket is currently connected
  bool _isConnected = false;

  /// Returns true if WebSocket is currently connected
  bool get isConnected => _isConnected;

  // ─── Connect ─────────────────────────────────────────────────────────────

  /// Connects to Laravel Reverb WebSocket server
  /// Called after successful login with Sanctum token
  /// [token] — Sanctum Bearer token for private channel auth
  Future<void> connect(String token) async {
    try {
      AppLogger.info('WebSocketService: Connecting to ${ApiConstants.socketUrl}...');

      /// Configure Pusher client options
      /// Reverb uses Pusher-compatible protocol
      final options = PusherOptions(
        /// WebSocket server host — from ApiConstants
        host: 'dev-api.revivefact.com',

        /// WebSocket port — from ApiConstants
        wsPort: ApiConstants.socketPort,

        /// Use secure connection (wss) in production
        /// TODO: Set to true when switching to production
        encrypted: false,

        /// Auth endpoint for private channels
        /// Laravel uses this to verify the Sanctum token
        auth: PusherAuth(
          '${ApiConstants.baseUrl}broadcasting/auth',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      /// Create Pusher client with Reverb app key
      _pusherClient = PusherClient(
        ApiConstants.socketAppKey,
        options,
        autoConnect: false,
        enableLogging: true,
      );

      /// Create Echo instance with Pusher connector
      _echo = Echo(
        broadcaster: EchoBroadcasterType.Pusher,
        client: _pusherClient,
      );

      /// Connect to WebSocket server
      _pusherClient?.connect();

      /// Listen for connection state changes
      _pusherClient?.onConnectionStateChange((state) {
        AppLogger.info(
          'WebSocketService: Connection state — ${state?.currentState}',
        );
        _isConnected = state?.currentState == 'connected';
      });

      /// Listen for connection errors
      _pusherClient?.onConnectionError((error) {
        AppLogger.error(
          'WebSocketService: Connection error — ${error?.message}',
        );
        _isConnected = false;
      });

      AppLogger.info('WebSocketService: Connected successfully');
    } catch (e) {
      AppLogger.error(
        'WebSocketService: Failed to connect',
        error: e,
      );
      _isConnected = false;
    }
  }

  // ─── Disconnect ──────────────────────────────────────────────────────────

  /// Disconnects from Laravel Reverb WebSocket server
  /// Called on logout — cleans up all subscriptions
  void disconnect() {
    try {
      _pusherClient?.disconnect();
      _echo = null;
      _pusherClient = null;
      _isConnected = false;
      AppLogger.info('WebSocketService: Disconnected successfully');
    } catch (e) {
      AppLogger.error(
        'WebSocketService: Failed to disconnect',
        error: e,
      );
    }
  }

  // ─── Public Channel ──────────────────────────────────────────────────────

  /// Listens to a PUBLIC channel event
  /// Public channels don't require authentication
  /// Use for: general announcements, public notifications
  ///
  /// Example:
  ///   websocketService.listenToChannel(
  ///     channel: 'announcements',
  ///     event: 'NewAnnouncement',
  ///     onEvent: (data) => print(data),
  ///   );
  void listenToChannel({
    required String channel,
    required String event,
    required Function(dynamic data) onEvent,
  }) {
    if (_echo == null) {
      AppLogger.warning(
        'WebSocketService: Cannot listen — not connected',
      );
      return;
    }

    try {
      _echo!.channel(channel).listen(event, (data) {
        AppLogger.debug(
          'WebSocketService: Event received — $channel.$event: $data',
        );
        onEvent(data);
      });
      AppLogger.info(
        'WebSocketService: Listening to public channel — $channel.$event',
      );
    } catch (e) {
      AppLogger.error(
        'WebSocketService: Failed to listen to channel $channel',
        error: e,
      );
    }
  }

  // ─── Private Channel ─────────────────────────────────────────────────────

  /// Listens to a PRIVATE channel event
  /// Private channels require Sanctum token authentication
  /// Use for: homework notifications, class updates, personal notifications
  ///
  /// Example:
  ///   websocketService.listenToPrivateChannel(
  ///     channel: 'student.1',
  ///     event: 'HomeworkAssigned',
  ///     onEvent: (data) => print(data),
  ///   );
  void listenToPrivateChannel({
    required String channel,
    required String event,
    required Function(dynamic data) onEvent,
  }) {
    if (_echo == null) {
      AppLogger.warning(
        'WebSocketService: Cannot listen — not connected',
      );
      return;
    }

    try {
      _echo!.private(channel).listen(event, (data) {
        AppLogger.debug(
          'WebSocketService: Private event received — $channel.$event: $data',
        );
        onEvent(data);
      });
      AppLogger.info(
        'WebSocketService: Listening to private channel — $channel.$event',
      );
    } catch (e) {
      AppLogger.error(
        'WebSocketService: Failed to listen to private channel $channel',
        error: e,
      );
    }
  }

  // ─── Leave Channel ───────────────────────────────────────────────────────

  /// Stops listening to a channel
  /// Call when leaving a screen that was listening to a channel
  /// Prevents memory leaks and unnecessary event processing
  void leaveChannel(String channel) {
    try {
      _echo?.leave(channel);
      AppLogger.info('WebSocketService: Left channel — $channel');
    } catch (e) {
      AppLogger.error(
        'WebSocketService: Failed to leave channel $channel',
        error: e,
      );
    }
  }
}