// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_screen.dart';
import 'indicators_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class AlertsAndPlanScreen extends StatefulWidget {
  const AlertsAndPlanScreen({super.key});

  @override
  State<AlertsAndPlanScreen> createState() => _AlertsAndPlanScreenState();
}

class _AlertsAndPlanScreenState extends State<AlertsAndPlanScreen> {
  int _currentIndex = 2; // Aba Alertas selecionada
  bool _task1Completed = true;
  bool _task2Completed = false;
  bool _task3Completed = false;

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
                    'ORIENTAÇÃO & RESPOSTA',
                    style: TextStyle(
                      color: AppColors.marromFerrugem,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Seu plano de cuidado',
                    style: TextStyle(
                      color: AppColors.marromEscuro,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Saiba o que fazer, no seu tempo.',
                    style: TextStyle(color: AppColors.textoCinza, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // ABAS DE FILTRO (Para você · 2 / Todos)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.marromFerrugem,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'Para você · 2',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.brown.shade100),
                          ),
                          child: const Center(
                            child: Text(
                              'Todos',
                              style: TextStyle(color: AppColors.textoCinza, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CARD DE ALERTA PRINCIPAL (Amarelo Suave)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.amareloAlerta,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: AppColors.marromEscuro, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'ATENÇÃO AO SEU PERFIL',
                                  style: TextStyle(
                                    color: AppColors.marromEscuro,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '09:20',
                              style: TextStyle(color: AppColors.marromEscuro, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Calor intenso e ar seco',
                          style: TextStyle(
                            color: AppColors.marromEscuro,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Umidade em 28%. Sua condição respiratória pede cuidado extra ao sair de casa.',
                          style: TextStyle(color: AppColors.marromEscuro, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.marromEscuro.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Hoje, das 10h às 16h',
                            style: TextStyle(color: AppColors.marromEscuro, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TÍTULO DA SEÇÃO DE TAREFAS + PROGRESSO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Seu plano para hoje',
                        style: TextStyle(color: AppColors.marromEscuro, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '1 de 3 concluído',
                        style: TextStyle(color: AppColors.textoCinza, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // LISTA DE TAREFAS / PLANO DE AÇÃO
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildTaskItem(
                          stepNumber: '1',
                          title: 'Mantenha a hidratação',
                          description: 'Beba água ao longo do dia, conforme sua orientação de saúde.',
                          isCompleted: _task1Completed,
                          onTap: () => setState(() => _task1Completed = !_task1Completed),
                          showDivider: true,
                        ),
                        _buildTaskItem(
                          stepNumber: '2',
                          title: 'Proteja-se do calor',
                          description: 'Prefira locais frescos e reduza esforço ao ar livre entre 10h e 16h.',
                          isCompleted: _task2Completed,
                          onTap: () => setState(() => _task2Completed = !_task2Completed),
                          showDivider: true,
                        ),
                        _buildTaskItem(
                          stepNumber: '3',
                          title: 'Observe como você se sente',
                          description: 'Registre tosse, cansaço ou falta de ar nos seus indicadores.',
                          isCompleted: _task3Completed,
                          onTap: () => setState(() => _task3Completed = !_task3Completed),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BOTÃO REGISTRAR COMO ESTOU
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IndicatorsScreen()),
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
                        Text('Registrar como estou', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CARD SECUNDÁRIO DE ALERTA
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_outlined, color: AppColors.marromFerrugem, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Qualidade do ar moderada',
                                style: TextStyle(color: AppColors.marromEscuro, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Outro alerta para hoje · Ver detalhes',
                                style: TextStyle(color: AppColors.textoCinza, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.textoCinza, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // AVISO MÉDICO NO RODAPÉ
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Em caso de falta de ar intensa, procure atendimento.',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Este aplicativo não substitui avaliação médica.',
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

  Widget _buildTaskItem({
    required String stepNumber,
    required String title,
    required String description,
    required bool isCompleted,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.marromFerrugem : AppColors.amareloAreia.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            stepNumber,
                            style: const TextStyle(
                              color: AppColors.marromEscuro,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.marromEscuro,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.textoCinza,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.brown.shade100, indent: 16, endIndent: 16),
      ],
    );
  }
}