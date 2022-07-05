import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/challenge.dart';

abstract class GamificationChallengesEvent extends Equatable { }

class GetChallenges extends GamificationChallengesEvent {
  @override
  List<Object> get props => []; 
}

class GetOwnerChallenges extends GamificationChallengesEvent {
  final String ownerId;

  GetOwnerChallenges(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetAppEvents extends GamificationChallengesEvent {
  final String ownerId;

  GetAppEvents(this.ownerId);

  @override
  List<Object> get props => []; 
}

class UpdateChallenge extends GamificationChallengesEvent {
  final String ownerId;
  final String challengeId;

  UpdateChallenge(this.ownerId, this.challengeId);

  @override
  List<Object> get props => []; 
}

class UpdateChallengeActivities extends GamificationChallengesEvent {
  final String ownerId;
  final String challengeId;
  final List<ChallengeActivity> challengeActivities;

  UpdateChallengeActivities(this.ownerId, this.challengeId, this.challengeActivities);

  @override
  List<Object> get props => []; 
}

class UpdatePetPoints extends GamificationChallengesEvent {
  final String ownerId;
  final int petPointsQuantity;

  UpdatePetPoints(this.ownerId, this.petPointsQuantity);

  @override
  List<Object> get props => []; 
}

class CreateChallenge extends GamificationChallengesEvent {
  final String ownerId;
  final Challenge challenge;

  CreateChallenge(this.ownerId, this.challenge);

  @override
  List<Object> get props => []; 
}
