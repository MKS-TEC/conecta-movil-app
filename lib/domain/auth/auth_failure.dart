import 'package:equatable/equatable.dart';

abstract class AuthFailure extends Equatable { }

class EmailAlreadyInUse extends AuthFailure {
  @override
  List<Object> get props => [];
}

class ServerError extends AuthFailure {
  @override
  List<Object> get props => [];
}

class InvalidEmailAndPasswordCombination extends AuthFailure {
  @override
  List<Object> get props => [];
}

