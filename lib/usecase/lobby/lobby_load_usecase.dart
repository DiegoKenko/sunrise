import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_load_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';

class LobbyLoadUsecase {
  final LobbyLoadDatasource lobbyLoadDatasource = LobbyLoadDatasource();
  final LoverLoadDatasource loverLoadDatasource = LoverLoadDatasource();
  LobbyLoadUsecase();

  Future<Result<LobbyEntity, Exception>> call(String lobbyId) async {
    Result<LobbyEntity, Exception> result = await lobbyLoadDatasource(lobbyId);
    LobbyEntity lobby = LobbyEntity.empty();
    result.fold(
      (success) {
        return lobby = success;
      },
      (failure) => null,
    );
    if (lobby.isEmpty()) {
      return result;
    } else {
      for (var i = 0; i < lobby.lovers.length; i++) {
        if (lobby.lovers[i].id.isNotEmpty) {
          await loverLoadDatasource(lobby.lovers[i].id).fold(
            (success) {
              lobby.lovers[i] = success;
            },
            (error) => null,
          );
        }
      }
      return lobby.toSuccess();
    }
  }
}
