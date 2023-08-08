import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyLoadDatasource {
  Future<Result<LobbyEntity, Exception>> call(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await getIt<FirebaseFirestore>().collection('lobby').doc(id).get();
      LobbyEntity lobby = LobbyEntity.empty();
      if (snapshot.exists) {
        if (snapshot.data() != null) {
          lobby = LobbyEntity.fromJson(snapshot.data()!);
          lobby.id = snapshot.id;
          return Success(lobby);
        }
      }
      return Failure(Exception('Sem dados'));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
