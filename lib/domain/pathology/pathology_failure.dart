import 'package:equatable/equatable.dart';

abstract class PathologyFailure extends Equatable { }

class ServerError extends PathologyFailure {
  @override
  List<Object> get props => [];
}

