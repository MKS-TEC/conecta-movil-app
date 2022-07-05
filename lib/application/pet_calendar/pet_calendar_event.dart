import 'package:equatable/equatable.dart';

abstract class PetCalendarEvent extends Equatable { }

class GetPetCalendar extends PetCalendarEvent {

  final String uid;
  GetPetCalendar(this.uid);

  @override
  List<Object> get props => []; 
}