import 'package:flutter/material.dart';

class NavigatorService {
  late GlobalKey<NavigatorState> navigatorKey;

  static NavigatorService instance = NavigatorService();

  NavigatorService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<T?> navigate<T>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void goBack<T extends Object?>([T? result]) {
    navigatorKey.currentState!.pop<T>(result);
  }
}
