import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/modelos_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/dialogo_texto.dart';
import '../../../core/presentation/tema_elora.dart';
import '../../cuidado/presentation/cuidado_conectado_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.store});
  final EloraStore store;

  Future<void> _editName(BuildContext context) async {
    final value = await mostrarDialogoTexto(
      context,
      title: 'Nome de exibição',
      label: 'Como podemos chamar você?',
      initialValue: store.name == 'Visitante' ? '' : store.name,
      maxLength: 32,
    );
    if (value != null && value.trim().isNotEmpty) {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(value.trim());
      store.definirNome(value);
    }
  }

  Future<void> _clear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Apagar dados locais?'),
        content: const Text(
          'Isso remove registros, metas, checklist, anotações e preferências deste dispositivo. A ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Apagar dados'),
          ),
        ],
      ),
    );
    if (confirmed == true) await store.apagarDados();
  }

  void _openCuidadoConectado(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CuidadoConectadoScreen(store: store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => ColunaConteudo(
        children: [
          const CabecalhoPagina(
            icon: Icons.person_outline_rounded,
            title: 'Perfil e preferências',
            subtitle:
                'Ajuste sua experiência e escolha os acompanhamentos que fazem sentido para você.',
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.heroStart, colors.heroEnd],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const LogoCircular(size: 58),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ??
                            'Conta ELORA',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFFE9D9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar nome',
                  onPressed: () => _editName(context),
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Perfil de cuidado'),
          CartaoElora(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Informação opcional',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Usamos esta escolha somente para mostrar opções de cuidado relevantes neste dispositivo.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<PerfilCuidado>(
                  initialValue: store.perfilCuidado,
                  decoration: const InputDecoration(labelText: 'Perfil'),
                  items: PerfilCuidado.values
                      .map(
                        (perfil) => DropdownMenuItem(
                          value: perfil,
                          child: Text(perfil.rotulo),
                        ),
                      )
                      .toList(),
                  onChanged: (perfil) {
                    if (perfil != null) store.definirPerfilCuidado(perfil);
                  },
                ),
                if (store.perfilCuidado == PerfilCuidado.mulher) ...[
                  const SizedBox(height: 10),
                  const AvisoDiscreto(
                    icon: Icons.calendar_month_outlined,
                    text:
                        'O acompanhamento menstrual opcional está disponível em Dados conectados e cuidados.',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const CabecalhoSecao(title: 'Meu cuidado e dispositivos'),
          ItemAcao(
            icon: Icons.tune_rounded,
            title: 'Acompanhamentos adicionais',
            subtitle:
                'Ative ou desative diabetes, pressão e acompanhamento menstrual.',
            onTap: () => _openCuidadoConectado(context),
          ),
          const SizedBox(height: 10),
          ItemAcao(
            icon: Icons.watch_outlined,
            title: 'Dados conectados',
            subtitle: store.integracaoSaudeAtiva
                ? '${store.fontesConectadas.length} fonte(s) conectada(s) · gerenciar ou remover'
                : 'Conecte, revise ou remova dados de dispositivos.',
            onTap: () => _openCuidadoConectado(context),
          ),
          const SizedBox(height: 20),
          const CabecalhoSecao(title: 'Preferências do app'),
          CartaoElora(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: store.theme,
                  decoration: const InputDecoration(labelText: 'Tema'),
                  items: const [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text('Usar configuração do dispositivo'),
                    ),
                    DropdownMenuItem(value: 'light', child: Text('Claro')),
                    DropdownMenuItem(value: 'dark', child: Text('Escuro')),
                  ],
                  onChanged: (tema) {
                    if (tema != null) store.definirTema(tema);
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Texto maior'),
                  subtitle: const Text('Amplia textos em todas as telas.'),
                  value: store.textoAmpliado,
                  onChanged: store.definirTextoAmpliado,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Conta e dados'),
          const AvisoDiscreto(
            icon: Icons.lock_outline_rounded,
            text:
                'Sua conta é autenticada pelo Firebase. A ELORA não realiza diagnóstico e você permanece no controle das informações registradas.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _clear(context),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Apagar dados locais'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}
