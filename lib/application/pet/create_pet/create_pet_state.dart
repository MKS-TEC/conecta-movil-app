import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/breed.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/species.dart';
import 'package:conecta/domain/pet/breed_failure.dart';
import 'package:conecta/domain/pet/pet_failure.dart';
import 'package:conecta/domain/pet/species_failure.dart';
import 'package:conecta/domain/program/program_category_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';

abstract class CreatePetState extends Equatable { }

class Initial extends CreatePetState {
  @override
  List<Object> get props => [];
}

class SetPetProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class FailuredSetPet extends CreatePetState {
  final PetFailure petFailure;

  FailuredSetPet(this.petFailure);

  @override
  List<Object> get props => [ petFailure ];
}

class SuccessfulSetPet extends CreatePetState {
  final Pet pet;

  SuccessfulSetPet(this.pet);

  @override
  List<Object> get props => [pet];
}
class GetSpeciesProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class SpeciesLoaded extends CreatePetState {
  final List<Species> species;

  SpeciesLoaded(this.species);

  @override
  List<Object> get props => [species];
}

class SpeciesNotWereLoaded extends CreatePetState {
  final SpeciesFailure speciesFailure;

  SpeciesNotWereLoaded(this.speciesFailure);

  @override
  List<Object> get props => [];
}

class GetBreedsProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class BreedsLoaded extends CreatePetState {
  final List<Breed> breeds;

  BreedsLoaded(this.breeds);

  @override
  List<Object> get props => [breeds];
}

class BreedsNotWereLoaded extends CreatePetState {
   final BreedFailure breedFailure;

  BreedsNotWereLoaded(this.breedFailure);

  @override
  List<Object> get props => [];
}

class GetProgramsProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}

class ProgramsLoaded extends CreatePetState {
  final List<Program> programs;

  ProgramsLoaded(this.programs);

  @override
  List<Object> get props => [programs];
}

class ProgramsNotWereLoaded extends CreatePetState {
  @override
  List<Object> get props => [];
}

class CreateProgramsProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreatePrograms extends CreatePetState {
  final ProgramFailure programFailure;

  FailuredCreatePrograms(this.programFailure);

  @override
  List<Object> get props => [ programFailure ];
}

class SuccessfulCreatePrograms extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class CreateCalendarProcessing extends CreatePetState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateCalendar extends CreatePetState {
  final CalendarFailure calendarFailure;

  FailuredCreateCalendar(this.calendarFailure);

  @override
  List<Object> get props => [ calendarFailure ];
}

class SuccessfulCreateCalendar extends CreatePetState {
  @override
  List<Object> get props => [];
}