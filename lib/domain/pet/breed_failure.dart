import 'package:equatable/equatable.dart';

abstract class BreedFailure extends Equatable { }

class ServerError extends BreedFailure {
  @override
  List<Object> get props => [];
}