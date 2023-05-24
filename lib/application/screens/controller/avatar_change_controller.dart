import 'package:flutter/material.dart';

class AvatarChangeController extends ValueNotifier<String> {
  AvatarChangeController() : super('assets/avatar1.png');
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

  void toRight() {
    value = _getNextItem();
  }

  void toLeft() {
    value = _getPreviousItem();
  }

  String _getNextItem() {
    int index = avatarsAvailable.indexWhere((element) => element == value);
    if (index + 1 > avatarsAvailable.length - 1) {
      return avatarsAvailable.first;
    } else {
      return avatarsAvailable[index + 1];
    }
  }

  String _getPreviousItem() {
    int index = avatarsAvailable.indexWhere((element) => element == value);
    if (index == 0) {
      return avatarsAvailable.last;
    } else {
      return avatarsAvailable[index - 1];
    }
  }
}
