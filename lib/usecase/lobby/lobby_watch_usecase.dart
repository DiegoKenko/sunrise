import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lobby/lobby_watch_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';

class LobbyWatchUsecase {
  final LobbyWatchDatasource lobbyWatchDatasource = LobbyWatchDatasource();
  final LoverLoadDatasource loverLoadDatasource = LoverLoadDatasource();
  Stream<LobbyEntity> call(LobbyEntity lobby) async* {
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
    yield lobby;
  }
}
