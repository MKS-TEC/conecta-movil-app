import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/program.dart';

abstract class ProgramViewState extends Equatable { }

class Initial extends ProgramViewState {
  @override
  List<Object> get props => [];
}

class ProgramLoaded extends ProgramViewState {
  final Program program;

  ProgramLoaded(this.program);

  @override
  List<Object> get props => [program];
}

class ProgramNotLoaded extends ProgramViewState {
  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends ProgramViewState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class GetCalendarsProcessing extends ProgramViewState {
  @override
  List<Object> get props => [];
}

class CalendarsLoaded extends ProgramViewState {
  final List<CalendarEvent> calendars;

  CalendarsLoaded(this.calendars);

  @override
  List<Object> get props => [calendars];
}

class CalendarsNotWereLoaded extends ProgramViewState {
  final CalendarFailure calendarFailure;

  CalendarsNotWereLoaded(this.calendarFailure);

  @override
  List<Object> get props => [];
}
 