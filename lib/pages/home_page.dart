import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/missao.dart';
import '../providers/missao_provider.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _tituloController = TextEditingController();
  final List<String> _dificuldades = ['Fácil', 'Médio', 'Difícil'];
  String _dificuldadeSelecionada = 'Fácil';

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o título da missão')),
      );
      return;
    }

    await context
        .read<MissaoProvider>()
        .adicionarMissao(titulo, _dificuldadeSelecionada);
    _tituloController.clear();
  }

  Future<void> _concluir(Missao missao) async {
    await context.read<MissaoProvider>().concluirMissao(missao);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Missão concluída!\nVocê conquistou ${missao.pontos} pontos.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('CENTRAL DE MISSÕES')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'PONTOS CONQUISTADOS: ${provider.pontuacaoTotal}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da missão',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _dificuldadeSelecionada,
              isExpanded: true,
              items: _dificuldades
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (valor) {
                setState(() => _dificuldadeSelecionada = valor!);
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _cadastrar,
              child: const Text('CADASTRAR MISSÃO'),
            ),
            const Divider(height: 32),
            Expanded(
              child: provider.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.missoes.length,
                      itemBuilder: (context, index) {
                        final missao = provider.missoes[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesPage(missao: missao),
                                ),
                              );
                            },
                            title: Text(missao.titulo),
                            subtitle: Text(
                              'Dificuldade: ${missao.estrelas}\n'
                              'Pontos: ${missao.pontos}\n'
                              'Data: ${missao.data}\n'
                              'Status: ${missao.concluida ? "Concluída" : "Pendente"}',
                            ),
                            isThreeLine: true,
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!missao.concluida)
                                  TextButton(
                                    onPressed: () => _concluir(missao),
                                    child: const Text('CONCLUIR'),
                                  ),
                                TextButton(
                                  onPressed: () => provider.excluirMissao(missao),
                                  child: const Text('EXCLUIR'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
