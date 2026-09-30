import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/missao.dart';
import '../providers/missao_provider.dart';

class DetalhesPage extends StatelessWidget {
  final Missao missao;

  const DetalhesPage({super.key, required this.missao});

  @override
  Widget build(BuildContext context) {
    // watch: a tela se redesenha quando o Provider avisar que algo mudou
    context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('DETALHES DA MISSÃO')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Título:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(missao.titulo),
            const SizedBox(height: 12),
            const Text('Dificuldade:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${missao.estrelas} ${missao.dificuldade}'),
            const SizedBox(height: 12),
            const Text('Pontos:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${missao.pontos}'),
            const SizedBox(height: 12),
            const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(missao.data),
            const SizedBox(height: 12),
            const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(missao.concluida ? 'Concluída' : 'Pendente'),
            const SizedBox(height: 24),
            if (!missao.concluida)
              ElevatedButton(
                onPressed: () async {
                  await context.read<MissaoProvider>().concluirMissao(missao);
                },
                child: const Text('CONCLUIR MISSÃO'),
              ),
          ],
        ),
      ),
    );
  }
}
