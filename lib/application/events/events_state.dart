import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/core/entities/pet.dart';
import 'package:conecta/domain/event/event_failure.dart';

abstract class EventsState extends Equatable { }

class Initial extends EventsState {
  @override
  List<Object> get props => [];
}

class GetEventsProcessing extends EventsState {
  @override
  List<Object> get props => [];
}

class EventsLoaded extends EventsState {
  final List<Event> events;

  EventsLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventsNotWereLoaded extends EventsState {
  final EventFailure eventFailure;

  EventsNotWereLoaded(this.eventFailure);

  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends EventsState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class PetLoaded extends EventsState {
  final Pet pet;

  PetLoaded(this.pet);

  @override
  List<Object> get props => [];
}

class PetNotLoaded extends EventsState {
  @override
  List<Object> get props => [];
}