import 'package:material_ui/material_ui.dart';

import '../../../core/data/elora_store.dart';
import '../../../core/presentation/tema_elora.dart';
import '../../../core/presentation/componentes_elora.dart';
import '../../cuidado/presentation/cuidado_screen.dart';
import '../../protecao/presentation/protecao_screen.dart';
import '../../relatorios/presentation/relatorios_screen.dart';
import '../domain/assistente_local.dart';

class AssistenteScreen extends StatefulWidget {
  const AssistenteScreen({super.key, required this.store});
  final EloraStore store;

  @override
  State<AssistenteScreen> createState() => _AssistenteScreenState();
}

class _AssistenteScreenState extends State<AssistenteScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  final mensagens = <_MensagemChat>[
    const _MensagemChat(
      'Olá! Posso ajudar você a entender dados do dia a dia, organizar uma consulta ou encontrar orientações de preparação. Escolha uma pergunta para começar.',
      false,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _send([String? prompt]) {
    final pergunta = (prompt ?? controller.text).trim();
    if (pergunta.isEmpty) return;
    final resposta = AssistenteLocal.responder(pergunta);
    setState(() {
      mensagens.add(_MensagemChat(pergunta, true));
      mensagens.add(_MensagemChat(resposta.text, false, resposta: resposta));
      controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _open(DestinoAssistente destino) {
    final page = switch (destino) {
      DestinoAssistente.cuidado => CuidadoScreen(store: widget.store),
      DestinoAssistente.protecao => ProtecaoScreen(store: widget.store),
      DestinoAssistente.ajuda => const AjudaScreen(),
      DestinoAssistente.relatorios => RelatoriosScreen(store: widget.store),
    };
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(switch (destino) {
              DestinoAssistente.cuidado => 'Meu cuidado',
              DestinoAssistente.protecao => 'Proteção e ajuda',
              DestinoAssistente.ajuda => 'Ajuda',
              DestinoAssistente.relatorios => 'Relatórios',
            }),
          ),
          body: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoresElora.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Conversar com a ELORA')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: AvisoDiscreto(
                    icon: Icons.info_outline_rounded,
                    text:
                        'Conteúdo educativo e caminhos do app. A ELORA não substitui avaliação profissional nem atendimento de emergência.',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      final message = mensagens[index];
                      return Align(
                        alignment: message.doUsuario
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 520),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: message.doUsuario
                                ? colors.accentSoft
                                : colors.surface,
                            border: Border.all(color: colors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!message.doUsuario) ...[
                                Text(
                                  'ELORA · conteúdo educativo',
                                  style: TextStyle(
                                    color: colors.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 7),
                              ],
                              Text(
                                message.text,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (index == 0 && !message.doUsuario) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Você pode escolher uma opção:',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    ActionChip(
                                      label: const Text('Frequência cardíaca'),
                                      onPressed: () => _send(
                                        'O que significa frequência cardíaca?',
                                      ),
                                    ),
                                    ActionChip(
                                      label: const Text('Registrar glicemia'),
                                      onPressed: () => _send(
                                        'Para que serve registrar glicemia?',
                                      ),
                                    ),
                                    ActionChip(
                                      label: const Text('Dia muito quente'),
                                      onPressed: () => _send(
                                        'Como me preparar para um dia muito quente?',
                                      ),
                                    ),
                                    ActionChip(
                                      label: const Text('Organizar consulta'),
                                      onPressed: () => _send(
                                        'Quero organizar minha próxima consulta.',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (message.resposta?.destino != null) ...[
                                const SizedBox(height: 9),
                                TextButton.icon(
                                  onPressed: () =>
                                      _open(message.resposta!.destino!),
                                  icon: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    message.resposta!.rotuloAcao ?? 'Abrir',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: colors.surface,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          maxLength: 240,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            hintText: 'Ex.: o que este dado significa?',
                            counterText: '',
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: 'Enviar pergunta',
                        onPressed: _send,
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MensagemChat {
  const _MensagemChat(this.text, this.doUsuario, {this.resposta});
  final String text;
  final bool doUsuario;
  final RespostaAssistente? resposta;
}
