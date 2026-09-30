class Missao {
  String? id;
  String titulo;
  String dificuldade;
  int pontos;
  bool concluida;
  String data;

  Missao({
    this.id,
    required this.titulo,
    required this.dificuldade,
    required this.pontos,
    this.concluida = false,
    required this.data,
  });

  // Objeto Dart -> Map (formato que o Firestore entende)
  // Repare que o id NÃO vai aqui: ele é o nome do documento, não um campo.
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': concluida,
      'data': data,
    };
  }

  // Map (vindo do Firestore) -> objeto Dart
  factory Missao.fromMap(Map<String, dynamic> map, String id) {
    return Missao(
      id: id,
      titulo: map['titulo'] ?? '',
      dificuldade: map['dificuldade'] ?? 'Fácil',
      pontos: map['pontos'] ?? 0,
      concluida: map['concluida'] ?? false,
      data: map['data'] ?? '',
    );
  }

  // Getter: parece um campo, mas é calculado na hora
  String get estrelas {
    switch (dificuldade) {
      case 'Fácil':
        return '⭐';
      case 'Médio':
        return '⭐⭐';
      default:
        return '⭐⭐⭐';
    }
  }
}
