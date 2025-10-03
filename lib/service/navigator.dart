import 'package:flutter/material.dart';

class NavigatorService {
  late GlobalKey<NavigatorState> navigatorKey;

  static NavigatorService instance = NavigatorService();

  NavigatorService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  navigate(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  goBack() {
    navigatorKey.currentState?.pop();
  }
}
