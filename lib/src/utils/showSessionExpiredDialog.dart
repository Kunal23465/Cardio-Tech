import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/routes/navigation_service.dart';

bool _sessionDialogShown = false;

void showSessionExpiredDialog() {
  if (_sessionDialogShown) return;
  _sessionDialogShown = true;

  final context = appNavigatorKey.currentContext;
  if (context == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Session Expired"),
        content: const Text("Your session has expired. Please login again."),
        actionsPadding: const EdgeInsets.only(bottom: 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Center(
            child: GradientButton(
              text: "Login",
              width: 80,
              height: 30,
              onPressed: () {
                Navigator.of(ctx).pop();
                _sessionDialogShown = false;

                appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}
