// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'views/welcome_screen.dart';

void main() {
  runApp(const EloraApp());
}

class EloraApp extends StatelessWidget {
  const EloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elora - Clima + Saúde + Você',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.fundoClaro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.marromFerrugem,
          primary: AppColors.marromFerrugem,
          secondary: AppColors.eloraOrange,
          background: AppColors.fundoClaro,
        ),
      ),
      builder: (context, child) {
        // Se estiver rodando na Web, envolve a aplicação em uma "moldura de celular"
        if (kIsWeb) {
          return Scaffold(
            backgroundColor: const Color(0xFFEFECE6), // Fundo externo um pouco mais escuro para destacar o celular
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 412,  // Largura padrão aproximada de um smartphone moderno
                  maxHeight: 870, // Altura padrão aproximada
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.fundoClaro,
                    borderRadius: BorderRadius.circular(36), // Cantos arredondados simulando o celular
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 15),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFD6CFC7),
                      width: 8, // Borda simulando a carcaça do aparelho
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            ),
          );
        }
        return child!;
      },
      home: const WelcomeScreen(),
    );
  }
}