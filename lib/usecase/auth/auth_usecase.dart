import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sunrise/datasource/lover/lover_create_datasource.dart';
import 'package:sunrise/datasource/lover/lover_load_datasource.dart';
import 'package:sunrise/entity/lover_entity.dart';
import 'package:sunrise/interface/controllers/auth/firebase_auth_controller.dart';
import 'package:sunrise/interface/states/auth_state.dart';
import 'package:sunrise/usecase/lover/lover_load_usecase.dart';

class AuthUsecase {
  final LoverLoadDatasource loverLoadUsecase = LoverLoadDatasource();
  final LoverCreateDatasource loverCreateDatasource = LoverCreateDatasource();
  Future<AuthState> authenticate() async {
    final UserCredential userCredencial =
        await FirebaseAuthController().signInWithGoogle();

    try {
      if (userCredencial.user != null) {
        LoverEntity lover = await loverLoadUsecase(userCredencial.user!.uid)
            .fold((success) => success, (error) => LoverEntity.empty());
        return AuthAuthenticatedState(lover);
      } else {
        return await _register(userCredencial);
      }
    } catch (e) {
      return AuthErrorState(e.toString());
    }
  }

  Future<AuthState> _register(UserCredential userCredencial) async {
    try {
      LoverEntity lover = LoverEntity(
        email: userCredencial.user!.email!,
        name: userCredencial.user!.displayName!,
        id: userCredencial.user!.uid,
        photoURL: userCredencial.user!.photoURL!,
      );
      await loverCreateDatasource(lover);
      return AuthAuthenticatedState(lover);
    } catch (e) {
      return AuthErrorState(e.toString());
    }
  }
}
