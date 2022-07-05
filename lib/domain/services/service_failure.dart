import 'package:equatable/equatable.dart';

abstract class ServiceFailure extends Equatable { }

class ServerError extends ServiceFailure {
  @override
  List<Object> get props => [];
}

