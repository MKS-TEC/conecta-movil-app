import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/pet.dart';

abstract class OwnerPetsState extends Equatable { }

class Initial extends OwnerPetsState {
  @override
  List<Object> get props => [];
}

class SubjectPetsLoaded extends OwnerPetsState {
  final List<Pet> pets;

  SubjectPetsLoaded(this.pets);

  @override
  List<Object> get props => [pets];
}

class SubjectPetsNotWereLoaded extends OwnerPetsState {
  @override
  List<Object> get props => [];
}
 
class NotificationsCountLoaded extends OwnerPetsState {
  final int count;

  NotificationsCountLoaded(this.count);

  @override
  List<Object> get props => [count];
}