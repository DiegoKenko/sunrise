import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_create_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/usecase/lobby/lobby_create_usecase.dart';
import 'package:sunrise/usecase/lover/lover_create_usecase.dart';

class AuthUsecase {
  final LoverLoadDatasource _loverLoadUsecase = LoverLoadDatasource();
  final LobbyCreateUsecase _lobbyCreateUsecase = LobbyCreateUsecase();

  Future<Result<LoverEntity, Exception>> authenticate() async {
    try {
      final UserCredential userCredencial =
          await FirebaseAuthController().signInWithGoogle();
      if (userCredencial.user != null) {
        Result<LoverEntity, Exception> result =
            await _loverLoadUsecase(userCredencial.user!.uid);
        if (result.isSuccess()) {
          return result;
        } else {
          return await _register(userCredencial);
        }
      } else {
        return await _register(userCredencial);
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<LoverEntity, Exception>> _register(
      UserCredential userCredencial) async {
    try {
      LoverEntity lover = LoverEntity(
        email: userCredencial.user!.email!,
        name: userCredencial.user!.displayName!,
        id: userCredencial.user!.uid,
        photoURL: userCredencial.user!.photoURL!,
      );
      await _lobbyCreateUsecase(lover);
      return lover.toSuccess();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
