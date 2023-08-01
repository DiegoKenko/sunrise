import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/datasource/lobby/lobby_create_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_delete_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_load_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_load_simpleid_datasource.dart';
import 'package:sunrise/datasource/lobby/lobby_watch_datasource.dart';
import 'package:sunrise/interface/states/lobby_state.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/usecase/lobby/lover_join_lobby_usecase.dart';
import 'package:sunrise/usecase/lobby/lover_leave_lobby_usecase.dart';

class LobbyController extends ValueNotifier<LobbyState> {
  Stream streamLobby = const Stream.empty();
  String lobbyId = '';
  LobbyLoadSimpleIdDatasource lobbyLoadSimpleIdDatasource =
      LobbyLoadSimpleIdDatasource();
  LobbyLoadDatasource lobbyLoadDatasource = LobbyLoadDatasource();
  LobbyWatchDatasource lobbyWatchDatasource = LobbyWatchDatasource();
  LobbyDeleteDatasource lobbyDeleteDatasource = LobbyDeleteDatasource();
  LoverJoinLobbyUsecase lobbyJoinUsecase = LoverJoinLobbyUsecase();
  LoverLeaveLobbyUsecase lobbyLeaveUsecase = LoverLeaveLobbyUsecase();

  LobbyController(super.value);

  lobbyJoin(LoverEntity lover) async {
    value = LobbyStateLoading();
    if (lobbyId.isEmpty) {
      value = LobbyStateFailureNoLobby();
      return;
    }
    LobbyEntity? lobby = await lobbyLoadSimpleIdDatasource(lobbyId);
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
      await lobbyJoinUsecase(lobby, lover);
      value = LobbyStateSuccessNoReady(lobby);
    } else {
      if (lobby.lovers[0].id == lover.id || lobby.lovers[1].id == lover.id) {
        value = LobbyStateSuccessNoReady(lobby);
      } else {
        value = LobbyStateFailureNoRoom(lobby);
      }
    }
  }

  lobbyLeave(LobbyEntity lobby, LoverEntity lover) async {
    // previous lobby
    value = LobbyStateLoading();
    lobby.removeLover(lover);
    if (lobby.isEmpty()) {
      await lobbyDeleteDatasource(lobby);
    }
    await lobbyLeaveUsecase(lobby, lover);

    // new lobby
    LobbyEntity newlobby = await createLobby(lover);
    lover.lobbyId = newlobby.id;
    await lobbyJoinUsecase(newlobby, lover);
    streamLobby = const Stream.empty();
    value = LobbyStateSuccessNoReady(newlobby);
  }

  lobbyCreate(LoverEntity lover) async {
    value = LobbyStateLoading();
    LobbyEntity lobby = await createLobby(lover);
    value = LobbyStateSuccessNoReady(lobby);
  }

  lobbyLoad(LoverEntity lover) async {
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
        LobbyEntity lobby = await lobbyLoadDatasource(lover.lobbyId);
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
      streamLobby = lobbyWatchDatasource(lobby);
    }
  }

  Future<LobbyEntity> createLobby(LoverEntity lover) async {
    LobbyCreateDatasource lobbyCreateDatasource = LobbyCreateDatasource();
    LobbyEntity lobby = LobbyEntity.empty();
    lobby.addLover(lover);
    lobby = await lobbyCreateDatasource(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().set(lover);
    return lobby;
  }
}
