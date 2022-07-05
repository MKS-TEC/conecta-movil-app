import 'package:equatable/equatable.dart';
import 'package:conecta/domain/app_event/app_event_failure.dart';
import 'package:conecta/domain/challenge/challenge_failure.dart';
import 'package:conecta/domain/core/entities/app_event.dart';
import 'package:conecta/domain/core/entities/challenge.dart';
import 'package:conecta/domain/core/entities/weight.dart';
import 'package:conecta/domain/pet_point/pet_point_failure.dart';
import 'package:conecta/domain/weight/weight_failure.dart';

abstract class WeightsState extends Equatable { }

class Initial extends WeightsState {
  @override
  List<Object> get props => [];
}

class WeightsLoaded extends WeightsState {
  final List<Weight> weights;

  WeightsLoaded(this.weights);

  @override
  List<Object> get props => [weights];
}

class WeightsNotWereLoaded extends WeightsState {
  @override
  List<Object> get props => [];
}

class CreateWeightProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}
 
class FailuredCreateWeight extends WeightsState {
  final WeightFailure weightFailure;

  FailuredCreateWeight(this.weightFailure);

  @override
  List<Object> get props => [ weightFailure ];
}

class SuccessfulCreateWeight extends WeightsState {
  final Weight weight;

  SuccessfulCreateWeight(this.weight);

  @override
  List<Object> get props => [weight];
}

class PetDefaultLoaded extends WeightsState {
  final String? petId;

  PetDefaultLoaded(this.petId);

  @override
  List<Object> get props => [];
}

class GetChallengesOwnerProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}

class ChallengesOwnerLoaded extends WeightsState {
  final List<Challenge> challenges;

  ChallengesOwnerLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];
}

class ChallengesOwnerNotWereLoaded extends WeightsState {
  final ChallengeFailure challengeFailure;

  ChallengesOwnerNotWereLoaded(this.challengeFailure);

  @override
  List<Object> get props => [];
}

class UpdateChallengeProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallenge extends WeightsState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallenge(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallenge extends WeightsState {
  @override
  List<Object> get props => [];
}

class UpdateChallengeActivityProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdateChallengeActivity extends WeightsState {
  final ChallengeFailure challengeFailure;

  FailuredUpdateChallengeActivity(this.challengeFailure);

  @override
  List<Object> get props => [ challengeFailure ];
}

class SuccessfulUpdateChallengeActivity extends WeightsState {
  final ChallengeActivity challenge;

  SuccessfulUpdateChallengeActivity(this.challenge);

  @override
  List<Object> get props => [challenge];
}

class UpdatePetPointsProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}
 
class FailuredUpdatePetPoints extends WeightsState {
  final PetPointFailure petPointFailure;

  FailuredUpdatePetPoints(this.petPointFailure);

  @override
  List<Object> get props => [ petPointFailure ];
}

class SuccessfulUpdatePetPoints extends WeightsState {
  @override
  List<Object> get props => [];
}

class GetAppEventsProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}

class AppEventsLoaded extends WeightsState {
  final List<AppEvent> appEvents;

  AppEventsLoaded(this.appEvents);

  @override
  List<Object> get props => [appEvents];
}

class AppEventsNotWereLoaded extends WeightsState {
  final AppEventFailure appEventFailure;

  AppEventsNotWereLoaded(this.appEventFailure);

  @override
  List<Object> get props => [];
}

class CreateAppEventProcessing extends WeightsState {
  @override
  List<Object> get props => [];
}

class FailuredCreateAppEvent extends WeightsState {
  @override
  List<Object> get props => [];
}
 

class SuccessfulCreateAppEvent extends WeightsState {
  final AppEvent appEvent;

  SuccessfulCreateAppEvent(this.appEvent);

  @override
  List<Object> get props => [appEvent];
}
 
