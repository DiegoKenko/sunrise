import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyCreateDatasource {
  Future<LobbyEntity> call(LobbyEntity lobby) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await getIt<FirebaseFirestore>()
            .collection('lobby')
            .add(lobby.toJson());
    lobby.id = docRef.id;
    await docRef.update(lobby.toJson());
    return lobby;
  }
}
