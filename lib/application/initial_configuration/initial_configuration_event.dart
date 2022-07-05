
import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';

abstract class InitialConfigurationEvent extends Equatable { }

class AuthCheckRequested extends InitialConfigurationEvent {
  @override
  List<Object> get props => [];
}

class SetPet extends InitialConfigurationEvent {
  final Pet pet;

  SetPet(this.pet);

  @override
  List<Object> get props => []; 
}

class GetSpecies extends InitialConfigurationEvent {
  @override
  List<Object> get props => []; 
}


class GetBreedsBySpecies extends InitialConfigurationEvent {
  final String species;

  GetBreedsBySpecies( this.species );

  @override
  List<Object> get props => [ species ]; 
}

class GetPrograms extends InitialConfigurationEvent {
  final Pet pet;

  GetPrograms( this.pet );

  @override
  List<Object> get props => []; 
}

class CreatePrograms extends InitialConfigurationEvent {
  final String petId;
  final List<Program> programs;

  CreatePrograms(this.petId, this.programs);

  @override
  List<Object> get props => []; 
}

class CreateCalendar extends InitialConfigurationEvent {
  final String petId;
  final List<CalendarEvent> calendarEvents;

  CreateCalendar(this.petId, this.calendarEvents);

  @override
  List<Object> get props => []; 
}
