import 'package:sunrise/datasource/lobby/lobby_delete_datasource.dart';
import 'package:sunrise/entity/lobby_entity.dart';

class LobbyDeleteUsecase {
  final LobbyDeleteDatasource lobbyDeleteDatasource = LobbyDeleteDatasource();
  LobbyDeleteUsecase();
  Future<void> call(LobbyEntity lobbyEntity) async {
    await lobbyDeleteDatasource(lobbyEntity.id);
  }
}
