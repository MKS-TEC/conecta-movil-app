import 'package:equatable/equatable.dart';
import 'package:conecta/domain/calendar/calendar_failure.dart';
import 'package:conecta/domain/core/entities/calendar.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/event/event_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';

abstract class DashboardDailyActivitiesState extends Equatable { }

class Initial extends DashboardDailyActivitiesState {
  @override
  List<Object> get props => [];
}

class GetProgramsProcessing extends DashboardDailyActivitiesState {
  @override
  List<Object> get props => [];
}

class ProgramsLoaded extends DashboardDailyActivitiesState {
  final List<Program> programs;

  ProgramsLoaded(this.programs);

  @override
  List<Object> get props => [programs];
}

class ProgramsNotWereLoaded extends DashboardDailyActivitiesState {
  final ProgramFailure programFailure;

  ProgramsNotWereLoaded(this.programFailure);

  @override
  List<Object> get props => [];
}

class GetCalendarsProcessing extends DashboardDailyActivitiesState {
  @override
  List<Object> get props => [];
}

class CalendarsLoaded extends DashboardDailyActivitiesState {
  final List<CalendarEvent> calendars;

  CalendarsLoaded(this.calendars);

  @override
  List<Object> get props => [calendars];
}

class CalendarsNotWereLoaded extends DashboardDailyActivitiesState {
  final CalendarFailure calendarFailure;

  CalendarsNotWereLoaded(this.calendarFailure);

  @override
  List<Object> get props => [];
}

class GetEventsProcessing extends DashboardDailyActivitiesState {
  @override
  List<Object> get props => [];
}

class EventsLoaded extends DashboardDailyActivitiesState {
  final List<Event> events;

  EventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventsNotWereLoaded extends DashboardDailyActivitiesState {
  final EventFailure eventFailure;

  EventsNotWereLoaded(this.eventFailure);

  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends DashboardDailyActivitiesState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class PetLoaded extends DashboardDailyActivitiesState {
  final Pet pet;

  PetLoaded(this.pet);

  @override
  List<Object> get props => [];
}

class PetNotLoaded extends DashboardDailyActivitiesState {
  @override
  List<Object> get props => [];
}