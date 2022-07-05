import 'package:equatable/equatable.dart';

abstract class EventViewEvent extends Equatable { }

class GetEvent extends EventViewEvent {
  final String eventId;

  GetEvent(this.eventId);

  @override
  List<Object> get props => []; 
}