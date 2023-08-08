import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_create_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';

class LobbyCreateUsecase {
  final LobbyCreateDatasource lobbyCreateDatasource = LobbyCreateDatasource();
  Future<LobbyEntity> call(LobbyEntity lobby) async {
    return await lobbyCreateDatasource(lobby).fold((success) => success, (error) => LobbyEntity.empty());
  }
}
