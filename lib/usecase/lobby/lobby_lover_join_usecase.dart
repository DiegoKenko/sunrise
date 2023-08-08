import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_load_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_update_datasource.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyLoverJoinUsecase {
  final LobbyLoadDatasource _lobbyLoadDatasource = LobbyLoadDatasource();
  final LobbyUpdateDatasource _lobbyUpdateDatasource = LobbyUpdateDatasource();
  final LoverUpdateDatasource _loverUpdateDatasource = LoverUpdateDatasource();

  Future<Result<LobbyEntity, Exception>> call(
      LoverEntity lover, String lobbyid) async {
    LobbyEntity lobby = await _lobbyLoadDatasource(lobbyid)
        .fold((success) => success, (error) => LobbyEntity.empty());
    if (lobby.isEmpty()) {
      return Failure(Exception('Lobby não existe'));
    }
    if (lobby.isLoverInLobby(lover)) {
      return lobby.toSuccess();
    }

    if (lobby.haveRoom()) {
      lobby.addLover(lover);
      lover.lobbyId = lobby.id;
      await _lobbyUpdateDatasource(lobby);
      await _loverUpdateDatasource(lover);
      return lobby.toSuccess();
    } else {
      return Failure(Exception('Lobby cheio'));
    }
  }
}
