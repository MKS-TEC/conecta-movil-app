import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/pet.dart';

abstract class PetProfileEvent extends Equatable { }

class GetPet extends PetProfileEvent {
  final String petId;

  GetPet(this.petId);

  @override
  List<Object> get props => [];
}

class UpdatePet extends PetProfileEvent {
  final Pet pet;

  UpdatePet(this.pet);

  @override
  List<Object> get props => []; 
}

class GetBreedsBySpecies extends PetProfileEvent {
  final String species;

  GetBreedsBySpecies( this.species );

  @override
  List<Object> get props => [ species ]; 
}

class GetOwnerChallenges extends PetProfileEvent {
  final String ownerId;

  GetOwnerChallenges(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetAppEvents extends PetProfileEvent {
  final String ownerId;

  GetAppEvents(this.ownerId);

  @override
  List<Object> get props => []; 
}

class UpdateChallenge extends PetProfileEvent {
  final String ownerId;
  final String challengeId;

  UpdateChallenge(this.ownerId, this.challengeId);

  @override
  List<Object> get props => []; 
}

class CreateAppEvent extends PetProfileEvent {
  final String ownerId;
  final AppEvent appEvent;

  CreateAppEvent(this.ownerId, this.appEvent);

  @override
  List<Object> get props => []; 
}

class UpdateChallengeActivity extends PetProfileEvent {
  final String ownerId;
  final String challengeId;
  final ChallengeActivity challengeActivity;

  UpdateChallengeActivity(this.ownerId, this.challengeId, this.challengeActivity);

  @override
  List<Object> get props => []; 
}

class UpdatePetPoints extends PetProfileEvent {
  final String ownerId;
  final int petPointsQuantity;

  UpdatePetPoints(this.ownerId, this.petPointsQuantity);

  @override
  List<Object> get props => []; 
}
