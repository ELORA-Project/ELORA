import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Configuração do perfil')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Configuração do perfil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
          SizedBox(height: 12),
          Text('Informe seus dados e preferências para personalizar as orientações.'),
        ],
      ),
    ),
  );
}
