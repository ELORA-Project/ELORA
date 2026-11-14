import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Orientações')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Orientações', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
          SizedBox(height: 12),
          Text('Confira recomendações preventivas adequadas às condições identificadas.'),
        ],
      ),
    ),
  );
}
