
import 'package:equatable/equatable.dart';

abstract class OwnerProfileEvent extends Equatable { }

class GetOwner extends OwnerProfileEvent {
  final String ownerId;

  GetOwner(this.ownerId);

  @override
  List<Object> get props => [];
}

class GetOwnerPets extends OwnerProfileEvent {
  final String ownerId;

  GetOwnerPets(this.ownerId);

  @override
  List<Object> get props => [];
}
