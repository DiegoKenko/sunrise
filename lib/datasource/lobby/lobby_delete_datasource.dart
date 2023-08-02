import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyDeleteDatasource {
  Future<void> call(LobbyEntity lobby) async {
    if (lobby.id.isEmpty) {
      return;
    }
    await getIt<FirebaseFirestore>().collection('lobby').doc(lobby.id).delete();
  }
}
