import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/modelos_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/tema_elora.dart';
import '../domain/resumo_relatorio.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key, required this.store});

  final EloraStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final resumo = montarResumoConsulta(
        registros: store.registros,
        metas: store.metas,
        note: store.notaConsulta,
        today: DateTime.now(),
      );
      final diario = store.diarioCuidado;
      return ColunaConteudo(
        children: [
          const CabecalhoPagina(
            icon: Icons.bar_chart_rounded,
            title: 'Relatórios',
            subtitle: 'Veja o que você registrou e prepare a próxima consulta.',
          ),
          const AvisoDiscreto(
            icon: Icons.info_outline_rounded,
            text:
                'Os números abaixo são calculados apenas com seus registros. Eles não representam avaliação de saúde.',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _CartaoEstatistica(
                  label: 'Registros',
                  value: '${store.registros.length}',
                  icon: Icons.edit_note_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CartaoEstatistica(
                  label: 'Metas hoje',
                  value: '${store.metasConcluidasHoje}',
                  icon: Icons.flag_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CartaoEstatistica(
                  label: 'Plano',
                  value:
                      '${store.tarefasPlanoConcluidas}/${store.plano.length}',
                  icon: Icons.shield_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Registros nos últimos 7 dias'),
          CartaoElora(
            child: store.registros.isEmpty
                ? const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Adicione um registro para ver seu histórico.',
                      ),
                    ),
                  )
                : _BarrasSemanais(contagens: store.registrosPorDiaRecente),
          ),
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Histórico recente'),
          if (diario.isEmpty)
            const AvisoDiscreto(
              icon: Icons.history_rounded,
              text: 'Nenhum registro ou ação de cuidado foi adicionado ainda.',
            )
          else
            for (final dia in diario) ...[
              _CartaoDia(
                dia: dia,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ResumoDiaScreen(store: store, dia: dia),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 24),
          const CabecalhoSecao(title: 'Resumo para a consulta'),
          CartaoElora(
            child: SelectableText(
              resumo,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: resumo));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Resumo copiado. Revise antes de compartilhar.',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copiar resumo'),
          ),
        ],
      );
    },
  );
}

class ResumoDiaScreen extends StatelessWidget {
  const ResumoDiaScreen({super.key, required this.store, required this.dia});

  final EloraStore store;
  final DiaDiarioCuidado dia;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Resumo do dia')),
    body: SafeArea(
      child: ColunaConteudo(
        children: [
          Text(
            dataPorExtenso(dia.data),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            '${dia.dados.length} ${dia.dados.length == 1 ? 'registro' : 'registros'} · ${dia.acoes.length} ${dia.acoes.length == 1 ? 'ação' : 'ações'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 22),
          if (dia.dados.isNotEmpty) ...[
            const CabecalhoSecao(title: 'Dados registrados'),
            for (final item in dia.dados) ...[
              _ItemHistorico(store: store, item: item),
              const SizedBox(height: 8),
            ],
          ],
          if (dia.acoes.isNotEmpty) ...[
            if (dia.dados.isNotEmpty) const SizedBox(height: 14),
            const CabecalhoSecao(title: 'Ações de cuidado'),
            for (final item in dia.acoes) ...[
              _ItemHistorico(store: store, item: item),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    ),
  );
}

class _CartaoDia extends StatelessWidget {
  const _CartaoDia({required this.dia, required this.onTap});
  final DiaDiarioCuidado dia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hoje = chaveDia(dia.data) == chaveDia(DateTime.now());
    final titulos = dia.itens
        .map((item) => item.titulo)
        .toSet()
        .take(3)
        .join(' · ');
    return CartaoElora(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hoje ? 'Hoje' : dataCurta(dia.data),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  '${dia.dados.length} ${dia.dados.length == 1 ? 'registro' : 'registros'} · ${dia.acoes.length} ${dia.acoes.length == 1 ? 'ação' : 'ações'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (titulos.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(titulos, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _ItemHistorico extends StatelessWidget {
  const _ItemHistorico({required this.store, required this.item});
  final EloraStore store;
  final ItemDiarioCuidado item;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    final detalhes = [
      if (item.valor != null && item.valor!.isNotEmpty) item.valor!,
      if (item.origem != null) item.origem!,
    ].join(' · ');
    return CartaoElora(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(
            item.categoria == CategoriaDiarioCuidado.dadosRegistrados
                ? Icons.monitor_heart_outlined
                : Icons.check_circle_outline_rounded,
            color: colors.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${horarioCurto(item.data)} · ${item.titulo}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (detalhes.isNotEmpty)
                  Text(detalhes, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (item.podeRemover)
            IconButton(
              tooltip: 'Remover registro',
              onPressed: () {
                if (item.idRegistroManual != null) {
                  store.removerRegistro(item.idRegistroManual!);
                } else if (item.idMetricaManual != null) {
                  store.removerMetricaManual(item.idMetricaManual!);
                }
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete_outline_rounded, color: colors.muted),
            ),
        ],
      ),
    );
  }
}

class _CartaoEstatistica extends StatelessWidget {
  const _CartaoEstatistica({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return CartaoElora(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accent, size: 22),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BarrasSemanais extends StatelessWidget {
  const _BarrasSemanais({required this.contagens});
  final List<int> contagens;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    final maiorContagem = math.max(1, contagens.reduce(math.max));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quantidade de registros por dia',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (indice) {
            final dia = DateTime.now().subtract(Duration(days: 6 - indice));
            return Expanded(
              child: Column(
                children: [
                  Text(
                    '${contagens[indice]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 90,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 20,
                        height: contagens[indice] == 0
                            ? 3
                            : 90 * contagens[indice] / maiorContagem,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${dia.day}/${dia.month}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
