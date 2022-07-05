import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/vaccine.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/domain/vaccine/vaccine_failure.dart';

abstract class VaccinesState extends Equatable { }

class Initial extends VaccinesState {
  @override
  List<Object> get props => [];
}

class VaccinesLoaded extends VaccinesState {
  final List<Vaccine> vaccines;

  VaccinesLoaded(this.vaccines);

  @override
  List<Object> get props => [vaccines];
}

class VaccinesNotWereLoaded extends VaccinesState {
  @override
  List<Object> get props => [];
}

class CreateVaccineProcessing extends VaccinesState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateVaccine extends VaccinesState {
  final VaccineFailure vaccineFailure;

  FailuredCreateVaccine(this.vaccineFailure);

  @override
  List<Object> get props => [ vaccineFailure ];
}

class SuccessfulCreateVaccine extends VaccinesState {
  final Vaccine vaccine;

  SuccessfulCreateVaccine(this.vaccine);

  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends VaccinesState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class GetCalendarsProcessing extends VaccinesState {
  @override
  List<Object> get props => [];
}

class CalendarsLoaded extends VaccinesState {
  final List<CalendarEvent> calendars;

  CalendarsLoaded(this.calendars);

  @override
  List<Object> get props => [calendars];
}

class CalendarsNotWereLoaded extends VaccinesState {
  final CalendarFailure calendarFailure;

  CalendarsNotWereLoaded(this.calendarFailure);

  @override
  List<Object> get props => [];
}

class GetProgramsProcessing extends VaccinesState {
  @override
  List<Object> get props => [];
}

class ProgramsLoaded extends VaccinesState {
  final List<Program> programs;

  ProgramsLoaded(this.programs);

  @override
  List<Object> get props => [programs];
}

class ProgramsNotWereLoaded extends VaccinesState {
  final ProgramFailure programFailure;

  ProgramsNotWereLoaded(this.programFailure);

  @override
  List<Object> get props => [];
}
