import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/contexto_cuidado.dart';
import '../../../core/domain/modelos_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/dialogo_texto.dart';
import '../../../core/presentation/tema_elora.dart';
import 'cuidado_conectado_screen.dart';
import '../../relatorios/presentation/relatorios_screen.dart';

class CuidadoScreen extends StatefulWidget {
  const CuidadoScreen({super.key, required this.store});
  final EloraStore store;

  @override
  State<CuidadoScreen> createState() => _CuidadoScreenState();
}

class _CuidadoScreenState extends State<CuidadoScreen> {
  bool mostrandoMetas = false;

  void _adicionarRegistro() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _FormularioRegistro(store: widget.store),
    );
  }

  Future<void> _adicionarMeta([String sugestao = '']) async {
    final titulo = await mostrarDialogoTexto(
      context,
      title: 'Nova meta de cuidado',
      label: 'O que você quer acompanhar?',
      initialValue: sugestao,
    );
    if (titulo != null) widget.store.adicionarMeta(titulo);
  }

  Future<void> _editarNota() async {
    final nota = await mostrarDialogoTexto(
      context,
      title: 'Perguntas para a consulta',
      label: 'Anote dúvidas para conversar com um profissional',
      initialValue: widget.store.notaConsulta,
      maxLength: 500,
      maxLines: 5,
    );
    if (nota != null) widget.store.definirNotaConsulta(nota);
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) => ColunaConteudo(
        children: [
          const CabecalhoPagina(
            icon: Icons.favorite_border_rounded,
            title: 'Meu cuidado',
            subtitle:
                'Registre o que faz sentido para você e acompanhe seu histórico.',
          ),
          const AvisoDiscreto(
            icon: Icons.science_outlined,
            text:
                'A ELORA organiza registros pessoais. Ela não interpreta medições nem realiza diagnóstico clínico.',
          ),
          const SizedBox(height: 14),
          ItemAcao(
            icon: Icons.health_and_safety_outlined,
            title: 'Cuidado conectado',
            subtitle:
                'Acompanhamentos, dispositivos, medicamentos e calendário opcional.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => CuidadoConectadoScreen(store: widget.store),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Registros'),
                icon: Icon(Icons.monitor_heart_outlined),
              ),
              ButtonSegment(
                value: true,
                label: Text('Metas'),
                icon: Icon(Icons.check_circle_outline_rounded),
              ),
            ],
            selected: {mostrandoMetas},
            onSelectionChanged: (selecao) =>
                setState(() => mostrandoMetas = selecao.first),
            showSelectedIcon: false,
          ),
          const SizedBox(height: 22),
          if (!mostrandoMetas) ...[
            const CabecalhoSecao(title: 'Indicadores principais'),
            _IndicadoresPrincipais(store: widget.store),
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'Seus dados registrados'),
            const AvisoDiscreto(
              icon: Icons.info_outline_rounded,
              text:
                  'Registre uma medida quando quiser acompanhar seu histórico ou organizar uma conversa com um profissional.',
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _adicionarRegistro,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar registro'),
            ),
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'Registros de hoje'),
            Text(
              dataPorExtenso(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            _ResumoDoDia(
              store: widget.store,
              dia: widget.store.diarioDoDia(DateTime.now()),
            ),
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'Para a próxima consulta'),
            ItemAcao(
              icon: Icons.edit_note_rounded,
              title: widget.store.notaConsulta.isEmpty
                  ? 'Anotar uma dúvida'
                  : 'Editar suas anotações',
              subtitle: widget.store.notaConsulta.isEmpty
                  ? 'Guarde perguntas para conversar com um profissional.'
                  : widget.store.notaConsulta,
              onTap: _editarNota,
            ),
          ] else ...[
            Text(
              '${widget.store.metasConcluidasHoje} de ${widget.store.metas.length} metas realizadas hoje',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            if (widget.store.metas.isEmpty) ...[
              const AvisoDiscreto(
                icon: Icons.flag_outlined,
                text:
                    'Você ainda não criou metas. Escolha uma ação simples que faça sentido para sua rotina.',
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Fazer uma pausa'),
                    onPressed: () => _adicionarMeta('Fazer uma pausa'),
                  ),
                  ActionChip(
                    label: const Text('Organizar a consulta'),
                    onPressed: () => _adicionarMeta('Organizar a consulta'),
                  ),
                ],
              ),
            ] else
              for (final meta in widget.store.metas) ...[
                CartaoElora(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: meta.completedOn == chaveDia(DateTime.now()),
                        onChanged: (_) => widget.store.alternarMeta(meta.id),
                      ),
                      Expanded(
                        child: Text(
                          meta.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remover meta',
                        onPressed: () => widget.store.removerMeta(meta.id),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => _adicionarMeta(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Criar meta'),
            ),
          ],
        ],
      ),
    );
  }
}

class _IndicadoresPrincipais extends StatelessWidget {
  const _IndicadoresPrincipais({required this.store});
  final EloraStore store;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, limites) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: TipoIndicador.values.map((indicador) {
          final registro = store.ultimoRegistro(indicador);
          return SizedBox(
            width: limites.maxWidth > 520
                ? (limites.maxWidth - 20) / 3
                : (limites.maxWidth - 10) / 2,
            child: CartaoElora(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_iconeIndicador(indicador), size: 20),
                  const SizedBox(height: 8),
                  Text(
                    indicador.rotulo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    registro == null
                        ? 'Sem registro'
                        : indicador.formatar(registro.value),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResumoDoDia extends StatelessWidget {
  const _ResumoDoDia({required this.store, required this.dia});
  final EloraStore store;
  final DiaDiarioCuidado? dia;

  @override
  Widget build(BuildContext context) {
    if (dia == null) {
      return const AvisoDiscreto(
        icon: Icons.history_rounded,
        text:
            'Ainda não há registros hoje. Quando fizer sentido, você pode acompanhar um dado ou uma ação de cuidado.',
      );
    }
    final titulos = dia!.itens
        .map((item) => item.titulo)
        .toSet()
        .take(3)
        .join(' · ');
    return CartaoElora(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ResumoDiaScreen(store: store, dia: dia!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumo de hoje',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  '${dia!.dados.length} ${dia!.dados.length == 1 ? 'dado' : 'dados'} registrados · ${dia!.acoes.length} ${dia!.acoes.length == 1 ? 'ação' : 'ações'} de cuidado',
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

IconData _iconeIndicador(TipoIndicador indicador) => switch (indicador) {
  TipoIndicador.hidratacao => Icons.water_drop_outlined,
  TipoIndicador.sono => Icons.nightlight_outlined,
  TipoIndicador.frequenciaCardiaca => Icons.monitor_heart_outlined,
};

enum _TipoRegistro { hidratacao, sono, frequenciaCardiaca, glicemia, pressao }

extension on _TipoRegistro {
  String get titulo => switch (this) {
    _TipoRegistro.hidratacao => 'Água ingerida',
    _TipoRegistro.sono => 'Tempo de sono',
    _TipoRegistro.frequenciaCardiaca => 'Frequência cardíaca',
    _TipoRegistro.glicemia => 'Glicemia',
    _TipoRegistro.pressao => 'Pressão arterial',
  };

  String get explicacao => switch (this) {
    _TipoRegistro.hidratacao =>
      'Guarde a quantidade de água que você ingeriu para acompanhar sua rotina. A necessidade varia de pessoa para pessoa.',
    _TipoRegistro.sono =>
      'Registre quantas horas você dormiu. Um registro isolado não explica sozinho a qualidade do sono.',
    _TipoRegistro.frequenciaCardiaca =>
      'Registre a medida em bpm. Atividade, emoções e outros fatores mudam esse valor; a ELORA não faz interpretação clínica.',
    _TipoRegistro.glicemia =>
      'Guarde o valor medido para organizar seu histórico e conversar com seu profissional. A ELORA não interpreta o resultado.',
    _TipoRegistro.pressao =>
      'Registre os dois números mostrados no aparelho: sistólica e diastólica. A ELORA apenas guarda a informação.',
  };

  String get unidade => switch (this) {
    _TipoRegistro.hidratacao => 'mL',
    _TipoRegistro.sono => 'horas',
    _TipoRegistro.frequenciaCardiaca => 'bpm',
    _TipoRegistro.glicemia => 'mg/dL',
    _TipoRegistro.pressao => 'mmHg',
  };

  IconData get icone => switch (this) {
    _TipoRegistro.hidratacao => Icons.water_drop_outlined,
    _TipoRegistro.sono => Icons.nightlight_outlined,
    _TipoRegistro.frequenciaCardiaca => Icons.monitor_heart_outlined,
    _TipoRegistro.glicemia => Icons.bloodtype_outlined,
    _TipoRegistro.pressao => Icons.favorite_outline_rounded,
  };
}

class _FormularioRegistro extends StatefulWidget {
  const _FormularioRegistro({required this.store});
  final EloraStore store;

  @override
  State<_FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<_FormularioRegistro> {
  final formulario = GlobalKey<FormState>();
  final valor = TextEditingController();
  final sistolica = TextEditingController();
  final diastolica = TextEditingController();
  _TipoRegistro tipo = _TipoRegistro.hidratacao;

  @override
  void dispose() {
    valor.dispose();
    sistolica.dispose();
    diastolica.dispose();
    super.dispose();
  }

  List<_TipoRegistro> get _opcoes => [
    _TipoRegistro.hidratacao,
    _TipoRegistro.sono,
    _TipoRegistro.frequenciaCardiaca,
    if (widget.store.diabetesAtivo) _TipoRegistro.glicemia,
    if (widget.store.hipertensaoAtiva) _TipoRegistro.pressao,
  ];

  void _salvar() {
    if (!formulario.currentState!.validate()) return;
    if (tipo == _TipoRegistro.pressao) {
      widget.store
        ..adicionarMetricaManual(
          TipoMetricaConectada.pressaoSistolica,
          double.parse(sistolica.text.replaceAll(',', '.')),
        )
        ..adicionarMetricaManual(
          TipoMetricaConectada.pressaoDiastolica,
          double.parse(diastolica.text.replaceAll(',', '.')),
        );
    } else {
      final numero = double.parse(valor.text.replaceAll(',', '.'));
      switch (tipo) {
        case _TipoRegistro.hidratacao:
          widget.store.adicionarRegistro(TipoIndicador.hidratacao, numero);
        case _TipoRegistro.sono:
          widget.store.adicionarRegistro(TipoIndicador.sono, numero);
        case _TipoRegistro.frequenciaCardiaca:
          widget.store.adicionarRegistro(
            TipoIndicador.frequenciaCardiaca,
            numero,
          );
        case _TipoRegistro.glicemia:
          widget.store.adicionarMetricaManual(
            TipoMetricaConectada.glicemia,
            numero,
          );
        case _TipoRegistro.pressao:
          break;
      }
    }
    Navigator.pop(context);
  }

  String? _validarNumero(String? texto) {
    final numero = double.tryParse((texto ?? '').replaceAll(',', '.'));
    if (numero == null || !numero.isFinite || numero <= 0 || numero > 10000) {
      return 'Informe um valor numérico válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        8,
        22,
        MediaQuery.viewInsetsOf(context).bottom + 22,
      ),
      child: Form(
        key: formulario,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Adicionar registro',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                'Os registros ajudam você a organizar seu histórico. Escolha o dado que quer guardar.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _opcoes
                    .map(
                      (opcao) => ChoiceChip(
                        avatar: Icon(opcao.icone, size: 18),
                        label: Text(opcao.titulo),
                        selected: tipo == opcao,
                        onSelected: (_) => setState(() => tipo = opcao),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AvisoDiscreto(
                icon: Icons.menu_book_outlined,
                text: tipo.explicacao,
              ),
              const SizedBox(height: 16),
              if (tipo == _TipoRegistro.pressao)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: sistolica,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Sistólica (ex.: 12)',
                        ),
                        validator: _validarNumero,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('/'),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: diastolica,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Diastólica (ex.: 6)',
                        ),
                        validator: _validarNumero,
                      ),
                    ),
                  ],
                )
              else
                TextFormField(
                  controller: valor,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: '${tipo.titulo} em ${tipo.unidade}',
                  ),
                  validator: _validarNumero,
                  onFieldSubmitted: (_) => _salvar(),
                ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Salvar registro'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
