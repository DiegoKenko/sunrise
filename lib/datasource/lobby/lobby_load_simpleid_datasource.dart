import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyLoadSimpleIdDatasource {
  Future<LobbyEntity> call(String simpleID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await getIt<FirebaseFirestore>()
            .collection('lobby')
            .where('simpleID', isEqualTo: simpleID.toUpperCase())
            .get();
    LobbyEntity lobby = LobbyEntity.empty();
    if (snapshot.docs.isEmpty) {
      return lobby;
    }
    QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
    if (doc.exists) {
      lobby = LobbyEntity.fromJson(doc.data());
      lobby.id = doc.id;
      if (lobby.lovers[0].id.isNotEmpty) {
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
      }
    }
    return lobby;
  }
}
