import 'package:equatable/equatable.dart';

abstract class EventFailure extends Equatable { }

class ServerError extends EventFailure {
  @override
  List<Object> get props => [];
}

