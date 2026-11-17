// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class IndicatorsScreen extends StatefulWidget {
  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    Widget targetScreen;
    switch (index) {
      case 1:
        targetScreen = const IndicatorsScreen();
        break;
      case 2:
        targetScreen = const AlertsAndPlanScreen();
        break;
      case 3:
        targetScreen = const ProfileScreen();
        break;
      case 4:
        targetScreen = const ReportsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoClaro,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SAÚDE & HÁBITOS',
                        style: TextStyle(
                          color: AppColors.marromFerrugem,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Meus indicadores',
                        style: TextStyle(
                          color: AppColors.marromEscuro,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.sync, size: 12, color: AppColors.marromFerrugem),
                        SizedBox(width: 4),
                        Text(
                          'Sincronizado às 09:35',
                          style: TextStyle(color: AppColors.marromFerrugem, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.brown.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.water_drop_outlined, color: AppColors.marromFerrugem, size: 22),
                            SizedBox(width: 8),
                            Text('Hidratação', style: TextStyle(color: AppColors.marromEscuro, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('60% da meta', style: TextStyle(color: AppColors.marromFerrugem, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text('1,2 L', style: TextStyle(color: AppColors.marromEscuro, fontSize: 32, fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Text('de 2,0 L hoje', style: TextStyle(color: AppColors.textoCinza, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.brown.shade50,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.laranjaElora),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.marromFerrugem,
        unselectedItemColor: AppColors.textoCinza,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart_outlined), label: 'Indicadores'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Relatórios'),
        ],
      ),
    );
  }
}