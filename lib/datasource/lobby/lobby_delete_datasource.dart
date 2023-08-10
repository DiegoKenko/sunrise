import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LobbyDeleteDatasource {
  Future<Result<bool, Exception>> call(String lobbyId) async {
    try {
      if (lobbyId.isEmpty) {
        return Failure(Exception('EmptyID'));
      }
      await getIt<FirebaseFirestore>()
          .collection('lobby')
          .doc(lobbyId)
          .delete();
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
