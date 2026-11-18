import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/contexto_cuidado.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/tema_elora.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({
    super.key,
    required this.store,
    required this.onNavigate,
    required this.onAssistente,
    required this.onTrabalho,
    required this.onAmbiente,
  });

  final EloraStore store;
  final ValueChanged<int> onNavigate;
  final VoidCallback onAssistente;
  final VoidCallback onTrabalho;
  final VoidCallback onAmbiente;

  String get _saudacao {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    final orientacao = store.orientacoesContextuais.isEmpty
        ? null
        : store.orientacoesContextuais.first;
    return ColunaConteudo(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_saudacao, ${store.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vamos transformar seus dados em cuidado prático.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const LogoCircular(size: 55),
          ],
        ),
        if (store.falhaAoSalvar) ...[
          const SizedBox(height: 12),
          const AvisoDiscreto(
            icon: Icons.warning_amber_rounded,
            text:
                'Não foi possível confirmar o armazenamento local. Revise os dados antes de fechar o aplicativo.',
          ),
        ],
        const SizedBox(height: 18),
        _PrioridadeAgora(orientacao: orientacao, onTap: () => onNavigate(1)),
        const SizedBox(height: 14),
        _DestaqueAssistente(onTap: onAssistente),
        const SizedBox(height: 14),
        CartaoElora(
          color: colors.surfaceAlt,
          onTap: onAmbiente,
          child: Row(
            children: [
              Icon(Icons.cloud_outlined, color: colors.accent, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prepare-se para o ambiente',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Calor, chuvas e alertas oficiais: veja cuidados educativos para o seu contexto.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.accent),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const CabecalhoSecao(title: 'Escolha por onde começar'),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 40) return const SizedBox.shrink();
            final itemWidth = constraints.maxWidth < 320
                ? constraints.maxWidth
                : (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Atalho(
                  width: itemWidth,
                  icon: Icons.insights_outlined,
                  title: 'Entender dados',
                  subtitle: 'Indicadores e registros',
                  onTap: () => onNavigate(1),
                ),
                _Atalho(
                  width: itemWidth,
                  icon: Icons.schedule_outlined,
                  title: 'Minha rotina',
                  subtitle: 'Pausas e bem-estar',
                  onTap: onTrabalho,
                ),
                _Atalho(
                  width: itemWidth,
                  icon: Icons.eco_outlined,
                  title: 'Ambiente',
                  subtitle: 'Preparação educativa',
                  onTap: onAmbiente,
                ),
                _Atalho(
                  width: itemWidth,
                  icon: Icons.shield_outlined,
                  title: 'Plano de segurança',
                  subtitle: 'Preparação e ajuda',
                  onTap: () => onNavigate(2),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        CartaoElora(
          onTap: () => onNavigate(4),
          child: Row(
            children: [
              Icon(Icons.auto_graph_rounded, color: colors.accent, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seu histórico pessoal',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${store.registros.length} registros · ${store.metasConcluidasHoje} metas hoje · ${store.tarefasPlanoConcluidas}/${store.plano.length} itens preparados',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.muted),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrioridadeAgora extends StatelessWidget {
  const _PrioridadeAgora({required this.orientacao, required this.onTap});
  final OrientacaoContextual? orientacao;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    final temOrientacao = orientacao != null;
    return CartaoElora(
      color: colors.surfaceAlt,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                temOrientacao
                    ? Icons.tips_and_updates_outlined
                    : Icons.favorite_outline_rounded,
                color: colors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Sua prioridade agora',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            orientacao?.titulo ?? 'Seu cuidado, do seu jeito',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Text(
            orientacao?.mensagem ??
                'Comece registrando um indicador, conte para a ELORA o que você quer entender ou explore seus cuidados.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(
              temOrientacao ? 'Ver meus cuidados' : 'Explorar cuidados',
            ),
          ),
        ],
      ),
    );
  }
}

class _DestaqueAssistente extends StatelessWidget {
  const _DestaqueAssistente({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.heroStart, colors.heroEnd],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.auto_awesome_outlined,
              color: Color(0xFFFFDCA6),
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Converse com a ELORA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Entenda um dado, prepare-se para o ambiente ou organize uma consulta.',
                    style: TextStyle(
                      color: Color(0xFFFFE9D9),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEACB),
                      foregroundColor: const Color(0xFF5D2413),
                      minimumSize: const Size(0, 40),
                    ),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                    ),
                    label: const Text('Fazer uma pergunta'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Atalho extends StatelessWidget {
  const _Atalho({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return SizedBox(
      width: width,
      height: 124,
      child: CartaoElora(
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: colors.accent, size: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
