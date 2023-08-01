import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sunrise/constants/enum/enum_lobby_status.dart';
import 'package:sunrise/datasource/data_provider_lobby.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/domain/lobby/lobby_state.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class LobbyController extends ValueNotifier<LobbyState> {
  Stream streamLobby = const Stream.empty();
  String lobbyId = '';

  LobbyController(super.value);

  lobbyJoin(Lover lover) async {
    value = LobbyStateLoading();
    if (lobbyId.isEmpty) {
      value = LobbyStateFailureNoLobby();
      return;
    }
    LobbyEntity? lobby = await DataProviderLobby().getSimpleId(lobbyId);
    if (lobby.id.isEmpty) {
      value = LobbyStateFailureNoLobby();
      return;
    }
    if (lobby.isLoverInLobby(lover)) {
      value = LobbyStateSuccessNoReady(lobby);
      return;
    }
    if (lobby.haveRoom()) {
      lobby.addLover(lover);
      lover.lobbyId = lobby.id;
      await DataProviderLobby().updateLobbyLover(lobby, lover);
      value = LobbyStateSuccessNoReady(lobby);
    } else {
      if (lobby.lovers[0].id == lover.id || lobby.lovers[1].id == lover.id) {
        value = LobbyStateSuccessNoReady(lobby);
      } else {
        value = LobbyStateFailureNoRoom(lobby);
      }
    }
  }

  lobbyLeave(LobbyEntity lobby, Lover lover) async {
    // previous lobby
    value = LobbyStateLoading();
    lobby.removeLover(lover);
    if (lobby.isEmpty()) {
      await DataProviderLobby().delete(lobby);
    }
    await DataProviderLobby().updateLobbyLover(lobby, lover);

    // new lobby
    LobbyEntity newlobby = await createLobby(lover);
    lover.lobbyId = newlobby.id;
    await DataProviderLobby().updateLobbyLover(newlobby, lover);
    streamLobby = const Stream.empty();
    value = LobbyStateSuccessNoReady(newlobby);
  }

  lobbyCreate(Lover lover) async {
    value = LobbyStateLoading();
    LobbyEntity lobby = await createLobby(lover);
    value = LobbyStateSuccessNoReady(lobby);
  }

  lobbyLoad(Lover lover) async {
    value = LobbyStateLoading();
    if (lobbyId.isEmpty) {
      value = LobbyStateInitial();
      LobbyEntity lobby = await createLobby(lover);
      value = LobbyStateSuccessNoReady(lobby);
    } else {
      if (lover.lobbyId.isEmpty) {
        LobbyEntity lobby = await createLobby(lover);
        value = LobbyStateSuccessNoReady(lobby);
      } else {
        LobbyEntity lobby = await DataProviderLobby().get(lover.lobbyId);
        value = LobbyStateSuccessNoReady(lobby);
        if (lobby.id.isEmpty) {
          lobby = await createLobby(lover);
          value = LobbyStateSuccessNoReady(lobby);
        }
      }
    }
  }

  lobbyWatch(LobbyEntity lobby) async {
    if (lobby.id.isNotEmpty) {
      streamLobby = DataProviderLobby().watch(lobby);
    }
  }

  Future<LobbyEntity> createLobby(Lover lover) async {
    LobbyEntity lobby = LobbyEntity.empty();
    lobby.addLover(lover);
    lobby = await DataProviderLobby().create(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().set(lover);
    return lobby;
  }
}
