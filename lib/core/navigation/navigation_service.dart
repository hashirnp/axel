import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => navigatorKey.currentState;

  // -------------------------------
  // NAMED ROUTE NAVIGATION (ADD THIS)
  // -------------------------------

  Future<void> pushNamed(String routeName, {Object? arguments}) {
    return _navigator!.pushNamed(routeName, arguments: arguments);
  }

  Future<void> pushReplacementNamed(String routeName, {Object? arguments}) {
    return _navigator!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // -------------------------------
  // YOUR EXISTING METHODS (KEEP)
  // -------------------------------

  Future<T?> push<T>(Widget page) {
    return _navigator!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return _navigator!.pushReplacement<T, T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return _navigator!.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void pop<T>([T? result]) {
    _navigator!.pop(result);
  }

  bool canPop() {
    return _navigator!.canPop();
  }

  Future<T?> showAppDialog<T>(Widget dialog) {
    return showDialog<T>(
      context: _navigator!.context,
      builder: (_) => dialog,
    );
  }

  Future<T?> showBottomSheet<T>(Widget sheet) {
    return showModalBottomSheet<T>(
      context: _navigator!.context,
      builder: (_) => sheet,
    );
  }
}
