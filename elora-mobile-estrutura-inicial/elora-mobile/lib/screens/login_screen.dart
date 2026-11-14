import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.spa, size: 64, color: AppColors.terracotta),
            const SizedBox(height: 12),
            const Text('ELORA', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, color: AppColors.brown, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const TextField(decoration: InputDecoration(labelText: 'E-mail')),
            const SizedBox(height: 14),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha')),
            const SizedBox(height: 22),
            FilledButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.profile), child: const Text('Entrar')),
            TextButton(onPressed: () {}, child: const Text('Criar conta')),
          ],
        ),
      ),
    ),
  );
}
