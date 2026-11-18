import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/contexto_cuidado.dart';
import '../../../core/domain/modelos_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/dialogo_texto.dart';
import '../../../core/presentation/tema_elora.dart';

class CalendarioMenstrualScreen extends StatefulWidget {
  const CalendarioMenstrualScreen({super.key, required this.store});
  final EloraStore store;

  @override
  State<CalendarioMenstrualScreen> createState() =>
      _CalendarioMenstrualScreenState();
}

class _CalendarioMenstrualScreenState extends State<CalendarioMenstrualScreen> {
  late DateTime mes = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _registrar(DateTime dia, TipoEventoCiclo tipo) async {
    String? descricao;
    if (tipo == TipoEventoCiclo.sintoma) {
      descricao = await mostrarDialogoTexto(
        context,
        title: 'Registrar sintoma',
        label: 'Descreva com suas palavras',
        maxLength: 120,
        maxLines: 3,
      );
      if (descricao == null || descricao.trim().isEmpty) return;
    }
    widget.store.registrarEventoCiclo(
      tipo,
      description: descricao,
      registradoEm: dia,
    );
    if (mounted) setState(() {});
  }

  Future<void> _escolherRegistro(DateTime dia) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Registrar em ${dia.day.toString().padLeft(2, '0')}/${dia.month.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _registrar(dia, TipoEventoCiclo.inicio);
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Início do ciclo'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _registrar(dia, TipoEventoCiclo.fim);
              },
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Fim do ciclo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _registrar(dia, TipoEventoCiclo.sintoma);
              },
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Sintoma ou observação'),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    final primeiroDia = DateTime(mes.year, mes.month);
    final inicioGrade = primeiroDia.subtract(
      Duration(days: primeiroDia.weekday - 1),
    );
    final eventosPorDia = <String, List<EventoCiclo>>{};
    for (final evento in widget.store.eventosCiclo) {
      (eventosPorDia[chaveDia(evento.registradoEm)] ??= []).add(evento);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário menstrual')),
      body: ColunaConteudo(
        children: [
          const CabecalhoPagina(
            icon: Icons.calendar_month_outlined,
            title: 'Acompanhamento menstrual',
            subtitle:
                'Registre datas e observações do seu jeito, sem previsões clínicas.',
          ),
          const AvisoDiscreto(
            icon: Icons.info_outline_rounded,
            text:
                'Este calendário é um registro pessoal. A ELORA não prevê fertilidade, não diagnostica e não substitui avaliação profissional.',
          ),
          const SizedBox(height: 18),
          CartaoElora(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Mês anterior',
                      onPressed: () => setState(
                        () => mes = DateTime(mes.year, mes.month - 1),
                      ),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        _nomeMes(mes),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Próximo mês',
                      onPressed: () => setState(
                        () => mes = DateTime(mes.year, mes.month + 1),
                      ),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final dia in [
                      'Seg',
                      'Ter',
                      'Qua',
                      'Qui',
                      'Sex',
                      'Sáb',
                      'Dom',
                    ])
                      Expanded(child: Text(dia, textAlign: TextAlign.center)),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 42,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final dia = inicioGrade.add(Duration(days: index));
                    final eventos = eventosPorDia[chaveDia(dia)] ?? const [];
                    final noMes = dia.month == mes.month;
                    final hoje = chaveDia(dia) == chaveDia(DateTime.now());
                    final temInicio = eventos.any(
                      (evento) => evento.tipo == TipoEventoCiclo.inicio,
                    );
                    final temFim = eventos.any(
                      (evento) => evento.tipo == TipoEventoCiclo.fim,
                    );
                    final temSintoma = eventos.any(
                      (evento) => evento.tipo == TipoEventoCiclo.sintoma,
                    );
                    return Semantics(
                      button: true,
                      label:
                          '${dia.day}/${dia.month}, ${eventos.isEmpty ? 'sem registro' : 'com registro'}',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: noMes ? () => _escolherRegistro(dia) : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: temInicio
                                ? colors.accentSoft
                                : colors.surfaceAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: hoje ? colors.accent : colors.border,
                              width: hoje ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${dia.day}',
                                style: TextStyle(
                                  color: noMes ? colors.text : colors.muted,
                                  fontWeight: hoje
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                ),
                              ),
                              if (temInicio || temFim || temSintoma)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (temInicio)
                                      Icon(
                                        Icons.circle,
                                        size: 7,
                                        color: colors.accent,
                                      ),
                                    if (temFim)
                                      Icon(
                                        Icons.stop_rounded,
                                        size: 9,
                                        color: colors.accent,
                                      ),
                                    if (temSintoma)
                                      Icon(
                                        Icons.note_alt_outlined,
                                        size: 9,
                                        color: colors.accent,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AvisoDiscreto(
            icon: Icons.touch_app_outlined,
            text:
                'Toque em um dia deste mês para registrar início, fim ou uma observação.',
          ),
        ],
      ),
    );
  }

  String _nomeMes(DateTime data) {
    const nomes = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return '${nomes[data.month - 1]} de ${data.year}';
  }
}
