import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/tema_elora.dart';
import '../../ambiente/presentation/ambiente_screen.dart';
import '../../cuidado/presentation/cuidado_conectado_screen.dart';
import '../../cuidado/presentation/cuidado_screen.dart';

class RotinaScreen extends StatelessWidget {
  const RotinaScreen({super.key, required this.store});

  final EloraStore store;

  static const _rotinas = <String, List<String>>{
    'Escritório': [
      'Alterne a postura e inclua pausas breves entre as tarefas.',
      'Ajuste tela, cadeira e iluminação para deixar o espaço mais confortável.',
      'Anote dúvidas ou incômodos persistentes para conversar com um profissional.',
    ],
    'Em casa': [
      'Reserve momentos de pausa entre as atividades e o descanso.',
      'Observe postura, iluminação e conforto do espaço que você usa.',
      'Deixe água por perto e adapte a rotina às suas necessidades.',
    ],
    'Comércio': [
      'Planeje pequenas pausas e momentos para beber água ao longo do dia.',
      'Se puder, alterne movimentos e posições durante as atividades.',
      'Anote dúvidas sobre desconfortos persistentes para buscar orientação.',
    ],
    'Externo': [
      'Prepare água, pausas e itens pessoais antes de sair.',
      'Sempre que possível, ajuste atividades intensas aos horários mais confortáveis.',
      'Consulte alertas e orientações oficiais da sua região antes de definir deslocamentos.',
    ],
  };

  static const _rotulosRotina = <String, String>{
    'Escritório': 'No computador',
    'Em casa': 'Em casa',
    'Comércio': 'Em atendimento / em pé',
    'Externo': 'Ao ar livre',
  };

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => pagina));
  }

  void _planejarPausa(BuildContext context) {
    const titulo = 'Planejar uma pausa';
    final existe = store.metas.any(
      (meta) => meta.title.trim().toLowerCase() == titulo.toLowerCase(),
    );
    if (!existe) store.adicionarMeta(titulo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          existe
              ? 'A pausa já está no seu cuidado.'
              : 'Pausa adicionada ao seu cuidado.',
        ),
      ),
    );
  }

  _Prioridade _prioridade() {
    if (store.orientacoesContextuais.isNotEmpty) {
      final orientacao = store.orientacoesContextuais.first;
      return _Prioridade(orientacao.titulo, orientacao.mensagem);
    }
    if (store.contextoTrabalho == 'Externo') {
      return const _Prioridade(
        'Preparação para o ambiente',
        'Antes de sair, organize água, pausas e consulte fontes oficiais da sua região. A ELORA não mostra clima em tempo real.',
      );
    }
    if (store.diabetesAtivo) {
      return const _Prioridade(
        'Organize sua alimentação',
        'Quando fizer sentido na sua rotina, registre uma refeição para manter seu histórico pessoal organizado.',
      );
    }
    return const _Prioridade(
      'Seu cuidado acompanha seu dia',
      'Inclua pausas, água e conforto na sua rotina. Pequenas ações podem ajudar você a se organizar com mais calma.',
    );
  }

  List<_AcaoHoje> _acoes(BuildContext context) {
    final acoes = <_AcaoHoje>[
      _AcaoHoje(
        icone: Icons.pause_circle_outline_rounded,
        titulo: 'Planejar uma pausa',
        descricao: 'Adicione uma meta simples para acompanhar em Meu cuidado.',
        aoTocar: () => _planejarPausa(context),
      ),
    ];
    if (store.diabetesAtivo) {
      acoes.add(
        _AcaoHoje(
          icone: Icons.restaurant_outlined,
          titulo: 'Registrar refeição',
          descricao: 'Guarde este momento no seu histórico pessoal.',
          aoTocar: () {
            store.registrarRefeicao();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Refeição registrada em Meu cuidado.'),
              ),
            );
          },
        ),
      );
    }
    if (store.medicamentos.isNotEmpty) {
      acoes.add(
        _AcaoHoje(
          icone: Icons.medication_outlined,
          titulo: 'Conferir medicamentos',
          descricao: 'Veja seus lembretes e confirmações no cuidado conectado.',
          aoTocar: () => _abrir(context, CuidadoConectadoScreen(store: store)),
        ),
      );
    }
    if (store.contextoTrabalho == 'Externo') {
      acoes.add(
        _AcaoHoje(
          icone: Icons.eco_outlined,
          titulo: 'Preparar-se para o ambiente',
          descricao: 'Acesse guias educativos e fontes oficiais.',
          aoTocar: () => _abrir(context, AmbienteScreen(store: store)),
        ),
      );
    }
    if (acoes.length == 1) {
      acoes.add(
        _AcaoHoje(
          icone: Icons.favorite_border_rounded,
          titulo: 'Revisar meu cuidado',
          descricao:
              'Registre um dado ou organize uma pergunta para sua consulta.',
          aoTocar: () => _abrir(context, CuidadoScreen(store: store)),
        ),
      );
    }
    return acoes.take(3).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final colors = CoresElora.of(context);
      final dicas = _rotinas[store.contextoTrabalho] ?? _rotinas['Escritório']!;
      final prioridade = _prioridade();
      final acoes = _acoes(context);
      return Scaffold(
        appBar: AppBar(title: const Text('Minha rotina')),
        body: ColunaConteudo(
          children: [
            const CabecalhoPagina(
              icon: Icons.schedule_outlined,
              title: 'Minha rotina',
              subtitle:
                  'Organize pequenos cuidados para o seu dia, no seu contexto.',
            ),
            const AvisoDiscreto(
              icon: Icons.privacy_tip_outlined,
              text:
                  'Você controla o contexto escolhido. Seus registros são pessoais e não são compartilhados com empregadores.',
            ),
            const SizedBox(height: 22),
            const CabecalhoSecao(title: 'Como é sua rotina hoje?'),
            Text(
              'Você pode mudar esse contexto quando seu dia mudar.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _rotinas.keys
                  .map(
                    (rotina) => ChoiceChip(
                      label: Text(_rotulosRotina[rotina]!),
                      selected: store.contextoTrabalho == rotina,
                      onSelected: (selecionada) {
                        if (selecionada) store.definirContextoTrabalho(rotina);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'O que merece atenção agora'),
            CartaoElora(
              color: colors.surfaceAlt,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates_outlined,
                    color: colors.accent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prioridade.titulo,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          prioridade.descricao,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'Meu plano para hoje'),
            for (final acao in acoes) ...[
              ItemAcao(
                icon: acao.icone,
                title: acao.titulo,
                subtitle: acao.descricao,
                onTap: acao.aoTocar,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),
            const CabecalhoSecao(title: 'Cuidados que combinam com seu dia'),
            for (var indice = 0; indice < dicas.length; indice++) ...[
              CartaoElora(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      indice == 0
                          ? Icons.access_time_rounded
                          : indice == 1
                          ? Icons.self_improvement_rounded
                          : Icons.info_outline_rounded,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dicas[indice],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      );
    },
  );
}

class _Prioridade {
  const _Prioridade(this.titulo, this.descricao);
  final String titulo;
  final String descricao;
}

class _AcaoHoje {
  const _AcaoHoje({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;
}
