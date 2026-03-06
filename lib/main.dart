/// MAIN
/// Entry point of the SMS School Management System app.
/// Initializes all core services before running the app.
///
/// Boot Order:
///   1. Firebase initialization
///   2. Dependency injection setup (get_it)
///   3. Notification service initialization (FCM)
///   4. App runs with router, theme, localizations
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_routes.dart';
import 'core/di/injection_container.dart';
import 'core/services/notification_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';

/// Global navigator key
/// Shared across go_router, AuthInterceptor, NotificationService
/// Allows navigation from anywhere without BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  /// Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  /// Lock app to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Step 1 — Initialize Firebase
  /// Must be done before any Firebase service is used
  await Firebase.initializeApp();
  AppLogger.info('Main: Firebase initialized');

  /// Step 2 — Setup all dependencies via get_it
  /// Must be done before accessing any service
  await setupDependencies(navigatorKey: navigatorKey);
  AppLogger.info('Main: Dependencies registered');

  /// Step 3 — Initialize notification service
  /// Sets up FCM, local notifications, permission requests
  await getIt<NotificationService>().initialize();
  AppLogger.info('Main: Notification service initialized');

  /// Run the app
  runApp(const SmsApp());
}

// ─── App Widget ──────────────────────────────────────────────────────────────

class SmsApp extends StatelessWidget {
  const SmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      /// TODO: Update with real Figma frame size when shared
      /// Open Figma → click on any screen frame → check W × H on right panel
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          /// App title
          title: 'SMS',

          /// Hide debug banner
          debugShowCheckedModeBanner: false,

          /// Theme — uses all our AppColors, AppTextStyles constants
          theme: AppTheme.lightTheme,

          /// Router — go_router with route guards
          routerConfig: _router,

          /// Localization — English + Arabic (RTL)
          localizationsDelegates: const [
            // TODO: Add generated localization delegates when arb files are ready
            // AppLocalizations.delegate,
            // GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
        );
      },
    );
  }
}

// ─── Router ──────────────────────────────────────────────────────────────────

/// go_router configuration
/// All routes are defined here with guards
/// Route guard checks token → redirects to login or dashboard
final GoRouter _router = GoRouter(
  /// Navigator key — must be the same global key used everywhere
  navigatorKey: navigatorKey,

  /// Initial route — splash screen
  initialLocation: AppRoutes.splash,

  /// Route guard — runs before every navigation
  /// Checks if user is logged in and redirects accordingly
  redirect: (context, state) async {
    final storageService = getIt<SecureStorageService>();
    final hasToken = await storageService.hasToken();
    final currentPath = state.uri.path;

    /// If user has no token and is not on login screen → redirect to login
    if (!hasToken && currentPath != AppRoutes.login) {
      AppLogger.info('Router: No token — redirecting to login');
      return AppRoutes.login;
    }

    /// If user has token and is on login or splash → redirect to dashboard
    if (hasToken &&
        (currentPath == AppRoutes.login ||
            currentPath == AppRoutes.splash)) {
      AppLogger.info('Router: Token found — redirecting to dashboard');
      return AppRoutes.dashboard;
    }

    /// No redirect needed
    return null;
  },

  /// All app routes
  routes: [
    /// Splash screen — shown on app launch
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const _SplashScreen(),
    ),

    /// Login screen — shown when no token found
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Login Screen',
        subtitle: 'Will be built with Figma',
      ),
    ),

    /// Children list — shown after parent login
    GoRoute(
      path: AppRoutes.childrenList,
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Children List',
        subtitle: 'Will be built with Figma',
      ),
    ),

    /// Dashboard — main screen after login
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Dashboard',
        subtitle: 'Will be built with Figma',
      ),
    ),

    /// Notifications screen
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Notifications',
        subtitle: 'Will be built with Figma',
      ),
    ),

    /// Profile screen
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Profile',
        subtitle: 'Will be built with Figma',
      ),
    ),

    /// TODO: Add remaining routes as features are built
    /// classes, subjects, homework, video, live_classes
  ],
);

// ─── Splash Screen ───────────────────────────────────────────────────────────

/// Temporary splash screen shown on app launch
/// Displays app name while router guard checks token
/// Will be replaced with proper animated splash when Figma is shared
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_rounded,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'SMS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'School Management System',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Placeholder Screen ──────────────────────────────────────────────────────

/// Temporary placeholder screen used for all routes not yet built
/// Shows route name so we can confirm navigation is working
/// Will be replaced feature by feature when Figma is shared
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}