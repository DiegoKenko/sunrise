import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_load_simpleid_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyLoadSimpleIdUsecase {
  final LobbyLoadSimpleIdDatasource lobbyLoadDatasource = LobbyLoadSimpleIdDatasource();
  final LoverLoadDatasource loverLoadDatasource = LoverLoadDatasource();
  LobbyLoadSimpleIdUsecase();

  Future<LobbyEntity> call(String lobbyId) async {
    LobbyEntity lobby = await lobbyLoadDatasource(lobbyId)
        .fold((success) => success, (error) => LobbyEntity.empty());
    for (var element in lobby.lovers) {
      element = await loverLoadDatasource(element.id)
          .fold((success) => success, (error) => LoverEntity.empty());
    }
    return lobby;
  }
}
