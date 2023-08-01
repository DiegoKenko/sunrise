import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyLoadDatasource {
  Future<LobbyEntity> call(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await getIt<FirebaseFirestore>().collection('lobby').doc(id).get();
    LobbyEntity lobby = LobbyEntity.empty();

    if (snapshot.data() != null) {
      lobby = LobbyEntity.fromJson(snapshot.data()!);
      lobby.id = snapshot.id;
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
