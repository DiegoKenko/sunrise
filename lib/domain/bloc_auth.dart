import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/domain/authentication.dart';
import 'package:sunrise/domain/notification.dart';
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
  bool loading = false;
  bool error = false;
  bool success = false;
  AuthState(
    this.lover,
  );
}

class AuthStateInitial extends AuthState {
  @override
  bool get loading => false;
  @override
  bool get error => false;
  @override
  bool get success => false;
  AuthStateInitial() : super(Lover.empty());
}

class AuthStateLoading extends AuthState {
  @override
  bool get loading => true;
  @override
  bool get error => false;
  @override
  bool get success => false;
  AuthStateLoading() : super(Lover.empty());
}

class AuthStateSuccess extends AuthState {
  @override
  bool get loading => false;
  @override
  bool get error => false;
  @override
  bool get success => true;
  final String message;
  AuthStateSuccess(this.message, Lover lover) : super(lover);
}

class AuthStateFailure extends AuthState {
  @override
  bool get loading => false;
  @override
  bool get error => true;
  @override
  bool get success => false;
  final String message;
  AuthStateFailure(this.message, Lover lover) : super(lover);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());
      final UserCredential userCredencial =
          await FirebaseAuthentication().signInWithGoogle();
      if (userCredencial.user != null) {
        Lover lover = await DataProviderLover().getUser(userCredencial.user!);
        await NotificationService().requestPermissions();
        emit(AuthStateSuccess('User logged', lover));
      } else {
        add(
          AuthEventRegister(userCredencial: userCredencial),
        );
      }
    });
    on<AuthEventRegister>((event, emit) async {
      emit(AuthStateLoading());
      String? token = await NotificationService().getToken();
      Lover lover = Lover(
        email: event.userCredencial.user!.email!,
        name: event.userCredencial.user!.displayName!,
        id: event.userCredencial.user!.uid,
        photoURL: event.userCredencial.user!.photoURL!,
      );
      lover.token = token!;
      await DataProviderLover().create(lover);
      await NotificationService().requestPermissions();
      add(const AuthEventLogin());
    });
    on<AuthEventLogout>((event, emit) async {
      emit(AuthStateLoading());
      await FirebaseAuthentication().signOut();
      emit(AuthStateInitial());
    });
  }
}
