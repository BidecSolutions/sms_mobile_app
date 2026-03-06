/// NETWORK_INFO
/// Checks device internet connectivity before making API calls.
/// Uses connectivity_plus package to detect network status.
/// An abstract class is used to allow easy mocking in unit tests.
///
/// Usage in Repository:
///   if (!await networkInfo.isConnected) {
///     return Left(NoInternetFailure());
///   }
///   // proceed with API call
import 'package:connectivity_plus/connectivity_plus.dart';

// ─── Abstract Class ──────────────────────────────────────────────────────────

/// Abstract contract for network connectivity checking
/// Implemented by [NetworkInfoImpl]
/// Can be mocked in tests with a fake implementation
abstract class NetworkInfo {
  /// Returns true if device has an active internet connection
  Future<bool> get isConnected;
}

// ─── Implementation ──────────────────────────────────────────────────────────

/// Real implementation of [NetworkInfo] using connectivity_plus
/// Registered in dependency injection as a singleton
class NetworkInfoImpl implements NetworkInfo {
  /// connectivity_plus instance injected via constructor
  final Connectivity connectivity;

  const NetworkInfoImpl(this.connectivity);

  /// Checks current network connectivity status
  /// Returns true if connected to WiFi, mobile data, or ethernet
  /// Returns false if no connection is available
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();

    /// connectivity_plus returns a list of ConnectivityResult
    /// We check if any of them is not 'none'
    return result.any(
          (status) => status != ConnectivityResult.none,
    );
  }
}