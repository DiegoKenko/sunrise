import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_delete_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_update_datasource.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyLoverLeaveUsecase {
  final LobbyDeleteDatasource _lobbyDeleteDatasource = LobbyDeleteDatasource();
  final LobbyUpdateDatasource _lobbyUpdateDatasource = LobbyUpdateDatasource();
  final LoverUpdateDatasource _loverUpdateDatasource = LoverUpdateDatasource();
  Future<Result<LobbyEntity, Exception>> call(
      LobbyEntity lobby, LoverEntity lover) async {
    try {
      lobby.removeLover(lover);
      lover.removeLobby();
      await _lobbyUpdateDatasource(lobby);
      await _loverUpdateDatasource(lover);
      if (lobby.isEmpty()) {
        await _lobbyDeleteDatasource(lobby.id);
      }
      return lobby.toSuccess();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
