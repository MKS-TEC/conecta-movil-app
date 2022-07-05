import 'package:equatable/equatable.dart';

abstract class OwnerFailure extends Equatable { }

class OwnerNotFound extends OwnerFailure {
  @override
  List<Object> get props => [];
}


class ServerError extends OwnerFailure {
  @override
  List<Object> get props => [];
}

