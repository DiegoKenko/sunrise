import 'package:sunrise/constants/enum/enum_lobby_status.dart';
import 'package:sunrise/model/model_lobby.dart';

abstract class LobbyState {
  LobbyEntity lobby;
  LobbyStatus status = LobbyStatus.initial;

  LobbyState({required this.lobby, required this.status});
}

class LobbyStateInitial extends LobbyState {
  LobbyStateInitial()
      : super(lobby: LobbyEntity.empty(), status: LobbyStatus.initial);
}

class LobbyStateLoading extends LobbyState {
  LobbyStateLoading()
      : super(lobby: LobbyEntity.empty(), status: LobbyStatus.loading);
}

class LobbyStateSuccessReady extends LobbyState {
  LobbyStateSuccessReady(LobbyEntity lobby)
      : super(lobby: lobby, status: LobbyStatus.successReady);
}

class LobbyStateSuccessNoReady extends LobbyState {
  LobbyStateSuccessNoReady(LobbyEntity lobby)
      : super(lobby: lobby, status: LobbyStatus.successNoReady);
}

class LobbyStateStandby extends LobbyState {
  LobbyStateStandby(LobbyEntity lobby)
      : super(lobby: lobby, status: LobbyStatus.standBy);
}

class LobbyStateFailureNoLobby extends LobbyState {
  LobbyStateFailureNoLobby()
      : super(lobby: LobbyEntity.empty(), status: LobbyStatus.failureNoLobby);
}

class LobbyStateFailureNoRoom extends LobbyState {
  LobbyStateFailureNoRoom(LobbyEntity lobby)
      : super(lobby: lobby, status: LobbyStatus.failureNoRoom);
}
