// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo claro da cartela de cores complementando a tela inteira
      backgroundColor: AppColors.fundoClaro,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // Limita a largura máxima no computador para manter o formato de card
            ),
            child: GestureDetector(
              onTap: () {
                // Ação ao tocar no card: navega para a tela de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  // Cor do card baseada no marrom escuro da cartela
                  color: AppColors.marromEscuro,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone de sol + Subtítulo
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: AppColors.amareloAreia,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CLIMA + SAÚDE + VOCÊ',
                          style: TextStyle(
                            color: AppColors.amareloAreia,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Título principal em destaque
                    const Text(
                      'Seu dia em\nequilíbrio.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Descrição
                    const Text(
                      'O clima muda. O seu cuidado acompanha você.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Indicador visual discreto para avançar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Toque para começar',
                          style: TextStyle(
                            color: AppColors.amareloAreia,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.amareloAreia,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}