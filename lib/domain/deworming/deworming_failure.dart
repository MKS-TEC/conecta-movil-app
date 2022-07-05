import 'package:equatable/equatable.dart';

abstract class DewormingFailure extends Equatable { }

class ServerError extends DewormingFailure {
  @override
  List<Object> get props => [];
}

