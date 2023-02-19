import 'package:bloc/bloc.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
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
    required this.lover,
    required this.lobbyId,
  });
}

class LobbyEventWatch extends LobbyEvent {
  final Lobby lobby;
  const LobbyEventWatch({
    required this.lobby,
  });
}

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc() : super(LobbyStateInitial()) {
    on<LobbyEventJoin>(
      (event, emit) async {
        if (event.lobbyId.isEmpty) {
          emit(LobbyStateFailureNoLobby());
          return;
        }
        emit(LobbyStateLoading());
        Lobby? lobby = await DataProviderLobby().getSimpleId(event.lobbyId);
        if (lobby.id.isEmpty) {
          emit(LobbyStateFailureNoLobby());
          return;
        }
        if (lobby.isLoverInLobby(event.lover)) {
          emit(LobbyStateFailureNoRoom(lobby));
          return;
        }
        if (lobby.haveRoom()) {
          lobby.addLover(event.lover);
          event.lover.lobbyId = lobby.id;
          DataProviderLobby().updateLobbyLover(lobby, event.lover);
          emit(LobbyStateSucessNoReady(lobby, LobbyStatus.waiting));
        } else {
          if (state.lobby.lovers[0].id == event.lover.id ||
              state.lobby.lovers[1].id == event.lover.id) {
            emit(LobbyStateSucessNoReady(lobby, LobbyStatus.waiting));
          } else {
            emit(
              LobbyStateFailureNoRoom(state.lobby),
            );
          }
        }
      },
    );

    on<LobbyEventLeave>(
      (event, emit) async {
        Lobby? lobby = state.lobby;
        lobby.removeLover(event.lover);
        event.lover.lobbyId = '';
        DataProviderLobby().updateLobbyLover(lobby, event.lover);
        emit(LobbyStateInitial());
      },
    );

    on<LobbyEventCreate>(
      (event, emit) async {
        emit(LobbyStateLoading());
        Lobby lobby = await createLobby(event.lover);
        emit(LobbyStateSucessNoReady(lobby, LobbyStatus.waiting));
      },
    );

    on<LobbyEventLoad>(
      (event, emit) async {
        emit(LobbyStateLoading());
        if (event.lover.lobbyId.isEmpty) {
          Lobby lobby = await createLobby(event.lover);

          emit(LobbyStateSucessNoReady(lobby, LobbyStatus.waiting));
        } else {
          Lobby lobby = await DataProviderLobby().get(event.lover.lobbyId);
          emit(LobbyStateSucessNoReady(lobby, LobbyStatus.waiting));
        }
      },
    );

    on<LobbyEventWatch>(
      (event, emit) async {
        if (event.lobby.id.isNotEmpty) {
          await emit.forEach(
            DataProviderLobby().watch(event.lobby),
            onData: (dataLobby) {
              if (dataLobby.isFull()) {
                return LobbyStateSucessReady(dataLobby);
              } else {
                return LobbyStateSucessNoReady(
                  dataLobby,
                  LobbyStatus.sucessNoReady,
                );
              }
            },
          );
        }
      },
    );
  }

  Future<Lobby> createLobby(Lover lover) async {
    Lobby lobby = Lobby.empty();
    lobby.addLover(lover);
    lobby = await DataProviderLobby().create(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().set(lover);
    return lobby;
  }
}

abstract class LobbyState {
  Lobby lobby;
  LobbyStatus status = LobbyStatus.initial;

  LobbyState({required this.lobby, required this.status});
}

class LobbyStateInitial extends LobbyState {
  LobbyStateInitial()
      : super(lobby: Lobby.empty(), status: LobbyStatus.initial);
}

class LobbyStateLoading extends LobbyState {
  LobbyStateLoading()
      : super(lobby: Lobby.empty(), status: LobbyStatus.loading);
}

class LobbyStateSucessReady extends LobbyState {
  LobbyStateSucessReady(Lobby lobby)
      : super(lobby: lobby, status: LobbyStatus.sucessReady);
}

class LobbyStateSucessNoReady extends LobbyState {
  LobbyStateSucessNoReady(Lobby lobby, LobbyStatus status)
      : super(lobby: lobby, status: status);
}

class LobbyStateFailureNoLobby extends LobbyState {
  LobbyStateFailureNoLobby()
      : super(lobby: Lobby.empty(), status: LobbyStatus.failureNoLobby);
}

class LobbyStateFailureNoRoom extends LobbyState {
  LobbyStateFailureNoRoom(Lobby lobby)
      : super(lobby: lobby, status: LobbyStatus.failureNoRoom);
}

enum LobbyStatus {
  initial,
  loading,
  waiting,
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
      case LobbyStatus.waiting:
        return 'watching';
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
