
import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/owner.dart';

abstract class OwnerEditProfileEvent extends Equatable { }

class GetOwner extends OwnerEditProfileEvent {
  final String ownerId;

  GetOwner(this.ownerId);

  @override
  List<Object> get props => [];
}

class UpdateOwner extends OwnerEditProfileEvent {
  final Owner owner;

  UpdateOwner(this.owner);

  @override
  List<Object> get props => []; 
}

class GetCountries extends OwnerEditProfileEvent {

  @override
  List<Object> get props => [];
}

class GetOwnerChallenges extends OwnerEditProfileEvent {
  final String ownerId;

  GetOwnerChallenges(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetAppEvents extends OwnerEditProfileEvent {
  final String ownerId;

  GetAppEvents(this.ownerId);

  @override
  List<Object> get props => []; 
}

class UpdateChallenge extends OwnerEditProfileEvent {
  final String ownerId;
  final String challengeId;

  UpdateChallenge(this.ownerId, this.challengeId);

  @override
  List<Object> get props => []; 
}

class CreateAppEvent extends OwnerEditProfileEvent {
  final String ownerId;
  final AppEvent appEvent;

  CreateAppEvent(this.ownerId, this.appEvent);

  @override
  List<Object> get props => []; 
}

class UpdateChallengeActivity extends OwnerEditProfileEvent {
  final String ownerId;
  final String challengeId;
  final ChallengeActivity challengeActivity;

  UpdateChallengeActivity(this.ownerId, this.challengeId, this.challengeActivity);

  @override
  List<Object> get props => []; 
}

class UpdatePetPoints extends OwnerEditProfileEvent {
  final String ownerId;
  final int petPointsQuantity;

  UpdatePetPoints(this.ownerId, this.petPointsQuantity);

  @override
  List<Object> get props => []; 
}
