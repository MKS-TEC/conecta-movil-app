import 'package:equatable/equatable.dart';

abstract class SpeciesFailure extends Equatable { }

class ServerError extends SpeciesFailure {
  @override
  List<Object> get props => [];
}