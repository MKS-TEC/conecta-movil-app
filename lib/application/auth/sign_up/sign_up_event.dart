
import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable { }

class SignUpWithEmailAndPassword extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  SignUpWithEmailAndPassword(
    this.email, 
    this.password,
    this.name
  );

  @override
  List<Object> get props => [ email, password ];
}

class SignUpWithGoogle extends SignUpEvent {
  @override
  List<Object> get props => []; 
}

