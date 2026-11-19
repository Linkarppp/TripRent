import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/mock_database.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/driver/driver_dashboard.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const TripRentApp());
}

class TripRentApp extends StatelessWidget {
  const TripRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripRent - Rental Mobil Online',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}

/// AuthGate: decides which dashboard to show based on login state and role.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TripRentStore.instance,
      builder: (context, _) {
        final user = TripRentStore.instance.currentUser;
        final isLoggedIn = TripRentStore.instance.isLoggedIn && user != null;

        if (!isLoggedIn) {
          // Show user dashboard as guest (allows browsing)
          return UserDashboard(
            onLogout: () {
              // Already logged out, no-op
            },
          );
        }

        // Route based on role
        switch (user.role) {
          case 'admin':
            return const AdminDashboard(
              bypassAuthForTesting: true,
            );
          case 'driver':
            return DriverDashboard(
              onLogout: () {
                TripRentStore.instance.logout();
              },
            );
          case 'user':
          default:
            return UserDashboard(
              onLogout: () {
                TripRentStore.instance.logout();
              },
            );
        }
      },
    );
  }
}
