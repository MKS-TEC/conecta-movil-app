import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conecta/domain/auth/auth_failure.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/owner/owner_failure.dart';

abstract class  SignInState extends Equatable { }

class Initial extends SignInState {
  @override
  List<Object> get props => [];
}

class Processing extends SignInState {
  @override
  List<Object> get props => [];
}
 
class FailuredSignInWithEmailAndPassword extends SignInState {
  final AuthFailure authFailure;

  FailuredSignInWithEmailAndPassword(this.authFailure);

  @override
  List<Object> get props => [ authFailure ];
}

class SuccessfulSignIn extends SignInState {
  @override
  List<Object> get props => [];
}

class FailuredSignInGoogle extends SignInState {
  final AuthFailure authFailure;

  FailuredSignInGoogle(this.authFailure);

  @override
  List<Object> get props => [ authFailure ];
}

class SuccessfulSignInGoogle extends SignInState {
  final User user;

  SuccessfulSignInGoogle(this.user);

  @override
  List<Object> get props => [user];
}

class OwnerLoaded extends SignInState {
  final Owner owner;

  OwnerLoaded(this.owner);

  @override
  List<Object> get props => [owner];
}

class OwnerNotWereLoaded extends SignInState {
  final OwnerFailure ownerFailure;

  OwnerNotWereLoaded(this.ownerFailure);

  @override
  List<Object> get props => [ ownerFailure ];
}

class SetOwnerProcessing extends SignInState {
  @override
  List<Object> get props => [];
}
 
class FailuredSetOwner extends SignInState {
  final OwnerFailure ownerFailure;

  FailuredSetOwner(this.ownerFailure);

  @override
  List<Object> get props => [ ownerFailure ];
}

class SuccessfulSetOwner extends SignInState {
  @override
  List<Object> get props => [];
}