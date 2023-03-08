import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/domain/auth/authentication.dart';
import 'package:sunrise/model/model_lover.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLogin extends AuthEvent {
  const AuthEventLogin();
}

class AuthEventRegister extends AuthEvent {
  final UserCredential userCredencial;
  const AuthEventRegister({
    required this.userCredencial,
  });
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

abstract class AuthState {
  Lover lover = Lover.empty();
  bool loading;
  bool error;
  bool success;
  AuthState(
    this.lover, {
    this.loading = false,
    this.error = false,
    this.success = false,
  });
}

class AuthStateInitial extends AuthState {
  AuthStateInitial() : super(Lover.empty());
}

class AuthStateLoading extends AuthState {
  AuthStateLoading() : super(Lover.empty(), loading: true);
}

class AuthStateSuccess extends AuthState {
  final String message;
  AuthStateSuccess(this.message, Lover lover) : super(lover, success: true);
}

class AuthStateFailure extends AuthState {
  final String message;
  AuthStateFailure(this.message, Lover lover) : super(lover, error: true);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());
      final UserCredential userCredencial =
          await FirebaseAuthentication().signInWithGoogle();
      if (userCredencial.user != null) {
        Lover lover = await DataProviderLover().getUser(userCredencial.user!);
        await DataProviderLover().update(lover);
        emit(AuthStateSuccess('User logged', lover));
      } else {
        add(
          AuthEventRegister(userCredencial: userCredencial),
        );
      }
    });
    on<AuthEventRegister>((event, emit) async {
      emit(AuthStateLoading());
      Lover lover = Lover(
        email: event.userCredencial.user!.email!,
        name: event.userCredencial.user!.displayName!,
        id: event.userCredencial.user!.uid,
        photoURL: event.userCredencial.user!.photoURL!,
      );
      await DataProviderLover().create(lover);
      add(const AuthEventLogin());
    });

    on<AuthEventLogout>((event, emit) async {
      emit(AuthStateLoading());
      await FirebaseAuthentication().signOut();
      emit(AuthStateInitial());
    });
  }
}
