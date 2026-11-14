import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Início')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Início', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
          SizedBox(height: 12),
          Text('Resumo das condições ambientais e dos alertas do dia.'),
        ],
      ),
    ),
  );
}
