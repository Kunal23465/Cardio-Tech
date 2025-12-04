import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  static GlobalKey<NavigatorState> get navigatorKey => appNavigatorKey;

  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return appNavigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop([dynamic result]) {
    return appNavigatorKey.currentState?.pop(result);
  }
}
