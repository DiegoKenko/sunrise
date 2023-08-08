import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoverCreateDatasource {
  Future<Result<LoverEntity, Exception>> call(LoverEntity lover) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          await getIt<FirebaseFirestore>()
              .collection('lovers')
              .add(lover.toJson());
      lover.id = docRef.id;
      return Success(lover);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
