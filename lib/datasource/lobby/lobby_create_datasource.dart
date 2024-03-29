import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyCreateDatasource {
  Future<Result<LobbyEntity, Exception>> call(LobbyEntity lobby) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          await getIt<FirebaseFirestore>()
              .collection('lobby')
              .add(lobby.toJson());
      lobby.id = docRef.id;
      await docRef.update(lobby.toJson());
      return Success(lobby);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
