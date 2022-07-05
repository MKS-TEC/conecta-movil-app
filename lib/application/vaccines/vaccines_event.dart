import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/vaccine.dart';

abstract class VaccinesEvent extends Equatable { }

class GetVaccines extends VaccinesEvent {
  final String petId;

  GetVaccines(this.petId);

  @override
  List<Object> get props => [];
}

class GetCalendars extends VaccinesEvent {
  final String petId;

  GetCalendars(this.petId);

  @override
  List<Object> get props => [];
}

class GetPrograms extends VaccinesEvent {
  final String petId;

  GetPrograms(this.petId);

  @override
  List<Object> get props => []; 
}

class CreateVaccine extends VaccinesEvent {
  final String petId;
  final Vaccine vaccine;

  CreateVaccine(this.petId, this.vaccine);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends VaccinesEvent {
  @override
  List<Object> get props => [];
}