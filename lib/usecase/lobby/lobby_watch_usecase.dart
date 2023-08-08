import 'package:sunrise/datasource/lobby/lobby_watch_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';

class LobbyWatchUsecase {
  final LobbyWatchDatasource lobbyWatchDatasource = LobbyWatchDatasource();
  Stream<LobbyEntity> call(LobbyEntity lobby) {
    return lobbyWatchDatasource(lobby);
  }
}
