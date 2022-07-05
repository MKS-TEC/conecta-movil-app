import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pet.dart';

abstract class DashboardState extends Equatable { }

class Initial extends DashboardState {
  @override
  List<Object> get props => [];
}

class SubjectPetsLoaded extends DashboardState {
  final List<Pet> pets;

  SubjectPetsLoaded(this.pets);

  @override
  List<Object> get props => [pets];
}

class SubjectPetsNotWereLoaded extends DashboardState {
  @override
  List<Object> get props => [];
}

class PetDefaultLoaded extends DashboardState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class SuccessfulSetPet extends DashboardState {
  final String? petId;

  SuccessfulSetPet(this.petId);

  @override
  List<Object> get props => [];
}
 
 
class NotificationsCountLoaded extends DashboardState {
  final int count;

  NotificationsCountLoaded(this.count);

  @override
  List<Object> get props => [count];
}