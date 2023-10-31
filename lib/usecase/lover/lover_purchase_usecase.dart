import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LoverPurchaseUsecase {
  LoverUpdateDatasource _loverUpdateDatasource = LoverUpdateDatasource();
  LoverLoadDatasource _loverLoadDatasource = LoverLoadDatasource();

  Future<double> spendSun(double ammount, String loverId) async {
    LoverEntity? lover = await _loverLoadDatasource
        .call(loverId)
        .fold((success) => success, (error) => null);

    if (lover == null) {
      return 99999999;
    } else {
      lover.suns = lover.suns - ammount;
      await _loverUpdateDatasource.call(lover);
      return lover.suns;
    }
  }

  Future<double> earnSun(double ammount, String loverId) async {
    LoverEntity? lover = await _loverLoadDatasource
        .call(loverId)
        .fold((success) => success, (error) => null);

    if (lover == null) {
      return 99999999;
    } else {
      lover.suns = lover.suns + ammount;
      await _loverUpdateDatasource.call(lover);
      return lover.suns;
    }
  }
}
