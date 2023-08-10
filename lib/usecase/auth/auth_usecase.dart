import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';
import 'package:sunrise/usecase/lobby/lobby_create_usecase.dart';

class AuthUsecase {
  final LoverLoadDatasource _loverLoadUsecase = LoverLoadDatasource();
  final LobbyCreateUsecase _lobbyCreateUsecase = LobbyCreateUsecase();

  Result<User, Exception> _currentUser() {
    try {
      User? user = getIt<FirebaseAuthController>().currentUser;
      if (user != null) return user.toSuccess();
      return Failure(Exception('Usuário não encontrado.'));
    } catch (e) {
      return Failure(Exception('Algo deu errado.'));
    }
  }

  bool isAuth() {
    return getIt<FirebaseAuthController>().currentUser != null;
  }

  Future<Result<LoverEntity, Exception>> authenticate() async {
    User? user;
    try {
      user = await _currentUser().fold((success) => success, (failure) async {
        UserCredential credential =
            await FirebaseAuthController().signInWithGoogle();
        return credential.user;
      });
      if (user != null) {
        Result<LoverEntity, Exception> result =
            await _loverLoadUsecase(user!.uid);
        if (result.isSuccess()) {
          return result;
        } else {
          return await _register(user!);
        }
      } else {
        return Failure(Exception('Usuário não identificado'));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<LoverEntity, Exception>> _register(User user) async {
    try {
      LoverEntity lover = LoverEntity(
        email: user.email!,
        name: user.displayName!,
        id: user.uid,
        photoURL: user.photoURL!,
      );
      await _lobbyCreateUsecase(lover);
      return lover.toSuccess();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
