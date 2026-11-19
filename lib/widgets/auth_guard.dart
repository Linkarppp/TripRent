import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../screens/login_screen.dart';

class AuthGuard {
  static Future<bool> requireLogin(
    BuildContext context, {
    String message = 'Silakan masuk terlebih dahulu untuk melanjutkan pemesanan.',
  }) async {
    if (TripRentStore.instance.isLoggedIn) {
      return true;
    }

    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(promptMessage: message),
      ),
    );

    return (success == true) && TripRentStore.instance.isLoggedIn;
  }
}
