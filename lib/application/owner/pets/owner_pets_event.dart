
import 'package:equatable/equatable.dart';

abstract class OwnerPetsEvent extends Equatable { }

class GetSubjectPets extends OwnerPetsEvent {
  final String uid;

  GetSubjectPets(this.uid);

  @override
  List<Object> get props => [];
}

class LoadNotificationsCount extends OwnerPetsEvent {
  @override
  List<Object> get props => [];
}