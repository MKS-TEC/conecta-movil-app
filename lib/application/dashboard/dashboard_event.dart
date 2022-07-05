
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable { }

class GetSubjectPets extends DashboardEvent {
  final String uid;

  GetSubjectPets(this.uid);

  @override
  List<Object> get props => [];
}

class SetPetDefault extends DashboardEvent {
  final String? petId;

  SetPetDefault(this.petId);

  @override
  List<Object> get props => [];
}

class GetPetDefault extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class LoadNotificationsCount extends DashboardEvent {
  @override
  List<Object> get props => [];
}