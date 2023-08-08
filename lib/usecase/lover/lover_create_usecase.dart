import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_create_datasource.dart';
import 'package:sunrise/datasource/lover/lover_create_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LoverCreateUsecase {
  LoverCreateDatasource loverCreateDatasource = LoverCreateDatasource();
  LobbyCreateDatasource lobbyCreateDatasource = LobbyCreateDatasource();

  Future<Result<LoverEntity, Exception>> call(LoverEntity lover) async {
    await lobbyCreateDatasource(LobbyEntity(lovers: [lover]));
    return await loverCreateDatasource(lover);
  }
}
