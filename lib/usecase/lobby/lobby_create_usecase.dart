import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_create_datasource.dart';
import 'package:sunrise/datasource/lover/lover_update_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyCreateUsecase {
  final LobbyCreateDatasource lobbyCreateDatasource = LobbyCreateDatasource();
  final LoverUpdateDatasource loverUpdateDatasource = LoverUpdateDatasource();
  Future<Result<LobbyEntity, Exception>> call(LoverEntity lover) async {
    LobbyEntity lobby = LobbyEntity.empty();
    lobby.addLover(lover);
    if (!lobby.isEmpty()) {
      lobby = await lobbyCreateDatasource(lobby)
          .fold((success) => success, (error) => LobbyEntity.empty());
      if (lobby.isEmpty()) {
        return Failure(Exception('Lobby não criado'));
      }
      lover.addLobby(lobby.id);
      lover = await loverUpdateDatasource(lover)
          .fold((success) => success, (error) => LoverEntity.empty());
      if (lover.isValid()) {
        return lobby.toSuccess();
      } else {
        return Failure(Exception('Lover não atualizado'));
      }
    } else {
      return Failure(Exception('No user'));
    }
  }
}
