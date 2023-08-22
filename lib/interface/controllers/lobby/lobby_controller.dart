import 'dart:async';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/interface/states/lobby_state.dart';
import 'package:sunrise/entity/lobby_entity.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/usecase/lobby/lobby_create_usecase.dart';
import 'package:sunrise/usecase/lobby/lobby_load_usecase.dart';
import 'package:sunrise/usecase/lobby/lobby_lover_join_usecase.dart';
import 'package:sunrise/usecase/lobby/lobby_lover_leave_usecase.dart';
import 'package:sunrise/usecase/lobby/lobby_watch_usecase.dart';

class LobbyController extends ValueNotifier<LobbyState> {
  final LobbyLoverJoinUsecase _lobbyJoinUsecase = LobbyLoverJoinUsecase();
  final LobbyCreateUsecase _lobbyCreateUsecase = LobbyCreateUsecase();
  final LobbyLoadUsecase _lobbyLoadUsecase = LobbyLoadUsecase();
  final LobbyLoverLeaveUsecase _lobbyLeaveUsecase = LobbyLoverLeaveUsecase();
  final LobbyWatchUsecase _lobbyWatchUsecase = LobbyWatchUsecase();

  LobbyController() : super(LobbyStateInitial());

  Future<void> lobbyJoin(LoverEntity lover, String lobbyId) async {
    value = LobbyStateLoading();
    await _lobbyJoinUsecase(lover, lobbyId).fold((success) {
      value = LobbyStateSuccessNoReady(success);
      _checkReady();
    }, (error) {
      value = LobbyStateFailureNoLobby();
    });
  }

  Future<void> lobbyLeave(LobbyEntity lobby, LoverEntity lover) async {
    value = LobbyStateLoading();
    LobbyEntity lobbyEntity = await _lobbyLeaveUsecase(lobby, lover).fold(
      (success) => success,
      (error) => LobbyEntity.empty(),
    );
    value = LobbyStateSuccessNoReady(lobbyEntity);
    _checkReady();
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
      await _createLobby(lover).fold(
        (success) => value = LobbyStateSuccessNoReady(success),
        (error) {
          value = LobbyStateFailureNoLobby();
        },
      );
    } else {
      await _lobbyLoadUsecase(lover.lobbyId).fold((success) {
        value = LobbyStateSuccessNoReady(success);
      }, (error) {
        value = LobbyStateFailureNoLobby();
      });
    }
    _checkReady();
  }

  Future<void> lobbyInitAndWatch(LoverEntity lover) async {
    await _lobbyLoad(lover);
    if (value.lobby.id.isNotEmpty) {
      _lobbyWatchUsecase(value.lobby).listen((event) {
        value = LobbyStateSuccessReady(event);
        _checkReady();
      });
    }
  }

  Future<Result<LobbyEntity, Exception>> _createLobby(LoverEntity lover) async {
    return await _lobbyCreateUsecase(lover);
  }
}
