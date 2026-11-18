enum TipoIndicador { hidratacao, sono, frequenciaCardiaca }

enum PerfilCuidado { naoInformado, mulher, homem, outro }

extension DetalhesPerfilCuidado on PerfilCuidado {
  String get rotulo => switch (this) {
    PerfilCuidado.naoInformado => 'Prefiro não informar',
    PerfilCuidado.mulher => 'Mulher',
    PerfilCuidado.homem => 'Homem',
    PerfilCuidado.outro => 'Outro',
  };
}

extension DetalhesIndicador on TipoIndicador {
  String get rotulo => switch (this) {
    TipoIndicador.hidratacao => 'Hidratação',
    TipoIndicador.sono => 'Sono',
    TipoIndicador.frequenciaCardiaca => 'Frequência cardíaca',
  };

  String get unidade => switch (this) {
    TipoIndicador.hidratacao => 'mL',
    TipoIndicador.sono => 'h',
    TipoIndicador.frequenciaCardiaca => 'bpm',
  };

  String get explicacao => switch (this) {
    TipoIndicador.hidratacao =>
      'Este registro ajuda a acompanhar o consumo de água informado por você. A necessidade de líquidos varia conforme a pessoa, o clima e a atividade. Não use um valor isolado como diagnóstico.',
    TipoIndicador.sono =>
      'O tempo de sono é apenas uma parte do descanso. Rotina, qualidade e como você se sente também importam. Observe mudanças ao longo do tempo e leve dúvidas a um profissional.',
    TipoIndicador.frequenciaCardiaca =>
      'A frequência cardíaca muda com esforço, emoções e outros fatores. Um número isolado, especialmente sem contexto, não permite concluir se há um problema de saúde.',
  };

  String formatar(double value) {
    final decimals = value == value.roundToDouble() ? 0 : 1;
    return '${value.toStringAsFixed(decimals).replaceAll('.', ',')} $unidade';
  }
}

class RegistroSaude {
  const RegistroSaude({
    required this.id,
    required this.indicador,
    required this.value,
    required this.createdAt,
  });

  final String id;
  final TipoIndicador indicador;
  final double value;
  final DateTime createdAt;

  Map<String, Object> toJson() => {
    'id': id,
    'metric': indicador.name,
    'value': value,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RegistroSaude.fromJson(Map<String, dynamic> json) => RegistroSaude(
    id: json['id'] as String,
    indicador: switch (json['metric'] as String) {
      'hydration' => TipoIndicador.hidratacao,
      'sleep' => TipoIndicador.sono,
      'heartRate' => TipoIndicador.frequenciaCardiaca,
      final code => TipoIndicador.values.byName(code),
    },
    value: (json['value'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class MetaCuidado {
  const MetaCuidado({required this.id, required this.title, this.completedOn});

  final String id;
  final String title;
  final String? completedOn;

  MetaCuidado copyWith({String? completedOn, bool clearCompletion = false}) =>
      MetaCuidado(
        id: id,
        title: title,
        completedOn: clearCompletion ? null : completedOn ?? this.completedOn,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'completedOn': completedOn,
  };

  factory MetaCuidado.fromJson(Map<String, dynamic> json) => MetaCuidado(
    id: json['id'] as String,
    title: json['title'] as String,
    completedOn: json['completedOn'] as String?,
  );
}

class TarefaPlano {
  const TarefaPlano({
    required this.id,
    required this.title,
    this.done = false,
    this.concluidaEm,
  });

  final String id;
  final String title;
  final bool done;
  final String? concluidaEm;

  TarefaPlano copyWith({
    bool? done,
    String? concluidaEm,
    bool limparConclusao = false,
  }) => TarefaPlano(
    id: id,
    title: title,
    done: done ?? this.done,
    concluidaEm: limparConclusao ? null : concluidaEm ?? this.concluidaEm,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'done': done,
    'completedOn': concluidaEm,
  };

  factory TarefaPlano.fromJson(Map<String, dynamic> json) => TarefaPlano(
    id: json['id'] as String,
    title: json['title'] as String,
    done: json['done'] as bool? ?? false,
    concluidaEm: json['completedOn'] as String?,
  );
}

enum CategoriaDiarioCuidado { dadosRegistrados, acoesCuidado }

class ItemDiarioCuidado {
  const ItemDiarioCuidado({
    required this.categoria,
    required this.titulo,
    required this.data,
    this.valor,
    this.origem,
    this.idRegistroManual,
    this.idMetricaManual,
  });

  final CategoriaDiarioCuidado categoria;
  final String titulo;
  final DateTime? data;
  final String? valor;
  final String? origem;
  final String? idRegistroManual;
  final String? idMetricaManual;

  bool get podeRemover => idRegistroManual != null || idMetricaManual != null;
}

class DiaDiarioCuidado {
  const DiaDiarioCuidado({required this.data, required this.itens});

  final DateTime data;
  final List<ItemDiarioCuidado> itens;

  List<ItemDiarioCuidado> get dados => itens
      .where(
        (item) => item.categoria == CategoriaDiarioCuidado.dadosRegistrados,
      )
      .toList(growable: false);

  List<ItemDiarioCuidado> get acoes => itens
      .where((item) => item.categoria == CategoriaDiarioCuidado.acoesCuidado)
      .toList(growable: false);
}

String chaveDia(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String dataCurta(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String horarioCurto(DateTime? data) {
  if (data == null) return 'Hoje';
  return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
}

String dataPorExtenso(DateTime data) {
  const dias = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];
  const meses = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  return '${dias[data.weekday - 1]}, ${data.day} de ${meses[data.month - 1]}';
}
