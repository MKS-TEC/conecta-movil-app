import 'package:equatable/equatable.dart';
import 'package:conecta/application/core/app_state.dart';
import 'package:conecta/domain/auth/auth_failure.dart';

abstract class  SignUpState extends Equatable { }

class Empty extends SignUpState {
  @override
  List<Object> get props => [];
}

class Processing extends SignUpState {
  @override
  List<Object> get props => [];
}
 
class FailuredSignUpWithEmailAndPassword extends SignUpState {
  final AuthFailure authFailure;

  FailuredSignUpWithEmailAndPassword(this.authFailure);

  @override
  List<Object> get props => [ authFailure ];
}

class SuccessfulSignUp extends SignUpState {
  @override
  List<Object> get props => [];
}