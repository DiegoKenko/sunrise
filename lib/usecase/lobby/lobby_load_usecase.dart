import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_load_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';

class LobbyLoadUsecase {
  final LobbyLoadDatasource lobbyLoadDatasource = LobbyLoadDatasource();
  final LoverLoadDatasource loverLoadDatasource = LoverLoadDatasource();
  LobbyLoadUsecase();

  Future<Result<LobbyEntity, Exception>> call(String lobbyId) async {
    Result<LobbyEntity, Exception> result = await lobbyLoadDatasource(lobbyId);
    LobbyEntity lobby = LobbyEntity.empty();
    result.fold((success) {
      return lobby = success;
    }, (failure) => null);
    if (lobby.isEmpty()) {
      return result;
    } else {
      for (var element in lobby.lovers) {
        if (element.id.isNotEmpty) {
          element = await loverLoadDatasource(element.id)
              .fold((success) => success, (error) => LoverEntity.empty());
        }
      }
      return lobby.toSuccess();
    }
  }
}
