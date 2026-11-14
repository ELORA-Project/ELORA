import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RiskScreen extends StatelessWidget {
  const RiskScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Análise de risco pessoal')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Análise de risco pessoal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.brown)),
          SizedBox(height: 12),
          Text('Visualize possíveis riscos considerando o ambiente e as informações autorizadas do perfil.'),
        ],
      ),
    ),
  );
}
