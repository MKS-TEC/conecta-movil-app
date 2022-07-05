import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/auth/sign_up/sign_up_event.dart';
import 'package:conecta/application/auth/sign_up/sign_up_state.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:conecta/infrastructure/auth/auth_facade.dart';

@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  AuthFacade _authFacade;

  SignUpBloc(this._authFacade) : super(Empty());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async*{
    yield Processing();
    if (event is SignUpWithEmailAndPassword) {
      yield* _signUpWithEmailAndPassword(event);
    } else if (event is SignUpWithGoogle) {
      yield* _signUpWithGoogle(event);
    }
  }

  Stream<SignUpState> _signUpWithEmailAndPassword(SignUpWithEmailAndPassword event) async* {
    var result = await _authFacade
        .registerWithEmailAndPassword(emailAddress: event.email, password: event.password, name: event.name);
    yield* result.fold(
      (AuthFailure l) async* {
        yield FailuredSignUpWithEmailAndPassword(l);
      }, 
      (Unit r) async* {
        yield SuccessfulSignUp();
      }
    );
  }

  Stream<SignUpState> _signUpWithGoogle(SignUpEvent event) async* {
    
  }
}