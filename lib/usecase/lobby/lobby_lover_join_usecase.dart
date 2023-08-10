import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_delete_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_load_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_load_simpleid_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_update_datasource.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyLoverJoinUsecase {
  final LobbyLoadSimpleIdDatasource _lobbyLoadSimpleIdDatasource =
      LobbyLoadSimpleIdDatasource();
  final LobbyDeleteDatasource _lobbyDeleteDatasource = LobbyDeleteDatasource();
  final LobbyUpdateDatasource _lobbyUpdateDatasource = LobbyUpdateDatasource();
  final LoverUpdateDatasource _loverUpdateDatasource = LoverUpdateDatasource();

  Future<Result<LobbyEntity, Exception>> call(
    LoverEntity lover,
    String lobbyid,
  ) async {
    String oldLobbyId = lover.lobbyId;
    Result<LobbyEntity, Exception> resultLobbyLoad =
        await _lobbyLoadSimpleIdDatasource(lobbyid);

    Result<LobbyEntity, Exception> lobbyUpdate =
        await resultLobbyLoad.fold((success) async {
      if (success.isEmpty()) return Failure(Exception('Lobby não existe'));
      if (success.isLoverInLobby(lover)) return success.toSuccess();

      if (success.haveRoom()) {
        success.addLover(lover);
        lover.lobbyId = success.id;
        Result<LobbyEntity, Exception> ret =
            await _lobbyUpdateDatasource(success).fold(
          (success) {
            _lobbyDeleteDatasource(oldLobbyId);
            _loverUpdateDatasource(lover);
            return success.toSuccess();
          },
          (error) {
            return Failure(Exception('Erro ao entrar no lobby'));
          },
        );
        return ret;
      } else {
        return Failure(Exception('Lobby cheio'));
      }
    }, (error) {
      return Failure(Exception('Erro ao entrar no lobby'));
    });

    return lobbyUpdate;
  }
}
