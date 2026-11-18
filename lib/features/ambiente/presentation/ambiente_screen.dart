import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/presentation/abrir_externo.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/tema_elora.dart';
import '../../protecao/presentation/protecao_screen.dart';

class AmbienteScreen extends StatelessWidget {
  const AmbienteScreen({super.key, required this.store});
  final EloraStore store;

  void _abrirGuia(BuildContext context, Guia guia) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => GuiaScreen(guide: guia, store: store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ambiente e preparação')),
      body: ColunaConteudo(
        children: [
          const CabecalhoPagina(
            icon: Icons.eco_outlined,
            title: 'Ambiente e preparação',
            subtitle:
                'Escolha um cenário e prepare seu plano pessoal com calma.',
          ),
          const AvisoDiscreto(
            icon: Icons.science_outlined,
            text:
                'A ELORA não mostra clima ao vivo nem alertas locais. Antes de decidir uma rota ou atividade, consulte a Defesa Civil e outras fontes oficiais da sua região.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.heroStart, colors.heroEnd],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.map_outlined, color: Colors.white, size: 34),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informação para se preparar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Use os guias educativos junto das informações atualizadas da sua localidade.',
                        style: TextStyle(
                          color: Color(0xFFFFE5D4),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Como você quer se preparar?'),
          for (final guia in guides) ...[
            ItemAcao(
              icon: guia.icon,
              title: guia.title,
              subtitle: guia.subtitle,
              onTap: () => _abrirGuia(context, guia),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const CabecalhoSecao(title: 'Preparação rápida'),
          for (final guia in guides) ...[
            CartaoElora(
              color: colors.surfaceAlt,
              onTap: () => _abrirGuia(context, guia),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(guia.icon, color: colors.accent, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guia.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _preparoRapido(guia),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: colors.accent),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const AvisoDiscreto(
            icon: Icons.backpack_outlined,
            text:
                'Ao montar seu plano, inclua água, medicamentos e itens pessoais que façam sentido para você.',
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Alertas oficiais'),
          CartaoElora(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Receba alertas da sua região',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _Passo(numero: '1', texto: 'Localize seu CEP.'),
                _Passo(numero: '2', texto: 'Envie o CEP para 40199.'),
                _Passo(
                  numero: '3',
                  texto: 'Acompanhe as instruções oficiais recebidas.',
                ),
                const SizedBox(height: 8),
                Text(
                  'Confira disponibilidade e instruções atualizadas diretamente na fonte oficial.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => abrirLinkExterno(
                    context,
                    'https://www.gov.br/mdr/pt-br/assuntos/protecao-e-defesa-civil/alertas-de-desastres-1',
                  ),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Abrir Defesa Civil Nacional'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _preparoRapido(Guia guia) => switch (guia.title) {
    'Calor intenso' =>
      'Organize água, proteção contra o sol, pausas e um local fresco.',
    'Enchentes' =>
      'Deixe o celular carregado, pense em uma rota segura e acompanhe a Defesa Civil.',
    _ =>
      'Observe os sinais divulgados por autoridades e siga uma saída segura quando indicada.',
  };
}

class _Passo extends StatelessWidget {
  const _Passo({required this.numero, required this.texto});
  final String numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: colors.accentSoft,
            foregroundColor: colors.accent,
            child: Text(numero),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
