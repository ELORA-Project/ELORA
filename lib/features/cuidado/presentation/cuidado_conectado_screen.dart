import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/domain/contexto_cuidado.dart';
import '../../../core/domain/modelos_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../../core/presentation/dialogo_texto.dart';
import '../../../core/presentation/tema_elora.dart';
import '../data/health_integration_service.dart';
import '../data/medication_notification_service.dart';
import 'calendario_menstrual_screen.dart';

class CuidadoConectadoScreen extends StatefulWidget {
  CuidadoConectadoScreen({
    super.key,
    required this.store,
    HealthIntegrationService? healthService,
    MedicationNotificationService? notificationService,
  }) : healthService = healthService ?? HealthIntegrationService(),
       notificationService =
           notificationService ?? MedicationNotificationService();

  final EloraStore store;
  final HealthIntegrationService healthService;
  final MedicationNotificationService notificationService;

  @override
  State<CuidadoConectadoScreen> createState() => _CuidadoConectadoScreenState();
}

class _CuidadoConectadoScreenState extends State<CuidadoConectadoScreen> {
  bool _importando = false;
  bool _configurandoAlertas = false;

  Future<void> _importarSaude() async {
    setState(() => _importando = true);
    try {
      final result = await widget.healthService.autorizarEImportar();
      if (!mounted) return;
      switch (result.estado) {
        case EstadoIntegracaoSaude.concluida:
          widget.store.salvarMetricasImportadas(result.metricas);
          _message(
            result.metricas.isEmpty
                ? 'Permissão concedida, mas nenhum registro foi encontrado nos últimos 7 dias.'
                : '${result.metricas.length} registros importados com sua autorização.',
          );
        case EstadoIntegracaoSaude.negada:
          _message('A permissão não foi concedida. Nenhum dado foi importado.');
        case EstadoIntegracaoSaude.indisponivel:
          _message(
            'A integração está disponível em celulares com Health Connect ou Apple Saúde.',
          );
      }
    } catch (_) {
      if (mounted) {
        _message(
          'Não foi possível acessar os dados de saúde neste dispositivo.',
        );
      }
    } finally {
      if (mounted) setState(() => _importando = false);
    }
  }

  Future<void> _adicionarMedicamento() async {
    final name = await mostrarDialogoTexto(
      context,
      title: 'Novo lembrete',
      label: 'Nome usado por você para identificar o medicamento',
      maxLength: 80,
    );
    if (name == null || name.trim().isEmpty || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'HORÁRIO DEFINIDO NA SUA ROTINA',
    );
    if (time == null) return;
    final medication = widget.store.adicionarMedicamento(
      name,
      TimeOfDayValue(time.hour, time.minute),
    );
    if (medication != null && widget.store.lembretesSistemaAtivos) {
      final scheduled = await widget.notificationService.scheduleDaily(
        medication,
      );
      if (!scheduled && mounted) {
        widget.store.definirLembretesSistema(false);
        _message(
          'O lembrete foi salvo no app, mas o alerta do celular precisa ser ativado novamente.',
        );
      }
    }
  }

  Future<void> _ativarAlertas() async {
    setState(() => _configurandoAlertas = true);
    final allowed = await widget.notificationService.requestPermission();
    if (!mounted) return;
    if (!allowed) {
      setState(() => _configurandoAlertas = false);
      _message(
        'Sem a permissão de notificações, os lembretes continuam visíveis apenas dentro da ELORA.',
      );
      return;
    }
    var scheduled = true;
    for (final medication in widget.store.medicamentos) {
      scheduled =
          await widget.notificationService.scheduleDaily(medication) &&
          scheduled;
    }
    widget.store.definirLembretesSistema(scheduled);
    setState(() => _configurandoAlertas = false);
    _message(
      scheduled
          ? 'Alertas diários ativados. O texto da tela bloqueada será discreto.'
          : 'A permissão foi concedida, mas não foi possível programar os alertas.',
    );
  }

  Future<void> _removerMedicamento(MedicamentoAgendado medication) async {
    await widget.notificationService.cancel(medication);
    widget.store.removerMedicamento(medication.id);
  }

  Future<void> _confirmarMedicamento(MedicamentoAgendado medication) async {
    widget.store.confirmarMedicamento(medication.id);
    if (widget.store.lembretesSistemaAtivos) {
      await widget.notificationService.scheduleDaily(
        medication,
        startTomorrow: true,
      );
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final colors = CoresElora.of(context);
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Cuidado conectado')),
        body: ColunaConteudo(
          children: [
            const CabecalhoPagina(
              icon: Icons.health_and_safety_outlined,
              title: 'Seu cuidado, do seu jeito',
              subtitle:
                  'Uma central pessoal para organizar dados, rotina e lembretes. Tudo é opcional.',
            ),
            const AvisoDiscreto(
              icon: Icons.privacy_tip_outlined,
              text:
                  'A ELORA organiza registros e lembretes. Não diagnostica, não altera tratamentos e não recomenda doses.',
            ),
            const SizedBox(height: 22),
            const CabecalhoSecao(title: 'Orientações para agora'),
            if (store.orientacoesContextuais.isEmpty)
              const AvisoDiscreto(
                icon: Icons.check_circle_outline_rounded,
                text: 'Nenhum lembrete pendente neste momento.',
              )
            else
              for (final insight in store.orientacoesContextuais) ...[
                CartaoElora(
                  color: colors.surfaceAlt,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.titulo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        insight.mensagem,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 18),
            const CabecalhoSecao(title: 'Dados conectados ou manuais'),
            CartaoElora(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Conectar dados com sua autorização',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Importe somente dados que você escolher compartilhar. Você também pode registrar informações manualmente nesta tela.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (store.ultimaSincronizacaoSaude != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Última atualização: ${dataCurta(store.ultimaSincronizacaoSaude!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _importando ? null : _importarSaude,
                    icon: _importando
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.watch_outlined),
                    label: Text(
                      store.integracaoSaudeAtiva
                          ? 'Atualizar dados conectados'
                          : 'Conectar com minha autorização',
                    ),
                  ),
                ],
              ),
            ),
            if (store.integracaoSaudeAtiva) ...[
              const SizedBox(height: 10),
              CartaoElora(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Fontes conectadas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (store.fontesConectadas.isEmpty)
                      const Text(
                        'Conexão autorizada sem dados importados.',
                        style: TextStyle(fontSize: 13),
                      )
                    else
                      for (final fonte in store.fontesConectadas)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.watch_outlined,
                            color: colors.accent,
                          ),
                          title: Text(fonte),
                          trailing: IconButton(
                            tooltip: 'Remover fonte conectada',
                            onPressed: () => store.removerFonteConectada(fonte),
                            icon: const Icon(Icons.link_off_rounded),
                          ),
                        ),
                    TextButton.icon(
                      onPressed: store.desconectarDadosSaude,
                      icon: const Icon(Icons.link_off_rounded),
                      label: const Text(
                        'Desconectar todos os dados importados',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const CabecalhoSecao(title: 'Acompanhamentos opcionais'),
            _AcompanhamentoCard(
              icon: Icons.bloodtype_outlined,
              titulo: 'Diabetes e rotina',
              descricao:
                  'Libera em Meu cuidado registros de refeição, glicemia e insulina.',
              ativo: store.diabetesAtivo,
              aoAlterar: store.definirDiabetes,
            ),
            const SizedBox(height: 10),
            _AcompanhamentoCard(
              icon: Icons.monitor_heart_outlined,
              titulo: 'Acompanhamento de pressão',
              descricao:
                  'Libera o registro manual de medições feitas no aparelho.',
              ativo: store.hipertensaoAtiva,
              aoAlterar: store.definirHipertensao,
            ),
            if (store.perfilCuidado == PerfilCuidado.mulher) ...[
              const SizedBox(height: 10),
              _AcompanhamentoCard(
                icon: Icons.calendar_month_outlined,
                titulo: 'Acompanhamento menstrual',
                descricao:
                    'Registre datas e observações no calendário pessoal, sem previsões clínicas.',
                ativo: store.cicloAtivo,
                aoAlterar: store.definirCiclo,
                aoAbrir: store.cicloAtivo
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              CalendarioMenstrualScreen(store: store),
                        ),
                      )
                    : null,
              ),
            ],
            const SizedBox(height: 10),
            const AvisoDiscreto(
              icon: Icons.info_outline_rounded,
              text:
                  'Ativar um acompanhamento apenas organiza atalhos e registros pessoais. A ELORA não interpreta resultados nem substitui orientações profissionais.',
            ),
            const SizedBox(height: 24),
            CabecalhoSecao(
              title: 'Medicamentos',
              action: TextButton.icon(
                onPressed: _adicionarMedicamento,
                icon: const Icon(Icons.add_alarm_rounded),
                label: const Text('Adicionar'),
              ),
            ),
            const AvisoDiscreto(
              icon: Icons.medication_outlined,
              text:
                  'Use o horário orientado pelo seu profissional. A ELORA apenas lembra e registra a confirmação.',
            ),
            const SizedBox(height: 10),
            if (!store.lembretesSistemaAtivos)
              OutlinedButton.icon(
                onPressed: _configurandoAlertas ? null : _ativarAlertas,
                icon: _configurandoAlertas
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.notifications_active_outlined),
                label: const Text('Ativar alertas no celular'),
              )
            else
              const AvisoDiscreto(
                icon: Icons.notifications_active_rounded,
                text: 'Alertas diários do celular estão ativos.',
              ),
            const SizedBox(height: 10),
            if (store.medicamentos.isEmpty)
              const AvisoDiscreto(
                icon: Icons.medication_outlined,
                text:
                    'Nenhum lembrete configurado. Se fizer sentido para você, adicione um horário já orientado pelo seu profissional.',
              )
            else
              for (final medication in store.medicamentos) ...[
                CartaoElora(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(child: Text(medication.horarioFormatado)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          medication.nome,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (!medication.confirmadoEm(DateTime.now()))
                        IconButton.filledTonal(
                          tooltip: 'Confirmar que tomei',
                          onPressed: () => _confirmarMedicamento(medication),
                          icon: const Icon(Icons.check_rounded),
                        )
                      else
                        Icon(Icons.check_circle_rounded, color: colors.accent),
                      IconButton(
                        tooltip: 'Remover lembrete',
                        onPressed: () => _removerMedicamento(medication),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            if (store.perfilCuidado == PerfilCuidado.mulher &&
                store.cicloAtivo) ...[
              const SizedBox(height: 24),
              const CabecalhoSecao(title: 'Ciclo menstrual opcional'),
              ItemAcao(
                icon: Icons.calendar_month_outlined,
                title: 'Abrir calendário menstrual',
                subtitle: 'Registre início, fim e observações por dia.',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => CalendarioMenstrualScreen(store: store),
                  ),
                ),
              ),
            ],
            if (store.metricasConectadas.isNotEmpty) ...[
              const SizedBox(height: 24),
              const CabecalhoSecao(
                title: 'Registros recentes conectados ou manuais',
              ),
              for (final metric in store.metricasConectadas.take(8)) ...[
                CartaoElora(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.insights_rounded, color: colors.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(metric.tipo.rotulo),
                            Text(
                              '${dataCurta(metric.registradaEm)} · ${metric.fonte}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${metric.valor.toStringAsFixed(metric.valor == metric.valor.roundToDouble() ? 0 : 1)} ${metric.tipo.unidade}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AcompanhamentoCard extends StatelessWidget {
  const _AcompanhamentoCard({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.ativo,
    required this.aoAlterar,
    this.aoAbrir,
  });

  final IconData icon;
  final String titulo;
  final String descricao;
  final bool ativo;
  final ValueChanged<bool> aoAlterar;
  final VoidCallback? aoAbrir;

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return CartaoElora(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(descricao, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ativo
                        ? OutlinedButton.icon(
                            onPressed: () => aoAlterar(false),
                            icon: const Icon(Icons.check_circle_rounded),
                            label: const Text('Ativo · desativar'),
                          )
                        : FilledButton.tonalIcon(
                            onPressed: () => aoAlterar(true),
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            label: const Text('Ativar acompanhamento'),
                          ),
                    if (aoAbrir != null)
                      TextButton.icon(
                        onPressed: aoAbrir,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: const Text('Abrir calendário'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
