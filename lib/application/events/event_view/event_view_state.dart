import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/event.dart';
import 'package:conecta/domain/event/event_failure.dart';

abstract class EventViewState extends Equatable { }

class Initial extends EventViewState {
  @override
  List<Object> get props => [];
}

class GetEventProcessing extends EventViewState {
  @override
  List<Object> get props => [];
}

class EventLoaded extends EventViewState {
  final Event event;

  EventLoaded(this.event);

  @override
  List<Object> get props => [event];
}

class EventNotWereLoaded extends EventViewState {
  final EventFailure eventFailure;

  EventNotWereLoaded(this.eventFailure);

  @override
  List<Object> get props => [];
}
