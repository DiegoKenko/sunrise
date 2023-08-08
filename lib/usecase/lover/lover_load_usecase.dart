import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LoverLoadUsecase {
  final LoverLoadDatasource loverLoadDatasource = LoverLoadDatasource();

  Future<LoverEntity> call(String id) async {
    return await loverLoadDatasource(id)
        .fold((success) => success, (error) => LoverEntity.empty());
  }
}
