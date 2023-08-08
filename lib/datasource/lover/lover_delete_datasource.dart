import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class LoverDeleteDatasource {
  Future<Result<bool, Exception>> call(LoverEntity lover) async {
    try {
      await getIt<FirebaseFirestore>()
          .collection('lovers')
          .doc(lover.id)
          .delete();
      return const Success(true);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
