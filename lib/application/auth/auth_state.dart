import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable { }

class Initial extends AuthState {
  @override
  List<Object> get props => [];
}
 
class AuthenticatedSubject extends AuthState {
  @override
  List<Object> get props => [];
}

class UnauthenticatedSubject extends AuthState {
  @override
  List<Object> get props => [];
}

class FirstTimeUsingApp extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthenticatedSubjectLoaded extends AuthState {
  final User? user;

  AuthenticatedSubjectLoaded(this.user);

  @override
  List<Object> get props => [];
}