import 'package:equatable/equatable.dart';

abstract class ProgramFailure extends Equatable { }

class ServerError extends ProgramFailure {
  @override
  List<Object> get props => [];
}

