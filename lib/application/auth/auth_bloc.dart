import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/auth/auth_event.dart';
import 'package:conecta/application/auth/auth_state.dart';
import 'package:conecta/infrastructure/auth/auth_facade.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(Initial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent blocEvent,
  ) async* {
    if (blocEvent is AuthCheckRequested) {
      final userOption = await _authFacade.getSignedInUser();
      yield* userOption.fold(
        () async* {
          if(_authFacade.isFirstTimeUsingApp())
            yield FirstTimeUsingApp();
          else
            yield UnauthenticatedSubject();
        },
        (user) async* {
          yield AuthenticatedSubject();
        } 
      );
    }else if (blocEvent is SignedOut) {
      await _authFacade.signOut();
      yield UnauthenticatedSubject();
    } else if (blocEvent is GetAuthenticatedSubject) {
      final Option<User> user = await _authFacade.getSignedInUser();
      yield AuthenticatedSubjectLoaded(
        user.fold(() => null, (user) => user)
      );
    }
  }
}