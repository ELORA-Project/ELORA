// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_screen.dart';
import 'indicators_screen.dart';
import 'alerts_screen.dart';
import 'reports_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Aba Perfil selecionada
  bool _switchAsma = true;
  bool _switchTrabalho = false;
  bool _switchIdoso = false;
  bool _switchAlertas = true;

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
                    'DO SEU JEITO',
                    style: TextStyle(
                      color: AppColors.marromFerrugem,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Perfil e preferências',
                    style: TextStyle(
                      color: AppColors.marromEscuro,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Um cuidado que acompanha você.',
                    style: TextStyle(color: AppColors.textoCinza, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // CARD DO USUÁRIO (Marrom Escuro)
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
                            const Text(
                              'Marina Oliveira',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                              child: const Text(
                                'Editar',
                                style: TextStyle(color: AppColors.amareloAreia, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'marina.oliveira@email.com',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '34 anos · Campinas, SP',
                          style: TextStyle(color: AppColors.amareloAreia, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SEÇÃO: MEU PERFIL DE SAÚDE
                  const Text(
                    'Meu perfil de saúde',
                    style: TextStyle(color: AppColors.marromEscuro, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Essas informações ajustam seus alertas.',
                    style: TextStyle(color: AppColors.textoCinza, fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchItem(
                          title: 'Condição respiratória · Asma',
                          value: _switchAsma,
                          onChanged: (val) => setState(() => _switchAsma = val),
                          showDivider: true,
                        ),
                        _buildSwitchItem(
                          title: 'Trabalho ao ar livre',
                          value: _switchTrabalho,
                          onChanged: (val) => setState(() => _switchTrabalho = val),
                          showDivider: true,
                        ),
                        _buildSwitchItem(
                          title: 'Pessoa idosa · 60 anos ou mais',
                          value: _switchIdoso,
                          onChanged: (val) => setState(() => _switchIdoso = val),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SEÇÃO: PREFERÊNCIAS DE CUIDADO
                  const Text(
                    'Preferências de cuidado',
                    style: TextStyle(color: AppColors.marromEscuro, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchItem(
                          title: 'Receber alertas preventivos',
                          value: _switchAlertas,
                          onChanged: (val) => setState(() => _switchAlertas = val),
                          showDivider: true,
                        ),
                        _buildNavigationItem(Icons.water_drop_outlined, 'Meta de hidratação', '2,0 L / dia'),
                        Divider(height: 1, thickness: 1, color: Colors.brown.shade100, indent: 16, endIndent: 16),
                        _buildNavigationItem(Icons.monitor_heart_outlined, 'Dispositivo de saúde', 'Conectado'),
                        Divider(height: 1, thickness: 1, color: Colors.brown.shade100, indent: 16, endIndent: 16),
                        _buildNavigationItem(Icons.lock_outline, 'Privacidade e dados', 'Gerenciar'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // AVISO DE PRIVACIDADE NO RODAPÉ
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lock_outline, size: 14, color: AppColors.textoCinza),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seus dados de saúde são usados apenas com sua autorização. Você pode apagar seus dados.',
                          style: TextStyle(color: AppColors.textoCinza, fontSize: 11, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // BOTÃO SALVAR PREFERÊNCIAS
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preferências salvas com sucesso!')),
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
                        Text('Salvar preferências', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.marromEscuro,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: AppColors.marromFerrugem,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.brown.shade200,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.brown.shade100, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, String value) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.marromFerrugem, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.marromEscuro,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textoCinza,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textoCinza, size: 18),
          ],
        ),
      ),
    );
  }
}