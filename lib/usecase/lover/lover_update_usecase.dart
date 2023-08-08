import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LoverUpdateUsecase {
  final LoverUpdateDatasource loverUpdateDatasource = LoverUpdateDatasource();
  Future<LoverEntity> call(LoverEntity lover) async {
    return await loverUpdateDatasource(lover)
        .fold((success) => success, (error) => LoverEntity.empty());
  }
}
