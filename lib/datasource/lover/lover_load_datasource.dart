import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoverLoadDatasource {
  Future<Result<LoverEntity, Exception>> call(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await getIt<FirebaseFirestore>().collection('lovers').doc(id).get();
      if (snapshot.exists) {
        LoverEntity lover = LoverEntity.fromJson(snapshot.data()!);
        lover.id = snapshot.id;
        return Success(lover);
      } else {
        return Failure(Exception('Sem dados'));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
