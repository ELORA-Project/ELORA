// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'indicators_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Início

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const HomeScreen();
        break;
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CABEÇALHO
                  Text(
                    'VISÃO DO DIA',
                    style: TextStyle(
                      color: AppColors.marromFerrugem,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Olá, Marina',
                    style: TextStyle(
                      color: AppColors.marromEscuro,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Cuide de você, em qualquer clima.',
                    style: TextStyle(color: AppColors.textoCinza, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // CARD PRINCIPAL DE CLIMA (Marrom Escuro)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.marromEscuro,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: AppColors.amareloAreia, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Campinas, SP',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Text(
                              'SEX, 13 NOV',
                              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '32°',
                                  style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold, height: 1),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Ensolarado · Sensação de 35°',
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.wb_sunny_outlined,
                              color: AppColors.amareloAreia,
                              size: 64,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // BANNER DE ALERTA DENTRO DO CARD
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.amareloAlerta,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'ALERTA',
                                style: TextStyle(
                                  color: AppColors.marromEscuro,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Calor intenso e ar seco',
                                  style: TextStyle(
                                    color: AppColors.marromEscuro,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TRÊS CARDS MENORES (Umidade, Qualidade do ar, Índice UV)
                  Row(
                    children: [
                      Expanded(child: _buildSmallMetricCard('Umidade', '28%', 'Ar seco', Icons.water_drop_outlined)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildSmallMetricCard('Qualidade do ar', '58', 'Moderada', Icons.air)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildSmallMetricCard('Índice UV', '8', 'Muito alto', Icons.wb_sunny_outlined)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CARD "SEU CUIDADO AGORA"
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seu cuidado agora',
                          style: TextStyle(color: AppColors.marromEscuro, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Evite esforço ao ar livre entre 10h e 16h.',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 13),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const AlertsAndPlanScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Ver meu plano de ação',
                                style: TextStyle(
                                  color: AppColors.marromFerrugem,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward, color: AppColors.marromFerrugem, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SEÇÃO: AO LONGO DO DIA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ao longo do dia',
                        style: TextStyle(color: AppColors.marromEscuro, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Próximas horas',
                        style: TextStyle(color: AppColors.marromFerrugem, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // HORÁRIOS DO DIA
                  Row(
                    children: [
                      Expanded(child: _buildHourCard('10h', '32°', false)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildHourCard('12h', '34°', false)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildHourCard('14h', '35°', true)), // Destacado
                      const SizedBox(width: 8),
                      Expanded(child: _buildHourCard('16h', '33°', false)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // RODAPÉ INFORMATIVO
                  Center(
                    child: Text(
                      'Dados ilustrativos · Atualizado às 09:40',
                      style: TextStyle(color: AppColors.textoCinza, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      // BARRA DE NAVEGAÇÃO INFERIOR
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

  Widget _buildSmallMetricCard(String title, String value, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.marromFerrugem, size: 18),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: AppColors.marromEscuro, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: AppColors.textoCinza, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildHourCard(String hour, String temp, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF3ECE4) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isSelected ? Colors.brown.shade300 : Colors.brown.shade100),
      ),
      child: Column(
        children: [
          Text(hour, style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
          const SizedBox(height: 8),
          const Icon(Icons.wb_sunny_outlined, color: AppColors.marromFerrugem, size: 20),
          const SizedBox(height: 8),
          Text(temp, style: TextStyle(color: AppColors.marromEscuro, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}