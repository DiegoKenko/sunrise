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
        if (lobby != null) {
          if (lobby.haveRoom()) {
            lobby.addLover(event.lover);
            DataProviderLobby().update(lobby);
            DataProviderLover().update(lobby.lover1);
            if (lobby.lover2 != null) {
              lobby.lover2!.lobbyId = lobby.id;
              DataProviderLover().update(lobby.lover2!);
              emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
              return;
            }
            emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
          } else {
            if (state!.lobby.lover1.id == event.lover.id ||
                state!.lobby.lover2!.id == event.lover.id) {
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
        } else {
          emit(
            LobbyState(
              lobby: state!.lobby,
              status: LobbyStatus.failureNoLobby,
            ),
          );
        }
      },
    );

    on<LobbyEventLeave>(
      (event, emit) async {
        Lobby? lobby = state!.lobby;
        lobby.removeLover(event.lover);
        event.lover.lobbyId = '';
        emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
        DataProviderLobby().update(lobby);
        DataProviderLover().update(event.lover);
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
          if (lobby != null) {
            if (lobby.lover1.id == event.lover.id ||
                lobby.lover2!.id == event.lover.id) {
              emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessReady));
            } else {
              emit(LobbyState(lobby: lobby, status: LobbyStatus.sucessNoReady));
            }
          } else {
            lobby = await createLobby(event.lover);
            emit(
              LobbyState(lobby: lobby, status: LobbyStatus.failureNoLobby),
            );
          }
        }
      },
    );
  }

  Future<Lobby> createLobby(Lover lover) async {
    Lobby lobby = Lobby(lover1: lover);
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
