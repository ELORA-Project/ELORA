import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EnvironmentScreen extends StatelessWidget {
  const EnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Monitoramento ambiental')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Monitoramento ambiental', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
          SizedBox(height: 12),
          Text('Acompanhe temperatura, umidade, qualidade do ar e índice UV.'),
        ],
      ),
    ),
  );
}
