import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/services/notification/firebase_messaging_service.dart';
import 'package:sunrise/usecase/auth/auth_usecase.dart';
import 'package:sunrise/usecase/lover/lover_update_usecase.dart';

class AuthController extends ValueNotifier<AuthState> {
  final AuthUsecase authUsecase = AuthUsecase();
  final LoverUpdateUsecase loverUpdateUsecase = LoverUpdateUsecase();

  final FirebaseMessagingService notificationService =
      getIt<FirebaseMessagingService>();
  AuthController() : super(AuthUninitializedState());

  Future<bool> login() async {
    LoverEntity? lover;
    value = AuthLoadingState();
    await authUsecase.authenticate().fold((success) {
      lover = success;
    }, (error) {
      value = AuthErrorState(error.toString());
    });
    if (lover != null) {
      lover!.setToken = await notificationService.getDeviceFirebaseToken();
      value = AuthAuthenticatedState(lover!);
      loverUpdateUsecase(lover!);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    value = AuthLoadingState();
    try {
      await FirebaseAuthController().signOut();
      value = AuthUnauthenticatedState();
    } catch (e) {
      value = AuthErrorState(e.toString());
    }
  }

  LoverEntity get lover {
    if (value is AuthAuthenticatedState) {
      return (value as AuthAuthenticatedState).lover;
    } else {
      return LoverEntity.empty();
    }
  }

  bool isAuth() {
    return value is AuthAuthenticatedState;
  }
}
