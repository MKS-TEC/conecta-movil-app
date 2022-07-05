import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/notifications/notification.dart';
import 'package:conecta/domain/core/pet_calendar/pet_calendar.dart';
import 'package:conecta/domain/pet_calendar/pet_calendar_failure.dart';

abstract class PetCalendarState extends Equatable { }

class Initial extends PetCalendarState {
  @override
  List<Object> get props => [];
}

class GetPetCalendarProcessing extends PetCalendarState {
  @override
  List<Object> get props => [];
}

class PetCalendarLoaded extends PetCalendarState {
  final List<PetCalendarItem> pet_calendar;

  PetCalendarLoaded(this.pet_calendar);

  @override
  List<Object> get props => [pet_calendar];
}

class PetCalendarNotWasLoaded extends PetCalendarState {
  final PetCalendarFailure pet_calendarFailure;

  PetCalendarNotWasLoaded(this.pet_calendarFailure);

  @override
  List<Object> get props => [];
}