import 'package:flutter/material.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/usecase/lover/lover_update_usecase.dart';

class LobbyAvatarChangeController extends ValueNotifier<String> {
  LobbyAvatarChangeController(String path) : super(path);
  final LoverUpdateUsecase _loverUpdateUsecase = LoverUpdateUsecase();
  final List<String> avatarsAvailable = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
    'assets/avatar4.png',
    'assets/avatar5.png',
    'assets/avatar6.png',
    'assets/avatar7.png',
    'assets/avatar8.png',
  ];

  void _updateLoveAvatar(LoverEntity lover) {
    _loverUpdateUsecase(lover);
  }

  void toRight(LoverEntity lover) {
    int index = avatarsAvailable.indexWhere((element) => element == value);
    if (index + 1 > avatarsAvailable.length - 1) {
      lover.photoURL = avatarsAvailable.first;
    } else {
      lover.photoURL = avatarsAvailable[index + 1];
    }
    value = lover.photoURL;
    _updateLoveAvatar(lover);
  }

  void toLeft(LoverEntity lover) {
    int index = avatarsAvailable.indexWhere((element) => element == value);
    if (index > 0) {
      lover.photoURL = avatarsAvailable[index - 1];
    } else {
      lover.photoURL = avatarsAvailable.last;
    }
    value = lover.photoURL;
    _updateLoveAvatar(lover);
  }
}
