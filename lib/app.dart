import 'package:material_ui/material_ui.dart';

import 'core/data/elora_store.dart';
import 'core/presentation/tema_elora.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/assistente/presentation/assistente_screen.dart';
import 'features/cuidado/presentation/cuidado_screen.dart';
import 'features/ambiente/presentation/ambiente_screen.dart';
import 'features/inicio/presentation/inicio_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/protecao/presentation/protecao_screen.dart';
import 'features/relatorios/presentation/relatorios_screen.dart';
import 'features/trabalho/presentation/rotina_screen.dart';

class EloraApp extends StatefulWidget {
  const EloraApp({super.key, required this.store});

  final EloraStore store;

  @override
  State<EloraApp> createState() => _EloraAppState();
}

class _EloraAppState extends State<EloraApp> {
  final GlobalKey<NavigatorState> _chaveNavegacao = GlobalKey<NavigatorState>();
  late String _tema;
  late bool _textoAmpliado;

  @override
  void initState() {
    super.initState();
    _tema = widget.store.theme;
    _textoAmpliado = widget.store.textoAmpliado;
    widget.store.addListener(_atualizarPreferencias);
  }

  @override
  void didUpdateWidget(covariant EloraApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store == widget.store) return;
    oldWidget.store.removeListener(_atualizarPreferencias);
    _tema = widget.store.theme;
    _textoAmpliado = widget.store.textoAmpliado;
    widget.store.addListener(_atualizarPreferencias);
  }

  @override
  void dispose() {
    widget.store.removeListener(_atualizarPreferencias);
    super.dispose();
  }

  void _atualizarPreferencias() {
    if (_tema == widget.store.theme &&
        _textoAmpliado == widget.store.textoAmpliado) {
      return;
    }
    setState(() {
      _tema = widget.store.theme;
      _textoAmpliado = widget.store.textoAmpliado;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: _chaveNavegacao,
    title: 'ELORA',
    debugShowCheckedModeBanner: false,
    theme: TemaElora.light,
    darkTheme: TemaElora.dark,
    themeMode: switch (_tema) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    },
    builder: (context, child) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(
          textScaler: TextScaler.linear(_textoAmpliado ? 1.16 : 1),
        ),
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: AuthGate(store: widget.store),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.store});

  final EloraStore store;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final colors = CoresElora.of(context);
      final pages = [
        InicioScreen(
          store: widget.store,
          onNavigate: (index) => setState(() => selectedIndex = index),
          onAssistente: () => _open(AssistenteScreen(store: widget.store)),
          onTrabalho: () => _open(RotinaScreen(store: widget.store)),
          onAmbiente: () => _open(AmbienteScreen(store: widget.store)),
        ),
        CuidadoScreen(store: widget.store),
        ProtecaoScreen(store: widget.store),
        ProfileScreen(store: widget.store),
        RelatoriosScreen(store: widget.store),
      ];
      return Scaffold(
        body: SafeArea(
          child: IndexedStack(index: selectedIndex, children: pages),
        ),
        floatingActionButton: selectedIndex == 0
            ? null
            : FloatingActionButton.small(
                tooltip: 'Conversar com a ELORA',
                backgroundColor: colors.accent,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () => _open(AssistenteScreen(store: widget.store)),
                child: const Icon(Icons.chat_bubble_outline_rounded),
              ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => selectedIndex = index),
          backgroundColor: colors.surface,
          indicatorColor: colors.accentSoft,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Cuidado',
            ),
            NavigationDestination(
              icon: Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield_rounded),
              label: 'Proteção',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Relatórios',
            ),
          ],
        ),
      );
    },
  );
}
