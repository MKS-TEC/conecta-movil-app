import 'package:equatable/equatable.dart';

abstract class WeightFailure extends Equatable { }

class ServerError extends WeightFailure {
  @override
  List<Object> get props => [];
}

