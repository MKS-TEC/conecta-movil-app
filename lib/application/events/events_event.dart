import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable { }

class GetEvents extends EventsEvent {
  @override
  List<Object> get props => []; 
}

class GetPetDefault extends EventsEvent {
  @override
  List<Object> get props => [];
}

class GetPet extends EventsEvent {
  final String petId;

  GetPet(this.petId);

  @override
  List<Object> get props => [];
}
