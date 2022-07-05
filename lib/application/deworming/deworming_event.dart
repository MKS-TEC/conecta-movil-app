import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/deworming.dart';

abstract class DewormingEvent extends Equatable { }

class GetDeworming extends DewormingEvent {
  final String petId;

  GetDeworming(this.petId);

  @override
  List<Object> get props => [];
}

class CreateDeworming extends DewormingEvent {
  final String petId;
  final Deworming deworming;

  CreateDeworming(this.petId, this.deworming);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends DewormingEvent {
  @override
  List<Object> get props => [];
}