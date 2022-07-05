
import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/owner.dart';

abstract class SignInEvent extends Equatable { }

class SignInWithEmailAndPassword extends SignInEvent {
  final String email;
  final String password;

  SignInWithEmailAndPassword(
    this.email, 
    this.password
  );

  @override
  List<Object> get props => [ email, password ];
}

class SignInWithGoogle extends SignInEvent {
  @override
  List<Object> get props => []; 
}

class GetOwner extends SignInEvent {
  final String uid;

  GetOwner(this.uid);

  @override
  List<Object> get props => []; 
}

class SetOwner extends SignInEvent {
  final Owner owner;

  SetOwner(this.owner);

  @override
  List<Object> get props => []; 
}

