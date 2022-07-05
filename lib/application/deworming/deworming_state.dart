import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/deworming.dart';
import 'package:conecta/domain/deworming/deworming_failure.dart';

abstract class DewormingState extends Equatable { }

class Initial extends DewormingState {
  @override
  List<Object> get props => [];
}

class DewormingLoaded extends DewormingState {
  final List<Deworming> dewormings;

  DewormingLoaded(this.dewormings);

  @override
  List<Object> get props => [dewormings];
}

class DewormingNotWereLoaded extends DewormingState {
  @override
  List<Object> get props => [];
}

class CreateDewormingProcessing extends DewormingState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateDeworming extends DewormingState {
  final DewormingFailure dewormingFailure;

  FailuredCreateDeworming(this.dewormingFailure);

  @override
  List<Object> get props => [ dewormingFailure ];
}

class SuccessfulCreateDeworming extends DewormingState {
  final Deworming deworming;

  SuccessfulCreateDeworming(this.deworming);

  @override
  List<Object> get props => [deworming];
}


class PetDefaultLoaded extends DewormingState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

