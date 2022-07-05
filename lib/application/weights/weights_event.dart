import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/weight.dart';

abstract class WeightsEvent extends Equatable { }

class GetWeights extends WeightsEvent {
  final String petId;

  GetWeights(this.petId);

  @override
  List<Object> get props => [];
}

class CreateWeight extends WeightsEvent {
  final String petId;
  final Weight weight;

  CreateWeight(this.petId, this.weight);

  @override
  List<Object> get props => []; 
}

class GetPetDefault extends WeightsEvent {
  @override
  List<Object> get props => [];
}

class GetOwnerChallenges extends WeightsEvent {
  final String ownerId;

  GetOwnerChallenges(this.ownerId);

  @override
  List<Object> get props => []; 
}

class GetAppEvents extends WeightsEvent {
  final String ownerId;

  GetAppEvents(this.ownerId);

  @override
  List<Object> get props => []; 
}

class UpdateChallenge extends WeightsEvent {
  final String ownerId;
  final String challengeId;

  UpdateChallenge(this.ownerId, this.challengeId);

  @override
  List<Object> get props => []; 
}

class CreateAppEvent extends WeightsEvent {
  final String ownerId;
  final AppEvent appEvent;

  CreateAppEvent(this.ownerId, this.appEvent);

  @override
  List<Object> get props => []; 
}

class UpdateChallengeActivity extends WeightsEvent {
  final String ownerId;
  final String challengeId;
  final ChallengeActivity challengeActivity;

  UpdateChallengeActivity(this.ownerId, this.challengeId, this.challengeActivity);

  @override
  List<Object> get props => []; 
}

class UpdatePetPoints extends WeightsEvent {
  final String ownerId;
  final int petPointsQuantity;

  UpdatePetPoints(this.ownerId, this.petPointsQuantity);

  @override
  List<Object> get props => []; 
}
