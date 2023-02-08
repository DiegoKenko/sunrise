import 'package:bloc/bloc.dart';
import 'package:sunrise/data/data_provider_lobby.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class LobbyCubit extends Cubit<LobbyState?> {
  LobbyCubit(Lover lover) : super(null) {
    loadLobby(lover);
  }

  void joinLobby(String lobbyId, Lover lover) async {
    Lobby? lobby = await DataProviderLobby().get(lobbyId);
    if (lobby != null) {
      if (lobby.haveRoom()) {
        lobby.addLover(lover);
        DataProviderLobby().update(lobby);
        DataProviderLover().update(state!.lobby.lover1);
        if (lobby.lover2 != null) {
          lobby.lover2!.lobbyId = lobby.id;
          DataProviderLover().update(lobby.lover2!);
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
          return;
        }
        emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
      } else {
        if (state!.lobby.lover1.id == lover.id ||
            state!.lobby.lover2!.id == lover.id) {
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
        } else {
          emit(
            LobbyState(lobby: state!.lobby, status: LobbyStatus.failureNoRoom),
          );
        }
      }
    } else {
      emit(LobbyState(lobby: state!.lobby, status: LobbyStatus.failureNoLobby));
    }
  }

  void leaveLobby(Lover lover) {
    Lobby? lobby = state!.lobby;
    DataProviderLobby().removeLover(lobby, lover);
    DataProviderLover().removeLobby(lover);
    createLobby(lover);
  }

  void createLobby(Lover lover) async {
    Lobby lobby = Lobby(lover1: lover);
    lobby = await DataProviderLobby().create(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().update(lover);
    emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
  }

  void loadLobby(Lover lover) async {
    if (lover.lobbyId.isEmpty) {
      createLobby(lover);
    } else {
      Lobby? lobby = await DataProviderLobby().get(lover.lobbyId);
      if (lobby != null) {
        if (lobby.lover1.id == lover.id || lobby.lover2!.id == lover.id) {
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
        } else {
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
        }
      } else {
        createLobby(lover);
      }
    }
  }
}

class LobbyState {
  Lobby lobby;
  LobbyStatus status = LobbyStatus.initial;

  LobbyState({required this.lobby, required this.status});
}

enum LobbyStatus {
  initial,
  loading,
  sucessReady,
  sucessNoReady,
  failureNoLobby,
  failureNoRoom,
}

extension LobbyStatusDescription on LobbyStatus {
  String get description {
    switch (this) {
      case LobbyStatus.initial:
        return 'initial';
      case LobbyStatus.loading:
        return 'loading';
      case LobbyStatus.sucessReady:
        return 'sucessReady';
      case LobbyStatus.sucessNoReady:
        return 'sucessNoReady';
      case LobbyStatus.failureNoLobby:
        return 'failureNoLobby';
      case LobbyStatus.failureNoRoom:
        return 'failureNoRoom';
    }
  }
}
