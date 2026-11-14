import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() => runApp(const EloraApp());

class EloraApp extends StatelessWidget {
  const EloraApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ELORA',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    initialRoute: AppRoutes.login,
    routes: AppRoutes.routes,
  );
}
