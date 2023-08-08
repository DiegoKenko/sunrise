import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyUpdateDatasource {
  Future<Result<LobbyEntity, Exception>> call(LobbyEntity lobby) async {
    try {
      await getIt<FirebaseFirestore>()
          .collection('lobby')
          .doc(lobby.id)
          .set(lobby.toJson());
      return Success(lobby);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
