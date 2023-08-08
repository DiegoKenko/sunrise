import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyLoadSimpleIdDatasource {
  Future<Result<LobbyEntity, Exception>> call(String simpleID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await getIt<FirebaseFirestore>()
              .collection('lobby')
              .where('simpleID', isEqualTo: simpleID.toUpperCase())
              .get();
      LobbyEntity lobby = LobbyEntity.empty();
      if (snapshot.docs.isEmpty) {
        return Failure(Exception('Sem dados'));
      }
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
      if (doc.exists) {
        lobby = LobbyEntity.fromJson(doc.data());
        lobby.id = doc.id;
      }
      return Success(lobby);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
