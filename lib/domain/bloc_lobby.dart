import 'package:bloc/bloc.dart';
import 'package:sunrise/data/data_provider_lobby.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

abstract class LobbyEvent {
  const LobbyEvent();
}

class LobbyEventJoin extends LobbyEvent {
  final String lobbyId;
  final Lover lover;

  const LobbyEventJoin({
    required this.lobbyId,
    required this.lover,
  });
}

class LobbyEventLeave extends LobbyEvent {
  final String lobbyId;
  final Lover lover;

  const LobbyEventLeave({
    required this.lobbyId,
    required this.lover,
  });
}

class LobbyEventCreate extends LobbyEvent {
  final Lover lover;

  const LobbyEventCreate({
    required this.lover,
  });
}

class LobbyEventLoad extends LobbyEvent {
  final String lobbyId;
  final Lover lover;

  const LobbyEventLoad({
    required this.lobbyId,
    required this.lover,
  });
}

class LobbyBloc extends Bloc<LobbyEvent, LobbyState?> {
  LobbyBloc() : super(null) {
    on<LobbyEventJoin>(
      (event, emit) async {
        Lobby? lobby = await DataProviderLobby().get(event.lobbyId);
        if (lobby.isLoverInLobby(event.lover)) {
          emit(LobbyState(lobby: lobby, status: LobbyStatus.failureNoRoom));
          return;
        }
        if (lobby.haveRoom()) {
          lobby.addLover(event.lover);
          DataProviderLobby().update(lobby);
          event.lover.lobbyId = lobby.id;
          DataProviderLover().update(event.lover);
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
        } else {
          if (state!.lobby.lovers[0].id == event.lover.id ||
              state!.lobby.lovers[1].id == event.lover.id) {
            emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
          } else {
            emit(
              LobbyState(
                lobby: state!.lobby,
                status: LobbyStatus.failureNoRoom,
              ),
            );
          }
        }
      },
    );

    on<LobbyEventLeave>(
      (event, emit) async {
        Lobby? lobby = state!.lobby;
        lobby.removeLover(event.lover);
        event.lover.lobbyId = '';
        DataProviderLobby().update(lobby);
        DataProviderLover().update(event.lover);
        emit(LobbyState(lobby: lobby, status: LobbyStatus.initial));
      },
    );

    on<LobbyEventCreate>(
      (event, emit) async {
        Lobby lobby = await createLobby(event.lover);
        emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
      },
    );

    on<LobbyEventLoad>(
      (event, emit) async {
        if (event.lover.lobbyId.isEmpty) {
          Lobby lobby = await createLobby(event.lover);
          emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
        } else {
          Lobby? lobby = await DataProviderLobby().get(event.lover.lobbyId);
          if (lobby.haveRoom()) {
            emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
          } else {
            if (lobby.isLoverInLobby(event.lover)) {
              emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
            } else {
              emit(
                LobbyState(lobby: lobby, status: LobbyStatus.failureNoRoom),
              );
            }
          }
        }
      },
    );
  }

  Future<Lobby> createLobby(Lover lover) async {
    Lobby lobby = Lobby.empty();
    lobby.addLover(lover);
    lobby = await DataProviderLobby().create(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().update(lover);
    return lobby;
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
