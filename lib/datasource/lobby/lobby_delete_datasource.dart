import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyDeleteDatasource {
  Future<Result<bool, Exception>> call(LobbyEntity lobby) async {
    try {
      if (lobby.id.isEmpty) {
        return Failure(Exception('EmptyID'));
      }
      await getIt<FirebaseFirestore>()
          .collection('lobby')
          .doc(lobby.id)
          .delete();
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
