import 'package:equatable/equatable.dart';

abstract class DashboardDailyActivitiesEvent extends Equatable { }

class GetPrograms extends DashboardDailyActivitiesEvent {
  final String petId;

  GetPrograms(this.petId);

  @override
  List<Object> get props => []; 
}

class GetCalendars extends DashboardDailyActivitiesEvent {
  final String petId;

  GetCalendars(this.petId);

  @override
  List<Object> get props => []; 
}

class GetEvents extends DashboardDailyActivitiesEvent {
  @override
  List<Object> get props => []; 
}

class GetPetDefault extends DashboardDailyActivitiesEvent {
  @override
  List<Object> get props => [];
}

class GetPet extends DashboardDailyActivitiesEvent {
  final String petId;

  GetPet(this.petId);

  @override
  List<Object> get props => [];
}
