
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable { }

class AuthCheckRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignedOut extends AuthEvent {
  @override
  List<Object> get props => []; 
}

class GetAuthenticatedSubject extends AuthEvent {
  @override
  List<Object> get props => []; 
}