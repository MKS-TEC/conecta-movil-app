import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/domain/core/entities/species.dart';
import 'package:conecta/domain/pet/breed_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/pet/species_failure.dart';
import 'package:conecta/domain/program/program_category_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';

abstract class InitialConfigurationState extends Equatable { }

class Initial extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}

class SetPetProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
 
class FailuredSetPet extends InitialConfigurationState {
  final PetFailure petFailure;

  FailuredSetPet(this.petFailure);

  @override
  List<Object> get props => [ petFailure ];
}

class SuccessfulSetPet extends InitialConfigurationState {
  final Pet pet;

  SuccessfulSetPet(this.pet);

  @override
  List<Object> get props => [pet];
}
class GetSpeciesProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
 
class SpeciesLoaded extends InitialConfigurationState {
  final List<Species> species;

  SpeciesLoaded(this.species);

  @override
  List<Object> get props => [species];
}

class SpeciesNotWereLoaded extends InitialConfigurationState {
  final SpeciesFailure speciesFailure;

  SpeciesNotWereLoaded(this.speciesFailure);

  @override
  List<Object> get props => [];
}

class GetBreedsProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
 
class BreedsLoaded extends InitialConfigurationState {
  final List<Breed> breeds;

  BreedsLoaded(this.breeds);

  @override
  List<Object> get props => [breeds];
}

class BreedsNotWereLoaded extends InitialConfigurationState {
   final BreedFailure breedFailure;

  BreedsNotWereLoaded(this.breedFailure);

  @override
  List<Object> get props => [];
}

class GetProgramsProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}

class ProgramsLoaded extends InitialConfigurationState {
  final List<Program> programs;

  ProgramsLoaded(this.programs);

  @override
  List<Object> get props => [programs];
}

class ProgramsNotWereLoaded extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}

class CreateProgramsProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreatePrograms extends InitialConfigurationState {
  final ProgramFailure programFailure;

  FailuredCreatePrograms(this.programFailure);

  @override
  List<Object> get props => [ programFailure ];
}

class SuccessfulCreatePrograms extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}

class CreateCalendarProcessing extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateCalendar extends InitialConfigurationState {
  final CalendarFailure calendarFailure;

  FailuredCreateCalendar(this.calendarFailure);

  @override
  List<Object> get props => [ calendarFailure ];
}

class SuccessfulCreateCalendar extends InitialConfigurationState {
  @override
  List<Object> get props => [];
}
