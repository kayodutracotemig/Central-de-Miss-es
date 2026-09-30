import 'package:flutter/material.dart';
import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  List<Missao> _missoes = [];
  bool _carregando = false;

  List<Missao> get missoes => _missoes;
  bool get carregando => _carregando;

  // Soma só os pontos das missões concluídas
  int get pontuacaoTotal {
    return _missoes
        .where((missao) => missao.concluida)
        .fold(0, (soma, missao) => soma + missao.pontos);
  }

  int _pontosPorDificuldade(String dificuldade) {
    switch (dificuldade) {
      case 'Fácil':
        return 10;
      case 'Médio':
        return 20;
      default:
        return 30;
    }
  }

  String _dataDeHoje() {
    final agora = DateTime.now();
    final dia = agora.day.toString().padLeft(2, '0');
    final mes = agora.month.toString().padLeft(2, '0');
    return '$dia/$mes/${agora.year}';
  }

  Future<void> carregarMissoes() async {
    _carregando = true;
    notifyListeners();

    _missoes = await _service.buscarTodas();

    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionarMissao(String titulo, String dificuldade) async {
    final missao = Missao(
      titulo: titulo,
      dificuldade: dificuldade,
      pontos: _pontosPorDificuldade(dificuldade),
      data: _dataDeHoje(),
    );

    await _service.adicionar(missao);
    await carregarMissoes(); // recarrega para pegar o id gerado pelo Firestore
  }

  Future<void> concluirMissao(Missao missao) async {
    await _service.atualizar(missao.id!, {'concluida': true});
    missao.concluida = true;
    notifyListeners();
  }

  Future<void> excluirMissao(Missao missao) async {
    await _service.excluir(missao.id!);
    _missoes.remove(missao);
    notifyListeners();
  }
}
