// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_screen.dart';
import 'indicators_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _currentIndex = 4; // Aba Relatórios selecionada
  int _selectedTab = 0; // 0: Semana, 1: Mês, 2: 3 meses

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
                    'HISTÓRICO DE BEM-ESTAR',
                    style: TextStyle(
                      color: AppColors.marromFerrugem,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Seus relatórios',
                    style: TextStyle(
                      color: AppColors.marromEscuro,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Entenda seus padrões ao longo do tempo.',
                    style: TextStyle(color: AppColors.textoCinza, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // ABAS DE PERÍODO (Semana / Mês / 3 meses)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade100.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildPeriodTab('Semana', 0)),
                        Expanded(child: _buildPeriodTab('Mês', 1)),
                        Expanded(child: _buildPeriodTab('3 meses', 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DATAS E REGISTROS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '07 – 13 nov, 2026',
                        style: TextStyle(color: AppColors.marromEscuro, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '7 registros',
                        style: TextStyle(color: AppColors.textoCinza, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // DOIS CARDS SUPERIORES DE MÉTRICAS
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.brown.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dias de bem-estar', style: TextStyle(color: AppColors.textoCinza, fontSize: 12)),
                              const SizedBox(height: 6),
                              const Text('5 de 7', style: TextStyle(color: AppColors.marromEscuro, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('Você se sentiu bem', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.brown.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hidratação média', style: TextStyle(color: AppColors.textoCinza, fontSize: 12)),
                              const SizedBox(height: 6),
                              const Text('1,6 L', style: TextStyle(color: AppColors.marromEscuro, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('80% da sua meta diária', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CARD GRÁFICO: CLIMA x BEM-ESTAR
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Clima × bem-estar',
                          style: TextStyle(color: AppColors.marromEscuro, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Temperatura máxima e seus registros diários',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 12),
                        ),
                        const SizedBox(height: 14),
                        // LEGENDA
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.marromFerrugem, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Máxima (°C)', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            const SizedBox(width: 20),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.marromEscuro, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Bem-estar', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // REPRESENTAÇÃO VISUAL DO GRÁFICO (Mock customizado fiel)
                        SizedBox(
                          height: 140,
                          child: Stack(
                            children: [
                              // Linhas pontilhadas de fundo
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildChartLineRow('36°', 'Bem'),
                                  _buildChartLineRow('32°', 'Regular'),
                                  _buildChartLineRow('28°', 'Mal'),
                                ],
                              ),
                              // Desenho simplificado das linhas dos pontos
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: CustomPaint(
                                    painter: ChartPainter(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // DIAS DA SEMANA NO EIXO X
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text('Sáb', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Dom', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Seg', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Ter', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Qua', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Qui', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                            Text('Sex', style: TextStyle(color: AppColors.textoCinza, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CARD: UM PADRÃO PARA OBSERVAR
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
                          'Um padrão para observar',
                          style: TextStyle(color: AppColors.marromEscuro, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No dia mais quente, você registrou mal-estar. Acompanhe essa relação nas próximas semanas.',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Associação não significa causa nem diagnóstico.',
                          style: TextStyle(color: AppColors.textoCinza.withOpacity(0.7), fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BOTÃO EXPORTAR RELATÓRIO EM PDF
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Relatório PDF exportado com sucesso!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.marromFerrugem,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.download, size: 18),
                        SizedBox(width: 8),
                        Text('Exportar relatório em PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // RODAPÉ INFORMATIVO
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Dados ilustrativos · Clima + registros de bem-estar',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Use o relatório para conversar com seu profissional de saúde.',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

  Widget _buildPeriodTab(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.marromEscuro : AppColors.textoCinza,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartLineRow(String tempLabel, String statusLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(tempLabel, style: TextStyle(color: AppColors.textoCinza.withOpacity(0.6), fontSize: 10)),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 1,
            color: Colors.brown.shade100,
          ),
        ),
        Text(statusLabel, style: TextStyle(color: AppColors.textoCinza.withOpacity(0.6), fontSize: 10)),
      ],
    );
  }
}

// Pintor customizado leve para ilustrar o gráfico da imagem
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintOrange = Paint()
      ..color = AppColors.marromFerrugem
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paintDark = Paint()
      ..color = AppColors.marromEscuro
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pathOrange = Path();
    final pathDark = Path();

    // Coordenadas simuladas dos 7 pontos (Sáb a Sex)
    final pointsOrange = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.7),
      Offset(size.width * 0.32, size.height * 0.6),
      Offset(size.width * 0.48, size.height * 0.4),
      Offset(size.width * 0.64, size.height * 0.1),
      Offset(size.width * 0.80, size.height * 0.5),
      Offset(size.width, size.height * 0.35),
    ];

    final pointsDark = [
      Offset(0, size.height * 0.1),
      Offset(size.width * 0.16, size.height * 0.1),
      Offset(size.width * 0.32, size.height * 0.1),
      Offset(size.width * 0.48, size.height * 0.5),
      Offset(size.width * 0.64, size.height * 0.9),
      Offset(size.width * 0.80, size.height * 0.1),
      Offset(size.width, size.height * 0.1),
    ];

    for (int i = 0; i < pointsOrange.length; i++) {
      if (i == 0) {
        pathOrange.moveTo(pointsOrange[i].dx, pointsOrange[i].dy);
      } else {
        pathOrange.lineTo(pointsOrange[i].dx, pointsOrange[i].dy);
      }
    }

    for (int i = 0; i < pointsDark.length; i++) {
      if (i == 0) {
        pathDark.moveTo(pointsDark[i].dx, pointsDark[i].dy);
      } else {
        pathDark.lineTo(pointsDark[i].dx, pointsDark[i].dy);
      }
    }

    canvas.drawPath(pathOrange, paintOrange);
    
    // Desenha pontilhado escuro
    canvas.drawPath(pathDark, paintDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}