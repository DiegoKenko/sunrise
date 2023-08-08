import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoverUpdateDatasource {
  Future<Result<LoverEntity, Exception>> call(LoverEntity lover) async {
    try {
      await getIt<FirebaseFirestore>()
          .collection('lovers')
          .doc(lover.id)
          .update(lover.toJson());
      return Success(lover);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
