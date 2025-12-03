import 'package:flutter/material.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/routes/navigation_service.dart';

void showSessionExpiredDialog() {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;

  // Ensure this runs after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Session Expired"),
        content: const Text("Your session has expired. Please login again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
              appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  });
}
