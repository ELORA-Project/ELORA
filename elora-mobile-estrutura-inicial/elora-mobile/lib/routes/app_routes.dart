import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/environment_screen.dart';
import '../screens/risk_screen.dart';
import '../screens/recommendations_screen.dart';

class AppRoutes {
  static const login = '/';
  static const profile = '/profile';
  static const dashboard = '/dashboard';
  static const environment = '/environment';
  static const risk = '/risk';
  static const recommendations = '/recommendations';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    profile: (_) => const ProfileScreen(),
    dashboard: (_) => const DashboardScreen(),
    environment: (_) => const EnvironmentScreen(),
    risk: (_) => const RiskScreen(),
    recommendations: (_) => const RecommendationsScreen(),
  };
}
