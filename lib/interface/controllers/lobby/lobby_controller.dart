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
  final LobbyLoadSimpleIdDatasource _lobbyLoadSimpleIdDatasource =
      LobbyLoadSimpleIdDatasource();
  final LobbyLoadDatasource _lobbyLoadDatasource = LobbyLoadDatasource();
  final LobbyWatchDatasource _lobbyWatchDatasource = LobbyWatchDatasource();
  final LobbyDeleteDatasource _lobbyDeleteDatasource = LobbyDeleteDatasource();
  final LoverJoinLobbyUsecase _lobbyJoinUsecase = LoverJoinLobbyUsecase();
  final LoverLeaveLobbyUsecase _lobbyLeaveUsecase = LoverLeaveLobbyUsecase();

  LobbyController(super.value);

  Future<void> lobbyJoin(LoverEntity lover) async {
    value = LobbyStateLoading();
    if (value.lobby.id.isEmpty) {
      value = LobbyStateFailureNoLobby();
      return;
    }
    LobbyEntity lobby = await _lobbyLoadSimpleIdDatasource(value.lobby.id);
    if (lobby.id.isEmpty) {
      value = LobbyStateFailureNoLobby();
      return;
    }
    if (lobby.isLoverInLobby(lover)) {
      value = LobbyStateSuccessNoReady(lobby);
      _checkReady();
      return;
    }

    if (lobby.haveRoom()) {
      lobby.addLover(lover);
      lover.lobbyId = lobby.id;
      await _lobbyJoinUsecase(lobby, lover);
      value = LobbyStateSuccessNoReady(lobby);
    } else {
      if (lobby.lovers[0].id == lover.id || lobby.lovers[1].id == lover.id) {
        value = LobbyStateSuccessNoReady(lobby);
        _checkReady();
      } else {
        value = LobbyStateFailureNoRoom(lobby);
      }
    }
  }

  Future<void> lobbyLeave(LobbyEntity lobby, LoverEntity lover) async {
    // previous lobby
    value = LobbyStateLoading();
    lobby.removeLover(lover);
    if (lobby.isEmpty()) {
      await _lobbyDeleteDatasource(lobby);
    }
    await _lobbyLeaveUsecase(lobby, lover);

    LobbyEntity newlobby = await _createLobby(lover);
    lover.lobbyId = newlobby.id;
    await _lobbyJoinUsecase(newlobby, lover);
    value = LobbyStateSuccessNoReady(newlobby);
  }

  lobbyCreate(LoverEntity lover) async {
    value = LobbyStateLoading();
    LobbyEntity lobby = await _createLobby(lover);
    value = LobbyStateSuccessNoReady(lobby);
  }

  void _checkReady() {
    if (value.lobby.id.isNotEmpty) {
      value = value.lobby.isFull()
          ? LobbyStateSuccessReady(value.lobby)
          : LobbyStateSuccessNoReady(value.lobby);
    }
  }

  Future<void> _lobbyLoad(LoverEntity lover) async {
    value = LobbyStateLoading();
    if (lover.lobbyId.isEmpty) {
      LobbyEntity lobby = await _createLobby(lover);
      value = LobbyStateSuccessNoReady(lobby);
    } else {
      LobbyEntity lobby = await _lobbyLoadDatasource(lover.lobbyId);
      value = LobbyStateSuccessNoReady(lobby);
    }
    _checkReady();
  }

  Future<void> lobbyInitAndWatch(LoverEntity lover) async {
    await _lobbyLoad(lover);
    if (value.lobby.id.isNotEmpty) {
      _lobbyWatchDatasource(value.lobby).listen((event) {
        value = LobbyStateSuccessReady(event);
        _checkReady();
      });
    }
  }

  Future<LobbyEntity> _createLobby(LoverEntity lover) async {
    LobbyCreateDatasource lobbyCreateDatasource = LobbyCreateDatasource();
    LobbyEntity lobby = LobbyEntity.empty();
    lobby.addLover(lover);
    lobby = await lobbyCreateDatasource(lobby);
    lover.lobbyId = lobby.id;
    DataProviderLover().set(lover);
    return lobby;
  }
}
