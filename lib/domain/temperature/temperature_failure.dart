import 'package:equatable/equatable.dart';

abstract class TemperatureFailure extends Equatable { }

class ServerError extends TemperatureFailure {
  @override
  List<Object> get props => [];
}

