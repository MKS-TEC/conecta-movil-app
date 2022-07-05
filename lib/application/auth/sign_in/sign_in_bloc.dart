import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/auth/sign_in/sign_in_event.dart';
import 'package:conecta/application/auth/sign_in/sign_in_state.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/owner/owner_failure.dart';
import 'package:conecta/infrastructure/auth/auth_facade.dart';
import 'package:conecta/infrastructure/owner/repositories/owner_repository.dart';

@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {

  AuthFacade _authFacade;
  OwnerRepository _ownerRepository;

  SignInBloc(this._authFacade, this._ownerRepository) : super(Initial());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async*{
    yield Processing();
    if (event is SignInWithEmailAndPassword) {
      yield* _signInWithEmailAndPassword(event);
    } else if (event is SignInWithGoogle) {
      yield* _signInWithGoogle(event);
    } else if (event is GetOwner) {
      yield* _getOwner(event);
    } else if (event is SetOwner) {
      yield SetOwnerProcessing();
      yield* _setOwner(event);
    }
  }

  Stream<SignInState> _signInWithEmailAndPassword(SignInWithEmailAndPassword event) async* {
    var result = await _authFacade.signInWithEmailAndPassword(emailAddress: event.email, password: event.password);
    yield* result.fold(
      (AuthFailure isLeft) async* {
        yield FailuredSignInWithEmailAndPassword(isLeft);
      }, 
      (Unit isRight) async* {
        yield SuccessfulSignIn();
      }
    );
  }

  Stream<SignInState> _signInWithGoogle(SignInWithGoogle event) async* {
    var result = await _authFacade.signInWithGoogle();
    yield* result.fold(
      (AuthFailure l) async* {
        yield FailuredSignInGoogle(l);
      }, 
      (User? r) async* {
        yield SuccessfulSignInGoogle(r!);
      }
    );
  }

  Stream<SignInState> _getOwner(GetOwner event) async* {
    var result = await _ownerRepository.getOwner(event.uid);
    yield* result.fold(
      (OwnerFailure l) async* {
        yield OwnerNotWereLoaded(l);
      }, 
      (Owner r) async* {
        yield OwnerLoaded(r);
      }
    );
  }

  Stream<SignInState> _setOwner(SetOwner event) async* {
    var result = await _ownerRepository.setOwner(event.owner);
    yield* result.fold(
      (OwnerFailure l) async* {
        yield FailuredSetOwner(l);
      }, 
      (Unit r) async* {
        yield SuccessfulSetOwner();
      }
    );
  }
}