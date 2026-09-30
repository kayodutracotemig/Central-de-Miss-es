import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/missao.dart';

class MissaoService {
  // Referência à collection "missoes" (é criada sozinha no primeiro .add)
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('missoes');

  // CREATE
  Future<void> adicionar(Missao missao) async {
    await _colecao.add(missao.toMap());
  }

  // READ
  Future<List<Missao>> buscarTodas() async {
    final snapshot = await _colecao.get();
    return snapshot.docs
        .map((doc) => Missao.fromMap(doc.data(), doc.id))
        .toList();
  }

  // UPDATE (só altera os campos que você mandar no Map)
  Future<void> atualizar(String id, Map<String, dynamic> dados) async {
    await _colecao.doc(id).update(dados);
  }

  // DELETE
  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
