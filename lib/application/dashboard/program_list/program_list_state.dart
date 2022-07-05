import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/program/program_failure.dart';

abstract class ProgramListState extends Equatable { }

class Initial extends ProgramListState {
  @override
  List<Object> get props => [];
}

class GetProgramsProcessing extends ProgramListState {
  @override
  List<Object> get props => [];
}

class ProgramsLoaded extends ProgramListState {
  final List<Program> programs;

  ProgramsLoaded(this.programs);

  @override
  List<Object> get props => [programs];
}

class ProgramsNotWereLoaded extends ProgramListState {
  final ProgramFailure programFailure;

  ProgramsNotWereLoaded(this.programFailure);

  @override
  List<Object> get props => [];
}

class GetCalendarsProcessing extends ProgramListState {
  @override
  List<Object> get props => [];
}

class CalendarsLoaded extends ProgramListState {
  final List<CalendarEvent> calendars;

  CalendarsLoaded(this.calendars);

  @override
  List<Object> get props => [calendars];
}

class CalendarsNotWereLoaded extends ProgramListState {
  final CalendarFailure calendarFailure;

  CalendarsNotWereLoaded(this.calendarFailure);

  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends ProgramListState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}