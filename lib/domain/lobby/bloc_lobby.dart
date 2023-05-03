import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sunrise/constants/enum.dart';
import 'package:sunrise/datasource/data_provider_lobby.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
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
  final Lover lover;

  const LobbyEventLeave({
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
  const LobbyEventWatch();
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
  LobbyStateSucessNoReady(Lobby lobby)
      : super(lobby: lobby, status: LobbyStatus.sucessNoReady);
}

class LobbyStateStandby extends LobbyState {
  LobbyStateStandby(Lobby lobby)
      : super(lobby: lobby, status: LobbyStatus.standBy);
}

class LobbyStateFailureNoLobby extends LobbyState {
  LobbyStateFailureNoLobby()
      : super(lobby: Lobby.empty(), status: LobbyStatus.failureNoLobby);
}

class LobbyStateFailureNoRoom extends LobbyState {
  LobbyStateFailureNoRoom(Lobby lobby)
      : super(lobby: lobby, status: LobbyStatus.failureNoRoom);
}

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  Stream streamLobby = const Stream.empty();
  LobbyBloc() : super(LobbyStateInitial()) {
    on<LobbyEventJoin>(_join);
    on<LobbyEventLeave>(_leave);
    on<LobbyEventCreate>(_onCreate);
    on<LobbyEventLoad>(
      (event, emit) async {
        emit(LobbyStateLoading());
        if (event.lobbyId.isEmpty) {
          emit(LobbyStateInitial());
          Lobby lobby = await createLobby(event.lover);
          emit(LobbyStateSucessNoReady(lobby));
        } else {
          if (event.lover.lobbyId.isEmpty) {
            Lobby lobby = await createLobby(event.lover);
            emit(LobbyStateSucessNoReady(lobby));
          } else {
            Lobby lobby = await DataProviderLobby().get(event.lover.lobbyId);
            emit(LobbyStateSucessNoReady(lobby));
          }
        }
      },
    );
    on<LobbyEventWatch>(_watch);
  }

  FutureOr<void> _watch(event, emit) async {
    if (state.lobby.id.isNotEmpty) {
      streamLobby = DataProviderLobby().watch(state.lobby);
      await emit.forEach(
        streamLobby,
        onData: (dataLobby) {
          if (dataLobby.isFull()) {
            return LobbyStateSucessReady(dataLobby);
          } else {
            return LobbyStateStandby(
              dataLobby,
            );
          }
        },
      );
    }
  }

  FutureOr<void> _onCreate(event, emit) async {
    emit(LobbyStateLoading());
    Lobby lobby = await createLobby(event.lover);
    emit(LobbyStateSucessNoReady(lobby));
  }

  FutureOr<void> _leave(event, emit) async {
    // previous lobby
    Lobby? lobby = state.lobby;
    lobby.removeLover(event.lover);
    if (lobby.isEmpty()) {
      await DataProviderLobby().delete(lobby);
    }
    await DataProviderLobby().updateLobbyLover(lobby, event.lover);

    // new lobby
    Lobby newlobby = await createLobby(event.lover);
    event.lover.lobbyId = newlobby.id;
    await DataProviderLobby().updateLobbyLover(newlobby, event.lover);
    streamLobby = const Stream.empty();
    emit(LobbyStateSucessNoReady(newlobby));
  }

  FutureOr<void> _join(event, emit) async {
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
      emit(LobbyStateSucessNoReady(lobby));
      return;
    }
    if (lobby.haveRoom()) {
      lobby.addLover(event.lover);
      event.lover.lobbyId = lobby.id;
      await DataProviderLobby().updateLobbyLover(lobby, event.lover);
      emit(LobbyStateSucessNoReady(lobby));
    } else {
      if (state.lobby.lovers[0].id == event.lover.id ||
          state.lobby.lovers[1].id == event.lover.id) {
        emit(LobbyStateSucessNoReady(lobby));
      } else {
        emit(
          LobbyStateFailureNoRoom(state.lobby),
        );
      }
    }
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

extension LobbyStatusDescription on LobbyStatus {
  String get description {
    switch (this) {
      case LobbyStatus.initial:
        return 'initial';
      case LobbyStatus.loading:
        return 'loading';
      case LobbyStatus.standBy:
        return 'standBy';
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
